//
//  WorkAndEduView.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/5.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "WorkAndEduView.h"
#import "MyCAShapeLayer.h"
#import "UILableFitText.h"
#import "UIColor+AddColor.h"
@interface WorkAndEduView ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *yearLabel;
@end
@implementation WorkAndEduView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.titleLabel.backgroundColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    self.titleLabel.textColor = [UIColor zzdColor];
    [self addSubview:self.titleLabel];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.nameLabel.backgroundColor = [UIColor orangeColor];
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    self.nameLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:self.nameLabel];
    
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.yearLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.yearLabel.textAlignment = 2;
//    self.yearLabel.backgroundColor = [UIColor greenColor];
    self.yearLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.yearLabel];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
//    lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
//    [self addSubview:lineView];
    
    CAShapeLayer *shapeLine = [MyCAShapeLayer createLayerWithXx:0 xy:0 yx:self.frame.size.width yy:0];
    [self.layer addSublayer:shapeLine];
}
- (void)changeViewValue:(NSDictionary *)dic titleValue:(NSInteger)title
{
    if (title == 1) {
        
        self.titleLabel.text = [dic objectForKey:@"cp_name"];
        
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"title"],[dic objectForKey:@"sub_category"]];

        
        
        self.yearLabel.text = [NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"work_start_date"],[dic objectForKey:@"work_end_date"]];
        
        
    }else if (title == 0){
        
        self.titleLabel.text = [dic objectForKey:@"edu_school"];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"edu_major"],[dic objectForKey:@"edu_experience"]];
        self.yearLabel.text = [NSString stringWithFormat:@"%@ - %@",[dic objectForKey:@"edu_start_date"],[dic objectForKey:@"edu_end_date"]];
        
    }
    CGSize titleSize = [UILableFitText fitTextWithHeight:20 label:self.titleLabel];
    self.titleLabel.frame = CGRectMake(10, 10, titleSize.width, 20);
    CGSize nameSize = [UILableFitText fitTextWithHeight:20 label:self.nameLabel];
    self.nameLabel.frame = CGRectMake(10, 35, nameSize.width, 20);
    CGSize yearSize = [UILableFitText fitTextWithHeight:20 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.frame.size.width - yearSize.width - 10, 10, yearSize.width, 20);


}
@end
