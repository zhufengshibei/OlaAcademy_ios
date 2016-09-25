//
//  CourSectionViewController.m
//  课程章节分类及视频 页面
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourSectionViewController.h"

#import "SysCommon.h"
#import "VIPSubController.h"
#import "AuthManager.h"
#import "CommodityManager.h"
#import "PlayerManager.h"

#import "Masonry.h"
#import "CourSectionTableCell.h"
#import "LoginViewController.h"
#import "CourBuyViewController.h"
#import "CommodityPayVC.h"
#import "IAPVIPController.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "ShareSheetView.h"

#import "DownloadModal.h"
#import "DownloadManager.h"

#import "PayManager.h"
#import "YzdHUDBackgroundView.h"
#import "YzdHUDLabel.h"
#import "YzdHUDImageView.h"
#import "YzdHUDIndicator.h"

#import "PDFView.h"
#import "HMSegmentedControl.h"
#import "SVProgressHUD.h"

@interface CourSectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ShareSheetDelegate,UMSocialUIDelegate>

@property (nonatomic) UIView *playView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) HMSegmentedControl *segmentedControl;
@property (nonatomic) UIView *operationView;
@property (nonatomic) PDFView *pdfView;

@property (nonatomic) ThirdPay *thirdPay; //iap支付 还是 支付宝 微信支付

@property (nonatomic) NSString *orderStatus; // 购买状态

@property (nonatomic) int currentIndex;
@property (nonatomic) CourseVideo *currentVideo;


@end

@implementation CourSectionViewController{
    
    UIView *titleView;
    
    UIButton *collectionButton;
    UIButton *downloadButton;
    UIButton *shareButton;
    
    /**
     *  数据源
     */
    NSMutableArray *dataArray;
    
    BOOL isCollected;
    
    NSInteger currentRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 取消右滑关闭页面功能
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initView];
    
    [self setupData];
    [self fetchPayModuleStatus];
    
    //返回按钮监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerClickBack object:nil];
    
}

-(void)initView{
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_STATUS_BAR_HEIGHT, SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    titleView.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self.view addSubview:titleView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, UI_NAVIGATION_BAR_HEIGHT);
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [titleView addSubview:backBtn];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
}

-(void)setupData{
    if (_type==1) {
        [self fetchSectionVideo];
    }else{
        [self fetchCommodityVideoList];
    }
    
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(ThirdPayResult *result) {
        _thirdPay = result.thirdPay;
    } Failure:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [SVProgressHUD dismiss];
}

-(void)setupPlayerView{
    _playView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH*9.0/16.0)];
    [self.view addSubview:_playView];
    
    [self setupSegment];
    [self setupTableView];
    [self setupPDFView];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.vc = self;
    
    [self playWithUrl:_currentVideo.address];
    
    // 程序退到后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)setupSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_playView.frame), SCREEN_WIDTH-60, GENERAL_SIZE(80))];
    _segmentedControl.sectionTitles = @[@"目录",@"讲义"];
    _segmentedControl.selectedSegmentIndex = 0;
    
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBCOLOR(81, 84, 93), NSFontAttributeName : LabelFont(32)};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COMMONBLUECOLOR, NSFontAttributeName: LabelFont(32)};
    _segmentedControl.selectionIndicatorColor = COMMONBLUECOLOR;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.selectionIndicatorHeight = 2;
    _segmentedControl.selectionIndicatorBoxOpacity = 0;
    
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [self.view addSubview:_segmentedControl];
    
    __weak CourSectionViewController *weakSelf =self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        _currentIndex = (int)index;
        if (index==0) {
            weakSelf.pdfView.hidden = YES;
        }else{
            weakSelf.pdfView.hidden = NO;
            [weakSelf.pdfView loadPDF:weakSelf.currentVideo];
        }
    }];
    
}

-(void)setupTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segmentedControl.frame)-43) style:UITableViewStylePlain];
    if (_type==2&&([_orderStatus isEqualToString:@"1"]||[_commodity.price isEqualToString:@"0"])) {
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segmentedControl.frame));
    }
    _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setupBottomView];
}

