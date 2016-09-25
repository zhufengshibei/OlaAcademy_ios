//
//  SignInPopoverView.m
//  签到
//
//  Created by 田晓鹏 on 6/2/13.
//  Copyright (c) 2013 田晓鹏. All rights reserved.
//

#import "SignInPopoverView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "SysCommon.h"
#import "Masonry.h"

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

@interface SignInPopoverView ()

@property (nonatomic, retain) UIImageView *backIV;
@property (nonatomic, retain) UIButton *cancelButton;
//初始化界面 
- (void)initTheInterface;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;
@end

@implementation SignInPopoverView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    self.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.6];
    
    _backIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_signIn"]];
    [self addSubview:_backIV];
    
    [_backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-GENERAL_SIZE(80));
    }];
    
    UIImageView *avatarIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_scholar"]];
    [self addSubview:avatarIV];
    
    [avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backIV);
        make.centerY.equalTo(_backIV).offset(-GENERAL_SIZE(10));
    }];
    
    UIImageView *bottomIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_signIn_bottom"]];
    [self addSubview:bottomIV];
    
    [bottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_backIV.mas_bottom);
    }];

}


#pragma mark - Button Method
- (void)setCancelButtonBlock:(PopoverViewButtonBlock)block
{
    if (nil == _cancelButton)
    {
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backIV).offset(GENERAL_SIZE(20));
            make.top.equalTo(_backIV).offset(GENERAL_SIZE(20));
        }];
        
    }
    
    objc_setAssociatedObject(self.cancelButton, kZSYPopoverListButtonClickForCancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show or hide self
- (void)show
{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
    PopoverViewButtonBlock __block block;
    
    block = objc_getAssociatedObject(sender, kZSYPopoverListButtonClickForCancel);
    if (block)
    {
        block();
    }
    [self animatedOut];
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
}
@end
