//
//  VideoHistory.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/28.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "OlaCircle.h"

#import "NSDate+MJ.h"

@implementation OlaCircle

- (NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    2014-08-06 12:57:24
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //获取微博的发表时间
    NSDate *createDate = [formatter dateFromString:_time];
#warning 真机调试的时候，必须加上这句
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //判断是否是今年
    if (createDate.isThisYear) {
        if (createDate.isToday) {//代表今天
            NSDateComponents *components = [createDate deltaWithNow];;
            if (components.hour >= 1) {//代表至少是1小时前发表的
                return [NSString stringWithFormat:@"%d小时前",components.hour];
            } else if (components.minute >= 1)//代表1~59分钟之前发表的
            {
                return [NSString stringWithFormat:@"%d分钟前",components.minute];
            }else
            {
                return @"刚刚";
            }
        }else if (createDate.isYesterday)//代表昨天
        {
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createDate];
        }else//代表至少是前天
        {
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:createDate];
        }
    }else//代表非今年
    {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:createDate];
    }
}

@end
