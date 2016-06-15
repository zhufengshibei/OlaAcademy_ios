//
//  SettingViewController.h
//  mxedu
//
//  Created by 田晓鹏 on 15-5-15.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController

@property (nonatomic, strong) void (^logoutSuccess)();

@end
