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
#import "GroupManager.h"

@interface CreateGroupController ()<UITextViewDelegate>


@end

@implementation CreateGroupController{
    
    UIImageView *avatarView;
    
    UILabel *title; //title 的 placehoder
    UITextView *editTitle;
    
    UILabel *label; //content 的 placehoder
    UITextView *editText;
    
    UIImageView *checkIV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群创建";
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
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
    
    avatarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_group_create"]];
    [self.view addSubview:avatarView];
    
    avatarView.center = CGPointMake(SCREEN_WIDTH/2, GENERAL_SIZE(203));
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 200, 40)];
    title.enabled = NO;
    title.text = @"填写群名称（2-10个字）";
    title.font =  LabelFont(24);
    title.textColor = [UIColor blackColor];
    [self.view addSubview:title];
    
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
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 200, 20)];
    label.enabled = NO;
    label.text = @"填写群资料（0-150个字）";
    label.font =  LabelFont(24);
    label.textColor = [UIColor blackColor];
    
    editText = [UITextView new];
    editText.tag=1002;
    editText.frame = CGRectMake(5, CGRectGetMaxY(dividerLine2.frame), SCREEN_WIDTH-10, GENERAL_SIZE(190));
    editText.font=[UIFont systemFontOfSize:16];
    editText.backgroundColor = [UIColor whiteColor];
    editText.delegate = self;
    [editText addSubview:label];
    [self.view addSubview:editText];
    
    UILabel *protocolL = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(220), CGRectGetMaxY(editText.frame)+GENERAL_SIZE(40), GENERAL_SIZE(380), GENERAL_SIZE(30))];
    protocolL.text = @"我已阅读并同意服务声明";
    [self.view addSubview:protocolL];

    checkIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_choice"]];
    [self.view addSubview:checkIV];
    
    [checkIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(protocolL);
        make.right.equalTo(protocolL.mas_left).offset(-10);
    }];
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createBtn.frame = CGRectMake(GENERAL_SIZE(70), CGRectGetMaxY(protocolL.frame)+GENERAL_SIZE(40), SCREEN_WIDTH-GENERAL_SIZE(140), GENERAL_SIZE(80));
    [createBtn setTitle:@"创 建 群" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = LabelFont(34);
    createBtn.backgroundColor = COMMONBLUECOLOR;
    createBtn.layer.cornerRadius = GENERAL_SIZE(40);
    [createBtn addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:createBtn];

}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==1001) {
        if ([textView.text length] == 0) {
            [title setHidden:NO];
        }else{
            [title setHidden:YES];
        }
    }else{
        if ([textView.text length] == 0) {
            [label setHidden:NO];
        }else{
            [label setHidden:YES];
        }
    }
    
}

-(void)createGroup{
    GroupManager *gm = [[GroupManager alloc]init];
    [gm createGroupWithUserId:@"" Name:editTitle.text Avatar:@"" success:^(CommonResult *result) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
