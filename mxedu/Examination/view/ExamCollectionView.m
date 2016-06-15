//
//  ExamCollectionView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/3/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ExamCollectionView.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "THProgressView.h"

@interface ExamCollectionView()

@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *studyLabel;
@property (strong, nonatomic)UILabel *significanceLabel;
@property (strong, nonatomic)UIView *starView;
@property (strong, nonatomic)THProgressView *progressView;
@property (strong, nonatomic)UILabel *sourceValue;
@property (strong, nonatomic)UILabel *progressValue;
@property (strong, nonatomic)UIImageView *lockIV;
@property (strong, nonatomic)UIView *coverIV;
@property (strong, nonatomic)UIButton *startBtn;

@end

@implementation ExamCollectionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc]init];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 8.0;
        view.backgroundColor = RGBCOLOR(250, 250, 250);
        [self addSubview:view];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 10);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self).with.insets(padding);
        }];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = COMMONBLUECOLOR;
        [view addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(GENERAL_SIZE(154)));
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
        }];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(36);
        _nameLabel.textColor = [UIColor whiteColor];
        [view addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(15);
            make.left.equalTo(view.mas_left).offset(15);
        }];
        
        _studyLabel = [[UILabel alloc]init];
        _studyLabel.font = LabelFont(28);
        _studyLabel.textColor = [UIColor whiteColor];
        [view addSubview:_studyLabel];
        
        [_studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.left.equalTo(view.mas_left).offset(15);
        }];
        
        _significanceLabel = [[UILabel alloc]init];
        _significanceLabel.font = LabelFont(32);
        _significanceLabel.textColor = RGBCOLOR(51, 51, 51);
        _significanceLabel.text = @"重要程度";
        [view addSubview:_significanceLabel];
        
        [_significanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(30);
            make.left.equalTo(view.mas_left).offset(15);
        }];
        
        
        _starView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(140), GENERAL_SIZE(32))];
        [self addSubview:_starView];
        
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(30);
            make.left.equalTo(_significanceLabel.mas_right).offset(10);
            make.centerY.equalTo(_significanceLabel);
        }];
        
        UILabel *sourceLabel = [[UILabel alloc]init];
        sourceLabel.font = LabelFont(32);
        sourceLabel.textColor = RGBCOLOR(51, 51, 51);
        sourceLabel.text = @"内容来源";
        [view addSubview:sourceLabel];
        
        [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_significanceLabel.mas_bottom).offset(20);
            make.left.equalTo(view.mas_left).offset(15);
        }];
        
        _sourceValue = [[UILabel alloc]init];
        _sourceValue.font = LabelFont(32);
        _sourceValue.textColor = RGBCOLOR(144, 144, 144);
        [view addSubview:_sourceValue];
        
        [_sourceValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_significanceLabel.mas_bottom).offset(20);
            make.left.equalTo(sourceLabel.mas_right).offset(10);
        }];
        
        UILabel *progressLabel = [[UILabel alloc]init];
        progressLabel.font = LabelFont(32);
        progressLabel.textColor = RGBCOLOR(144, 144, 144);
        progressLabel.text = @"学习进度";
        [view addSubview:progressLabel];
        
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sourceLabel.mas_bottom).offset(20);
            make.left.equalTo(view.mas_left).offset(15);
        }];
        
        _progressView = [[THProgressView alloc]init];
        _progressView.borderTintColor = [UIColor clearColor];
        _progressView.progressTintColor = COMMONBLUECOLOR;
        _progressView.progressBackgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:_progressView];
        
        _progressValue = [[UILabel alloc]init];
        _progressValue.font = LabelFont(32);
        _progressValue.textColor = RGBCOLOR(144, 144, 144);
        [view addSubview:_progressValue];
        
        [_progressValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sourceLabel.mas_bottom).offset(20);
            make.right.equalTo(view.mas_right).offset(-15);
        }];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sourceLabel.mas_bottom).offset(20);
            make.left.equalTo(progressLabel.mas_right).offset(10);
            make.right.equalTo(_progressValue.mas_left).offset(-15);
            make.height.equalTo(@20);
        }];
        
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"button_start"] forState:UIControlStateNormal];
        [_startBtn setTitle:@"开始模考" forState:UIControlStateNormal];
        _startBtn.userInteractionEnabled = NO; //不响应点击事件
        [view addSubview:_startBtn];
        
        [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom).offset(-GENERAL_SIZE(50));
            make.centerX.equalTo(view);
        }];
        
        _coverIV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width-10, self.bounds.size.height)];
        _coverIV.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [self addSubview:_coverIV];
        
        _lockIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_lock"]];
        [self addSubview:_lockIV];
        
        [_lockIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        
    }
    return self;
}

-(void)setupViewWithModel:(Examination*) examination{
    _nameLabel.text = examination.name;
    for (int i=0; i<3; i++) {
        UIImageView *starIV = [[UIImageView alloc]initWithFrame:CGRectMake((GENERAL_SIZE(34)+4)*i, 0, GENERAL_SIZE(34), GENERAL_SIZE(32))];
        if (i<[examination.degree intValue]) {
            starIV.image = [UIImage imageNamed:@"foregroundStar"];
        }else{
            starIV.image = [UIImage imageNamed:@"backgroundStar"];
        }
        [_starView addSubview:starIV];
    }
    if ([examination.isfree integerValue]==1) {
        _coverIV.hidden = YES;
        _lockIV.hidden = YES;
    }else{
        _coverIV.hidden = NO;
        _lockIV.hidden = NO;
    }
    _studyLabel.text = [NSString stringWithFormat: @"已有%@人学习",examination.learnNum];
    _sourceValue.text = examination.source;
    NSString *progress=[NSString stringWithFormat:@"%.2lf", [examination.progress intValue]/100.0];
    _progressView.progress = [progress floatValue];
    _progressValue.text = [NSString stringWithFormat:@"%@％",examination.progress];
}
@end
