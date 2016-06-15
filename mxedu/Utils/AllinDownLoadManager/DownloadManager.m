//
//  DownloadManager.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/6/18.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "DownloadManager.h"
#import "DataManager.h"
#import "DownloadModal.h"
#import "SDHeader.h"
// 一次最多下载次数
#define kMaxDownloadPer         3


static DownloadManager *sharedDownLoadManager = nil;

@implementation DownloadManager
+ (id)sharedDownloadManager
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedDownLoadManager = [[DownloadManager alloc] init];
        });
    }
    return sharedDownLoadManager;
}

- (void)dealloc
{
    _arrayDownLoadSessionModals = nil;
    _arrayDownLoadedSessionModals = nil;
}

- (instancetype)init
{
    if(self = [super init])
    {
        _arrayDownLoadSessionModals = [[NSMutableArray alloc] init];
        _arrayDownLoadedSessionModals = [[NSMutableArray alloc] init];
    }
    return self;
}

// 当前总共下载的数目
- (NSInteger)totalDownloadingTask
{
    NSInteger totalDownloading = 0;
    for (int i = 0; i< [_arrayDownLoadSessionModals count]; i++)
    {
        DownloadModal *downloadModal = (DownloadModal *)_arrayDownLoadSessionModals[i];
        if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
           ([downloadModal downloadStatusType] == eDownloadStatusOn))
        {
            totalDownloading ++;
        }
    }
    
    return totalDownloading;
}

// 添加下载任务
- (void)addDownloadTask:(DownloadModal *)downloadModal
{
    [_arrayDownLoadSessionModals addObject:downloadModal];
    
    // 决定是否开始下载
    if([self totalDownloadingTask] < kMaxDownloadPer)
    {
        [downloadModal startDownload];
    }
    else
    {
        [downloadModal waitToDownload];
    }
}

// 下载完成/删除完后将最近一个开始下载
- (void)remakeDownloads
{
    NSInteger downLoadCount = 0;
    for(DownloadModal *downloadModal in _arrayDownLoadSessionModals)
    {
        if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
           [downloadModal downloadStatusType] == eDownloadStatusOn)
        {
            downLoadCount ++;
        }
        else if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
           ([downloadModal downloadStatusType] == eDownloadStatusWait) && downLoadCount < kMaxDownloadPer)
        {
            downLoadCount ++;
            [downloadModal startDownload];
        }
    }
}

// 全部开始下载
- (void)beginAllDownLoadTask
{
    // 将on －> pause
//    for(DownloadModal *downloadModal in _arrayDownLoadSessionModals)
//    {
//        if([downloadModal downloadStatusType] != DownloadStatusPause)
//        {
//            [downloadModal pauseDownload];
//        }
//    }
    
    NSInteger downLoadCount = 0;
    for(DownloadModal *downloadModal in _arrayDownLoadSessionModals)
    {
        if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]])
        {
            downLoadCount ++;
            
            if(downLoadCount <= kMaxDownloadPer)
            {
                if([downloadModal downloadStatusType] == eDownloadStatusPause)
                {
                    [downloadModal startDownload];
                }
            }
            else
            {
                if([downloadModal downloadStatusType] == eDownloadStatusPause)
                {
                    [downloadModal waitToDownload];
                }
            }
        }
    }
}

// 全部暂停下载
- (void)pauseAllDownLoadTask
{
    for(DownloadModal *downloadModal in _arrayDownLoadSessionModals)
    {
        if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
           ([downloadModal downloadStatusType] != eDownloadStatusPause))
        {
            [downloadModal pauseDownload];
        }
    }
}

// 启动一个下载
- (void)startASessionTask:(DownloadModal *)downloadModal
{
    if([self totalDownloadingTask] < kMaxDownloadPer)
    {
        if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
           ([downloadModal downloadStatusType] == eDownloadStatusPause))
        {
            [downloadModal startDownload];
        }
    }
    else
    {
        if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
           ([downloadModal downloadStatusType] == eDownloadStatusPause))
        {
            [downloadModal waitToDownload];
        }
    }
}

// 暂停一个下载
- (void)pauseASessionTask:(DownloadModal *)downloadModal
{
    if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]] &&
       ([downloadModal downloadStatusType] != eDownloadStatusPause))
    {
        [downloadModal pauseDownload];
    }
}

// 停止一个下载
- (void)stopASessionTask:(DownloadModal *)downloadModal
{
    if([[downloadModal stringCustomId] isEqualToString:[DataManager customerId]])
    {
        [downloadModal stopDownload];
    }
}

// 下载完成后添加完成任务
- (void)addACompleteSessionTask:(DownloadModal *)downloadModal
{
    BOOL isIn = NO;
    for(DownloadModal *downloadModalIn in _arrayDownLoadedSessionModals)
    {
        if([[downloadModalIn stringCustomId] isEqualToString:[downloadModal stringCustomId]] &&
           ([[downloadModalIn stringSourseId] isEqualToString:[downloadModal stringSourseId]]))
        {
            isIn = YES;
        }
    }
    if(isIn == NO)
    {
        [_arrayDownLoadedSessionModals addObject:downloadModal];
        NSNumber *numberVideoNum = [NSNumber numberWithInteger:_arrayDownLoadedSessionModals.count];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeLocalVideoNum", ) object:numberVideoNum];
    }
}

// 下载完成后删除完成任务
- (void)deleteACompleteSessionTask:(DownloadModal *)downloadModal
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:_arrayDownLoadSessionModals];
    for(DownloadModal *downloadModalIn in _arrayDownLoadSessionModals)
    {
        if([[downloadModalIn stringCustomId] isEqualToString:[downloadModal stringCustomId]] &&
           ([[downloadModalIn stringSourseId] isEqualToString:[downloadModal stringSourseId]]))
        {
            [tmpArr removeObject:downloadModalIn];
        }
    }
    _arrayDownLoadSessionModals = tmpArr;
}

// 删除一个已经下载后的任务
- (void)deleteAComletedVideo:(DownloadModal *)downloadModal
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:_arrayDownLoadedSessionModals];
    for(DownloadModal *downloadModalIn in _arrayDownLoadedSessionModals)
    {
        if([[downloadModalIn stringCustomId] isEqualToString:[downloadModal stringCustomId]] &&
           ([[downloadModalIn stringSourseId] isEqualToString:[downloadModal stringSourseId]]))
        {
            [tmpArr removeObject:downloadModalIn];
        }
    }
    _arrayDownLoadedSessionModals = tmpArr;
    NSNumber *numberVideoNum = [NSNumber numberWithInteger:_arrayDownLoadedSessionModals.count];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeLocalVideoNum", ) object:numberVideoNum];
}

@end
