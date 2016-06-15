//
//  DataManager+Vedio.h
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DataManager.h"

@interface DataManager (Vedio)
// 是否允许过3G 播放
- (void)setAllowed3GPlay:(BOOL)allowed3GPlay;
- (BOOL)allowed3GPlay;

// 3G下是否是第一次下载
- (void)setFirst3GDownload:(BOOL)first3GDownload;
- (BOOL)first3GDownload;

// 是否是3G第一次进入下载页面
- (void)setFirst3GDownloadVC:(BOOL)first3GDownload;
- (BOOL)first3GDownloadVC;

- (BOOL)hasVedioReviewed:(NSString*)vedioID;

@end
