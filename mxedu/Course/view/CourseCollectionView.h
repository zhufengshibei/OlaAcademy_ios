//
//  CourseCollectionView.h
//  mxedu
//
//  Created by 田晓鹏 on 15/11/4.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCollectionView : UICollectionViewCell

//自定义的控件属性
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UILabel *visitLabel;

@end
