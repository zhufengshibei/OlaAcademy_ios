//
//  OtherUserController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "OtherUserController.h"

#import "SysCommon.h"
#import "OtherHeadView.h"
#import "AuthManager.h"
#import "LoginViewController.h"
#import "AttentionManager.h"
#import "HMSegmentedControl.h"
#import "CircleManager.h"
#import "UserPostTableCell.h"

@interface OtherUserController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UserPost *userPost;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) OtherHeadView *headView;

@end

@implementation OtherUserController{
    HMSegmentedControl *segmentedControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _headView = [[OtherHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(350))];
     [_headView updateWithUser:_userInfo];
    _tableView.tableHeaderView = _headView;
    
    [self fetchUserData];
}

-(void)fetchUserData{
    CircleManager *cm = [[CircleManager alloc]init];
    [cm fetchUserPostListWithUserId:_userInfo.userId Success:^(UserPostResult *result) {
        _userPost = result.userPost;
        _dataArray = result.userPost.deployList;
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}

-(void)attendUser:(NSString*)type{
    OLA_LOGIN;
    AttentionManager *atm = [[AttentionManager alloc]init];
    [atm attendOtherWithUserId:am.userInfo.userId AttendedId:_userInfo.userId Type:type success:^(CommonResult *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma tableview

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GENERAL_SIZE(100);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(100))];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    
    if (!segmentedControl) {
        segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(78))];
        segmentedControl.sectionTitles = @[@"TA的提问",@"TA的回答"];
        segmentedControl.selectedSegmentIndex = 0;
        
        segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBCOLOR(81, 84, 93), NSFontAttributeName : LabelFont(32)};
        segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COMMONBLUECOLOR, NSFontAttributeName: LabelFont(32)};
        segmentedControl.selectionIndicatorColor = COMMONBLUECOLOR;
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        segmentedControl.selectionIndicatorHeight = 2;
        segmentedControl.selectionIndicatorBoxOpacity = 0;
        
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl.backgroundColor = [UIColor whiteColor];
        segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        
        __weak OtherUserController* wself = self;
        [segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (index==0) {
                _dataArray = _userPost.deployList;
            }else{
                _dataArray = _userPost.replyList;
            }
            [wself.tableView reloadData];
        }];
    }
    [view addSubview:segmentedControl];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserPostTableCell *cell = [[UserPostTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userPostTableCell"];
    OlaCircle *circle = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCell:circle];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(130);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
