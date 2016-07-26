//
//  OWTImageInfo.m
//  Weitu
//
//  Created by Su on 5/9/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//

#import "MCImageInfo.h"

@implementation MCImageInfo

- (CGSize)imageSize
{
    return CGSizeMake(_width, _height);
}

- (NSString*)thumbnailURL
{
    if (_smallURL != nil && _smallURL.length > 0)
    {
        return _smallURL;
    }
    else
    {
        return _url;
    }
}

@end
