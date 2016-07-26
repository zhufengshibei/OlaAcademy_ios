//
//  Message.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic) NSString *messageId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *otherId;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *time;

@end
