//
//  UserViewController.h
//  NTreat
//
//  Created by 田晓鹏 on 15-4-19.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfoView.h"

@interface UserViewController : UIViewController

@property (nonatomic, strong) NSMutableArray  *dataSource;
@property (nonatomic) UserInfoView *userView;

@end
