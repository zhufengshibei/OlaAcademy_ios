//
//  AlbumListController.h
//  QYER
//
//  Created by Frank on 15/5/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYViewController+PhotoPicker.h"

/**
 *  相册列表的控制器
 */
@interface AlbumListController : UIViewController

/**
 *  最多允许选择多少张图片
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfImages;

/**
 *  已经选中图片的名字
 */
@property (nonatomic, strong) NSArray *selectedPhotoNames;

/**
 *  选中/取消选中的block
 */
@property (nonatomic, copy) PhotoPickerToggleBlock toggleBlock;

/**
 *  取消调用的block
 */
@property (nonatomic, copy) PhotoPickerGroupBlock cancelBlock;

/**
 *  确认调用的block
 */
@property (nonatomic, copy) PhotoPickerGroupBlock finishBlock;

@end
