//
//  UIImage+Extension.h
//  黑马微博-1
//
//  Created by wangzhaohui-Mac on 14-7-3.
//  Copyright (c) 2014年 com.Itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)imageWithName:(NSString *)name;
/**
 *  生成一张可以随意拉伸不变形的图片
 *
 *  @param name 传入图片名称
 *
 *  @return 返回一个拉伸后的图片
 */
+ (UIImage *)resizeImageWithName:(NSString *)name;
@end
