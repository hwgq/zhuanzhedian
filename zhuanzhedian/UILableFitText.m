//
//  UILableFitText.m
//  zhuanzhedian
//
//  Created by Gaara on 16/2/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "UILableFitText.h"
#import <UIKit/UIKit.h>
@implementation UILableFitText
+ (CGSize)fitTextWithHeight:(CGFloat)height label:(UILabel *)label
{
    CGSize size = CGSizeMake(100000,height);
    CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelSize;
}

+ (CGSize)fitTextWithWidth:(CGFloat)width label:(UILabel *)label
{
    CGSize size = CGSizeMake(width, 100000);
    CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelSize;
}
+(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width string:(NSString *)string {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
@end
