//
//  UIFont+FontSize.m
//  NTreat
//
//  Created by Frank on 15/5/30.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "NTFont.h"

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

@implementation NTFont

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    if (iPhone6) {
        size +=1;
    }else if (iPhone6plus) {
        size +=4;
    }
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    if (iPhone6) {
        size +=1;
    }else if (iPhone6plus) {
        size +=4;
    }
    return [UIFont boldSystemFontOfSize:size];
}

@end
