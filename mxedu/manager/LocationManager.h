//
//  LocationManager.h
//  NTreat
//
//  Created by 田晓鹏 on 15/5/29.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

@property (nonatomic) NSMutableArray *locationArray;
@property (nonatomic) NSMutableArray *hostpitalArray;

/**
 * 地区查询
 */
-(void)fetchLocationWithCode:(NSString*)code
                       level:(NSString*)level
                     Success:(void(^)())success
                     Failure:(void(^)(NSError* error))failure;

/**
 * 医院查询
 */
-(void)fetchHospitalWithAreacode:(NSString*)areaCode
                         Success:(void(^)())success
                         Failure:(void(^)(NSError* error))failure;

@end
