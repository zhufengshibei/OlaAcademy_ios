//
//  SDTool.h
//  NTreat
//
//  Created by 周冉 on 16/4/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDTool : NSObject
+(void)deleteDirectoryAllFilePath:(NSString *)path;
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString;
// 是否有足够的空间
+ (BOOL)hasEnoughFreeSpace;
+ (NSString *)freeDiskSpaceInBytes;
+(NSString *)getFileSizeString:(NSString *)size;
+(NSString *)getCurNetStatusForLog;//获取当前网络
+ (BOOL)isLocalVideo:(NSString *)videoId;//查看是否是本地
@end
