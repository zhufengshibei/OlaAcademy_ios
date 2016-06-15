//
//  OrganizationResult.h
//  mxedu
//
//  Created by 田晓鹏 on 15/11/9.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) NSArray *orgList;

@end
