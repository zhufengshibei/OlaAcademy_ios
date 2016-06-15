//
//  UIBarButtonItem+ZHBarButtonItem.m
//  黑马微博-1
//
//  Created by wangzhaohui-Mac on 14-7-3.
//  Copyright (c) 2014年 com.Itheima. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemImageName:(NSString *)imageName highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];

    //设置按钮的尺寸为按钮背景按钮的尺寸
    //button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
