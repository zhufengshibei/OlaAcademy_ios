//
//  HomeworkChooseController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/30.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkChooseController.h"

#import "HomeworkWebController.h"

@interface HomeworkChooseController ()

@end

@implementation HomeworkChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)chooseQuestion{
    HomeworkWebController *homeworkWC = [[HomeworkWebController alloc]init];
    homeworkWC.type = 1;
    homeworkWC.objectId = @"104";
    homeworkWC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeworkWC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
