//
//  UILableFitText.h
//  zhuanzhedian
//
//  Created by Gaara on 16/2/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UILableFitText : NSObject
+ (CGSize)fitTextWithHeight:(CGFloat)height label:(UILabel *)label;
+ (CGSize)fitTextWithWidth:(CGFloat)width label:(UILabel *)label;
+(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width string:(NSString *)string;
@end
