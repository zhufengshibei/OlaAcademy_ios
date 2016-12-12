//
//  CircleListTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleListTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation CircleListTableCell{
    UILabel *_titleL;
    UIImageView *_imageV;
    UIImageView *_avatar;
    UILabel *_nameL;
    UILabel *_timeL;
    UILabel *_numberL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(20), GENERAL_SIZE(30), GENERAL_SIZE(50), GENERAL_SIZE(50))];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = GENERAL_SIZE(25);
        [self addSubview:_avatar];
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(24);
        _nameL.numberOfLines = 0;
        _nameL.lineBreakMode = NSLineBreakByWordWrapping;
        _nameL.textColor = RGBCOLOR(81, 83, 93);
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(10));
            make.centerY.equalTo(_avatar);
        }];
        
        _timeL = [[UILabel alloc]init];
        _timeL.font = LabelFont(22);
        _timeL.textColor = [UIColor colorWhthHexString:@"#a4a6a9"];
        [self addSubview:_timeL];
        
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
            make.centerY.equalTo(_nameL);
        }];

        
        _titleL = [[UILabel alloc]init];
        _titleL.font = LabelFont(34);
        _titleL.textColor = RGBCOLOR(39, 42, 54);
        _titleL.numberOfLines = 0;
        [self addSubview:_titleL];
        
        _imageV = [[UIImageView alloc]init];
        [self addSubview:_imageV];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(235,235, 235);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@(GENERAL_SIZE(2)));
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
    }
    return self;
}

-(void)setupCellWithModel:(OlaCircle*)circle{
    
    if(circle.userAvatar) {
        if ([circle.userAvatar rangeOfString:@".jpg"].location == NSNotFound) {
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:circle.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:circle.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _avatar.image = [UIImage imageNamed:@"ic_avatar"];
    }
    _nameL.text = circle.userName;
    
    _timeL.text = circle.time;
    
    //标题
    NSString* contetxt = [circle.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //根据普通文本计算正文的范围
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    NSDictionary *attributes = @{NSFontAttributeName: LabelFont(30),NSParagraphStyleAttributeName:style};
    CGRect rect = [contetxt boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-GENERAL_SIZE(40), MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    _titleL.frame = CGRectMake(GENERAL_SIZE(20), CGRectGetMaxY(_avatar.frame)+GENERAL_SIZE(30), SCREEN_WIDTH-GENERAL_SIZE(40), rect.size.height);
    _titleL.text = circle.title;
    // 图片
    if (circle.imageGids&&![circle.imageGids isEqualToString:@""]) {
        _imageV.frame = CGRectMake(0, CGRectGetMaxY(_titleL.frame)+GENERAL_SIZE(30), SCREEN_WIDTH, GENERAL_SIZE(300));
        NSArray *imageArray = [circle.imageGids componentsSeparatedByString:@","];
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:imageArray[0]]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image != nil)
            {
                // 图片剪裁
                CGFloat width = CGImageGetWidth([image CGImage]);
                CGFloat height = CGImageGetHeight([image CGImage]);
                CGRect rect = CGRectMake(0, 0, width,width*300/750);
                if (width*300/750<height) {
                    rect = CGRectMake(0, (height-width*300/750)/2.0, width,width*300/750);
                }
                CGImageRef imagePartRef = CGImageCreateWithImageInRect([image CGImage], rect);
                [_imageV setImage:[UIImage imageWithCGImage:imagePartRef]];
            }else{
                _imageV.image = [UIImage imageNamed:@"ic_circle_default"];
            }
        }];
    }else{
        _imageV.frame = CGRectMake(0, CGRectGetMaxY(_titleL.frame), SCREEN_WIDTH, 0);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
