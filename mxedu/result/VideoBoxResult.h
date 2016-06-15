//
//  VideoBoxResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoBox.h"

@interface VideoBoxResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) VideoBox *videoBox;

@end