-(void)setupPDFView{
    _pdfView = [[PDFView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segmentedControl.frame))];
    _pdfView.backgroundColor = [UIColor whiteColor];
    _pdfView.hidden = YES;
    [self.view addSubview:_pdfView];
}

-(void)playWithUrl:(NSString*)url{
    if (self.player) {
        [self.player.mediaPlayer.player pause];
        [self.player.mediaPlayer.player shutdown];
        self.player = nil;
    }
    self.player = [[PlayerManager alloc] init];
    self.player.view = _playView;
    self.player.viewContorller = self;
    
    [self.player setSupportAutomaticRotation:YES];
    [self.player setSupportAngleChange:YES];
    
    NSString *path = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.player buildMediaPlayer:path];
    
    __weak CourSectionViewController *weakSelf =self;
    self.player.didClickFullScreen = ^void(BOOL fullScreen){
        [weakSelf hideContentView:fullScreen];
    };
}

//全屏隐藏其他视图
-(void)hideContentView:(BOOL)fullScreen{
    if (fullScreen) {
        _tableView.hidden = YES;
        _segmentedControl.hidden = YES;
        _operationView.hidden = YES;
        _pdfView.hidden = YES;
    }else{
        _tableView.hidden = NO;
        _segmentedControl.hidden = NO;
        if ([_commodity.price intValue]>0&&![_orderStatus isEqualToString:@"1"]) {
            _operationView.hidden = NO;
        }
        if (_currentIndex==1) {
            _pdfView.hidden = NO;
        }
    }
}

- (void)noti:(NSNotification *)noti
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([noti.name isEqualToString:UCloudMoviePlayerClickBack])
    {
        [self back];
    }
}

-(void)back{
    /**
     *  一定要置空
     */
    self.player = nil;
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.vc = nil;
    
    //移除提示视图，否则影响下拉列表
    [[YzdHUDBackgroundView shareHUDView] removeFromSuperview];
    [[YzdHUDLabel shareHUDView] removeFromSuperview];
    [[YzdHUDImageView shareHUDView] removeFromSuperview];
    [[YzdHUDIndicator shareHUDView] removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)applicationWillResignActive{
    // 暂停
    [self.player.mediaPlayer.player pause];
}

/**
 *  以下方法必须实现
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.player)
    {
        return self.player.supportInterOrtation;
    }
    else
    {
        /**
         *  这个在播放之外的程序支持的设备方向
         */
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.player rotateEnd];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.player rotateBegain:toInterfaceOrientation];
    if (toInterfaceOrientation==UIDeviceOrientationLandscapeLeft||toInterfaceOrientation==UIDeviceOrientationLandscapeRight) {
        [self hideContentView:YES];
    }else{
        [self hideContentView:NO];
    }
}


-(void)setupBottomView{
    downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadButton setImage:[UIImage imageNamed:@"ic_downloaded"] forState:UIControlStateNormal];
    [downloadButton sizeToFit];
    [downloadButton addTarget:self action:@selector(downloadVideo) forControlEvents:UIControlEventTouchDown];
    
    collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionButton setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
    [collectionButton sizeToFit];
    [collectionButton addTarget:self action:@selector(collectCourse) forControlEvents:UIControlEventTouchDown];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareButton sizeToFit];
    [shareButton addTarget:self action:@selector(shareCourse) forControlEvents:UIControlEventTouchDown];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"btn_buy"] forState:UIControlStateNormal];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton sizeToFit];
    [buyButton addTarget:self action:@selector(buyCourse) forControlEvents:UIControlEventTouchDown];
    
    _operationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 43)];
    _operationView.backgroundColor = RGBCOLOR(250, 250, 250);
    [self.view addSubview:_operationView];
    
    if (_type==1) {
        [_operationView addSubview:downloadButton];
        [_operationView addSubview:collectionButton];
        [_operationView addSubview:shareButton];
        
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_operationView.mas_right).offset(-20);
            make.centerY.equalTo(_operationView);
        }];
        
        [downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_operationView);
            make.right.equalTo(shareButton.mas_left).offset(-20);
        }];
        
        [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(downloadButton.mas_left).offset(-20);
            make.centerY.equalTo(_operationView);
        }];
    }else{
        [_operationView addSubview:buyButton];
        if ([_orderStatus isEqualToString:@"1"]||[_commodity.price isEqualToString:@"0"]) {
            _operationView.hidden = YES;
        }else{
            _operationView.hidden = NO;
        }
        
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_operationView);
            make.right.equalTo(_operationView.mas_right).offset(-10);
        }];
    }
}

