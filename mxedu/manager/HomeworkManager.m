//
//  HomeworkManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkManager.h"

#import "SysCommon.h"

@implementation HomeworkManager

/**
 *  作业列表
 *
 *  @param type 1 学生 2 老师
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomeworkListWithHomeworkId:(NSString*)homeworkId
                              PageSize:(NSString*)pageSize
                                UserId:(NSString*)userId
                                  Type:(NSString*)type
                               Success:(void(^)(HomeworkListResult *result))success
                               Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.homeworkListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getHomeworkList"
        parameters:@{@"homeworkId": homeworkId,
                     @"pageSize": pageSize,
                     @"userId": userId,
                     @"type": type
                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[HomeworkListResult class]]) {
                   HomeworkListResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
               
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
    
}

/**
 *  获取作业对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithHomeworkId:(NSString*)homeworkId
                           Success:(void(^)(QuestionListResult *result))success
                           Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.questionListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getSubjectList" parameters:@{ @"homeworkId" : homeworkId
                                                                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[QuestionListResult class]]) {
                   QuestionListResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}



@end
