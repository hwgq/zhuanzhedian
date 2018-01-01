//
//  SelectAsBtnView.m
//  SelectBtnView
//
//  Created by Gaara on 16/6/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "SelectAsBtnView.h"

@interface SelectAsBtnView ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@end
@implementation SelectAsBtnView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = [UIColor colorWithRed:26 / 255.0 green:171 / 255.0 blue:125 / 255.0 alpha:1].CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = 1.f;
    
    border.lineCap = @"square";
    
    border.lineDashPattern = @[@4, @2];
    
    [self.layer addSublayer:border];
    
   
   
    self.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:171 / 255.0 blue:125 / 255.0 alpha:0.1];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width   / 4 + 40, 20, self.frame.size.width * 3 / 4  - 40 , 30)];
    self.titleLabel.textColor = [UIColor colorWithRed:26 / 255.0 green:171 / 255.0 blue:125 / 255.0 alpha:1];
//    self.titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.titleLabel];
    
    UIImageView *selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 4 , 25, 20, 20)];
    selectImg.image = [UIImage imageNamed:@"+.png"];
    [self addSubview:selectImg];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 30)];
    self.detailLabel.textColor = [UIColor lightGrayColor];
//    self.detailLabel.backgroundColor = [UIColor blueColor];
    self.detailLabel.textAlignment = 1;
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.detailLabel];
    
    
    
}
- (void)setText:(NSString *)title detail:(NSString *)detail key:(NSString *)key
{
    self.key = key;
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}
@end
