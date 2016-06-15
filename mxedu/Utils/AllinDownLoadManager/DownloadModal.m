//
//  DownloadModal.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/6/19.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "DownloadModal.h"
#import "DataManager.h"
#import "DownloadManager.h"
#import "SDTool.h"
@implementation DownloadModal

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        Decode(stringCustomId);
        Decode(stringDownloadURL);
        Decode(stringSourseId);
        Decode(stringPlayTime);
        Decode(dataDownload);
        Decode(dataImgDownload);
        Decode(stringDownloadPath);
        Decode(stringImgDownloadPath);
        Decode(curloadSize);
        Decode(stringShowImageURL);
        Decode(stringVideoName);
        Decode(stringTotalSize);
        Decode(stringVideoAuthor);
        Decode(startTime);
        Decode(creatTime);
        
        self.downloadStatusType = [aDecoder decodeIntForKey:@"downloadStatusType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    Encode(stringCustomId);
    Encode(stringDownloadURL);
    Encode(stringSourseId);
    Encode(stringPlayTime);
    Encode(dataDownload);
    Encode(dataImgDownload);
    Encode(stringDownloadPath);
    Encode(stringImgDownloadPath);
    Encode(curloadSize);
    Encode(stringTotalSize);
    Encode(stringShowImageURL);
    Encode(stringVideoName);
    Encode(stringVideoAuthor);
    Encode(startTime);
    Encode(creatTime);
    [aCoder encodeInt:self.downloadStatusType forKey:@"downloadStatusType"];
    
}

- (instancetype)init
{
    if(self = [super init])
    {
        _curloadSize = @0;
    }
    return self;
}

// 开始下载
- (void)startDownload
{
    // 视频
    if(_stringDownloadURL && [_stringDownloadURL length])
    {
        [self startDownloadMedia];
        
        if(_dataDownload == nil)
        {
//            AllinMyDownloadVideo_request * downloadVideoRequest = [[AllinMyDownloadVideo_request alloc] init];
//            NSDate *currentDate = [NSDate date];//获取当前时间，日期
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *dateString = [dateFormatter stringFromDate:currentDate];
//            downloadVideoRequest.startTime = dateString;
//            downloadVideoRequest.createTime = self.creatTime;
//            downloadVideoRequest.resourceId = self.stringSourseId;
//            downloadVideoRequest.downloadType = @"1";
//            downloadVideoRequest.customerId = self.stringCustomId;
//            [self setStartTime:dateString];
        }
    }
    // 图片
    if(_stringShowImageURL && [_stringShowImageURL length] &&
       (_stringImgDownloadPath == nil || [_stringImgDownloadPath length] == 0))
    {
        [self startDownloadImg];
    }
}
// 开始下载图片
- (void)startDownloadImg
{
    if(!_mImgSession)
    {
        _mImgSession = [self imgBackgroundSession];
    }
    
    if(_dataImgDownload)
    {
        if(_imgDownloadTask)
        {
            _imgDownloadTask = nil;
        }
        
        _imgDownloadTask = [_mImgSession downloadTaskWithResumeData:_dataImgDownload];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imgDownloadTask resume];
        });
    }
    else
    {
        NSString *urlImgStr = [_stringShowImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *downloadImgURL = [NSURL URLWithString:urlImgStr];
        NSURLRequest *requestImg = [NSURLRequest requestWithURL:downloadImgURL];
        
        _imgDownloadTask = [_mImgSession downloadTaskWithRequest:requestImg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imgDownloadTask resume];
        });
    }
}

// 开始下载资源
- (void)startDownloadMedia
{
    if(!_mSession)
    {
        _mSession = [self mediaBackgroundSession];
    }
    
    if(_dataDownload)
    {
        [self setDownloadStatusType:eDownloadStatusOn];
        
        if(_downloadTask)
        {
            _downloadTask = nil;
        }
        
        _downloadTask = [_mSession downloadTaskWithResumeData:_dataDownload];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downloadTask resume];
        });
    }
    else
    {
        NSString *urlStr = [_stringDownloadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *downloadURL = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
        
        _downloadTask = [_mSession downloadTaskWithRequest:request];
        [self setDownloadStatusType:eDownloadStatusOn];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downloadTask resume];
        });
        
        // 保存临时文件
        [[DataManager sharedDataManager] saveDownloadVideo];
    }
}

