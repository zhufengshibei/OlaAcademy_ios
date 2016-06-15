//
//  UserEditViewController.h
//  NTreat
//
//  Created by 田晓鹏 on 15-5-20.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEditViewController : UITableViewController

@property (nonatomic, strong) void (^successFunc)();

@end
