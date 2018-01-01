//
//  NewZZDPeopleCell.m
//  NewZZDBossCell
//
//  Created by Gaara on 16/7/12.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "NewZZDPeopleCell.h"
#import "UIImageView+WebCache.h"
#import "UILableFitText.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface NewZZDPeopleCell ()
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *peopleDetailLabel;





@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UIImageView *cityImg;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UIImageView *yearImg;
@property (nonatomic, strong)UILabel *eduLabel;
@property (nonatomic, strong)UIImageView *eduImg;
@property (nonatomic, strong)UILabel *salaryLabel;
@property (nonatomic, strong)UIImageView *salaryImg;


@property (nonatomic, strong)UILabel *tapLabel;

@property (nonatomic, strong)UILabel *peopleSummaryLabel;
@property (nonatomic, strong)UILabel *otherLabel;
@end
@implementation NewZZDPeopleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
//        self.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)createSubViews
{
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
//    backView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
//    [self.contentView addSubview:backView];
    
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(21, 22, 64, 64)];
//    self.headerImg.backgroundColor = [UIColor yellowColor];
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 32;
    [self.contentView addSubview:self.headerImg];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 35, 100, 25)];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
//    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
//    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.titleLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 23, 32, 16)];
    self.tapLabel.text = @"求职";
    self.tapLabel.layer.borderWidth = 1;
    self.tapLabel.layer.borderColor = [UIColor colorFromHexCode:@"38ab99"].CGColor;
    self.tapLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
    self.tapLabel.textAlignment = 1;
    self.tapLabel.font = [UIFont systemFontOfSize:11];
    
    [self.contentView addSubview:self.tapLabel];
    
    
    self.peopleDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 150, 25)];
    self.peopleDetailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.peopleDetailLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
//    self.peopleDetailLabel.backgroundColor = [UIColor greenColor];
//    [self.contentView addSubview:self.peopleDetailLabel];
    
    self.cityImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.cityImg.image = [UIImage imageNamed:@"Group 9 Copy 2"];
    [self.contentView addSubview:self.cityImg];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.cityLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.cityLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.cityLabel];
    
    self.yearImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.yearImg.image = [UIImage imageNamed:@"Group 4 Copy 5"];
    [self.contentView addSubview:self.yearImg];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.yearLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.yearLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.yearLabel];
    
    self.eduImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.eduImg.image = [UIImage imageNamed:@"Group 5 Copy 5"];
    [self.contentView addSubview:self.eduImg];
    
    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.eduLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.eduLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.eduLabel];
    
    self.salaryImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.salaryImg.image = [UIImage imageNamed:@"Group 9 Copy 4"];
    [self.contentView addSubview:self.salaryImg];
    self.salaryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.salaryLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.salaryLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.salaryLabel];
    
    
    
    
    
    self.peopleSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 75, 150, 40)];
    self.peopleSummaryLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.peopleSummaryLabel.font =[[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.peopleSummaryLabel.numberOfLines = 1;
//    self.peopleSummaryLabel.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:self.peopleSummaryLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 124, [UIScreen mainScreen].bounds.size.width - 30, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#EEEEEE"];
    [self.contentView addSubview:lineView];
    
    self.otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 125, 150, 25)];
    self.otherLabel.textColor = [UIColor colorFromHexCode:@"#38ab99"];
    self.otherLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.otherLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.otherLabel];
}
- (void)setSubViewTextFromDic:(NSDictionary *)dic
{
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"user"]objectForKey:@"avatar"]]placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    
    self.titleLabel.text = [[dic objectForKey:@"user"]objectForKey:@"name"];
    CGSize titleSize = [UILableFitText fitTextWithHeight:25 label:self.titleLabel];
    self.titleLabel.frame = CGRectMake(96, 22, titleSize.width, 20);
    
//    NSString *peopleDetailStr = [NSString stringWithFormat:@"%@  %@  %@  %@",[dic objectForKey:@"city"],[dic objectForKey:@"work_year"],[[dic objectForKey:@"user"]objectForKey:@"highest_edu"],[dic objectForKey:@"salary"]];
//    self.peopleDetailLabel.text = peopleDetailStr;
//    CGSize peopleDetailSize = [UILableFitText fitTextWithHeight:25 label:self.peopleDetailLabel];
//    self.peopleDetailLabel.frame = CGRectMake(96, 50, peopleDetailSize.width, 18);
    
    self.cityImg.frame = CGRectMake(94, 53, 13, 13);
    
    self.cityLabel.text = [dic objectForKey:@"city"];
    CGSize citySize = [UILableFitText fitTextWithHeight:20 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(106, 50, citySize.width, 20);
    
    self.yearImg.frame = CGRectMake(106 + citySize.width + 8, 53, 13, 13);
    self.yearLabel.text = [dic objectForKey:@"work_year"];
    CGSize yearSize = [UILableFitText fitTextWithHeight:20 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.yearImg.frame.origin.x + 15, 50, yearSize.width, 20);
    
    self.eduImg.frame = CGRectMake(self.yearLabel.frame.origin.x + yearSize.width + 8, 54, 13, 12);
    self.eduLabel.text = [[dic objectForKey:@"user"]objectForKey:@"highest_edu"];
    CGSize eduSize = [UILableFitText fitTextWithHeight:20 label:self.eduLabel];
    self.eduLabel.frame = CGRectMake(self.eduImg.frame.origin.x + 15, 50, eduSize.width, 20);
    
    self.salaryImg.frame = CGRectMake(self.eduLabel.frame.origin.x + eduSize.width + 8, 52, 16, 16);
    self.salaryLabel.text = [dic objectForKey:@"salary"];
    CGSize salarySize = [UILableFitText fitTextWithHeight:20 label:self.salaryLabel];
    self.salaryLabel.frame = CGRectMake(self.salaryImg.frame.origin.x + 17, 50, salarySize.width, 20);
    
    
    self.peopleSummaryLabel.text = [dic objectForKey:@"self_summary"];
//    CGSize peopleSummarySize = [UILableFitText fitTextWithWidth:[UIScreen mainScreen].bounds.size.width - 120 label:self.peopleSummaryLabel];
    self.peopleSummaryLabel.frame = CGRectMake(96, 75, [UIScreen mainScreen].bounds.size.width - 120, 18);
    
    NSString *titleStr = [dic objectForKey:@"title"];
    
  
    self.otherLabel.text = titleStr;
    CGSize otherSize = [UILableFitText fitTextWithHeight:25 label:self.otherLabel];
    self.otherLabel.frame = CGRectMake(96 + 8 + titleSize.width, 22, otherSize.width, 20);
    
    self.tapLabel.frame = CGRectMake(96 + 8 + titleSize.width + otherSize.width + 5, 24  , 32, 16);
    
}
@end