// 暂停下载图片
- (void)pauseDownloadImg
{
    if(_imgDownloadTask)
    {
        [_imgDownloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            _dataImgDownload = resumeData;
            _imgDownloadTask = nil;
        }];
    }
}

// 暂停下载资源
- (void)pauseDownloadMedia
{
    [self setDownloadStatusType:eDownloadStatusPause];
    if(_downloadTask)
    {
        [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            _dataDownload = resumeData;
            _downloadTask = nil;
        }];
    }
}

// 暂停下载
- (void)pauseDownload
{
    /*图片*/
    [self pauseDownloadImg];
    /*资源*/
    [self pauseDownloadMedia];
}

// 停止下载图片
- (void)stopDownloadImg
{
    if(_dataImgDownload)
    {
        _imgDownloadTask = [_mImgSession downloadTaskWithResumeData:_dataImgDownload];
        [_imgDownloadTask cancel];
        _imgDownloadTask = nil;
    }
    if(_mImgSession)
    {
        [_mImgSession invalidateAndCancel];
        _mImgSession = nil;
    }
}

// 停止下载资源
- (void)stopDownloadMedia
{
    [self setDownloadStatusType:eDownloadStatusCancel];
    if(_dataDownload)
    {
        _downloadTask = [_mSession downloadTaskWithResumeData:_dataDownload];
        [_downloadTask cancel];
        _downloadTask = nil;
    }
    if(_mSession)
    {
        [_mSession invalidateAndCancel];
        _mSession = nil;
    }
}

// 停止下载
- (void)stopDownload
{
    /*图片*/
    [self stopDownloadImg];
    /*资源*/
    [self stopDownloadMedia];
}

// 等待下载
- (void)waitToDownload
{
    /*图片*/
    [self pauseDownloadImg];
    
    /*资源*/
    [self setDownloadStatusType:eDownloadStatusWait];

    if(_downloadTask)
    {
        [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            _dataDownload = resumeData;
            _downloadTask = nil;
        }];
    }
    else
    {
        // 保存临时文件
        [[DataManager sharedDataManager] saveDownloadVideo];
    }
}

// 视频会话
- (NSURLSession *)mediaBackgroundSession
{
    NSURLSessionConfiguration *configuration = nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:
                         _stringDownloadURL];
    }
    else
    {
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:
                         _stringDownloadURL];
    }
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self
                                                               delegateQueue:[NSOperationQueue mainQueue]];
    return backgroundSession;
}

// 图片会话
- (NSURLSession *)imgBackgroundSession
{
    NSURLSessionConfiguration *configuration = nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:_stringShowImageURL
                         ];
    }
    else
    {
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:
                         _stringShowImageURL];
    }
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self
                                                               delegateQueue:[NSOperationQueue mainQueue]];
    return backgroundSession;
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    //debugLog(@"Invalid %@",error);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    /*图片*/
    if(session == _mImgSession)
    {
        if(_imgDownloadTask)
        {
            [_imgDownloadTask cancel];
            _imgDownloadTask = nil;
        }
        if(_mImgSession)
        {
            [_mImgSession invalidateAndCancel];
            _mImgSession = nil;
        }
    }
    /*资源*/
    else
    {
        if(_downloadTask)
        {
            [_downloadTask cancel];
            _downloadTask = nil;
        }
        if(_mSession)
        {
            [_mSession invalidateAndCancel];
            _mSession = nil;
        }
    }

