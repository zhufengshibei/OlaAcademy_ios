//
//  CircleManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/5.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonResult.h"
#import "VideoHistoryResult.h"
#import "CircleDetailResult.h"

@interface CircleManager : NSObject

-(void)addOlaCircleWithUserId:(NSString*)userId
                        Title:(NSString*)title
                      content:(NSString*)content
                    imageGids:(NSString*)imageGids
                   assignUser:(NSString*)assignUser
                     isPublic:(NSString*)isPublic
                     Location:(NSString*)location
                         Type:(NSString*)type
                      Success:(void(^)(CommonResult *result))success
                      Failure:(void(^)(NSError* error))failure;

/**
 *  欧拉圈列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchVideoHistoryListWithVideoLogId:(NSString*)circleId
                                    UserId:(NSString*)userId
                                  PageSize:(NSString*)pageSize
                                      Type:(NSString*)type
                                   Success:(void(^)(VideoHistoryResult *result))success
                                   Failure:(void(^)(NSError* error))failure;

/**
 *  帖子详情
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchCircleDetailWithId:(NSString*)circleId
                       Success:(void(^)(CircleDetailResult *result))success
                       Failure:(void(^)(NSError* error))failure;

/**
 *  欧拉圈帖子点赞
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)praiseCirclePostWithCircle:(NSString*)circleId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure;

@end
