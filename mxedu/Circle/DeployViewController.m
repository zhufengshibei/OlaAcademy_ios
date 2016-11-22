//
//  AddSubPostViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 16/2/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DeployViewController.h"

#import "DeployViewController.h"
#import "SysCommon.h"
#import "UIImage+Resize.h"
#import "UIView+Positioning.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "UploadManager.h"
#import "QYSelectPhotoView.h"
#import "ALAsset+BSEqual.h"
#import "MCImageInfo.h"
#import "ImageCell.h"
#import "User.h"
#import "AuthManager.h"
#import "CircleManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DeployViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *rights;//导航栏右侧按钮
    
    UILabel *label; //content 的 placehoder
    UITextView *editText;
    
    NSMutableArray *choosenImages;
    UIImageView *addImage;
    UILabel *localtion;
    
    NSString *locationString;
    
    UIView *orgiView;
    UIView *localView;
    
    UIButton *addMediaButton;
    
    dispatch_queue_t _workingQueue;
    
    /**
     *  图片选择视图
     */
    QYSelectPhotoView *_selectPhotoView;
    
    NSURL *choiceURL;//选中视频的URL地址
    
    NSString *meidaType;//上传的媒体样式
    
    UITapGestureRecognizer *wholeTap;
}

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation DeployViewController

BOOL uploadOrignalImage;

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBar];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 180, 20)];
    label.enabled = NO;
    label.text = @"说说您的备考问题／经验";
    label.font =  [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    
    editText = [UITextView new];
    editText.tag=1002;
    int height = 100;
    if (iPhone6) {
        height = 110;
    }else if(iPhone6Plus){
        height = 120;
    }
    editText.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, height);
    editText.font=[UIFont systemFontOfSize:16];
    editText.backgroundColor = [UIColor whiteColor];
    editText.delegate = self;
    [editText addSubview:label];
    [self.view addSubview:editText];
    
    UIView *dividerLine3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(editText.frame), SCREEN_WIDTH, 5)];
    dividerLine3.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:dividerLine3];
    
    localView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dividerLine3.frame), SCREEN_WIDTH, 44)];
    localView.backgroundColor = [UIColor whiteColor];
    UILabel *localLabel = [[UILabel alloc]init];
    localLabel.text = @"所在位置";
    localLabel.textColor = RGBCOLOR(87, 87, 87);
    localtion = [[UILabel alloc]init];
    localtion.text = @"定位中...";
    [localView addSubview:localLabel];
    [localView addSubview:localtion];
    [self.view addSubview:localView];
    
    [localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(localView).offset(0);
        make.left.equalTo(localView.mas_left).offset(10);
    }];
    [localtion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(localView).offset(0);
        make.right.equalTo(localView.mas_right).offset(-10);
    }];
    
    UIView *dividerLine4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(localView.frame), SCREEN_WIDTH, 1)];
    dividerLine4.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:dividerLine4];
    
    
    orgiView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dividerLine4.frame)+5, SCREEN_WIDTH, 35)];
    orgiView.backgroundColor = [UIColor whiteColor];
    UILabel *oriLabel = [[UILabel alloc]init];
    oriLabel.text = @"上传原图";
    oriLabel.textColor = RGBCOLOR(87, 87, 87);
    UISwitch *switchButton = [[UISwitch alloc]init];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [orgiView addSubview:oriLabel];
    [orgiView addSubview:switchButton];
    [self.view addSubview:orgiView];
    
    
    [oriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orgiView).offset(0);
        make.left.equalTo(orgiView.mas_left).offset(10);
    }];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orgiView).offset(0);
        make.right.equalTo(orgiView.mas_right).offset(-10);
    }];
    
    addMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMediaButton setImage:[UIImage imageNamed:@"ic_choose_photo"] forState:UIControlStateNormal];
    [addMediaButton addTarget:self action:@selector(addPhotoView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMediaButton];
    
    [addMediaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orgiView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    uploadOrignalImage = NO;
    
    wholeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self setupLocation];
    
}

