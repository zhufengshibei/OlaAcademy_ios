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
#import "SVProgressHUD.h"
#import "FSMediaPicker.h"
#import "AuthManager.h"
#import "GroupManager.h"
#import "UploadManager.h"
#import "UserProcotolViewController.h"

@interface CreateGroupController ()<UITextViewDelegate,FSMediaPickerDelegate>


@end

@implementation CreateGroupController{
    
    UIImageView *avatarView;
    
    UIImage *selectedImage;
    
    UILabel *title; //title 的 placehoder
    UITextView *editTitle;
    
    UILabel *label; //content 的 placehoder
    UITextView *editText;
    
    UIImageView *checkIV;
    
    UIButton *createBtn;
    NSString *titleString;
    
    NSString *subjectType;
    
    UITapGestureRecognizer *wholeTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群创建";
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    [self setupBackButton];
    
    subjectType = @"2";
    
    [self setupView];
    
    wholeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
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
    
    avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(144), GENERAL_SIZE(144))];
    avatarView.center = CGPointMake(SCREEN_WIDTH/2, GENERAL_SIZE(203));
    avatarView.image = [UIImage imageNamed:@"bg_group_create"];
    avatarView.layer.masksToBounds = YES;
    avatarView.layer.cornerRadius = GENERAL_SIZE(72);
    [self.view addSubview:avatarView];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    avatarView.userInteractionEnabled = YES;
    [avatarView addGestureRecognizer:singleRecognizer];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 200, 40)];
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browseProcotol)];
    protocolL.userInteractionEnabled = YES;
    [protocolL addGestureRecognizer:tap];

    checkIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_choice"]];
    [self.view addSubview:checkIV];
    
    [checkIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(protocolL);
        make.right.equalTo(protocolL.mas_left).offset(-10);
    }];
    
    createBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createBtn.frame = CGRectMake(GENERAL_SIZE(70), CGRectGetMaxY(protocolL.frame)+GENERAL_SIZE(40), SCREEN_WIDTH-GENERAL_SIZE(140), GENERAL_SIZE(80));
    [createBtn setTitle:@"创 建 群" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = LabelFont(34);
    createBtn.backgroundColor = COMMONBLUECOLOR;
    createBtn.layer.cornerRadius = GENERAL_SIZE(40);
    [createBtn addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:createBtn];

}

-(void)chooseImage{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSMediaTypePhoto;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.view];
}

// 上传图片成后后保存群信息
-(void)createGroup{
    titleString = [editTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (titleString.length<2||titleString.length>10) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"标题字数为2-10个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }

    [createBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    if (selectedImage) {
        [self uploadImage];
    }else{
        [self createGroup:@""];
    }
}

- (void)uploadImage
{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"保存中，请稍后..."]];
    
    UploadManager* um = [[UploadManager alloc]init];
    NSData* imageData = UIImageJPEGRepresentation(selectedImage, 0.8);
    [um uploadImageData:imageData angles:nil success:^{
        NSString *imageGid =  um.imageGid;
        [self createGroup:imageGid];
    } failure:^(NSError *error) {
        [createBtn setTitleColor:RGBCOLOR(01, 139, 232) forState:UIControlStateNormal];
    }];
}

-(void)createGroup:(NSString*)imgGid{
    AuthManager * am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        return;
    }
    GroupManager *gm = [[GroupManager alloc]init];
    [gm createGroupWithUserId:am.userInfo.userId Name:editTitle.text Avatar:imgGid Type:subjectType success:^(CommonResult *result) {
        if (result.code==10000) {
            if (_groupCreateBlock) {
                _groupCreateBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        
    }];
}

//查看协议
-(void)browseProcotol
{
    UserProcotolViewController *procotolVC = [[UserProcotolViewController alloc]init];
    [self.navigationController pushViewController:procotolVC animated:YES];
}

#pragma UITextView

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addGestureRecognizer:wholeTap];
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

#pragma mediaPicker delegate

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    if (mediaPicker.editMode == FSEditModeNone) {
        selectedImage = mediaInfo.originalImage;
    } else {
        selectedImage = mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage;
    }
    [avatarView setImage:selectedImage];
}

- (void)mediaPickerDidCancel:(FSMediaPicker *)mediaPicker{
}


/**
 *  隐藏键盘
 */
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:wholeTap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
