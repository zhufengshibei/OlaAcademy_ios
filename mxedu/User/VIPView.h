//
//  HealthHeadView.h
//  NTreat
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VIPViewDelegate <NSObject>

-(void)didClickTeamView;
-(void)didClickPatientView;
-(void)didClickCaseView;
-(void)didClickCodeView;

@end

@interface VIPView : UIView

@property (nonatomic) id<VIPViewDelegate> headViewDelegate;

@end
