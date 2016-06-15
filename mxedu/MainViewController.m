//
//  MainViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/8/2.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "MainViewController.h"

#import "SKSplashIcon.h"
#import "AuthManager.h"
#import "SysCommon.h"

@interface MainViewController ()

@property (strong, nonatomic) SKSplashView *splashView;

@end

@implementation MainViewController

@synthesize tabbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 启动动画
//    AuthManager *am = [[AuthManager alloc]init];
//    if (am.isAuthenticated) {
//        SKSplashIcon *swiftSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"ic_logo_white"] animationType:SKIconAnimationTypeBounce];
//        _splashView = [[SKSplashView alloc] initWithSplashIcon:swiftSplashIcon backgroundColor:COMMONBLUECOLOR animationType:SKSplashAnimationTypeNone];
//        _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
//        _splashView.animationDuration = 2; //Optional -> set animation duration. Default: 1s
//        [self.view addSubview:_splashView];
//        [_splashView startAnimation];
//    }
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
