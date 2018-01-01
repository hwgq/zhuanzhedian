//
//  WordEduDetailView.m
//  NewPeopleDetail
//
//  Created by Gaara on 16/7/13.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "WordEduDetailView.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface WordEduDetailView ()

@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *subTitleLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIImageView *point;
@property (nonatomic, strong)UIView *longLineView;
@end
@implementation WordEduDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews
{
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    self.lineView.backgroundColor = [UIColor zzdColor];
    [self addSubview:self.lineView];
    
    self.point = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 10, 10)];
    self.point.image = [UIImage imageNamed:@"point_boss.png"];
    [self addSubview:self.point];
    
    self.longLineView = [[UIView alloc]initWithFrame:CGRectMake(14, 55, 1, 130 - 55)];
    self.longLineView.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    [self addSubview:self.longLineView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:self.titleLabel];
    
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, [UIScreen mainScreen].bounds.size.width - 60, 25)];
    self.dateLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.dateLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.dateLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.dateLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, [UIScreen mainScreen].bounds.size.width - 60, 25)];
    self.subTitleLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.subTitleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.subTitleLabel.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.subTitleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 60, 25)];
    self.detailLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.detailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.detailLabel.backgroundColor = [UIColor brownColor];
    [self addSubview:self.detailLabel];
    
}
- (void)setValueWithDic:(NSDictionary *)dic title:(NSString *)title count:(NSInteger)count
{
    if (count == 0) {
        self.titleLabel.text = title;
    }else{
        UIView *longLineView = [[UIView alloc]initWithFrame:CGRectMake(14, 0, 2, 15)];
        longLineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:longLineView];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        self.point.frame = CGRectMake(10, 15, 10, 10);
        self.dateLabel.frame = CGRectMake(30, 10, [UIScreen mainScreen].bounds.size.width - 60, 25);
        self.subTitleLabel.frame = CGRectMake(30, 40, [UIScreen mainScreen].bounds.size.width - 60, 25);
        self.detailLabel.frame = CGRectMake(30, 70, [UIScreen mainScreen].bounds.size.width - 60, 25);
        self.longLineView.frame = CGRectMake(14, 25, 2, 100 - 25);
    }
    if ([title isEqualToString:@"工作经历"]) {
        NSString *dateStr = [NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"work_start_date"],[dic objectForKey:@"work_end_date"]];
        self.dateLabel.text = dateStr;
        self.subTitleLabel.text = [dic objectForKey:@"cp_name"];
        NSString *detailStr = [NSString stringWithFormat:@"%@·%@",[dic objectForKey:@"title"],[dic objectForKey:@"sub_category"]];
        self.detailLabel.text = detailStr;
        
    }else if([title isEqualToString:@"教育经历"]){
        NSString *dateStr = [NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"edu_start_date"],[dic objectForKey:@"edu_end_date"]];
        self.dateLabel.text = dateStr;
        self.subTitleLabel.text = [dic objectForKey:@"edu_school"];
        NSString *detailStr = [NSString stringWithFormat:@"%@·%@",[dic objectForKey:@"edu_experience"],[dic objectForKey:@"edu_major"]];
        self.detailLabel.text = detailStr;
    }
}
@end
