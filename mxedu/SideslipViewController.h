//
//  WWSideslipViewController.h
//  WWSideslipViewControllerSample
//
//  Created by 田晓鹏 on 14-8-26.
//  Copyright (c) 2014年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideslipViewController : UIViewController<UIGestureRecognizerDelegate>{
@private

    UIViewController * mainControl;
    UIViewController * righControl;
    
    UIImageView * imgBackground;
    
    CGFloat scalef;
}

-(instancetype)initWithMainView:(UIViewController *)MainView
                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image;

//当前视图的状态
@property (assign,nonatomic) BOOL isShowingMain;

//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;

//是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;


//恢复位置
-(void)showMainView;


//显示右视图
-(void)showRighView;



@end
