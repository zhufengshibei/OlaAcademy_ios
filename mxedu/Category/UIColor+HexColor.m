//
//  UIColor+HexColor.m
//  NTreat
//
//  Created by Frank on 15/5/11.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor*)colorWhthHexString:(NSString*)hexString
{
    if (!hexString || [hexString isEqualToString:@""]) {
        return nil;
    }
    
    unsigned red,green,blue;
    
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    
    range.location = 3;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    
    range.location = 5;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];

    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];;
}

@end
