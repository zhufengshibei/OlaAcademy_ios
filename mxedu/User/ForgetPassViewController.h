//
//  xiugaimimaViewController.h
//  Lvlicheng
//
//  Created by LZQ on 14-6-20.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPassViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) NSString * phoneNumber;
@property (nonatomic) BOOL isFromIndex;

@end
