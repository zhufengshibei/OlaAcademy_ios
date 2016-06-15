//
//  FilterView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterChooseDelegate <NSObject>

-(void)didChooseSubject:(NSString*)subject Button:(UIButton *)button;

@end

@interface FilterView : UIView

@property (nonatomic) id<FilterChooseDelegate> delegate;

@end
