//
//  SearchResultCell.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/27.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Course.h"
#import "CourseVideo.h"
#import "ImageUtils.h"

@interface SearchResultCell : UITableViewCell

-(void)setupCellWithModel:(NSObject*) model;

@end
