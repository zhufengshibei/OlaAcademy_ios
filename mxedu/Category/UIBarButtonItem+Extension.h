//
//  UIBarButtonItem+ZHBarButtonItem.h
//  黑马微博-1
//
//  Created by wangzhaohui-Mac on 14-7-3.
//  Copyright (c) 2014年 com.Itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemImageName:(NSString *)imageName highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action;
@end


