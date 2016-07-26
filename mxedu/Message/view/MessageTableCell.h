//
//  MessageTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"

@interface MessageTableCell : UITableViewCell

-(void)setupCell:(Message*)message;

@end
