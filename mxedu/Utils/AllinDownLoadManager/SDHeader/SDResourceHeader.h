//
//  SDResourceHeader.h
//  NTreat
//
//  Created by 周冉 on 16/4/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>


//====================== 归档 / 解档=========================
#define OBJC_STRING(x) @#x
#define Decode(x) self.x = [aDecoder decodeObjectForKey:OBJC_STRING(x)]
#define Encode(x) [aCoder encodeObject:self.x forKey:OBJC_STRING(x)]
//==========================================================



#define kDocPath         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

#define kCachPath        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

#define kTmpPath          NSTemporaryDirectory()


// 视频路径
//======================================================
#define kVedioDataPath  @"/DownLoad"
#define kVedioTempPath  @"/DownLoad/Temp"
#define kVedioListPath  @"/DownLoad/VideoList"

// 图片路径
//======================================================
#define kImgDataPath    @"/Images"
#define kImgListPath    @"/Images/ImageList"



#define kShareVideoActionDataPath   @"/Actions/video"

@interface SDResourceHeader : NSObject

@end
