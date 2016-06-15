//
//  ModifyPassViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 15/5/29.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "ModifyPassViewController.h"
#import "SysCommon.h"
#import "UserManager.h"

@interface ModifyPassViewController ()

@end

@implementation ModifyPassViewController

UITextField *oldPass;
UITextField *newPass;
UITextField *newPassAgain;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor =BACKGROUNDCOLOR;
    oldPass = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 40)];
    oldPass.borderStyle = UITextBorderStyleRoundedRect;
    oldPass.placeholder = @"旧密码";
    
    newPass = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 40)];
    newPass.borderStyle = UITextBorderStyleRoundedRect;
    newPass.placeholder = @"新密码";
    
    newPassAgain = [[UITextField alloc]initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-20, 40)];
    newPassAgain.borderStyle = UITextBorderStyleRoundedRect;
    newPassAgain.placeholder = @"重复新密码";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 170, SCREEN_WIDTH-20, 40);
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage: [UIImage imageNamed:@"btn_login"] forState:(UIControlStateNormal)] ;
    
    [button addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:oldPass];
    [self.view addSubview:newPass];
    [self.view addSubview:newPassAgain];
    [self.view addSubview:button];
}

- (void)modify {

    if (oldPass.text.length == 0) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入旧密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    if (newPass.text.length == 0) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    if (newPassAgain.text.length == 0) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请再次输入新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    if (![newPass.text isEqualToString:newPassAgain.text]) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    UserManager *um = [[UserManager alloc]init];
    [um modifyPasswordWithOldPwd:oldPass.text newPwd:newPass.text Success:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        // 保存用户名密码
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSData* data = [defaults objectForKey:@"LoginInfo"];
        NSDictionary *loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSDictionary *newInfo = [NSDictionary dictionaryWithObjectsAndKeys:[loginInfo objectForKey:@"mobile"],@"mobile",newPass.text,@"password", nil];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:newInfo]
                     forKey:@"LoginInfo"];
        [self.navigationController popViewControllerAnimated:YES];
    } Failure:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
