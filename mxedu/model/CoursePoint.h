//
//  CoursePoint.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursePoint : NSObject

@property (nonatomic, copy) NSString* pointId;
@property (nonatomic, copy) NSString* courseId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* type;

@end
