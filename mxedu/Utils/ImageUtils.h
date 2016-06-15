//
//  FileUtils.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/26.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

/**
 *  通过视频的URL，获得视频缩略图
 */
+(UIImage *)imageWithMediaURL:(NSURL *)url;

@end
