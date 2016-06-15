//
//  SDTool.m
//  NTreat
//
//  Created by 周冉 on 16/4/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "SDTool.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AVFoundation/AVFoundation.h>
#import <sys/param.h>
#import <sys/mount.h>
#import "Reachability.h"
#import "DataManager.h"
#import "DownloadManager.h"

@implementation SDTool
//清除下载的缓存
+(void)deleteDirectoryAllFilePath:(NSString *)allFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:allFilePath error:nil];
}
//查询占用的空间大小
+(NSString *)usedSpaceAndfreeSpaceSubsefPath:(NSString * )subPath
{
    long long fileSize = [self folderSizeAtPath2:subPath];
    
    NSString *str = nil;
    if (fileSize/1024.0/1024.0 > 1024) {
        str= [NSString stringWithFormat:@"%0.fG",fileSize/1024.0/1024.0/1024.0];
    } else {
        str= [NSString stringWithFormat:@"%0.fMB",fileSize/1024.0/1024.0];
    }
    
    return str;
}
+(long long)folderSizeAtPath2:(NSString*)folderPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString*
        fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return
    folderSize;
    
}
+(long long)fileSizeAtPath:(NSString*)filePath{
    
    NSFileManager*manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
// 避免icloud备份
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
//        debugLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
+ (BOOL)hasEnoughFreeSpace
{
    NSString *spaceRemained = [SDTool freeDiskSpaceInBytes];
    double spaceRemainedValue = 0.;// k
    if([spaceRemained hasSuffix:@"MB"])
    {
        spaceRemainedValue = [spaceRemained floatValue] * 1024;
    }
    if([spaceRemained hasSuffix:@"G"])
    {
        spaceRemainedValue = [spaceRemained floatValue] * 1024 * 1024;
    }
    
    if(spaceRemainedValue <= 50*1024)
    {
        return NO;
    }
    return YES;
}
// 手机剩余空间
+ (NSString *)freeDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/private/var", &buf) >= 0)
    {
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    if (freespace/1024.0/1024.0 > 1024) {
        return [NSString stringWithFormat:@"%0.fG",freespace/1024.0/1024.0/1024.0];
    } else {
        return [NSString stringWithFormat:@"%0.fMB",freespace/1024.0/1024.0];
    }
}
+(NSString *)getFileSizeString:(NSString *)size
{
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];
    }
}
// 得到当前网络状态
+ (NSString *)getCurNetStatusForLog
{
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            return nil;
        }
            break;
            
        case ReachableViaWWAN:
        {
            // 7.0
            Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
            if (telephoneNetWorkClass != nil)
            {
                CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
                
                if ([telephonyNetworkInfo respondsToSelector:@selector(currentRadioAccessTechnology)])
                {
                    NSString* wlanNetwork = telephonyNetworkInfo.currentRadioAccessTechnology;
                    
                    if (wlanNetwork == nil)
                    {
                        return nil;
                    }
                    if([wlanNetwork isEqualToString:CTRadioAccessTechnologyGPRS])
                    {
                        return NSLocalizedString(@"NetStatus2GTo3G", );// 2g-3g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyEdge])
                    {
                        return NSLocalizedString(@"NetStatus2GTo3G", );// 2g-3g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyWCDMA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 联通3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyHSDPA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g-4g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyHSUPA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g-4g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMA1x])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 标准3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 电信3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 电信3g 升级版
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyeHRPD])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g-4g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyLTE])
                    {
                        return NSLocalizedString(@"NetStatus4G",);// 4g
                    }
                    return nil;
                }
            }
            
            return NSLocalizedString(@"NetStatus2G3G", );
        }
            break;
            
        case ReachableViaWiFi:
        {
            return NSLocalizedString(@"NetStatusWifi", );
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}
// 是否是本地
+ (BOOL)isLocalVideo:(NSString *)videoId
{
    NSArray *arrayVideoDownloaded = [[DownloadManager sharedDownloadManager] arrayDownLoadedSessionModals];
    for(DownloadModal *modal in arrayVideoDownloaded)
    {
        if([modal.stringSourseId isEqualToString:[NSString stringWithFormat:@"%@",videoId]] &&
           [[modal stringCustomId] isEqualToString:[DataManager customerId]])
        {
            return YES;
        }
    }
    return NO;
}

@end
