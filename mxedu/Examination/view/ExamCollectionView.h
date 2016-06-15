//
//  ExamCollectionView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Examination.h"

@interface ExamCollectionView : UICollectionViewCell

-(void)setupViewWithModel:(Examination*) examination;

@end
