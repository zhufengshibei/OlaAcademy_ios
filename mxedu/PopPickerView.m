//
//  PopPickerView.m
//  NTreat
//
//  Created by Frank on 15/5/26.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "PopPickerView.h"
#import "UIView+Positioning.h"
#import "UIColor+HexColor.h"

#import "Masonry.h"

@implementation PopPickerView
{
    NSDate *_date;
    UIDatePickerMode _mode;
}

- (id)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _mode = UIDatePickerModeDate;
        
        [self setupSubviews];
    }
    return self;
}

- (id)initWithDate:(NSDate*)date withMode:(UIDatePickerMode)mode
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _date = date;
        _mode = mode;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    //背景视图
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [self addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView)];
    [backgroundView addGestureRecognizer:tap];
    
    //选择器背景
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor colorWhthHexString:@"#DCDDDD"];
    [self addSubview:contentView];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelImage = [UIImage imageNamed:@"Cancel"];
    cancelImage = [cancelImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    cancelButton.tag = 1000;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWhthHexString:@"#018BE6"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    //确认按钮
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sureImage = [UIImage imageNamed:@"Button_Save"];
    sureButton.tag = 1001;
    sureImage = [sureImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    [sureButton setBackgroundImage:sureImage forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureButton];
    
    //横线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.alpha = 0.5;
    [contentView addSubview:lineView];
    
    UIView *pickerView = nil;
    
    //创建选择器
    if (_date) {
        _datePickerView = [[UIDatePicker alloc] init];
       // _datePickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [_datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        _datePickerView.datePickerMode = _mode;
        //_datePickerView.date = _date;
        _datePickerView.date =[NSDate date];
        [contentView addSubview:_datePickerView];
        
        pickerView = _datePickerView;
    }else{
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        [contentView addSubview:_pickerView];
        
        pickerView = _pickerView;
    }
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(contentView.mas_top);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(backgroundView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.height.offset(270);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(sureButton.mas_left).offset(-40);
        make.bottom.equalTo(pickerView.mas_top).offset(-10);
        make.width.equalTo(sureButton.mas_width);
        make.height.offset(30);
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(cancelButton.mas_right).offset(40);
        make.bottom.equalTo(cancelButton.mas_bottom);
        make.width.equalTo(cancelButton.mas_width);
        make.height.equalTo(cancelButton.mas_height);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(1);
        make.top.equalTo(cancelButton.mas_bottom).offset(10);
    }];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(cancelButton.mas_bottom).offset(10);
    }];

}

- (void)setPickerViewDelegate:(id<UIPickerViewDataSource,UIPickerViewDelegate>)pickerViewDelegate
{
    _pickerView.delegate = pickerViewDelegate;
    _pickerView.dataSource = pickerViewDelegate;
}

- (void)buttonClicked:(UIButton*)button
{
    if (_block) {
        _block(self, button.tag - 1000);
    }
}

- (void)setButtonClickBlock:(ButtonClickBlock)buttonClickBlock
{
    _block = buttonClickBlock;
}

- (void)tapBackgroundView
{
    if (_block) {
        _block(self, 0);
    }
}

@end
