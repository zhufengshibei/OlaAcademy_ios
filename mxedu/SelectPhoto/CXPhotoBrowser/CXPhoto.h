//
//  CXPhoto.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/18.
//  Copyright (c) 2013年 QYER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXPhotoProtocol.h"
#import "CXPhotoLoadingView.h"

@interface CXPhoto : NSObject
<CXPhotoProtocol>

@property (nonatomic,strong)UIImage *currentImge;
@property (nonatomic, strong, readonly) UIImage *underlyingImage;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) long long timeSend;
@property (nonatomic, copy) NSString *imageUrl;//大图url
@property (nonatomic, copy)NSString * photoPath; //图片路径

// Class
+ (CXPhoto *)photoWithImage:(UIImage *)image;
+ (CXPhoto *)photoWithFilePath:(NSString *)path;
+ (CXPhoto *)photoWithURL:(NSURL *)url;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;

//Load Async
- (void)loadImageFromFileAsync:(NSString *)path;
- (void)loadImageFromURLAsync:(NSURL *)url;
- (void)unloadImage;
- (void)reloadImage;

@end
