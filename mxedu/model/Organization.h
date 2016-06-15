//
//  Organization.h
//  mxedu
//
//  Created by 田晓鹏 on 15/11/9.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject

@property (nonatomic, copy) NSString* orgId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* org;
@property (nonatomic, copy) NSString* logo;
@property (nonatomic, copy) NSString* profile;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* checkinCount;
@property (nonatomic, copy) NSString* attendCount;
@property (nonatomic, copy) NSString* checkedIn; //0 未报名 1 已报名


@end
