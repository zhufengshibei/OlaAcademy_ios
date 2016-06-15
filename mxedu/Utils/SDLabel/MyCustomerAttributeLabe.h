//
//  MyCustomerAttributeLabe.h
//  AllinmdProject
//
//  Created by ZhangTeng on 15/6/2.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomerAttributeLabe : UILabel



-(void)setText:(NSString *)text andlineSpace:(CGFloat)lineSpace;

-(void)setText:(NSString *)text andlineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace;

- (void)setAttText:(NSAttributedString *)attText lineSpace:(CGFloat)lineSpace numberSpace:(CGFloat)numberSpace;

@end
