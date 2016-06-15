//
//  Correctness.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/16.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Correctness : NSObject

@property (nonatomic) NSString *no;  //题目Id
@property (nonatomic) NSString *optId; // 所选答案Id
@property (nonatomic) NSString *timeSpan; // 耗时（秒）
@property (nonatomic) NSString *isCorrect;

@end
