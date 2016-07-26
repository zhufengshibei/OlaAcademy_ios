//
//  QYViewController+PhotoPicker.h
//  QYER
//
//  Created by Frank on 15/5/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

typedef void (^PhotoPickerToggleBlock)(ALAsset *asset, BOOL select);
typedef void (^PhotoPickerGroupBlock)(NSArray *assets);

@class AlbumListController;
@interface UIViewController (PhotoPicker)

/**
 *  弹出相册
 *
 *  @param viewControllerToPresent 相册视图控制器
 *  @param animated                是否需要动画
 *  @param completion              弹出完成的Block
 *  @param toggleBlock             选中/取消选中的Block
 *  @param cancelBlock             取消的Block
 *  @param finishBlock             完成的Block
 */
- (void)presentPhotoPickerController:(UIViewController *)viewControllerToPresent
                            animated:(BOOL)animated
                          completion:(void (^)(void))completion
                              toggle:(PhotoPickerToggleBlock)toggleBlock
                              cancel:(PhotoPickerGroupBlock)cancelBlock
                              finish:(PhotoPickerGroupBlock)finishBlock;

@end
