//
//  ExamFilterView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/5/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ExamFilterView.h"

#import "SysCommon.h"

@implementation ExamFilterView{
    UIView *_shadowView;//遮罩视图
    UIView *_searchView;//筛选视图
    NSInteger _currentSubjectIndex; //当前选中的button tag
    NSInteger _currentTypeIndex; //当前选中的button tag
    
    NSArray *_subjectTitleArr;
    NSMutableArray *_subjectBtnArray;
    NSArray *_typeTitleArr;
    NSMutableArray *_typeBtnArray;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _shadowView = [[UIView alloc]initWithFrame:self.bounds];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha=0.3;
        [self addSubview:_shadowView];
        
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 160)];
        _searchView.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
        [self addSubview:_searchView];
        
        [self addSubjectButtons];
        [self addTypeButtons];
    }
    return self;
}

-(void)addSubjectButtons{
    
    _subjectTitleArr = @[@"数学",@"英语",@"逻辑",@"写作"];
    _subjectBtnArray = [NSMutableArray arrayWithCapacity:[_subjectTitleArr count]];
    
    for (int i =0; i<_subjectTitleArr.count; i++) {
        UIView *cView = [[UIView alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 15.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [RGBCOLOR(222, 222, 222) CGColor];
        btn.tag = i;
        [btn setTitle:_subjectTitleArr[i] forState:UIControlStateNormal];
        if(i==0){
            btn.backgroundColor = COMMONBLUECOLOR;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(didClickSubjectBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i<2) {
            cView.frame = CGRectMake(i*SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 50);
            
        }else{
            cView.frame = CGRectMake((i-2)*SCREEN_WIDTH/2.0, 50, SCREEN_WIDTH/2.0, 50);
        }
        btn.frame = CGRectMake(SCREEN_WIDTH/12.0, GENERAL_SIZE(40), SCREEN_WIDTH/3.0, 30);
        [_subjectBtnArray addObject:btn];
        [cView addSubview:btn];
        [_searchView addSubview:cView];
    }
}

-(void)addTypeButtons{
    
    _typeTitleArr = @[@"模考",@"真题"];
    _typeBtnArray = [NSMutableArray arrayWithCapacity:[_typeTitleArr count]];
    
    for (int i =0; i<_typeTitleArr.count; i++) {
        UIView *cView = [[UIView alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 15.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [RGBCOLOR(222, 222, 222) CGColor];
        btn.tag = i;
        [btn setTitle:_typeTitleArr[i] forState:UIControlStateNormal];
        if(i==0){
            btn.backgroundColor = COMMONBLUECOLOR;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(didClickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        cView.frame = CGRectMake(i*SCREEN_WIDTH/2.0, 100, SCREEN_WIDTH/2.0, 50);
        btn.frame = CGRectMake(SCREEN_WIDTH/12.0, GENERAL_SIZE(40), SCREEN_WIDTH/3.0, 30);
        [_typeBtnArray addObject:btn];
        [cView addSubview:btn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,10, SCREEN_WIDTH, 1)];
        line.backgroundColor = RGBCOLOR(225, 225, 225);
        [cView addSubview:line];
        
        [_searchView addSubview:cView];
    }
}


-(void)didClickSubjectBtn:(UIButton *)sender{
    // 清除上一button样式
    UIButton *preBtn = (UIButton*)_subjectBtnArray[_currentSubjectIndex];
    preBtn.backgroundColor = [UIColor clearColor];
    [preBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    // 设置当前button样式
    sender.backgroundColor = COMMONBLUECOLOR;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _currentSubjectIndex = sender.tag;
    
    if (_delegate) {
        [_delegate didChooseSubject:_subjectTitleArr[_currentSubjectIndex] Button:sender];
    }
}

-(void)didClickTypeBtn:(UIButton *)sender{
    // 清除上一button样式
    UIButton *preBtn = (UIButton*)_typeBtnArray[_currentTypeIndex];
    preBtn.backgroundColor = [UIColor clearColor];
    [preBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    // 设置当前button样式
    sender.backgroundColor = COMMONBLUECOLOR;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _currentTypeIndex = sender.tag;
    
    if (_delegate) {
        [_delegate didChooseTypeWithButton:sender];
    }
}


@end
