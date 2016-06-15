//
//  ExamManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/12.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ExamListRsult.h"
#import "QuestionListResult.h"

@interface ExamManager : NSObject

/**
 * 获取模考／真题列表
 * 1 模考 2 真题
 */
-(void)fetchExamListWithCourseID:(NSString*)courseId
                            Type:(NSString*)type
                          UserId:(NSString*)userId
                         Success:(void(^)(ExamListRsult *result))success
                         Failure:(void(^)(NSError* error))failure;

/**
 *  获取试卷对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithExamId:(NSString*)examId
                       Success:(void(^)(QuestionListResult *result))success
                       Failure:(void(^)(NSError* error))failure;

@end
