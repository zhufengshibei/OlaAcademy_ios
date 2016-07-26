//
//  PhotoManager.h
//  Frank
//
//  Created by Frank on 15/3/6.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoModel.h"
/**
 *  当前用户IM连接状态.
 */
typedef NS_ENUM(NSUInteger, PhotoManagerSourceType) {
    /**
     *  取消选择
     */
    PhotoManagerSourceTypeCancel = -1,
    /**
     *  从照片库选择
     */
    PhotoManagerSourceTypePhotoLibrary = 0,
    /**
     *  拍照
     */
    PhotoManagerSourceTypeCamera,
    /**
     *  其他
     */
    PhotoManagerSourceTypeOther
};

typedef void (^PhotoManagerBlock)(PhotoModel* photo, PhotoManagerSourceType type);
typedef void (^PhotoManagerMultipleBlock)(NSArray* photoModels, PhotoManagerSourceType type);


@interface PhotoManager : NSObject

/**
 *  ActionSheet标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  显示内容
 */
@property (nonatomic, strong) NSArray *texts;

@property (nonatomic, weak) UIViewController *delegate;


@property (nonatomic, assign) NSInteger type;//0 只是相册 1 打开相机 2进行选择

+ (PhotoManager *)shareManager;

/**
 *  显示获取图片的ActionSheet
 *
 *  @param block
 */
- (void)showPhotoView:(PhotoManagerBlock)block;

/**
 *  显示获取图片的ActionSheet
 *
 *  @param block
 *  @param title 标题
 *  @param texts 显示内容
 */
- (void)showPhotoView:(PhotoManagerBlock)block withTitle:(NSString*)title withTexts:(NSArray *)texts;

/**
 *  显示选择多张图片的视图控制器
 *
 *  @param block              完成的Block
 *  @param maxSelect          最大选择数量
 *  @param selectedPhotoNames 已经选中的图片名字
 */
- (void)showPhotoView:(PhotoManagerMultipleBlock)block withMaxSelect:(NSInteger)maxSelect  withSelectedPhotoNames:(NSArray *)selectedPhotoNames;

@end
