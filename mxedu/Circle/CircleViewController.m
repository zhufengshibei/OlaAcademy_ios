//
//  CircleViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleViewController.h"

#import "SysCommon.h"
#import "CircleTableCell.h"
#import "MJRefresh.h"

@interface CircleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation CircleViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欧拉圈";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData:@""];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        VideoHistory *videoHis = [_dataArray lastObject];
        if (videoHis) {
            [self setupData:videoHis.logId];
        }
    }];
    
    [self setupData:@""];
}

-(void)setupData:(NSString*)logId{
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchVideoHistoryListWithVideoLogId:logId PageSize:@"10" Success:^(VideoHistoryResult *result) {
        if ([logId isEqualToString:@""]) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.historyArray];
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleTableCell *cell = [[CircleTableCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"circleCell"];
    VideoHistory *history = [_dataArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:history];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoHistory *history = [_dataArray objectAtIndex:indexPath.row];
    CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
    sectionVC.objectId = history.courseId;
    sectionVC.type = 1;
    sectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sectionVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
