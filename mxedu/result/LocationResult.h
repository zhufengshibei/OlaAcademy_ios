//
//  LocationResult.h
//  NTreat
//
//  Created by 田晓鹏 on 15/5/29.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) NSMutableArray *locationArray;

@end
