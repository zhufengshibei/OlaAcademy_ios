//
//  ExamManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/12.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ExamManager.h"

#import "DataMappingManager.h"
#import "SysCommon.h"

@implementation ExamManager

-(void)fetchExamListWithCourseID:(NSString*)courseId
                           Type:(NSString*)type
                          UserId:(NSString*)userId
                        Success:(void(^)(ExamListRsult *result))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.examListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/exam/getExamList" parameters:@{  @"courseId" : courseId,
                                                                    @"type" : type,
                                                                    @"userId" : userId
                                                                }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[ExamListRsult class]]) {
                         ExamListRsult *result = mappingResult.firstObject;
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

/**
 *  获取试卷对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithExamId:(NSString*)examId
                       Success:(void(^)(QuestionListResult *result))success
                       Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.questionListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/exam/getExamSubList" parameters:@{ @"examId" : examId
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
