//
//  KeywordListResult.h
//  mxedu
//
//  Created by 田晓鹏 on 15/11/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordListResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) NSArray *keywordList;

@end
