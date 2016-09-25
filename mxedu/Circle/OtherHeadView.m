//
//  OtherHeadView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "OtherHeadView.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface OtherHeadView ()
{
    UIImageView *_avatarImageview;
    UILabel *_nameLabel;
    UILabel *_vipLabel;
    UILabel *_localLabel;
}

@end

@implementation OtherHeadView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COMMONBLUECOLOR;
        
        _avatarImageview = [[UIImageView alloc]init];
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        _avatarImageview.layer.masksToBounds = YES;
        _avatarImageview.layer.cornerRadius = GENERAL_SIZE(60);
        _avatarImageview.layer.borderColor = [[UIColor whiteColor]CGColor];
        _avatarImageview.layer.borderWidth = 1.0;
        [self addSubview:_avatarImageview];
        
        UIImageView *nextIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_next"]];
        [self addSubview:nextIV];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(32);
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _vipLabel = [[UILabel alloc]init];
        _vipLabel.text = @"VIP会员";
        _vipLabel.layer.masksToBounds = YES;
        _vipLabel.layer.cornerRadius = 5.0;
        _vipLabel.backgroundColor =  RGBCOLOR(255, 5, 0);
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.font = LabelFont(24);
        [self addSubview:_vipLabel];
        
        _localLabel = [[UILabel alloc]init];
        _localLabel.textColor = [UIColor whiteColor];
        _localLabel.font = LabelFont(28);
        [self addSubview:_localLabel];
        
        [_avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(32);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.equalTo(@(GENERAL_SIZE(120)));
            make.height.equalTo(@(GENERAL_SIZE(120)));
        }];
        
        [nextIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImageview);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
        }];
        
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageview.mas_top).offset(5);
            make.left.equalTo(_avatarImageview.mas_right).offset(10);
            make.width.equalTo(@200);
            make.height.equalTo(@20);
        }];
        
        [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageview.mas_right).offset(10);
            make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(30));
            make.width.equalTo(@(GENERAL_SIZE(120)));
            make.height.equalTo(@(GENERAL_SIZE(36)));
        }];
        
        [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_vipLabel.mas_right).offset(8);
            make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(30));
            make.width.equalTo(@200);
            make.height.equalTo(@20);
        }];
        
        //[self setupLocltionManager];
        
    }
    return self;
    
    
}

- (void)updateWithUser:(User*)user
{
    if (user) {
        if(user.avatar){
            if ([user.avatar rangeOfString:@".jpg"].location == NSNotFound) {
                [_avatarImageview sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
            }else{
                [_avatarImageview sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
            }
        }else{
            _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        }
        _nameLabel.text = user.name;
    }else{
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        _nameLabel.text = @"小欧";
    }
}

@end
