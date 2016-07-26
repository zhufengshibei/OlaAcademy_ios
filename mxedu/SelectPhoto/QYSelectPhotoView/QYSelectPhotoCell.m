//
//  QYSelectPhotoCell.m
//  Frank
//
//  Created by Frank on 15/5/20.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "QYSelectPhotoCell.h"

@implementation QYSelectPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{    
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.imageView];
}

@end
