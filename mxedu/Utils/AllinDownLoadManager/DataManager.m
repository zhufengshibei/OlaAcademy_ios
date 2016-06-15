//
//  DataManager.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 14-12-18.
//  Copyright (c) 2014年 Mac_Libin. All rights reserved.
//

#import "DataManager.h"
#import "SDTool.h"
#import "AuthManager.h"
#import "DownloadManager.h"

static DataManager *sharedDataManager = nil;

@implementation DataManager

+ (id)sharedDataManager
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedDataManager = [[super allocWithZone:NULL] init];
        });
        return sharedDataManager;
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedDataManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

/// app版本.
+ (NSString *)appVersionString {
    
    NSString * versionStr = [[[NSBundle mainBundle] infoDictionary]
                             objectForKey:@"CFBundleShortVersionString"];
    return versionStr;
}

/// 写入缓存.
- (void)saveCache
{
    [self saveVideoData];

}

/// 读取缓存.
- (void)readCache
{
    [self readVideoData];

}

+ (NSString *)customerId
{
   SDUserID;
}
//保存缓存
- (void)saveVideoData
{
    if(vedioData)
    {
        [self saveData:vedioData path:[[kDocPath stringByAppendingString:kShareVideoActionDataPath]
                                       stringByAppendingFormat:@"/%@",[DataManager customerId]]
      basePathDirectry:[kDocPath stringByAppendingString:kShareVideoActionDataPath]];
    }
}
//读取数据
- (void)readVideoData
{
    vedioData = (VedioData *)[self readData:NSStringFromClass([VedioData class]) path:[[kDocPath stringByAppendingString:kShareVideoActionDataPath] stringByAppendingFormat:@"/%@",[DataManager customerId]]];
}


- (void)readVersionData
{
//    versionData = (VersionData *)[self readData:NSStringFromClass([VersionData class]) path:[[kDocPath stringByAppendingString:kVersionDataPath] stringByAppendingFormat:@"/%@",[DataManager customerId]]];
}

/// 获取用户权限.
- (void)readUserPermission {
    
    /// 检查表.
  //  [AllinDBManager check];
    
//    /// 读取访客用户权限.
//    NSString * visitorId = [NSString stringWithFormat:@"%ld",(long)eCustomerRoleTypeNotLogin];
//    NSArray * resultVisitor =  [AllinCustomerRoleDB queryItem:visitorId];
//    if(resultVisitor && resultVisitor.count) {
//        NSDictionary * dictVisitor = resultVisitor[0];
//        [[DataManager sharedDataManager] setVisitorRolePermission:dictVisitor[@"roleOps"]];
//    }
//    
//    /// 读取登陆用户权限.
//    NSString * logerId = [NSString stringWithFormat:@"%ld",(long)eCustomerRoleTypeNotAuthed];
//    NSArray * resultLogin =  [AllinCustomerRoleDB queryItem:logerId];
//    if(resultLogin && resultLogin.count) {
//        NSDictionary * dictLoger = resultLogin[0];
//        [[DataManager sharedDataManager] setNotAuthedRolePermission:dictLoger[@"roleOps"]];
//    }
//    
//    /// 读取认证用户权限.
//    NSString * authorId = [NSString stringWithFormat:@"%ld",(long)eCustomerRoleTypeAuthed];
//    NSArray * resultAuthor =  [AllinCustomerRoleDB queryItem:authorId];
//    if(resultAuthor && resultAuthor.count) {
//        NSDictionary * dictAuthor = resultAuthor[0];
//        [[DataManager sharedDataManager] setAuthedRolePermission:dictAuthor[@"roleOps"]];
//    }
//    
//    /// 读取厂商用户权限.
//    NSString * manufacturerId = [NSString stringWithFormat:@"%ld",(long)eCustomerRoleTypeManufacturer];
//    NSArray * resultManufacturer =  [AllinCustomerRoleDB queryItem:manufacturerId];
//    if(resultManufacturer && resultManufacturer.count) {
//        NSDictionary * dictManufacturer = resultManufacturer[0];
//        [[DataManager sharedDataManager] setManufacturerRolePermission:dictManufacturer[@"roleOps"]];
//    }
}

