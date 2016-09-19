//
//  PDFView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/18.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseVideo.h"

@interface PDFView : UIView

-(void)loadPDF:(CourseVideo*)video;

@end
