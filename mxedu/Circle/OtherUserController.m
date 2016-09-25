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

@interface OtherUserController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) OtherHeadView *headView;

@end

@implementation OtherUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _headView = [[OtherHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(300))];
     [_headView updateWithUser:_userInfo];
    _tableView.tableHeaderView = _headView;
    
    [self fetchUserData];
}

-(void)fetchUserData{
   
}

-(void)attendUser:(NSString*)type{
    OLA_LOGIN;
    AttentionManager *atm = [[AttentionManager alloc]init];
    [atm attendOtherWithUserId:am.userInfo.userId AttendedId:_userInfo.userId Type:type success:^(CommonResult *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(320);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
