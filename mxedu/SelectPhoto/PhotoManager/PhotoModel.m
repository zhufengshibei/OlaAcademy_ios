//
//  QYPhotoModel.m
//  Frank
//
//  Created by Frank on 15/3/6.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"thumbnailData": @"thumbnailData",
                                                       @"photoData": @"photoData",
                                                       @"photoName": @"photoName"
                                                       }];
}

@end
