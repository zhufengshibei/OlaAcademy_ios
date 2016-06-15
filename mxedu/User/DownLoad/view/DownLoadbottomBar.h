//
//  DownLoadbottomBar.h
//  NTreat
//
//  Created by 周冉 on 16/4/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  DownLoadbottomBar;
@protocol DownLoadbottomBarDeleght <NSObject>

-(void)clikeBarButton:(UIButton *)send myView:(DownLoadbottomBar *)myView;

@end
@interface DownLoadbottomBar : UIView
@property(nonatomic ,assign)BOOL allType;//全选状态
@property(nonatomic ,strong)UIButton *seclectLButton;//左侧全选按钮
@property(nonatomic ,assign)id<DownLoadbottomBarDeleght>deleght;
@end
