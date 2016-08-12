//
//  HomeworkViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkViewController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "AuthManager.h"
#import "HomeworkTableCell.h"
#import "HomeworkManager.h"
#import "QuestionWebController.h"

@interface HomeworkViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation HomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的作业";
    [self setupBackButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData:@""];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Homework *homework = [_dataArray lastObject];
        if (homework) {
            [self setupData:homework.homeworkId];
        }
    }];
    
    [self setupData:@""];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupData:(NSString*)homeworkId{
    AuthManager *am = [[AuthManager alloc]init];
    HomeworkManager *hm = [[HomeworkManager alloc]init];
    [hm fetchHomeworkListWithHomeworkId:homeworkId PageSize:@"20" UserId:am.userInfo.userId Success:^(HomeworkListResult *result) {
        if ([homeworkId isEqualToString:@""]) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.homeworkArray];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkTableCell *cell = [[HomeworkTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeworkTableCell"];
    Homework *homework = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCellWithModel:homework];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Homework *homework = [_dataArray objectAtIndex:indexPath.row];
    QuestionWebController *questionVC = [[QuestionWebController alloc]init];
    questionVC.titleName = homework.name;
    questionVC.objectId = homework.homeworkId;
    questionVC.type = 3;
    questionVC.callbackBlock = ^{
        [self setupData:@""];
    };
    [self.navigationController pushViewController:questionVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
