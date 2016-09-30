//
//  TeaHomeworkController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/30.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "TeaHomeworkController.h"

#import "SysCommon.h"
#import "HomeworkTableViewObject.h"

#import "HomeworkManager.h"
#import "AuthManager.h"
#import "MonthHomework.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "DWBubbleMenuButton.h"

#import "GroupViewController.h"
#import "CreateGroupController.h"
#import "HomeworkChooseController.h"

@interface TeaHomeworkController ()<MeetingTableViewDelegate>

@property (nonatomic) UIImageView *groupBtn;
@property (nonatomic) UILabel *tipL;
@property (nonatomic) UIButton *btn;
@property (nonatomic) DWBubbleMenuButton *upMenuView;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) HomeworkTableViewObject *tableViewObject;
@property (nonatomic) NSString *userId;

@end

@implementation TeaHomeworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"老师版";
    [self setupRightButton];
    [self setupDefaultView];
    
    _dataSource = [[NSMutableArray alloc] init];
    [self setupDataWithId:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"NEEDREFRESH" object:nil];
}

-(void)setupRightButton{
    _groupBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _groupBtn.image = [UIImage imageNamed:@"ic_group"];
    _groupBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showGroupView)];
    [_groupBtn addGestureRecognizer:singleTap];
    [_groupBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:_groupBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)setupDefaultView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default"]];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-GENERAL_SIZE(120));
    }];
    
    _tipL = [[UILabel alloc]init];
    _tipL.text = @"加载中...";
    _tipL.textColor= RGBCOLOR(178, 180, 183);
    _tipL.font = LabelFont(24);
    [self.view addSubview:_tipL];
    
    [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom).offset(GENERAL_SIZE(30));
    }];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = GENERAL_SIZE(40);
    _btn.backgroundColor = COMMONBLUECOLOR;
    [self.view addSubview:_btn];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipL.mas_bottom).offset(GENERAL_SIZE(75));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(75));
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(75));
        make.height.equalTo(@(GENERAL_SIZE(80)));
    }];
}

-(void)showGroupView{
    GroupViewController *groupVC = [[GroupViewController alloc]init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
}

/**
 *  表格
 */
- (void)setupTableView
{
    _tableViewObject = [HomeworkTableViewObject new];
    _tableViewObject.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = _tableViewObject;
    _tableView.dataSource = _tableViewObject;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupDataWithId:@""];
    }];
}

-(void)setupDeployView{
    UILabel *homeLabel = [self createHomeButtonView];
    
    _upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 20.f,
                                                                                          self.view.frame.size.height - homeLabel.frame.size.height - 50.f,
                                                                                          homeLabel.frame.size.width,
                                                                                          homeLabel.frame.size.height)
                                                            expansionDirection:DirectionUp];
    _upMenuView.homeButtonView = homeLabel;
    
    [_upMenuView addButtons:[self createDemoButtonArray]];
    
    [self.view addSubview:_upMenuView];
}

- (void)setupDataWithId:(NSString*)homeworkId
{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        return;
    }
    _btn.hidden = YES;
    _tipL.text = @"加载中...";
    HomeworkManager *hm = [[HomeworkManager alloc]init];
    _userId = am.userInfo.userId;
    [hm fetchHomeworkListWithHomeworkId:homeworkId PageSize:@"20" UserId:_userId Type:@"2" Success:^(HomeworkListResult *result) {
        
        if ([homeworkId isEqualToString:@""]) {
            if(result.code == 10001){
                _tipL.text = @"您尚未创建作业群";
                _btn.hidden = NO;
                [_btn setTitle:@"创建作业群" forState:UIControlStateNormal];
                [_btn addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchDown];
                if (_tableView) {
                    [_tableView removeFromSuperview];
                }
                if (_upMenuView) {
                    [_upMenuView removeFromSuperview];
                }
                
            }else if(result.code == 10000){
                [self setupTableView];
                [self setupDeployView];
                [_dataSource removeAllObjects];
                if ([_dataSource count]==20) {
                    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        Homework *homework = [_dataSource lastObject];
                        if (homework) {
                            [self setupDataWithId:homework.homeworkId];
                        }
                    }];
                }
            }else{
                _tipL.text = @"加载失败";
                _btn.hidden = NO;
                [_btn setTitle:@"重新加载" forState:UIControlStateNormal];
                [_btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchDown];
            }
        }
        [_dataSource addObjectsFromArray:result.homeworkArray];
        _tableViewObject.dataSource = [self configDataWithArray:_dataSource];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        _tipL.text = @"加载失败";
        _btn.hidden = NO;
        [_btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchDown];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}


- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"数学", @"英语", @"逻辑", @"写作"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(deployHomework:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)deployHomework:(UIButton *)sender {
    HomeworkChooseController *chooseVC = [[HomeworkChooseController alloc]init];
    chooseVC.subjectType = (int)sender.tag+1;
    chooseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (UIButton *)createButtonWithName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


-(void)reloadData{
    [self setupDataWithId:@""];
}

-(void)createGroup{
    CreateGroupController *createVC = [[CreateGroupController alloc]init];
    createVC.groupCreateBlock = ^{
        [self setupDataWithId:@""];
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

/**
 *  整理数据
 *
 *  @param array
 *
 *  @return
 */
- (NSArray*)configDataWithArray:(NSArray*)array
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    
    MonthHomework *monthModel = nil;
    
    for (Homework *item in array) {
        
        if (![item.month isEqualToString:monthModel.month]) {
            if (monthModel) {
                [dataSource addObject:monthModel];
            }
            
            monthModel = [[MonthHomework alloc] init];
            monthModel.homeworkArray = [[NSMutableArray alloc] init];
            monthModel.month = item.month;
        }
        
        if (item) {
            [monthModel.homeworkArray addObject:item];
        }
        
    }
    
    if (![dataSource containsObject:monthModel] && monthModel) {
        [dataSource addObject:monthModel];
    }
    
    return dataSource;
}

-(void)tableView:(UITableView *)tableView didSelectRowWithModel:(Homework *)model{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

