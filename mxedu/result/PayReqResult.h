//
//  PayReqResult.h
//  NTreat
//
//  Created by 田晓鹏 on 16/4/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApiObject.h"

@interface PayReqResult : NSObject

@property (nonatomic) int code;

@property (nonatomic) NSString *message;

@property (nonatomic) PayReq *payReq;

@end
