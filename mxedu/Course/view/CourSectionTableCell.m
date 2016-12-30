//
//  CourSectionTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 15/12/12.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourSectionTableCell.h"

#import "Masonry.h"
#import "SysCommon.h"

@implementation CourSectionTableCell

{
    UILabel *_nameL;
    UILabel *_timeL;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameL = [UILabel new];
        _nameL.font = LabelFont(32);
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(GENERAL_SIZE(5));
            make.left.equalTo(self.mas_left).offset(20);
        }];
        
        _timeL = [UILabel new];
        _timeL.font = LabelFont(28);
        [self addSubview:_timeL];
        
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(GENERAL_SIZE(5));
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        
    }
    return self;
    
}

-(void) setCellWithModel:(CourseVideo*)point{
    _nameL.text = point.name;
    _timeL.text = point.timeSpan;
    if (point.isChosen==1) {
        _nameL.textColor = COMMONBLUECOLOR;
        _timeL.textColor = COMMONBLUECOLOR;
    }else{
        _nameL.textColor = RGBCOLOR(153, 153, 153);
        _timeL.textColor = RGBCOLOR(153, 153, 153);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
