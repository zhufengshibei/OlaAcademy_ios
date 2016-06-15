//
//  CommodityFilterView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommodityFilterChooseDelegate <NSObject>

-(void)didChooseSubject:(NSString*)subject Button:(UIButton *)button;

@end

@interface CommodityFilterView : UIView

@property (nonatomic) id<CommodityFilterChooseDelegate> delegate;

@end
