//
//  DownloadManager.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/6/18.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModal.h"
#import "SDHeader.h"
//#import "AllinMyDownloadVideo_request.h"
@interface DownloadManager : NSObject<NSURLSessionDelegate>
// 未下载完成的
@property (nonatomic,strong) NSMutableArray *arrayDownLoadSessionModals;

// 下载完成的
@property (nonatomic,strong) NSMutableArray *arrayDownLoadedSessionModals;

// 下载状态
@property (nonatomic,assign) DownloadStatusType downloadStatusType;

// 获取实例
+ (id)sharedDownloadManager;

// 添加下载任务
- (void)addDownloadTask:(DownloadModal *)downloadModal;

// 下载完成后将最近一个开始下载
- (void)remakeDownloads;

// 全部开始下载
- (void)beginAllDownLoadTask;

// 全部暂停下载
- (void)pauseAllDownLoadTask;

// 启动一个下载
- (void)startASessionTask:(DownloadModal *)downloadModal;

// 暂停一个下载
- (void)pauseASessionTask:(DownloadModal *)downloadModal;

// 停止一个下载
- (void)stopASessionTask:(DownloadModal *)downloadModal;

// 下载完成后添加完成任务
- (void)addACompleteSessionTask:(DownloadModal *)downloadModal;

// 下载完成后删除完成任务
- (void)deleteACompleteSessionTask:(DownloadModal *)downloadModal;

// 删除一个已经下载后的任务
- (void)deleteAComletedVideo:(DownloadModal *)downloadModal;

@end
