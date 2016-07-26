//
//  OWTImageInfo.h
//  Weitu
//
//  Created by Su on 5/9/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ALAsset+BSEqual.h"

@interface MCImageInfo : NSObject

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* smallURL;
@property (nonatomic, assign) int angle;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, readonly) CGSize imageSize;
@property (nonatomic, readonly) NSString* thumbnailURL;

@end
