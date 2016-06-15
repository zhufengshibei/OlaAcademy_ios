//
//  FilterView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "FilterView.h"

#import "SysCommon.h"

@implementation FilterView{
    UIView *_shadowView;//遮罩视图
    UIView *_searchView;//筛选视图
    NSInteger _currentIndex; //当前选中的button tag
    
    NSArray *_titlesArr;
    NSMutableArray *_btnArray;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        _shadowView = [[UIView alloc]initWithFrame:self.bounds];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha=0.3;
        [self addSubview:_shadowView];
        
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 115)];
        _searchView.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
        [self addSubview:_searchView];
        
        [self addButtons];
    }
    return self;
}

-(void)addButtons{
    
    _titlesArr = @[@"数学",@"英语",@"逻辑",@"写作"];
    _btnArray = [NSMutableArray arrayWithCapacity:[_titlesArr count]];
    
    for (int i =0; i<_titlesArr.count; i++) {
        UIView *cView = [[UIView alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 15.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [RGBCOLOR(222, 222, 222) CGColor];
        btn.tag = i;
        [btn setTitle:_titlesArr[i] forState:UIControlStateNormal];
        if(i==0){
            btn.backgroundColor = COMMONBLUECOLOR;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(didClickBt:) forControlEvents:UIControlEventTouchUpInside];
        if (i<2) {
            cView.frame = CGRectMake(i*SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 50);
            
        }else{
            cView.frame = CGRectMake((i-2)*SCREEN_WIDTH/2.0, 50, SCREEN_WIDTH/2.0, 50);
        }
        btn.frame = CGRectMake(SCREEN_WIDTH/12.0, GENERAL_SIZE(40), SCREEN_WIDTH/3.0, 30);
        [_btnArray addObject:btn];
        [cView addSubview:btn];
        [_searchView addSubview:cView];
    }
}
-(void)didClickBt:(UIButton *)sender{
    // 清除上一button样式
    UIButton *preBtn = (UIButton*)_btnArray[_currentIndex];
    preBtn.backgroundColor = [UIColor clearColor];
    [preBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    // 设置当前button样式
    sender.backgroundColor = COMMONBLUECOLOR;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _currentIndex = sender.tag;

    if (_delegate) {
        [_delegate didChooseSubject:_titlesArr[_currentIndex] Button:sender];
    }
}


@end
