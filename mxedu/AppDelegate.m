//
//  AppDelegate.m
//  mxedu
//
//  Created by 田晓鹏 on 15/8/2.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "RightViewController.h"
#import "IntroViewController.h"
#import "IndexViewController.h"

#import "MobClick.h"
#import "UMSocialConfig.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "AuthManager.h"

#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WXApiObject.h"

#import "DataManager.h"
#import "DownloadManager.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setup];
    
    
    // 是否第一次登录
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   	BOOL is = [userDefaults integerForKey:@"alreadyUsed"];
    if (!is) {
        IntroViewController *introVC = [[IntroViewController alloc]init];
        [self.window setRootViewController:introVC];
        [self.window makeKeyAndVisible];
    }else{
        //判断用户账号有本地存储
        AuthManager *am =[[AuthManager alloc]init];\
        if(am.isAuthenticated)
        {
            [[DataManager sharedDataManager] readDownloadVideo];
            [[DataManager sharedDataManager] readDownloadedVideo];
//            [[DataManager sharedDataManager] pauseAllDownLoadTask];
        }
        
        [self setupRootView];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[DataManager sharedDataManager] readCache];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[DownloadManager sharedDownloadManager] pauseAllDownLoadTask];
    // 写入缓存
    [[DataManager sharedDataManager] saveCache];
    [[DataManager sharedDataManager] saveDownloadVideo];
    [[DataManager sharedDataManager] saveDownloadedVideo];
}

// 支付回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    #warning 支付是否成功回调尚存在问题
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {
        //微信支付
        [WXApi handleOpenURL:url delegate:self];
    }
    NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return YES;
}


- (void)setup
{
    [self setupNavigationBar];
    [self setupManagers];
    [self setupUMShare];
    [self setupWXPay];
}

-(void)setupNavigationBar{
    UINavigationBar * appearance = [UINavigationBar appearance];
    appearance.translucent = NO;
    //设置显示的颜色
    appearance.barTintColor = COMMONBLUECOLOR;
    //设置字体颜色
    appearance.tintColor = [UIColor whiteColor];
    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

-(void)setupRootView{
//    AuthManager *am = [[AuthManager alloc]init];
//    if (!am.isAuthenticated) {
//        IndexViewController *indexVC = [[IndexViewController alloc]init];
//        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:indexVC];
//        self.window.rootViewController = navController;
//
//    }else{
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
        MainViewController * mainVC = [board instantiateViewControllerWithIdentifier:@"mainView"];
        [mainVC setSelectedIndex:0];
        
        [self.window setRootViewController:mainVC];
        [self.window makeKeyAndVisible];
//    }
    
}

-(void)setupRootViewWithSlide{
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        IndexViewController *indexVC = [[IndexViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:indexVC];
        self.window.rootViewController = navController;
        
    }else{
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
        MainViewController * main = [board instantiateViewControllerWithIdentifier:@"mainView"];
        RightViewController * right = [[RightViewController alloc]init];
        
        [main setSelectedIndex:0];
        
        _slideViewController = [[SideslipViewController alloc]initWithMainView:main andRightView:right andBackgroundImage:[UIImage imageNamed:@"background"]];
        _slideViewController.isShowingMain = YES;
        
        //滑动速度系数
        [_slideViewController setSpeedf:0.5];
        //点击视图是是否恢复位置
        _slideViewController.sideslipTapGes.enabled = YES;
        
        [self.window setRootViewController:_slideViewController];
        [self.window makeKeyAndVisible];
    }
    
}

- (void)setupManagers
{
    _dataManager = [[DataMappingManager alloc] init];
}

-(void)pushToMainView{
    
    [self setupRootView];
    
}

// 友盟分析
-(void)setupUMAnalysis{
    [MobClick startWithAppkey:@"57414ca367e58edccb000cdc" reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

-(void)setupUMShare{
    
    [UMSocialData setAppKey:@"57414ca367e58edccb000cdc"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxc60b8fd5de5f874e" appSecret:@"f309138a94cb8f3948fdf7b1082bcd29" url:@"http://www.olaxueyuan.com"];
    //设置QQ AppId、appSecret，分享url
    [UMSocialQQHandler setQQWithAppId:@"1105343675" appKey:@"LMCCjR2U7M4QGhY1" url:@"http://www.olaxueyuan.com"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2432498933" secret:@"f517effe10a25aca694550447f6bf645" RedirectURL:@"http://app.olaxueyuan.com"];
    
#warning 审核需添加 未安装客户端平台进行隐藏
    //[UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
}

-(void)setupWXPay{
    [WXApi registerApp:@"wxc60b8fd5de5f874e" withDescription:@"mcPay"];
}

// 微信支付回调
-(void)onReq:(BaseReq *)resp{
    
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        //        switch (resp.errCode) {
        //            case WXSuccess:{
        //                strMsg = @"支付结果：成功！";
        //                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
        //                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"success"];
        //                [[NSNotificationCenter defaultCenter] postNotification:notification];
        //                break;
        //            }
        //            default:{
        //                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
        //                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
        //                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"fail"];
        //                [[NSNotificationCenter defaultCenter] postNotification:notification];
        //                break;
        //            }
        //        }
    }
}

// 视频的横竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    /**
     *  这里移动要注意，条件判断成功的是在播放器播放过程中返回的
     下面的是播放器没有弹出来的所支持的设备方向
     */
    if (self.vc){
        return self.vc.player.supportInterOrtation;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
