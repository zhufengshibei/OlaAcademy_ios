//
//  CommodityManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/16.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommodityListRsult.h"
#import "VideoListResult.h"
#import "StatusResult.h"

@interface CommodityManager : NSObject

/**
 * 查询整体视频或题库
 * type 1 视频 2 题库
 */
-(void)fetchCommodityListWithType:(NSString*)type
                        pageIndex:(NSString*)pageIndex
                         pageSize:(NSString*)pageSize
                          Success:(void(^)(CommodityListRsult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 * 查询已购买视频
 */
-(void)fetchBuyCommodityListWithUserId:(NSString*)userId
                               Success:(void(^)(CommodityListRsult *result))success
                               Failure:(void(^)(NSError* error))failure;
/**
 * 购买状态查询
 */
-(void)fetchCommodityStautsWithGoodsId:(NSString*)gid
                                UserId:(NSString*)userId
                               Success:(void(^)(StatusResult *result))success
                               Failure:(void(^)(NSError* error))failure;

/**
 * 查询整体视频列表
 */
-(void)fetchCommodityVideoListWithGoodsId:(NSString*)gid
                                   UserId:(NSString*)userId
                                  Success:(void(^)(VideoListResult *result))success
                                  Failure:(void(^)(NSError* error))failure;

@end
