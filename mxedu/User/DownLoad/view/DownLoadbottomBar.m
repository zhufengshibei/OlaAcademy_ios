//
//  DownLoadbottomBar.m
//  NTreat
//
//  Created by 周冉 on 16/4/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DownLoadbottomBar.h"
#import "SysCommon.h"

@implementation DownLoadbottomBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self loadButton];
    }
    return self;
}
-(void)loadButton
{
    NSArray * titleStr = @[@"全选",@"删除"];
    
    for(int i = 0;i<[titleStr count];i++ ){
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(i*SCREEN_WIDTH/2, 0,SCREEN_WIDTH/2 , 49);
        [button setTitle:[titleStr objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = 10000+i;
        if(button.tag == 10000)
        {
            _seclectLButton = button;//获取左侧全选按钮
        
        }
        [button setTitleColor:[UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1] forState:UIControlStateSelected];
        [button addTarget:self  action:@selector(buttonClike:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
-(void)buttonClike:(UIButton *)send
{
   if([_deleght respondsToSelector:@selector(clikeBarButton: myView:)])
   {
       if(send.tag == 10000)
       {
           self.allType = !self.allType;
       
       }
       
    [_deleght  clikeBarButton:send myView:self];
   }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
