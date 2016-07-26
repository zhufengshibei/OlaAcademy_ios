//
//  QYImageUtil.h
//  Frank
//
//  Created by Frank on 14-6-23.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QYImageUtil : NSObject

+ (NSData*)thumbnailWithImageWithoutScale:(UIImage *)image withMaxScale:(CGFloat)maxScale;

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
