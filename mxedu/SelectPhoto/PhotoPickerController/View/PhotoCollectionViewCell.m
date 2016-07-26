//
//  PhotoCollectionViewCell.m
//  QYER
//
//  Created by Frank on 15/5/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "Masonry.h"

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupImageView];
        
        [self setupButton];
    }
    return self;
}

- (void)setupImageView
{
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [self.contentView addSubview:_imageView];
}

- (void)setupButton{
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.userInteractionEnabled = NO;
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"Photo_Selected_No"] forState:UIControlStateNormal];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"Photo_Selected"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:_selectButton];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.width.offset(25);
        make.height.offset(25);
    }];
}

@end