/// 保存下载的视频.
- (void)saveDownloadVideo
{
    NSArray *arrayVideoDownload = [[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals];
    if(arrayVideoDownload && [arrayVideoDownload count])
    {
        // 保存视频
        [self saveVideDownloadData:arrayVideoDownload key:[NSString stringWithFormat:@"DownloadVideo_%@",[DataManager customerId]]
                          path:[[kDocPath stringByAppendingString:kVedioTempPath] stringByAppendingFormat:@"/%@/%@",[DataManager customerId],[DataManager customerId]]
              basePathDirectry:[[kDocPath stringByAppendingString:kVedioTempPath] stringByAppendingFormat:@"/%@",[DataManager customerId]]];
    }
    else
    {
        // 保存视频
        [self saveVideDownloadData:arrayVideoDownload key:[NSString stringWithFormat:@"DownloadVideo_%@",[DataManager customerId]]
                              path:[[kDocPath stringByAppendingString:kVedioTempPath] stringByAppendingFormat:@"/%@/%@",[DataManager customerId],[DataManager customerId]]
                  basePathDirectry:[[kDocPath stringByAppendingString:kVedioTempPath] stringByAppendingFormat:@"/%@",[DataManager customerId]]];
//        [CheckAllin deleteDirectoryAllFilePath:[[kDocPath stringByAppendingString:kVedioTempPath] stringByAppendingFormat:@"/%@",[DataManager customerId]]];
    }
}

/// 读取下载的视频.
- (void)readDownloadVideo
{
    NSArray *arrayVideoDownload = [self readVideDownloadData:[[kDocPath stringByAppendingString:kVedioTempPath] stringByAppendingFormat:@"/%@/%@",[DataManager customerId],[DataManager customerId]] key:[NSString stringWithFormat:@"DownloadVideo_%@",[DataManager customerId]]];
    if(!arrayVideoDownload)
    {
        arrayVideoDownload = [[NSArray alloc] init];
    }
    [[[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals] removeAllObjects];
    [[DownloadManager sharedDownloadManager] setArrayDownLoadSessionModals:[NSMutableArray arrayWithArray:arrayVideoDownload]];
}

// 保存下载完的视频
- (void)saveDownloadedVideo
{
    NSArray *arrayVideoDownloaded = [[DownloadManager sharedDownloadManager] arrayDownLoadedSessionModals];
    if(!arrayVideoDownloaded || [arrayVideoDownloaded count] == 0)
    {
        [SDTool deleteDirectoryAllFilePath:[[kDocPath stringByAppendingString:kVedioListPath] stringByAppendingFormat:@"/%@",[DataManager customerId]]];
    }
    else
    {
        [self saveVideDownloadData:arrayVideoDownloaded key:[NSString stringWithFormat:@"DownloadVideo_%@",[DataManager customerId]]
                              path:[[kDocPath stringByAppendingString:kVedioListPath] stringByAppendingFormat:@"/%@/%@",[DataManager customerId],@"data"]
                  basePathDirectry:[kDocPath stringByAppendingString:kVedioListPath]];
    }
}

// 读取下载完成的视频
- (void)readDownloadedVideo
{
    NSArray *arrayVideoDownloaded = [self readVideDownloadData:[[kDocPath stringByAppendingString:kVedioListPath] stringByAppendingFormat:@"/%@/%@",[DataManager customerId],@"data"]
                                                           key:[NSString stringWithFormat:@"DownloadVideo_%@",[DataManager customerId]]];
    [[[DownloadManager sharedDownloadManager] arrayDownLoadedSessionModals] removeAllObjects];
    [[DownloadManager sharedDownloadManager] setArrayDownLoadedSessionModals:[NSMutableArray arrayWithArray:arrayVideoDownloaded]];
}


- (void)removeDownLoadVideo:(DownloadModal *)downloadModal
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kVedioListPath],downloadModal.stringCustomId,downloadModal.stringSourseId];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [SDTool deleteDirectoryAllFilePath:path];
    }
}

- (void)removeDownLoadImage:(DownloadModal *)downloadModal
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[kDocPath stringByAppendingString:kImgListPath],downloadModal.stringCustomId,downloadModal.stringSourseId];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [SDTool deleteDirectoryAllFilePath:path];
    }
}

- (void)saveVideDownloadData:(NSArray *)arrData key:(NSString *)key path:(NSString *)path basePathDirectry:(NSString *)basePathDirectry
{
    if([[NSFileManager defaultManager] fileExistsAtPath:basePathDirectry] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:basePathDirectry
                                  withIntermediateDirectories:YES attributes:nil error:nil];
        [SDTool addSkipBackupAttributeToItemAtPath:basePathDirectry];
    }
    
    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    [archiver encodeObject:arrData forKey:key];
    [archiver finishEncoding];
    
    if([mData writeToFile:path atomically:YES])
    {
    }
}

- (id)readVideDownloadData:(NSString *)path key:(NSString *)key
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path] == YES)
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *arrVideoDownLoad = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        
        return arrVideoDownLoad;
    }
    return nil;
}


////
- (void)saveData:(id)data path:(NSString *)path basePathDirectry:(NSString *)basePathDirectry
{
    if([[NSFileManager defaultManager] fileExistsAtPath:basePathDirectry] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:basePathDirectry
                                  withIntermediateDirectories:YES attributes:nil error:nil];

        [SDTool addSkipBackupAttributeToItemAtPath:basePathDirectry];
    }
   
    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    [archiver encodeObject:data forKey:NSStringFromClass([data class])];
    [archiver finishEncoding];
    
    if([mData writeToFile:path atomically:YES])
    {
    }
}

- (id)readData:(NSString *)dataKey path:(NSString *)path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path] == YES)
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id dataArchived = [unarchiver decodeObjectForKey:dataKey];
        [unarchiver finishDecoding];
        
        return dataArchived;
    }
    return nil;
}

// 缓存数据是否有效
- (BOOL)isCacheDataValid
{
    // 版本号一致?
    return YES;
}

@end
