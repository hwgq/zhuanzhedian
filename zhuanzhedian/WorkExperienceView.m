//
//  WorkExperienceView.m
//  CompleteRS
//
//  Created by Gaara on 16/6/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "WorkExperienceView.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface WorkExperienceView ()
@property (nonatomic, strong)UILabel *workDateLabel;
@property (nonatomic, strong)UILabel *workTitleLabel;
@property (nonatomic, strong)UILabel *workDetailLabel;
@property (nonatomic, strong)UIImageView *point;
@property (nonatomic, strong)UIView *longLineView;
@property (nonatomic, strong)UIView *originView;
@end
@implementation WorkExperienceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor
//        ;
//        self.layer.borderWidth = 0.5;
    }
    return self;
}
- (void)createSubView
{
    
    
    self.originView = [[UIView alloc]initWithFrame:CGRectZero];
    self.originView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:self.originView];
    
    
    self.point = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 10)];
    self.point.image = [UIImage imageNamed:@"point_boss.png"];
    [self addSubview:self.point];
    
    self.longLineView = [[UIView alloc]initWithFrame:CGRectMake(14.5, 25, 1, 70)];
    self.longLineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:self.longLineView];
    
    self.workDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, self.frame.size.width - 40, 25)];
    self.workDateLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.workDateLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self addSubview:self.workDateLabel];
    
    self.workTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 35, self.frame.size.width - 40, 25)];
    self.workTitleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.workTitleLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self addSubview:self.workTitleLabel];
    
    self.workDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, self.frame.size.width - 40, 25)];
    self.workDetailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.workDetailLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self addSubview:self.workDetailLabel];
    
}
- (void)setLabelText:(NSString *)date title:(NSString *)title detail:(NSString *)detail count:(NSInteger)a
{
    if (a != 0) {
        self.originView.frame = CGRectMake(14, 0, 2, 15);
    }
    self.workDateLabel.text = date;
    self.workTitleLabel.text = title;
    self.workDetailLabel.text = detail;
}
@end
