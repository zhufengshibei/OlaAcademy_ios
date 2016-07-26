//
//  PhotoCollectionViewCell.h
//  QYER
//
//  Created by Frank on 15/5/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  多选的图片Cell
 */
@interface PhotoCollectionViewCell : UICollectionViewCell

/**
 *  选中按钮
 */
@property (nonatomic, strong) UIButton *selectButton;

/**
 *  图片
 */
@property (nonatomic, strong) UIImageView *imageView;

@end
