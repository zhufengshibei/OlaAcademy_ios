//
//  AuthResult.h
//  NTreat
//
//  Created by 田晓鹏 on 15-5-15.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AuthResult : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *message;
@property (nonatomic) User *userInfo;

@end
