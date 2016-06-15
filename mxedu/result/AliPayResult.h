//
//  AliPayResult.h
//  NTreat
//
//  Created by 田晓鹏 on 16/4/21.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AliPayInfo.h"

@interface AliPayResult : NSObject

@property (nonatomic) int code;

@property (nonatomic) NSString *message;

@property (nonatomic) AliPayInfo *payInfo;

@end