/**
 *  获取课程下的所有章节视频
 */
-(void)fetchSectionVideo{
    AuthManager *am = [AuthManager sharedInstance];
    NSString *userId = @"";
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchSectionVideoWithID:_objectId UserId:userId Success:^(VideoBoxResult *result) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray: result.videoBox.videoList];
        if ([result.videoBox.isCollect intValue]==1) {
            [collectionButton setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
            isCollected = YES;
        }

        if ([dataArray count]>0) {
            titleView.hidden  = YES;
            currentRow = 0;
            _currentVideo = dataArray[0];
            _currentVideo.isChosen = 1;
            [dataArray replaceObjectAtIndex:0 withObject:_currentVideo]; //当前正在播放的视频
            [self setupPlayerView];
        }
        [SVProgressHUD dismiss];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"数据加载失败"];
    }];
}
// 成套视频
-(void)fetchCommodityVideoList{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CommodityManager *cm = [[CommodityManager alloc]init];
    [cm fetchCommodityVideoListWithGoodsId:_objectId UserId:userId Success:^(VideoListResult *result) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray: result.videoList];
        if ([dataArray count]>0) {
            titleView.hidden  = YES;
            _orderStatus = result.orderStatus;
            currentRow = 0;
            _currentVideo = dataArray[0];
            _currentVideo.isChosen = 1;
            [dataArray replaceObjectAtIndex:0 withObject:_currentVideo]; //当前正在播放的视频
            [self setupPlayerView];
        }
        [SVProgressHUD dismiss];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"数据加载失败"];
    }];
}

-(void)buyCourse{
    if (!_player.isPrepared) { //视频未加载完成，不允许跳转
        return;
    }
    // 暂停
    [self.player.mediaPlayer.player pause];

    CourBuyViewController *buyVC = [[CourBuyViewController alloc]init];
    buyVC.commodity = _commodity;
    [self.navigationController pushViewController:buyVC animated:YES];
}

