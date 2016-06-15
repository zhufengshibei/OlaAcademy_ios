//
//  PopPickerView.h
//  NTreat
//
//  Created by Frank on 15/5/26.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopPickerView;

typedef void (^ButtonClickBlock)(PopPickerView *pickerView, NSInteger index);

/**
 *  选择视图
 */
@interface PopPickerView : UIView
{
    ButtonClickBlock _block;
}

/**
 *  选择器
 */
@property (nonatomic, strong) UIPickerView *pickerView;

/**
 *  日期选择器
 */
@property (nonatomic, strong) UIDatePicker *datePickerView;

/**
 *  数据源
 */
@property (nonatomic, weak) id<UIPickerViewDataSource, UIPickerViewDelegate> pickerViewDelegate;

/**
 *  点击按钮触发的方法
 *
 *  @param buttonClickBlock <#buttonClickBlock description#>
 */
- (void)setButtonClickBlock:(ButtonClickBlock)buttonClickBlock;

/**
 *  初始化
 *
 *  @param date
 *  @param mode
 *
 *  @return 
 */
- (id)initWithDate:(NSDate*)date withMode:(UIDatePickerMode)mode;

@end