-(void)setupLocation{
    _locationmanager = [[CLLocationManager alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [_locationmanager requestWhenInUseAuthorization];// 前台定位
        //[_locationmanager requestAlwaysAuthorization];// 前后台同时定位
    }
    //设置定位的精度
    [_locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    //实现协议
    _locationmanager.delegate = self;
    
    //开始定位
    [_locationmanager startUpdatingLocation];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavBar
{
    [self.navigationItem setTitle:@"欧拉动态"];
    [self setupBackButton];
    
    //发布按钮
    rights=[UIButton buttonWithType:UIButtonTypeCustom];
    rights.frame=CGRectMake(0, 0, 40, 24);
    [rights setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [rights setTitle:@"发布" forState:UIControlStateNormal];
    rights.titleLabel.font = LabelFont(28);
    
    [rights addTarget:self action:@selector(deployMessage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc] initWithCustomView:rights];
    self.navigationItem.rightBarButtonItem = rightbtn;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [SVProgressHUD showInfoWithStatus:@"上传原图将耗费较多流量"];
        uploadOrignalImage = YES;
    }else {
        uploadOrignalImage = NO;
    }
}

-(void)deployMessage:(UIButton *)sender{
    if (editText.text.length<2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"内容不少于两个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    sender.enabled=NO;
    if (_selectPhotoView) {
        if (_selectPhotoView.photoData.count>0) {
            [self uploadImages];
        }else{
            [self savePostInfo:@""];
        }
        return;
        
    }
    [self savePostInfo:@""];
}
-(void)uploadImages{
    if (uploadOrignalImage) {
        [self uploadByImageDatas:_selectPhotoView.photoData Angles:_selectPhotoView.photoAngle];
    }else{
        [self uploadByImageDatas:_selectPhotoView.smallphotoData Angles:_selectPhotoView.photoAngle];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addGestureRecognizer:wholeTap];
}

-(void)addPhotoView{
    QYSelectPhotoView *selectPhotoView = [[QYSelectPhotoView alloc] initWithFrame:CGRectZero];
    selectPhotoView.delegate = self;
    selectPhotoView.isEnable = YES;
    selectPhotoView.isHiddenAdd=YES;
    selectPhotoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectPhotoView];
    _selectPhotoView = selectPhotoView;
    
    [selectPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orgiView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    [selectPhotoView showSelectPhotoView];
}

- (void)uploadByImageDatas:(NSArray*)imageDatas Angles:(NSArray*)angles
{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请先登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (imageDatas == nil || imageDatas.count == 0)
    {
        [SVProgressHUD showSuccessWithStatus:@"上传完毕。"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [SVProgressHUD showProgress:0.5 / (float)imageDatas.count
                         status:[NSString stringWithFormat:@"正在上传第%d张图片，共%lu张。", 1, (unsigned long)imageDatas.count]];
    
    UploadManager* um = [[UploadManager alloc]init];
    [um uploadImageDatas:imageDatas
                  angles:angles
                progress:^(NSInteger uploadedImageNum, NSInteger totalImageNum) {
                    float progress = ((float)uploadedImageNum  + 0.5) / (float)totalImageNum;
                    [SVProgressHUD showProgress:progress
                                         status:[NSString stringWithFormat:@"正在上传第%ld张图片，共%ld张。", (long)uploadedImageNum + 1, (long)totalImageNum]];
                }
                 success:^{
                     [SVProgressHUD showSuccessWithStatus:@"上传完毕。"];
                     NSMutableArray *imageGids =  um.imageGids;
                     NSString* imgIDs = @"";
                     int index = 0;
                     for (NSString* imgID in imageGids) {
                         imgIDs = [imgIDs stringByAppendingString:imgID];
                         if (index < [imageGids count]-1) {
                             imgIDs = [imgIDs stringByAppendingString:@","];
                         }
                         index++;
                     }
                     
                     [self savePostInfo:imgIDs];
                     
                 }
                 failure:^(NSError* error) {
                     
                 }];
}

-(void)savePostInfo:(NSString*) lstPic{
    AuthManager *am = [AuthManager sharedInstance];
    CircleManager* cm = [[CircleManager alloc]init];
    [cm addOlaCircleWithUserId:am.userInfo.userId Title:@"欧拉圈" content:editText.text imageGids:lstPic Location:locationString==nil?@"":locationString Type:@"2" Success:^(CommonResult *result) {
        if (_doneAction) {
            _doneAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - UICollectionView Datasource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (choosenImages != nil)
    {
        if (choosenImages.count % 3 == 0) {
            return 3;
        }else {
            if(section == choosenImages.count / 3){
                return choosenImages.count % 3;
            }else{
                return 3;
            }
        }
    }
    return 0;
}
//每个section的item个数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if (choosenImages != nil)
    {
        return choosenImages.count % 3 == 0? choosenImages.count/3:choosenImages.count/3+ 1;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    if (indexPath.row==choosenImages.count-1) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(getImages)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [tapRecognizer setDelegate:(id)self];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:tapRecognizer];
    }
    //加载图片
    if (choosenImages != nil) {
        if (indexPath.section==0) {
            cell.imageView.image = [choosenImages objectAtIndex:indexPath.row];
        }else{
            cell.imageView.image = [choosenImages objectAtIndex:indexPath.row+3*indexPath.section];
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/3-15, SCREEN_WIDTH/3-15);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark locationManager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           locationString = [NSString stringWithFormat:@"%@%@",place.locality,place.subLocality];
                           localtion.text = [NSString stringWithFormat:@"%@·%@",place.locality,place.subLocality];
                       }
                   }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
    localtion.text = @"定位失败";
}

/**
 *  隐藏键盘
 */
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:wholeTap];
}
@end
