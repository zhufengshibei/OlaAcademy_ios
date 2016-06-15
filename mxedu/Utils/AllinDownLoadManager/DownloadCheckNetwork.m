//
//  DownloadCheckNetwork.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/4/13.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "DownloadCheckNetwork.h"
#import "DownloadManager.h"
#import "Reachability.h"
static DownloadCheckNetwork *sharedDownloadCheckNetwork = nil;

@implementation DownloadCheckNetwork

+ (id)sharedDownloadCheckNetwork
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedDownloadCheckNetwork = [[DownloadCheckNetwork alloc] init];
        });
        return sharedDownloadCheckNetwork;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkDownLoadNetwork
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification object:nil];
}

- (void)reachabilityChanged:(NSNotification *)note
{
//    NSString *customerID = [AllinUserDefault  objectForKey:kLog_CustomerId];
//    if(!customerID || [customerID length] == 0)
//    {
//        return;
//    }
//    
   // NSString *wifiType = (NSString *)[AllinUserDefault objectForKey:@"wifiType"];
    Reachability *reachability = [note object];
    // wifi
    if(reachability.isReachableViaWiFi)
    {
        if([[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] &&
           [[[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] count])
        {
            [[DownloadManager sharedDownloadManager] beginAllDownLoadTask];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshDownloadVideoStatus", ) object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
            
//            if([[VCManager windowTopVC] isKindOfClass:[AllinMyVideoDownloadVC class]])
//            {
//                AllinMyVideoDownloadVC *newViewController = (AllinMyVideoDownloadVC *)[VCManager windowTopVC];
//                [newViewController dissMissNetAlert];
//            }
        }
        [self refreshMyVC];
    }
    // 2g/3g/4g
    else if(reachability.isReachableViaWWAN)
    {
        // off
//        if([wifiType isEqualToString:@"1"])
//        {
//            [self startDownload];
//        }
//        // on
//        else if ([wifiType isEqualToString:@"2"])
//        {
//            [self pauseDownload];
//        }
//        
//        [self refreshMyVC];
    }
    else if(![reachability isReachable])
    {
//        if([[VCManager windowTopVC] isKindOfClass:[AllinMyVideoDownloadVC class]])
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"网络未连接，请检查网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
        
        if([[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] &&
           [[[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] count])
        {
            [[DownloadManager sharedDownloadManager] pauseAllDownLoadTask];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshDownloadVideoStatus", ) object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
        }
    }
}

- (void)startDownload
{
    if([[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] &&
       [[[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] count])
    {
        [[DownloadManager sharedDownloadManager] beginAllDownLoadTask];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshDownloadVideoStatus", ) object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
        
//        if([[VCManager windowTopVC] isKindOfClass:[AllinMyVideoDownloadVC class]])
//        {
//            AllinMyVideoDownloadVC *newViewController = (AllinMyVideoDownloadVC *)[VCManager windowTopVC];
//            [newViewController dissMissNetAlert];
//        }
    }
}

- (void)pauseDownload
{
    if([[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] &&
       [[[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] count])
    {
        [[DownloadManager sharedDownloadManager] pauseAllDownLoadTask];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshDownloadVideoStatus", ) object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
        
//        if([[VCManager windowTopVC] isKindOfClass:[AllinMyVideoDownloadVC class]])
//        {
//            AllinMyVideoDownloadVC *newViewController = (AllinMyVideoDownloadVC *)[VCManager windowTopVC];
//            [newViewController showAlert];
//        }
    }
}

- (void)refreshMyVC
{
//    AllinRootVC * allinRootVC = AllinAppRootVC;
//    AllinTabBarController * tabbarControl = allinRootVC.tabBarController;
//    
//    AllInBaseNavigationController * navRootMy =
//    [tabbarControl viewControllers][eMy];
//    
//    if([[navRootMy viewControllers] count])
//    {
//        if ([[[navRootMy viewControllers] lastObject] isKindOfClass:[AllinMyVC class]]) {
//            AllinMyVC *allinMyVC = [[navRootMy viewControllers] lastObject];
//            if(allinMyVC && [allinMyVC isViewLoaded])
//            {
//                [allinMyVC requestMy];
//            }
//        }
//    }
}

@end
