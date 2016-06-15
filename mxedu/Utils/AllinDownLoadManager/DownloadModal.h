//
//  DownloadModal.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/6/19.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDHeader.h"
//#import "AllinMyDownloadVideo_request.h"


@class AFURLSessionManager;
@protocol DownloadStatusDelget;
@interface DownloadModal : NSObject
<
NSCoding,
NSURLSessionDelegate,
NSURLSessionTaskDelegate,
NSURLSessionDownloadDelegate
>

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

/*
 内部
 */
/*视频*/
// 下载状态
@property (nonatomic,assign) DownloadStatusType downloadStatusType;
// 下载会话
@property (nonatomic,strong) NSURLSession *mSession;
// 下载任务
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

/*图片*/
// 下载会话
@property (nonatomic,strong) NSURLSession *mImgSession;
// 下载任务
@property (nonatomic,strong) NSURLSessionDownloadTask *imgDownloadTask;


// 下载cache路径
//@property (nonatomic,copy) NSString *stringTempPath;
// 下载后存储路径
@property (nonatomic,copy) NSString *stringDownloadPath;
// 下载后的图片存储路径
@property (nonatomic,copy) NSString *stringImgDownloadPath;
// 已经下载的数据 断点续传
@property (nonatomic,strong) NSData *dataDownload;
// 缩略图下载的数据 断点续传
@property (nonatomic,strong) NSData *dataImgDownload;
// 已经下载的文件大小
@property (nonatomic,strong) NSNumber *curloadSize;
// 代理
@property (nonatomic,weak) id<DownloadStatusDelget> delegate;
// 是否选中-删除
@property (nonatomic,assign) BOOL isSelect;

/*
 外界传
 */
// 下载人id
@property (nonatomic,copy) NSString *stringCustomId;
// 下载地址
@property (nonatomic,copy) NSString *stringDownloadURL;
// 下载资源id
@property (nonatomic,copy) NSString *stringSourseId;
// 视频播放长度
@property (nonatomic,copy) NSString *stringPlayTime;
// 缩略图
@property (nonatomic,copy) NSString *stringShowImageURL;
// 视频标题
@property (nonatomic,copy) NSString *stringVideoName;
// 作者
@property (nonatomic,copy) NSString *stringVideoAuthor;
// 视频总大小
@property (nonatomic,copy) NSString *stringTotalSize;

// 视频下载开始时间
@property (nonatomic,copy) NSString * startTime;
// 视频下载创建时间
@property (nonatomic,copy) NSString * creatTime;
// 视频下载结束时间
@property (nonatomic,copy) NSString * endTime;

/*
 赋值之后再调用 startDownload
 */
// 开始下载
- (void)startDownload;

// 暂停下载
- (void)pauseDownload;

// 等待下载
- (void)waitToDownload;

// 停止下载
- (void)stopDownload;

@end


@protocol DownloadStatusDelget <NSObject>

- (void)updateDownloadProgress:(DownloadModal *)downloadModal;

@end
