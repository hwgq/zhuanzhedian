//
//  CircleLayer.m
//  Alert
//
//  Created by Gaara on 16/6/20.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "CircleLayer.h"
#import "UIColor+AddColor.h"
@interface CircleLayer ()
@property (nonatomic, strong)CAShapeLayer *arcLayer;
@end
@implementation CircleLayer
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self intiUIOfView];
    }
    return self;
}
-(void)intiUIOfView
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=self.frame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2 - 3,rect.size.height/2 - 3) radius:16 startAngle:0 endAngle:2*M_PI clockwise:NO];
    self.arcLayer=[CAShapeLayer layer];
    self.arcLayer.path=path.CGPath;//46,169,230
    self.arcLayer.fillColor=[UIColor clearColor].CGColor;
    self.arcLayer.strokeColor=[UIColor zzdColor].CGColor;
    self.arcLayer.lineWidth = 1;
    self.arcLayer.frame=self.frame;
    [self.layer addSublayer:self.arcLayer];
    [self drawLineAnimation:self.arcLayer];
}
//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=0.5;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
   
    
}
@end
