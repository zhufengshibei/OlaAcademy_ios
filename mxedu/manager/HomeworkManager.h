//
//  HomeworkManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeworkListResult.h"
#import "QuestionListResult.h"

@interface HomeworkManager : NSObject

/**
 *  作业列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomeworkListWithHomeworkId:(NSString*)homeworkId
                              PageSize:(NSString*)pageSize
                                UserId:(NSString*)userId
                               Success:(void(^)(HomeworkListResult *result))success
                               Failure:(void(^)(NSError* error))failure;

/**
 *  获取作业对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithHomeworkId:(NSString*)homeworkId
                           Success:(void(^)(QuestionListResult *result))success
                           Failure:(void(^)(NSError* error))failure;

@end
