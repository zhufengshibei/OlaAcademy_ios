//
//  VideoInfoResult.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CourseVideo.h"

@interface VideoInfoResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) CourseVideo *video;


@end
