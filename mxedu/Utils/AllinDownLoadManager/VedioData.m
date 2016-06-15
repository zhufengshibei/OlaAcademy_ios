//
//  VedioData.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "VedioData.h"

@implementation VedioData
- (instancetype)init
{
    if(self = [super init])
    {
        _vedioDataDic = [[NSMutableDictionary alloc] init];
        _vedioReviewDataDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    _vedioDataDic = nil;
    _vedioReviewDataDic = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        Decode(vedioDataDic);
        Decode(vedioReviewDataDic);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    Encode(vedioDataDic);
    Encode(vedioReviewDataDic);
}

@end
