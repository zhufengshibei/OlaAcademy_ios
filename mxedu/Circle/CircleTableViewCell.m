//
//  WKOneViewCell.m
//  WKDemo
//
//  Created by wangzhaohui-Mac on 14-8-4.
//  Copyright (c) 2014年 com.app. All rights reserved.

#import "CircleTableViewCell.h"
#import "OlaCircle.h"
#import "CircleFrame.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SysCommon.h"

@interface CircleTableViewCell ()

@end

@implementation CircleTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CircleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
    {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            //self.backgroundColor = BACKGROUNDCOLOR;
            //取消显示选中时的阴影
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //1,添加cell内容控件
            CircleDetailView *detailView = [[CircleDetailView alloc] init];
            [self addSubview:detailView];
            self.detailView = detailView;
        }
        return self;
}

- (void)setStatusFrame:(CircleFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.detailView.statusFrame = statusFrame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = GENERAL_SIZE(16);
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height - y;
    self.detailView.frame = CGRectMake(x, y, w, h);
}
@end
