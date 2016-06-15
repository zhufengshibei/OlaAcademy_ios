//
//  SDMyStrokeControl.m
//  NTreat
//
//  Created by 周冉 on 16/4/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "SDMyStrokeControl.h"

@implementation SDMyStrokeControl
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0.0];
    [[UIColor colorWithRed:219/255. green:219/255. blue:219/255. alpha:1.0] setStroke];
    [path stroke];
    
}

@end