-(void)collectCourse{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        return;
    }
    if (_objectId) {
        CourseManager *cm = [[CourseManager alloc]init];
        int type = isCollected?0:1;
        [cm addVideoToCollectionWithUserId:am.userInfo.userId VideoId:_currentVideo.videoId CourseId: _objectId State:[NSString stringWithFormat:@"%d",type] Success:^(CommonResult *result)  {
            if (isCollected) {
                isCollected = NO;
                [collectionButton setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
            }else{
                isCollected = YES;
                [collectionButton setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NEEDREFRESH" object:nil];
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(void)downloadVideo{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:@"download_type"];
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable &&type==1){
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否设置允许使用移动数据下载？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertView.tag = 1001;
        [alertView show];
        return;
    }
    
    //正在下载视频
    NSMutableArray *LoadingArray = [[DownloadManager sharedDownloadManager]arrayDownLoadSessionModals];
    //本地视频
    NSMutableArray *LoactionArray = [[DownloadManager sharedDownloadManager]arrayDownLoadedSessionModals];
    for(DownloadModal *loadmodal in LoadingArray)
    {
        if([_currentVideo.videoId isEqualToString:loadmodal.stringSourseId])
        {
            [self loadPromptImage];//添加加入队列提示
            return;
        }
    }
    for(DownloadModal *loaction in LoactionArray)
    {
        if([_currentVideo.videoId isEqualToString: loaction.stringSourseId])
        {
            
            [self loadPromptImage];//添加加入队列提示框
            
            return;
        }
    }
    
    DownloadModal  *downloadModal = [[DownloadModal alloc]init];
    downloadModal.stringVideoName = _currentVideo.name;//标题的名字
    downloadModal.stringShowImageURL = _currentVideo.pic;//图片头像
    downloadModal.stringDownloadURL = _currentVideo.address;//下载地址
    downloadModal.stringCustomId = am.userInfo.userId;//账号id
    downloadModal.stringSourseId = _currentVideo.videoId;//视频id
    downloadModal.stringPlayTime = _currentVideo.timeSpan; //视频播放时长
    //downloadModal.stringVideoAuthor = _currentVideo.playCount;//观看次数
    [downloadModal setStringTotalSize: _currentVideo.content];//视频大小
    [[DownloadManager sharedDownloadManager]addDownloadTask: downloadModal];//添加下载队列
    [self loadPromptImage];//添加加入队列提示框
}

-(void)shareCourse{
    if (!_player.isPrepared) { //视频未加载完成，不允许跳转
        return;
    }
    // 暂停
    [self.player.mediaPlayer.player pause];
    
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    
    shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
    shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
    
    ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

//点击下载时弹出提示框
-(void)loadPromptImage
{
    UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"加入队列" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [AlertView show];
}

#pragma talbeview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourSectionTableCell *cell = [[CourSectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionCell"];
    CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:videoInfo];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==currentRow) {
        return;
    }
    CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
    if(videoInfo.isfree==1){
        if (!_player.isPrepared) { //上一个视频加载中不允许切换
            return;
        }
        _currentVideo.isChosen = 0; //取消上一个的选中效果
        [dataArray replaceObjectAtIndex:currentRow withObject:_currentVideo];
        
        CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
        currentRow = indexPath.row;
        _currentVideo = videoInfo;
        _currentVideo.isChosen = 1;
        [dataArray replaceObjectAtIndex:indexPath.row withObject:_currentVideo]; //当前正在播放的视频
        [tableView reloadData];
        if (videoInfo.address) {
            [self playWithUrl:videoInfo.address];
        }
    }else{
        AuthManager *am = [AuthManager sharedInstance];
        if(!am.isAuthenticated)
        {
            [self showLoginView];
            return;
        };
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"购买后即可拥有" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去购买",nil];
        alert.tag = 1002;
        [alert show];
    }
}

#pragma alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag == 1001) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:2 forKey:@"download_type"];
            [self downloadVideo];
        }else if (alertView.tag == 1002) {
            [self.player.mediaPlayer.player pause];
            if(_type==1){
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                if ([_thirdPay.version isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]&&[_thirdPay.thirdPay isEqualToString:@"0"]){
                    IAPVIPController *iapVC =[[IAPVIPController alloc]init];
                    iapVC.callbackBlock = ^{
                        [self fetchSectionVideo];
                    };
                    iapVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:iapVC animated:YES];
                }else{
                    VIPSubController *vipVC =[[VIPSubController alloc]init];
                    vipVC.callbackBlock = ^{
                        [self fetchSectionVideo];
                    };
                    vipVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vipVC animated:YES];
                }
            }else{
                CommodityPayVC *payVC = [[CommodityPayVC alloc]init];
                payVC.commodity = _commodity;
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }
    }
}

-(void)showLoginView{
    [self.player.mediaPlayer.player pause];
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    loginViewCon.successFunc = ^{
        if (_type==1) {
            [self fetchSectionVideo];
        }else{
            [self fetchCommodityVideoList];
        }
    };
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = _currentVideo.name;
    NSString *url = [NSString stringWithFormat: @"http://api.olaxueyuan.com/course.html?courseId=%@",_objectId];
    
    switch((int)imageIndex){
        case 0:
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 1:
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 2:
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:url];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 3:
            [UMSocialData defaultData].extConfig.qqData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.qqData.url =url;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 4:
            // QQ空间分享只支持图文分享（图片文字缺一不可）
            [UMSocialData defaultData].extConfig.qzoneData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.qzoneData.url = url;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
