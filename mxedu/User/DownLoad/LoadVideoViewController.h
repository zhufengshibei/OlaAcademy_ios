//
//  LoadVideoViewController.h
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DownLoadSubViews.h"
#import "DownloadModal.h"
#define PlayPortrait  0


@interface LoadVideoViewController : DownLoadSubViews

@property (nonatomic, strong) void (^addHeadView)(); //解决本地播放后，视图上移问题

@end
