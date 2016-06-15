//
//  SearchTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "SearchTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"

@implementation SearchTableCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = COMMONBLUECOLOR;
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(0);
        }];
    }
    return self;
}

-(void)setCellWithModel:(Keyword*)keyword{
    _nameLabel.text = keyword.name;
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search:)];
    _nameLabel.userInteractionEnabled=YES;
    [_nameLabel addGestureRecognizer:tapRecognizer];
}

-(void)search:(UILabel*)sender{
    if (_delegate) {
        [_delegate searchTableCell:self didTapLabel:_nameLabel.text];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
