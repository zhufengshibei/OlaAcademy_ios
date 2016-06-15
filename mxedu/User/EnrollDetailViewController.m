//
//  EnrollDetailViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/12/2.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "EnrollDetailViewController.h"

#import "User.h"
#import "SysCommon.h"
#import "Masonry.h"

@interface EnrollDetailViewController ()

@end

@implementation EnrollDetailViewController{

    UIButton *_enrollButton;
    
    
    UITextField *phoneText;
    UILabel *dateLabel;
    UIImageView *michenImageView;
    UIImageView *chenxingImageView;
    
    int type; //1通过幂辰报名 2 通过晨星报名
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    [self setupCheckinView];
}

- (void)setupBackButton
{
    self.title = @"报名详情";
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 11, 20);
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  报名
 */
- (void)setupCheckinView
{
    UIView *divider1 = [self dividerViewWithLable:@"报名机构"];
    [self.view addSubview:divider1];
    
    UILabel *orgLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 40)];
    orgLabel.text = _checkInfo.orgName;
    [self.view addSubview:orgLabel];
    
    UIView *divider2 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label.textColor = RGBCOLOR(128, 128, 128);
    label.text = @"报名手机";
    divider2.backgroundColor = RGBCOLOR(230, 230, 230);
    [divider2 addSubview:label];
    [self.view addSubview:divider2];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 200, 40)];
    phoneLabel.text = _checkInfo.userPhone;
    [self.view addSubview:phoneLabel];
    
    UIView *divider3 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 35)];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label3.textColor = RGBCOLOR(128, 128, 128);
    label3.text = @"报名时间";
    divider3.backgroundColor = RGBCOLOR(230, 230, 230);
    [divider3 addSubview:label3];
    [self.view addSubview:divider3];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 185, 200, 40)];
    timeLabel.text = _checkInfo.checkinTime;
    [self.view addSubview:timeLabel];
    
    UIView *divider4 = [[UIView alloc]initWithFrame:CGRectMake(0, 225, SCREEN_WIDTH, 35)];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label4.textColor = RGBCOLOR(128, 128, 128);
    label4.text = @"报名时间";
    divider4.backgroundColor = RGBCOLOR(230, 230, 230);
    [divider4 addSubview:label4];
    [self.view addSubview:divider4];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, 40)];
    if([_checkInfo.type isEqualToString:@"1"]){
        typeLabel.text = @"『Swift Academy』报名";
    }else{
        typeLabel.text = @"『晨星计划』报名";
    }
    
    [self.view addSubview:typeLabel];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_logo_gray"]];
    [self.view addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(typeLabel.mas_bottom).offset(50);
    }];
    
}

-(UIView*)dividerViewWithLable:(NSString*)labelString{
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label.textColor = RGBCOLOR(128, 128, 128);
    label.text = labelString;
    dividerView.backgroundColor = RGBCOLOR(230, 230, 230);
    [dividerView addSubview:label];
    return dividerView;
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
