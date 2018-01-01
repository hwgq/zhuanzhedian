//
//  UITextView+PrintField.m
//  zhuanzhedian
//
//  Created by Gaara on 16/2/19.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "UITextView+PrintField.h"

@implementation UITextView_PrintField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (CGSize)sizeThatFits:(CGSize)size
{
    
    CGRect labelRect = [self.attributedText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 49 * 3 + 10, 100000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    
    
//    CGRect labelRect = [self.attributedText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 49 * 3 + 10, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    //    NSLog(@"%lf---%lf",labelRect.size.width,labelRect.size.height);
    
    if (labelRect.size.height < 29) {
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 49 * 3 + 10, 29);
    }else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 49 * 3 + 10, labelRect.size.height + 5);
    }
}
@end
