//
//  DownLoadingCell.h
//  NTreat
//
//  Created by 周冉 on 16/4/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDHeader.h"
#import "DownloadModal.h"
@protocol AllinMyLocalVideoCellDelegate;
@interface DownLoadingCell : UITableViewCell

@property (nonatomic,assign) SDMyLocalVideoCellTyp localVideoCellTyp;
@property (nonatomic,strong) DownloadModal *downloadModal;
@property (nonatomic,weak) id<AllinMyLocalVideoCellDelegate> delegate;
@property (nonatomic,assign) BOOL isSEditing;
@property (nonatomic,assign) BOOL isSelecting;

// 刷新
- (void)reloadSubview:(DownloadModal *)downloadModal;

// 按钮下载状态
- (void)setUpViewDownLoadStatus;

// 是否处于选中状态
- (void)setIsSelecting:(BOOL)isSelecting;

@end


@protocol AllinMyLocalVideoCellDelegate <NSObject>

- (void)showAlert;
@end