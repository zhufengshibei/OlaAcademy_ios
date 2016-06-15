//
//  LocationManager.m
//  NTreat
//
//  Created by 田晓鹏 on 15/5/29.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "LocationManager.h"
#import "DataMappingManager.h"
#import "SysCommon.h"
#import "LocationResult.h"

@implementation LocationManager

/**
 * 地区查询
 */
-(void)fetchLocationWithCode:(NSString*)code
                       level:(NSString*)level
                     Success:(void(^)())success
                     Failure:(void(^)(NSError* error))failure{
    
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.loacationResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/SD/common/areaSelect" parameters:@{ @"code" : code,
                                                                @"level" : level
                                                                }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[LocationResult class]]) {
                         LocationResult *result = mappingResult.firstObject;
                         if (result.code==0) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                             return;
                         }
                         _locationArray = result.locationArray;
                     }
                     if (success != nil) {
                         success();
                     }
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

/**
 * 医院查询
 */
-(void)fetchHospitalWithAreacode:(NSString*)areaCode
                     Success:(void(^)())success
                     Failure:(void(^)(NSError* error))failure{
    
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.loacationResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/SD/common/hosSelect" parameters:@{ @"areCode" : areaCode
                                                                }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[LocationResult class]]) {
                         LocationResult *result = mappingResult.firstObject;
                         if (result.code==0) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                             return;
                         }
                         _hostpitalArray = result.locationArray;
                     }
                     if (success != nil) {
                         success();
                     }
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}



@end
