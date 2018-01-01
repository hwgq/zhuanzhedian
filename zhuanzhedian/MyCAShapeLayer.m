//
//  MyCAShapeLayer.m
//  zhuanzhedian
//
//  Created by Gaara on 16/2/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "MyCAShapeLayer.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@implementation MyCAShapeLayer



+ (CAShapeLayer *)createLayerWithXx:(CGFloat)xx xy:(CGFloat)xy yx:(CGFloat)yx yy:(CGFloat)yy
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:self.bounds];
//    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:4],
      [NSNumber numberWithInt:2],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, xx, xy);
    CGPathAddLineToPoint(path, NULL, yx,yy);
    
    // Setup the path
//    CGMutablePathRef path = CGPathCreateMutable();
//    // 0,10代表初始坐标的x，y
//    // 320,10代表初始坐标的x，y
//    CGPathMoveToPoint(path, NULL, 0, 10);
//    CGPathAddLineToPoint(path, NULL, 320,10);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    return shapeLayer;
}
@end
