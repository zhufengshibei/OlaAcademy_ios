//
//  Comment.m
//
//  Created by 田晓鹏 on 14-8-1.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import "Comment.h"
#import "NSDate+MJ.h"
@interface Comment ()
{
    UILabel * content ;
}
@end
@implementation Comment

- (NSString *)passtime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    2014-08-06 12:57:24
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //获取微博的发表时间
    NSDate *createDate = [formatter dateFromString:_passtime];
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
-(CGFloat)cellHeight
{
    CGFloat spect = 0;
    content = [[UILabel alloc]init];
    content.font = [UIFont systemFontOfSize:16];
    content.frame = CGRectMake(0, 35, SCREEN_WIDTH-100, 0);

//    CGSize  contentSize = [self.content sizeWithFontCompatible:content.font constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)];
//    content.frame = CGRectMake(0, 35, SCREEN_WIDTH-100, contentSize.height);
//
//    spect = CGRectGetMaxY( content.frame)+3+23;
//    if(![self.rpyToUserName isKindOfClass:[NSString class]] || [self.rpyToUserName isEqualToString:@""])
//    {
//      
//
//    }
//    else
//    {
//     CGSize  subcontentSize = [self.subcontent sizeWithFontCompatible:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT)];
//        spect+=subcontentSize.height+20+9;
//    }
    return spect;
}
@end
