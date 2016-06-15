//
//  CommodityManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/16.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommodityManager.h"

#import "SysCommon.h"

@implementation CommodityManager

-(void)fetchCommodityListWithType:(NSString*)type
                        pageIndex:(NSString*)pageIndex
                         pageSize:(NSString*)pageSize
                          Success:(void(^)(CommodityListRsult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commodityListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/goods/getGoodsList" parameters:@{  @"pageIndex": pageIndex,
                                                                    @"pageSize" : pageSize,
                                                                    @"type" : type
                                                                    }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommodityListRsult class]]) {
                   CommodityListRsult *result = mappingResult.firstObject;
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

-(void)fetchBuyCommodityListWithUserId:(NSString*)userId
                          Success:(void(^)(CommodityListRsult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commodityListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/goods/getBuyGoodsList" parameters:@{  @"userId": userId
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommodityListRsult class]]) {
                   CommodityListRsult *result = mappingResult.firstObject;
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


-(void)fetchCommodityVideoListWithGoodsId:(NSString*)gid
                                   UserId:(NSString*)userId
                                  Success:(void(^)(VideoListResult *result))success
                                  Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.videoListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/goods/getVideoList" parameters:@{  @"userId": userId,
                                                                      @"gid": gid
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[VideoListResult class]]) {
                   VideoListResult *result = mappingResult.firstObject;
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

-(void)fetchCommodityStautsWithGoodsId:(NSString*)gid
                                UserId:(NSString*)userId
                                Success:(void(^)(StatusResult *result))success
                                Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.statusResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/goods/getOrderStatus" parameters:@{  @"userId": userId,
                                                                        @"gid": gid
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[StatusResult class]]) {
                   StatusResult *result = mappingResult.firstObject;
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

@end
