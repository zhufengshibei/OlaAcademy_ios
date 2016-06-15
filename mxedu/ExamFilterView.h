//
//  ExamFilterView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterChooseDelegate <NSObject>

-(void)didChooseSubject:(NSString*)subject Button:(UIButton *)button;
-(void)didChooseTypeWithButton: (UIButton *)button;

@end

@interface ExamFilterView : UIView

@property (nonatomic) id<FilterChooseDelegate> delegate;

@end
