//
//  LoginViewController.m
//  bonedict
//
//  Created by 田晓鹏 on 15/7/14.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "IndexViewController.h"

#import "AuthManager.h"
#import "SysCommon.h"

#import "MainViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ForgetPassViewController.h"

#import <Masonry.h>

@interface IndexViewController ()

@end

@implementation IndexViewController

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImgView setImage:[UIImage imageNamed:@"background_login"]];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"btn_reg"] forState:UIControlStateNormal];
    [registBtn sizeToFit];
    [registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        if (iPhone6){
            make.top.equalTo(self.view.mas_top).offset(500);
        }else if (iPhone6Plus){
            make.top.equalTo(self.view.mas_top).offset(550);
        }else{
            make.top.equalTo(self.view.mas_top).offset(420);
        }
        
    }];
    
    UILabel *chLabel = [UILabel new];
    chLabel.text = @"欢迎使用Swift Academy";
    chLabel.font = [UIFont systemFontOfSize:24.0];
    chLabel.textColor = [UIColor whiteColor];
    [chLabel sizeToFit];
    [self.view addSubview:chLabel];
    [chLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(registBtn.mas_top).offset(-70);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *enLabel = [UILabel new];
    enLabel.text = @"Learning becomes smart,easy and free!";
    if (iPhone6||iPhone6Plus) {
        enLabel.font = [UIFont systemFontOfSize:20.0];
    }else{
        enLabel.font = [UIFont systemFontOfSize:16.0];
    }
    
    enLabel.textColor = [UIColor whiteColor];
    [enLabel sizeToFit];
    [self.view addSubview:enLabel];
    [enLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(registBtn.mas_top).offset(-30);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *userLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [userLogin setTitle:@"登录" forState:UIControlStateNormal];
    [userLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:userLogin];
    [userLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registBtn.mas_bottom).offset(15);
        make.centerX.equalTo(self.view).offset(0);
    }];
    
    UIButton *visitorLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [visitorLogin setTitle:@"游客进入" forState:UIControlStateNormal];
    visitorLogin.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [visitorLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [visitorLogin addTarget:self action:@selector(visit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:visitorLogin];
    [visitorLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(userLogin.mas_bottom).offset(10);
    }];
    
    UIImage *logo = [UIImage imageNamed:@"ic_logo_white"];
    CGFloat width = logo.size.width;
    CGFloat height = logo.size.height;
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:
                              CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT/2-30, width, height)];
    logoImage.image = logo;
    [self.view addSubview:logoImage];
    
    [self moveView:logoImage To:CGRectMake(SCREEN_WIDTH/2-30, 50, width, height)];
}

-(void)moveView:(UIView*)view To:(CGRect)frame{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    view.frame = frame;
    [UIView commitAnimations];
}

//进入登录页面
-(void)login{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//访客模式登入
- (void)visit {
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
    MainViewController * mainVC = [board instantiateViewControllerWithIdentifier:@"mainView"];
    [mainVC setSelectedIndex:0];
    [UIApplication sharedApplication].delegate.window.rootViewController = mainVC;
}

//用户注册
- (void)regist {
    RegisterViewController * regVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
