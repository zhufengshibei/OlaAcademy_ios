//
//  CommentFrame.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Comment.h"

@interface CommentFrame : NSObject

/**头像frame*/
@property (nonatomic, assign) CGRect iconFrame;
/**昵称frame*/
@property (nonatomic, assign) CGRect nameFrame;
/**视频／音频frame*/
@property (nonatomic, assign) CGRect mediaFrame;
/**正文frame*/
@property (nonatomic, assign) CGRect textFrame;
/**图片frame*/
@property (nonatomic, assign) CGRect imageFrame;

/**自定义cell的高度*/
@property (nonatomic,assign) CGFloat cellHeight;

/**模型数据*/
@property (nonatomic,strong) Comment *comment;

@end
