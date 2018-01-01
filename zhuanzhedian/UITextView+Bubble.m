//
//  UITextView+Bubble.m
//  zhuanzhedian
//
//  Created by Gaara on 16/2/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "UITextView+Bubble.h"

@implementation UITextView_Bubble

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (CGSize)sizeThatFits:(CGSize)size
{
    
    CGRect labelRect = [self.text boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 10) / 2.0, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    //    NSLog(@"%lf---%lf",labelRect.size.width,labelRect.size.height);
    return CGSizeMake(labelRect.size.width, labelRect.size.height);
}
@end
