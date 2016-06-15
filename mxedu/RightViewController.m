//
//  RightViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/8/2.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "RightViewController.h"

#import "Masonry.h"
#import "SysCommon.h"

#define PUSH_TO_DOWNLOAD @"pushToMyDownload"

@interface RightViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource=self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(SCREEN_HEIGHT/10); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(3*SCREEN_WIDTH/10);
        make.bottom.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [headerView setBackgroundColor:RGBCOLOR(100, 181, 242)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 18)];
    label.textColor = [UIColor whiteColor];
    if (section==0) {
        label.text = @"下载";
    }else if (section==1){
        label.text = @"收藏";
    }
    [headerView addSubview:label];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * infoCell = @"InfoCell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:infoCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:infoCell];
    }
    if (indexPath.section==0) {
        cell.imageView.image = [UIImage imageNamed:@"ic_collection"];
        cell.textLabel.text=@"我的下载";
    }else if (indexPath.section==1) {
        cell.imageView.image = [UIImage imageNamed:@"ic_message_slide"];
        cell.textLabel.text=@"我的收藏";
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        NSNotification *notification=[NSNotification notificationWithName:PUSH_TO_DOWNLOAD object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if(indexPath.section==1){
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
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
