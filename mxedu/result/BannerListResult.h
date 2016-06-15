//
//  BannerListResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/12.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerListResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) NSArray *bannerArray;

@end
