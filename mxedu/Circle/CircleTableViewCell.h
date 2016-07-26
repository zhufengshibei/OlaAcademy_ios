//
//  WKOneViewCell.h
//  WKDemo
//
//  Created by wangzhaohui-Mac on 14-8-4.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleDetailView.h"

@class CircleFrame;

@interface CircleTableViewCell : UITableViewCell

@property (nonatomic,strong) CircleFrame *statusFrame;
/**cell内容控件*/
@property (nonatomic, weak) CircleDetailView *detailView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
