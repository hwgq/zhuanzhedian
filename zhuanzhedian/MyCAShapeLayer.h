//
//  MyCAShapeLayer.h
//  zhuanzhedian
//
//  Created by Gaara on 16/2/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface MyCAShapeLayer : NSObject
+ (CAShapeLayer *)createLayerWithXx:(CGFloat)xx xy:(CGFloat)xy yx:(CGFloat)yx yy:(CGFloat)yy;
@end
