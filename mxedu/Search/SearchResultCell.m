//
//  SearchResultCell.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/27.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "SearchResultCell.h"
#import "SysCommon.h"

#import "UIImageView+AsyncDownload.h"

@implementation SearchResultCell{
    UIImageView *_videoImage;
    UILabel *_nameLabel;
    UILabel *_orgLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 55)];
        _videoImage.layer.cornerRadius=8;
        _videoImage.layer.masksToBounds=YES;
        [self addSubview:_videoImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 20)];
        _nameLabel.textColor = COMMONBLUECOLOR;
        [self addSubview:_nameLabel];
        
        _orgLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 200, 20)];
        _orgLabel.textColor = RGBCOLOR(105, 105, 105);
        [self addSubview:_orgLabel];
    }
    return self;
}

-(void)setupCellWithModel:(NSObject*) model{
    if ([model isKindOfClass:[Course class]]) {
        Course *course = (Course*)model;
        [_videoImage setImageWithURL:[NSURL URLWithString: course.address] placeholderImage:[UIImage imageNamed:@"ic_video"]];
        _nameLabel.text = course.name;
        _orgLabel.text = course.profile;
    }else{
        CourseVideo *video = (CourseVideo*)model;
        [_videoImage setImageWithVideoURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4", video.address]] placeholderImage:[UIImage imageNamed:@"ic_video"]];
        _nameLabel.text = video.name;
        _orgLabel.text = video.content;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
