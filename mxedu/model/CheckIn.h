//
//  CheckIn.h
//  mxedu
//
//  Created by 田晓鹏 on 15/12/1.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckIn : NSObject

@property (nonatomic, copy) NSString* checkId;
@property (nonatomic, copy) NSString* orgId;
@property (nonatomic, copy) NSString* userLocal;
@property (nonatomic, copy) NSString* orgPic;
@property (nonatomic, copy) NSString*orgName;
@property (nonatomic, copy) NSString* checkinTime;
@property (nonatomic, copy) NSString* userPhone;
@property (nonatomic, copy) NSString* type;

@end
