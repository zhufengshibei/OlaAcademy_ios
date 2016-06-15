//
//  CourseBarView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/11.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CourseBarView.h"

#import "Masonry.h"
#import "SysCommon.h"

@implementation CourseBarView{
    UIImageView *courseIV;
    UILabel *titleLabel;
    UILabel *contentLabel;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        courseIV = [[UIImageView alloc]init];
        [self addSubview:courseIV];
        
        [courseIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(courseIV.mas_right).offset(20);
        }];
        
        contentLabel = [UILabel new];
        contentLabel.textColor = RGBCOLOR(144, 144, 144);
        contentLabel.font = LabelFont(28);
        [self addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(10);
            make.bottom.equalTo(titleLabel.mas_bottom).offset(0);
        }];

    }
    return self;
}

-(void)setViewWithImage:(NSString*)imageName Title:(NSString*)title Content:(NSString*)content{
    courseIV.image = [UIImage imageNamed:imageName];
    titleLabel.text = title;
    contentLabel.text = content;
}

@end
