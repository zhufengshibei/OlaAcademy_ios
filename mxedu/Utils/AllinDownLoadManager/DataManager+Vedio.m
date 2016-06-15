//
//  DataManager+Vedio.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DataManager+Vedio.h"
#import "VedioData.h"//视频模型
#define kAllowed3GPlay                              @"kAllowed3GPlay"
#define kFirst3GDownload                            @"kFirst3GDownload"
#define kFirst3GDownloadVC                          @"kFirst3GDownloadVC"
@implementation DataManager (Vedio)
- (VedioData *)initionalVedioData
{
    if(vedioData == nil)
    {
        vedioData = [[VedioData alloc] init];
        [[vedioData vedioDataDic] setObject:[NSNumber numberWithBool:YES] forKey:kFirst3GDownload];
        [[vedioData vedioDataDic] setObject:[NSNumber numberWithBool:YES] forKey:kFirst3GDownloadVC];
    }
    
    return vedioData;
}
// 是否允许过3G 播放
- (void)setAllowed3GPlay:(BOOL)allowed3GPlay
{
    [[[self initionalVedioData] vedioDataDic] setObject:[NSNumber numberWithBool:allowed3GPlay] forKey:kAllowed3GPlay];
}
- (BOOL)allowed3GPlay
{
    return [[[[self initionalVedioData] vedioDataDic] objectForKey:kAllowed3GPlay] boolValue];
}
// 3G下是否是第一次下载
- (void)setFirst3GDownload:(BOOL)first3GDownload
{
    [[[self initionalVedioData] vedioDataDic] setObject:[NSNumber numberWithBool:first3GDownload] forKey:kFirst3GDownload];
}
- (BOOL)first3GDownload
{
    return [[[[self initionalVedioData] vedioDataDic] objectForKey:kFirst3GDownload] boolValue];
}
// 是否对某个资源进行过评论
- (BOOL)hasVedioReviewed:(NSString*)vedioID
{
    return [[[[self initionalVedioData] vedioReviewDataDic] objectForKey:vedioID] boolValue];
}

@end
