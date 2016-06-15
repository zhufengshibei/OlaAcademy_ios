//
//  yindaoyeViewController.h
//  Lvlicheng
//
//  Created by xianjunwang on 14-8-30.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysCommon.h"

@interface IntroViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *myPageController;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollview;
- (IBAction)pageValueChanged:(id)sender;

@end
