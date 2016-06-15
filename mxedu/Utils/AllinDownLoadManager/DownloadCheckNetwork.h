//
//  DownloadCheckNetwork.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/7/9.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadCheckNetwork : NSObject

+ (id)sharedDownloadCheckNetwork;

/*检测网络环境*/
- (void)checkDownLoadNetwork;

@end
