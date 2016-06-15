//
//  DataManager.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 14-12-18.
//  Copyright (c) 2014年 Mac_Libin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VedioData.h"
//#import "CaseData.h"
//#import "TopicData.h"
//#import "VersionData.h"
//#import "AllinDeviceData.h"
//#import "AllinMessageData.h"
//#import "AllinRootPageData.h"
//#import "AllinRoleTypeData.h"

//*****************************不要随意改动*****************************//
@class DownloadModal;
@interface DataManager : NSObject
{
    /// 视屏数据.
    VedioData *vedioData;
//    
//    /// 话题数据.
//    TopicData *topicData;
//    
//    /// 病例数据.
//    CaseData *caseData;
//    
//    /// 版本数据.
//    VersionData *versionData;
//    
//    /// 设备信息.
//    AllinDeviceData *deviceData;
//    
//    /// 消息数据(动态/赞/粉丝/草稿).
//    AllinMessageData * messageData;
//    
//    /// 首页数据.
//    AllinRootPageData * rootPageData;
//    
//    /// 用户角色数据.
//    AllinRoleTypeData *roleTypeData;
}

/// 通过单例获取.
+ (id)sharedDataManager;

/// app版本.
+ (NSString *)appVersionString;

/// 用户id.
+ (NSString *)customerId;

/// 写入缓存.
- (void)saveCache;

/// 读取缓存.
- (void)readCache;

/// 缓存数据是否有效.
- (BOOL)isCacheDataValid;

/*单独调用*/
- (void)saveDownloadVideo;
- (void)saveDownloadedVideo;

- (void)readDownloadedVideo;
- (void)readDownloadVideo;

- (void)removeDownLoadVideo:(DownloadModal *)downloadModal;
- (void)removeDownLoadImage:(DownloadModal *)downloadModal;



@end



