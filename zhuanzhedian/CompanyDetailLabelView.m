//
//  CompanyDetailLabelView.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/8.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "CompanyDetailLabelView.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface CompanyDetailLabelView ()
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, assign)CGFloat labelSizeHeight;
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *detailStr;
@end
@implementation CompanyDetailLabelView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title detailStr:(NSString *)detailStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleStr = title;
        self.detailStr = detailStr;
        [self createSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)createSubViews
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 33)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    [self addSubview:lineView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 33)];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.titleLabel.text = self.titleStr;
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, [UIScreen mainScreen].bounds.size.width - 20, self.labelSizeHeight)];
    self.detailLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.detailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = self.detailStr;
    [self addSubview:self.detailLabel];
    
    
}
- (void)setDetailLabelSize:(CGFloat)sizeHeight
{
    self.detailLabel.frame = CGRectMake(10, 43, [UIScreen mainScreen].bounds.size.width - 20, sizeHeight);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sizeHeight + 20 + 33);
    
}
@end
