//
//  MyCustomerAttributeLabe.m
//  AllinmdProject
//
//  Created by ZhangTeng on 15/6/2.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "MyCustomerAttributeLabe.h"

#import <CoreText/CoreText.h>

@implementation MyCustomerAttributeLabe

-(instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
        return self;
}

- (instancetype) init {
    self = [super init ];
    if (self) {
    }
    return self;
}

- (void)setText:(NSString *)text andlineSpace:(CGFloat)lineSpace{

    if (text) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle1 setLineSpacing:lineSpace];
        
        paragraphStyle1.lineBreakMode = NSLineBreakByTruncatingTail;
        
        paragraphStyle1.alignment = NSTextAlignmentJustified;
        
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        
        //字间距
        long number = 0.6;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
        CFRelease(num);
        
        [self setAttributedText:attributedString1];
    }
}

- (void)setAttText:(NSAttributedString *)attText lineSpace:(CGFloat)lineSpace numberSpace:(CGFloat)numberSpace
{
    if (attText)
    {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithAttributedString:attText];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:lineSpace];
        paragraphStyle1.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attText length])];
        
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&numberSpace);
        [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
        CFRelease(num);
        [self setAttributedText:attributedString1];
    }
}

-(void)setText:(NSString *)text {
    if (text && ![text isEqual:[NSNull null]]) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5.0];
        paragraphStyle1.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle1.alignment = NSTextAlignmentJustified;
        
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        
        //字间距
        long number = 0.6;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
        CFRelease(num);
        
        
        [self setAttributedText:attributedString1];
    }
    
}

-(void)setText:(NSString *)text andlineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace{
    if (text) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle1 setLineSpacing:lineSpace];
        
        paragraphStyle1.lineBreakMode = NSLineBreakByTruncatingTail;
        
        paragraphStyle1.alignment = NSTextAlignmentJustified;
        
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        
        long number = wordSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString1 length])];
        CFRelease(num);
        
        [self setAttributedText:attributedString1];
    }
}



-(void)setAttributedText:(NSAttributedString *)attributedText {
    
    [super setAttributedText:attributedText];
    
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
