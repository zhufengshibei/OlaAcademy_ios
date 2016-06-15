//
//  Question.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic) NSString* questionId;
@property (nonatomic) NSString* article;
@property (nonatomic) NSString* question;
@property (nonatomic) NSString* type;
@property (nonatomic) NSString* degree;
@property (nonatomic) NSString* hint;
@property (nonatomic) NSString* allcount;
@property (nonatomic) NSString* rightcount;
@property (nonatomic) NSString* avgtime;
@property (nonatomic) NSString* pic;
@property (nonatomic) NSString* hintpic;
@property (nonatomic) NSString* videourl;
@property (nonatomic) NSMutableArray *optionList;

@end
