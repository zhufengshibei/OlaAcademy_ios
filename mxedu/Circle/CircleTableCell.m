//
//  CircleTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation CircleTableCell{
   
    UIImageView *_avatarImage;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_recordLabel;
    UILabel *_courseLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarImage = [UIImageView new];
        _avatarImage.image = [UIImage imageNamed:@"ic_avatar"];
        [self addSubview:_avatarImage];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COMMONBLUECOLOR;
        [self addSubview:_nameLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        _timeLabel.textColor = RGBCOLOR(147, 147, 147);
        [self addSubview:_timeLabel];
        
        _recordLabel = [UILabel new];
        _recordLabel.text = @"学习了：";
        _recordLabel.font = [UIFont systemFontOfSize:14.0];
        _recordLabel.textColor = RGBCOLOR(147, 147, 147);
        [self addSubview:_recordLabel];
        
        _courseLabel = [UILabel new];
        _courseLabel.textColor = RGBCOLOR(50, 50, 50);
        _courseLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_courseLabel];
        
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(20);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImage.mas_top).offset(5);
            make.left.equalTo(_avatarImage.mas_right).offset(20);
            make.width.equalTo(@200);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            make.left.equalTo(_avatarImage.mas_right).offset(20);
            make.width.equalTo(@(SCREEN_WIDTH-30));
        }];
        
        [_recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom).offset(5);
            make.left.equalTo(_avatarImage.mas_right).offset(20);
        }];
        
        [_courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom).offset(5);
            make.left.equalTo(_recordLabel.mas_right);
        }];
    }
    return self;
    
}

-(void)setCellWithModel:(VideoHistory*)history{
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:GET_IMAGE_URL(history.userAvatar)] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    _avatarImage.layer.cornerRadius = 25;
    _avatarImage.layer.masksToBounds = YES;
    _avatarImage.layer.borderWidth = 1;
    _avatarImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _nameLabel.text = history.userName;
    _courseLabel.text = history.videoName;
    _timeLabel.text = [NSString stringWithFormat:@"%@ 学习记录",[history.time substringWithRange:NSMakeRange(5,11)]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
