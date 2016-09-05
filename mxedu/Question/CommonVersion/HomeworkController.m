//
//  TeachHomeworkController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkController.h"

#import "SysCommon.h"
#import "HomeworkTableViewObject.h"

#import "HomeworkManager.h"
#import "AuthManager.h"
#import "MonthHomework.h"
#import "MJRefresh.h"

#import "GroupViewController.h"
#import "QuestionWebController.h"

@interface HomeworkController ()<MeetingTableViewDelegate>

@property (nonatomic) UIImageView *groupBtn;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) HomeworkTableViewObject *tableViewObject;
@property (nonatomic) NSString *userId;

@end

@implementation HomeworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_type isEqualToString:@"1"]) {
        self.navigationItem.title = @"我的作业";
        [self setupBackButton];
    } else {
        self.navigationItem.title = @"老师版";
        [self setupRightButton];
    }
    
    
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        [self setupTableView];
        _userId = am.userInfo.userId;
        _dataSource = [[NSMutableArray alloc] init];
        [_tableView.header beginRefreshing];
    }else{
        
    }
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

- (void)setupDataWithId:(NSString*)homeworkId
{
    HomeworkManager *hm = [[HomeworkManager alloc]init];
    [hm fetchHomeworkListWithHomeworkId:homeworkId PageSize:@"20" UserId:_userId Type:_type Success:^(HomeworkListResult *result) {
        
        if ([homeworkId isEqualToString:@""]) {
            [_dataSource removeAllObjects];
            if ([_dataSource count]==20) {
                self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    Homework *homework = [_dataSource lastObject];
                    if (homework) {
                        [self setupDataWithId:homework.homeworkId];
                    }
                }];
            }
        }
        [_dataSource addObjectsFromArray:result.homeworkArray];
        _tableViewObject.dataSource = [self configDataWithArray:_dataSource];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
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
    if ([_type isEqualToString:@"1"]) {
        QuestionWebController *questionVC = [[QuestionWebController alloc]init];
        questionVC.titleName = model.name;
        questionVC.objectId = model.homeworkId;
        questionVC.type = 3;
        questionVC.callbackBlock = ^{
            [self setupDataWithId:@""];
        };
        [self.navigationController pushViewController:questionVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
