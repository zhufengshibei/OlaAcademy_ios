//
//  VideoCollectionResult.h
//  mxedu
//
//  Created by 田晓鹏 on 15/11/27.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoCollection.h"

@interface VideoCollectionResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) VideoCollection *collection;

@end
