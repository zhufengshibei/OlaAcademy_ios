//
//  CheckInResult.h
//  mxedu
//
//  Created by 田晓鹏 on 15/12/14.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CheckIn.h"

@interface CheckInResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) CheckIn *checkInfo;

@end
