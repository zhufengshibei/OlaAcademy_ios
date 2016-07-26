//
//  CXTapDetectingView.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 QYER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXTapDetectingViewDelegate;

@interface CXTapDetectingView : UIView

@property (nonatomic, weak) id <CXTapDetectingViewDelegate> tapDelegate;
- (void)handleSingleTap:(UITouch *)touch;
- (void)handleDoubleTap:(UITouch *)touch;
- (void)handleTripleTap:(UITouch *)touch;

@end

@protocol CXTapDetectingViewDelegate <NSObject>
@optional
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;
@end