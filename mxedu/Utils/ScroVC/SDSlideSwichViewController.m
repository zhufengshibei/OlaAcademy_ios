//
//  SDSlideSwichViewController.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "SDSlideSwichViewController.h"

#import "SysCommon.h"

@implementation SDSlideSwichViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    _VCArray = [NSMutableArray arrayWithCapacity:3];
    [self loadSwitchView];
}
-(void)loadSwitchView
{
    _switchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    
    _switchView.isTop = NO;
    _switchView.slideSwitchViewDelegate = self;
    [self.view addSubview:_switchView];
    self.switchView.tabItemNormalColor = kCellSelectTextColor;
    self.switchView.tabItemSelectedColor = TITLE_BACKGROUND_COLOR;
    self.switchView.shadowImage = [UIImage imageNamed:@"searchblueline.png"];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{

    
}
-(void)upLoadSwitchViewContent
{
    [_switchView buildUI];
}
-(NSMutableArray *)numberOfTab:(QCSlideSwitchView *)view
{
    return  _VCArray;
}
-(id)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    
    return  [_VCArray objectAtIndex:number];
}

-(void)slideSwitchView:(QCSlideSwitchView *)view didselecFirstTime:(NSUInteger)number
{
    [self searchInfoWithTag:number andMainString:nil];
}
-(void)searchInfoWithTag:(NSInteger)tag andMainString:(NSString *)str
{//
    
}
-(void)slideSwitchView:(QCSlideSwitchView *)view didHiddenViewsWithCurrentTag:(NSUInteger)number andLastTag:(NSInteger)lastTag
{
    number-=100;
    _seclect = number;
    [self searchInfoWithTag:number andMainString:nil];
}
@end
