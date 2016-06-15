//
//  VedioData.h
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SysCommon.h"

@interface VedioData : NSObject
@property (nonatomic,strong) NSMutableDictionary *vedioDataDic;             // 存储一些简单的键值对
@property (nonatomic,strong) NSMutableDictionary *vedioReviewDataDic;       // 评论 存储一些简单的键值对

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;
@end
