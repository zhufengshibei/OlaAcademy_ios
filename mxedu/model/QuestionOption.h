//
//  QuestionOption.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionOption : NSObject

@property (nonatomic) NSString *optionId;
@property (nonatomic) NSString *sid;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *isanswer;
@property (nonatomic) int isCurrentChosen; //当前选中

@end
