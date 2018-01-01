//
//  BossCheatTitleView.m
//  DifferentCell
//
//  Created by Gaara on 16/7/18.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "BossCheatTitleView.h"
#import "UILableFitText.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "UIImageView+WebCache.h"
@interface BossCheatTitleView ()
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *userDetailLabel;
@property (nonatomic, strong)UILabel *userSummaryLabel;
@property (nonatomic, strong)UILabel *userSalaryLabel;

@property (nonatomic, strong)UILabel *userCityLabel;
@property (nonatomic, strong)UILabel *userYearLabel;
@property (nonatomic, strong)UILabel *userEduLabel;

@property (nonatomic, strong)UIImageView *cityImg;
@property (nonatomic, strong)UIImageView *yearImg;
@property (nonatomic, strong)UIImageView *eduImg;
@end
@implementation BossCheatTitleView
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
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 85)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#38AB99"];
    [self addSubview:lineView];
    self.backgroundColor = [UIColor colorFromHexCode:@"#ffffff"];
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 11, 64, 64)];
    //    self.headerImg.backgroundColor = [UIColor redColor];
    self.headerImg.layer.cornerRadius = 32;
    self.headerImg.layer.masksToBounds = YES;
    [self addSubview:self.headerImg];
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 17, 80, 18)];
    //    self.userNameLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.userNameLabel];
    self.userNameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    self.userNameLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    
    //    self.userDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 43, 200, 15)];
    ////    self.userDetailLabel.backgroundColor = [UIColor brownColor];
    //    self.userDetailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    //    self.userDetailLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    //    [self addSubview:self.userDetailLabel];
    
    
    
    //    self.userSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 95, 150, 30)];
    ////    self.userSummaryLabel.backgroundColor = [UIColor cyanColor];
    //    self.userSummaryLabel.font = [UIFont systemFontOfSize:14];
    //    self.userSummaryLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    //    [self addSubview:self.userSummaryLabel];
    
    self.userCityLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userCityLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userCityLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self addSubview:self.userCityLabel];
    
    self.userYearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userYearLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userYearLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self addSubview:self.userYearLabel];
    
    self.userEduLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userEduLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userEduLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self addSubview:self.userEduLabel];
    
    self.cityImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.cityImg.image = [UIImage imageNamed:@"Group 6 Copy 6.png"];
    [self addSubview:self.cityImg];
    
    self.yearImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.yearImg.image = [UIImage imageNamed:@"Group 4 Copy 5.png"];
    [self addSubview:self.yearImg];
    
    self.eduImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.eduImg.image = [UIImage imageNamed:@"Group 5 Copy 5.png"];
    [self addSubview:self.eduImg];
    
    
    
}
- (void)setValueFromDic:(NSDictionary *)dic
{
    if ([dic objectForKey:@"avatar"]) {
        
        [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"v2.png"]];
    }
    if ([dic objectForKey:@"bossTitle"]) {
        
        self.userNameLabel.text = [dic objectForKey:@"bossTitle"];
        CGSize userNameSize = [UILableFitText fitTextWithHeight:30 label:self.userNameLabel];
        self.userNameLabel.frame = CGRectMake(100, 17, userNameSize.width, 18);
    }
    
    
    
    if ([dic objectForKey:@"city"] && [dic objectForKey:@"workYear"] && [dic objectForKey:@"education"]) {
        self.yearImg.frame = CGRectMake(100, 48, 14, 14);
        
        self.userYearLabel.text = [dic objectForKey:@"workYear"];
        CGSize userYearSize = [UILableFitText fitTextWithHeight:18 label:self.userYearLabel];
        self.userYearLabel.frame = CGRectMake(121, 48, userYearSize.width, 18);
        
        self.eduImg.frame = CGRectMake(121 + userYearSize.width + 10, 48, 14, 14);
        self.userEduLabel.text = [dic objectForKey:@"education"];
        CGSize userEduSize = [UILableFitText fitTextWithHeight:18 label:self.userEduLabel];
        self.userEduLabel.frame = CGRectMake(121 + userYearSize.width + 21 + 10, 48, userEduSize.width, 18);
        
        self.cityImg.frame = CGRectMake(self.userEduLabel.frame.origin.x + userEduSize.width + 7, 49, 14, 14);
        self.userCityLabel.text = [dic objectForKey:@"city"];
        CGSize userCitySize = [UILableFitText fitTextWithHeight:18 label:self.userCityLabel];
        self.userCityLabel.frame = CGRectMake(self.cityImg.frame.origin.x + 21, 48, userCitySize.width, 18);
        
    }
    
    
}
@end
