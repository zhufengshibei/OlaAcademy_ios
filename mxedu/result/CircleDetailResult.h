//
//  CircleDetailResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/25.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OlaCircle.h"

@interface CircleDetailResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) OlaCircle *circleDetail;

@end
