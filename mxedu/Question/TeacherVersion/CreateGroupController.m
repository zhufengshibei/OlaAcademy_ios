//
//  CreateGroupController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CreateGroupController.h"

#import "SysCommon.h"
#import "Masonry.h"

@interface CreateGroupController ()<UITextViewDelegate>


@end

@implementation CreateGroupController{
    
    UIImageView *avatarView;
    
    UILabel *title; //title 的 placehoder
    UITextView *editTitle;
    
    UILabel *label; //content 的 placehoder
    UITextView *editText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群创建";
    [self setupBackButton];
    
    [self setupView];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    
    avatarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self.view addSubview:avatarView];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(3, GENERAL_SIZE(405), 160, 40)];
    title.enabled = NO;
    title.text = @"填写群名称（2-10个字）";
    title.font =  [UIFont systemFontOfSize:16];
    title.textColor = [UIColor blackColor];
    
    editTitle = [UITextView new];
    editTitle.tag = 1001;
    editTitle.frame = CGRectMake(5, GENERAL_SIZE(415), SCREEN_WIDTH-10, 45);
    editTitle.font=[UIFont systemFontOfSize:16];
    editTitle.backgroundColor = [UIColor whiteColor];
    editTitle.delegate = self;
    editTitle.showsVerticalScrollIndicator = false;
    [editTitle addSubview:title];
    [self.view addSubview:editTitle];
    
    UIView *dividerLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(editTitle.frame), SCREEN_WIDTH, 1)];
    dividerLine2.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:dividerLine2];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, GENERAL_SIZE(415), 160, 20)];
    label.enabled = NO;
    label.text = @"填写群资料（0-150个字）";
    label.font =  [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    
    editText = [UITextView new];
    editText.tag=1002;
    int height = 100;
    if (iPhone6) {
        height = 110;
    }else if(iPhone6Plus){
        height = 120;
    }
    editText.frame = CGRectMake(5, CGRectGetMaxY(dividerLine2.frame), SCREEN_WIDTH-10, height);
    editText.font=[UIFont systemFontOfSize:16];
    editText.backgroundColor = [UIColor whiteColor];
    editText.delegate = self;
    [editText addSubview:label];
    [self.view addSubview:editText];
    
    UIView *dividerLine3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(editText.frame), SCREEN_WIDTH, 5)];
    dividerLine3.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:dividerLine3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
