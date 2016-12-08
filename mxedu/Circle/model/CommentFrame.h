//
//  CommentFrame.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Comment;
@class CustomProgress;
typedef enum
{
    Playing = 0,
    Paused = 1,
    Stop = 2
    
}PlayState;

@interface CommentFrame : NSObject

/**头像frame*/
@property (nonatomic, assign) CGRect iconFrame;
/**昵称frame*/
@property (nonatomic, assign) CGRect nameFrame;
/**音频frame*/
@property (nonatomic, assign) CGRect audioFrame;
/**视频frame*/
@property (nonatomic, assign) CGRect mediaFrame;
/**正文frame*/
@property (nonatomic, assign) CGRect textFrame;
/**图片frame*/
@property (nonatomic, assign) CGRect imageFrame;

/**自定义cell的高度*/
@property (nonatomic,assign) CGFloat cellHeight;

/**模型数据*/
@property (nonatomic,strong) Comment *comment;

// 音频播放相关
@property (nonatomic,copy) NSString * urlString;
@property (nonatomic,assign) PlayState playstate;
@property (nonatomic,strong) CustomProgress * custoprogress;

@end
