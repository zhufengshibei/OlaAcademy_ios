//
//  SignInStatus.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInStatus : NSObject

@property (nonatomic) int status; // 1 已签到 0 未签到
@property (nonatomic) NSString *lastSignIn; // 最近签到
@property (nonatomic) NSString *signInDays; // 连续签到

@end