//    if([kAllinAppDelegate backgroundSessionCompletionHandler])
//    {
//        void (^handler)() = [kAllinAppDelegate backgroundSessionCompletionHandler];
//        [kAllinAppDelegate setBackgroundSessionCompletionHandler:nil];
       // handler();
   // }
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error)
    {
        //debugLog(@"3下载失败 %@",[error description]);
        NSDictionary *errDic = [error userInfo];
        /*图片*/
        if(session == _mImgSession)
        {
            if(errDic)
            {
                NSData *data = errDic[@"NSURLSessionDownloadTaskResumeData"];
                if(data)
                {
                    _dataImgDownload = data;
                    [[DataManager sharedDataManager] saveDownloadVideo];
                }
            }
            
            NSString *domainError = [error domain];
            if(domainError && [domainError isEqualToString:NSURLErrorDomain])
            {
                // 复用data出问题
                if([error code] == -3003)
                {
                    // 只能重新下载
                    _dataImgDownload = nil;
                    [_imgDownloadTask cancel];
                    _imgDownloadTask = nil;
                    [self startDownloadImg];
                }
                else if ([error code] == -1002)
                {
//                    _dataImgDownload = nil;
//                    [_imgDownloadTask cancel];
//                    _imgDownloadTask = nil;
//                    
                    
                    
                }

            }
                        return;
        }

        /*视频*/
        if(errDic)
        {
            NSData *data = errDic[@"NSURLSessionDownloadTaskResumeData"];
            if(data)
            {
                _dataDownload = data;
                [[DataManager sharedDataManager] saveDownloadVideo];
            }
        }
        
        NSString *domainError = [error domain];
        if(domainError && [domainError isEqualToString:NSURLErrorDomain])
        {
            // 复用data出问题
            if([error code] == -3003)
            {
                // 只能重新下载
                _dataDownload = nil;
                [_downloadTask cancel];
                _downloadTask = nil;
                [self startDownloadMedia];
            }
            // 其他
        }
        else
        {
        
        }
    }
    else
    {
        //debugLog(@"3下载成功");
        /*图片*/
        if(session == _mImgSession)
        {
            if(_imgDownloadTask)
            {
                [_imgDownloadTask cancel];
                _imgDownloadTask = nil;
            }
            if(_mImgSession)
            {
                [_mImgSession invalidateAndCancel];
                _mImgSession = nil;
            }
            [[DataManager sharedDataManager] saveDownloadVideo];
            return;
        }
        
        /*资源*/
        [self setDownloadStatusType:eDownloadStatusOver];
        if(_downloadTask == task)
        {
            [_downloadTask cancel];
            _downloadTask = nil;
        }
        if(_mSession == session)
        {
            [_mSession invalidateAndCancel];
            _mSession = nil;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[DownloadManager sharedDownloadManager] addACompleteSessionTask:self];
            [[DownloadManager sharedDownloadManager] deleteACompleteSessionTask:self];
            [[DownloadManager sharedDownloadManager] remakeDownloads];
            [[DataManager sharedDataManager] saveDownloadVideo];
            [[DataManager sharedDataManager] saveDownloadedVideo];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeVideoDownloadOver", ) object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
//            AllinMyDownloadVideo_request * downloadVideorequest = [[AllinMyDownloadVideo_request alloc] init];
//            downloadVideorequest.startTime = self.startTime;
//            downloadVideorequest.endTime = dateString;
//            downloadVideorequest.customerId = self.stringCustomId;
//            downloadVideorequest.resourceId = self.stringSourseId;
//            downloadVideorequest.createTime = self.creatTime;
//            downloadVideorequest.downloadType = @"1";
//            downloadVideorequest.downloadDesc = self.stringVideoName;
//            downloadVideorequest.visitSiteId = @"5";
//            [downloadVideorequest asyncStartWithCompletionBlockWithSuccess:^(AllinBaseRequest *request) {
//                debugLog(@"success   ＝＝ %@", request.responseString);
//            } failure:^(AllinBaseRequest *request) {
//                debugLog(@"failed");
//            }];
        });
    }
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //debugLog(@"2下载完成了啊");
    /*图片*/
    if(session == _mImgSession)
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kImgListPath],_stringCustomId,_stringSourseId]] == NO)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kImgListPath],_stringCustomId,_stringSourseId]
                                      withIntermediateDirectories:YES attributes:nil error:nil];
            [SDTool addSkipBackupAttributeToItemAtPath:[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kImgListPath],_stringCustomId,_stringSourseId]];
        }
        
        NSString *fileName = [_stringShowImageURL lastPathComponent];
        _stringImgDownloadPath = [[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kImgListPath],_stringCustomId,_stringSourseId]
                                  stringByAppendingPathComponent:fileName];
        NSURL *cacheFileURL = [NSURL fileURLWithPath:_stringImgDownloadPath];
        
        if ([[NSFileManager defaultManager] moveItemAtURL:location
                                                    toURL:cacheFileURL
                                                    error:nil]) {
        }
        return;
    }
    
    /*视频*/
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kVedioListPath],_stringCustomId,_stringSourseId]] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kVedioListPath],_stringCustomId,_stringSourseId]
                                  withIntermediateDirectories:YES attributes:nil error:nil];
        [SDTool addSkipBackupAttributeToItemAtPath:[NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kVedioListPath],_stringCustomId,_stringSourseId]];
    }
    
    NSString *fileName = [location lastPathComponent];
    NSMutableString *mFileName = [NSMutableString stringWithString:fileName];
    if([mFileName hasSuffix:@".tmp"])
    {
        NSRange rane = [mFileName rangeOfString:@".tmp"];
        if(rane.location != NSNotFound && rane.length)
        {

            [mFileName replaceCharactersInRange:rane
                                     withString:[NSString stringWithFormat:@".%@",[_stringDownloadURL pathExtension]]];
            if([mFileName rangeOfString:@"?"].location != NSNotFound &&
               [mFileName rangeOfString:@"?"].length) {
                NSString * newFileName = [mFileName substringToIndex:
                                          [mFileName rangeOfString:@"?"].location];
                mFileName = [NSMutableString stringWithString:newFileName];
            }
            
            _stringDownloadPath =
            [[NSString stringWithFormat:@"%@/%@/%@",kVedioListPath,_stringCustomId,_stringSourseId]
                                   stringByAppendingPathComponent:mFileName];

            NSURL *cacheFileURL =
            [NSURL fileURLWithPath:[kDocPath stringByAppendingString:_stringDownloadPath]];
            
            NSError *error = nil;
            
            if (![[NSFileManager defaultManager] moveItemAtURL:location
                                                        toURL:cacheFileURL
                                                        error:&error]) {
            }
        }
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    long long size1 = totalBytesExpectedToWrite;
    
    _stringTotalSize = [NSString stringWithFormat:@"%lld",size1];
    /*图片*/
    if(session == _mImgSession)
    {
        return;
    }
    /*视频*/
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_downloadTask == downloadTask)
        {
            // 空间不足
            if([SDTool hasEnoughFreeSpace] == NO)
            {
                [[DownloadManager sharedDownloadManager] pauseAllDownLoadTask];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshDownloadVideoStatus", ) object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
                
//                if([[VCManager windowTopVC] isKindOfClass:[AllinMyVideoDownloadVC class]])
//                {
//                    ALAlertView *alertView = [[ALAlertView alloc] init];
//                    alertView.nAnimationType = ALTransitionStylePop;
//                    alertView.dRound = 10.0;
//                    alertView.showAnimate = YES;
//                    alertView.bGrayBg = YES;
//                    [alertView doAlert:@"" body:@"可用空间不足,请及时清理空间" duration:0 done:^(ALAlertView *alertView) {
//                        
//                    }];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [alertView hideAlert];
//                    });
//                }
            }
            else
            {
                [self setCurloadSize:[NSNumber numberWithDouble:totalBytesWritten]];
                if(self.delegate && [self.delegate respondsToSelector:@selector(updateDownloadProgress:)])
                {
                    [self.delegate updateDownloadProgress:self];
                }
            }
        }
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
}

@end
