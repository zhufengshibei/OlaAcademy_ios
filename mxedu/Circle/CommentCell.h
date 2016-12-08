//
//  WKCommentCell.h
//  WKDemo
//
//  Created by apple on 14-8-10.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentFrame.h"

#import "CustomProgress.h"
#import "CommentFrame.h"

@class CommentCell;
@protocol CommentCellDelegate <NSObject>

//点击点赞按钮
-(void)didPraiseAction:(CommentCell *)seletedCell;

-(void)showMediaContent:(Comment*)comment;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic) Comment *comment;

@property (nonatomic,strong) CommentFrame * rdmanager;
@property (nonatomic,strong) Comment * sdModel;

@property (nonatomic,weak) id<CustomProgressDelegate> delegate;

- (void)setupCellWithFrame:(CommentFrame *)commentR;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,retain) id<CommentCellDelegate> cellDelegate;

@end
