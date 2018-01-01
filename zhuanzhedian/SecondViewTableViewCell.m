//
//  SecondViewTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/3.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "SecondViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AddColor.h"
#import "UILableFitText.h"
#import "MyCAShapeLayer.h"
@interface SecondViewTableViewCell ()
@property (nonatomic, strong)UIView *view;

//up
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UILabel *eduLabel;
@property (nonatomic, strong)UILabel *priceLabel;

//down
@property (nonatomic, strong)UIImageView *userHeadImage;
@property (nonatomic, strong)UILabel *userInforLabel;
@property (nonatomic, strong)UILabel *peoNumLabel;

@property (nonatomic, strong)UIImageView *cityImage;
@property (nonatomic, strong)UIImageView *yearImage;
@property (nonatomic, strong)UIImageView *eduImage;
@end
@implementation SecondViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        [self createUpView];
        [self createDownView];
        [self createImage];
    }
    return self;
}

- (void)createView
{
    self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
 
    self.view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 165)];
    
    self.view.layer.cornerRadius = 7;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.view];

    CAShapeLayer *lineView = [MyCAShapeLayer createLayerWithXx:10 xy:65 yx:self.view.frame.size.width - 10 yy:65];
    
    [self.view.layer addSublayer:lineView];
    
    
    CAShapeLayer *lineViewTwo = [MyCAShapeLayer createLayerWithXx:10 xy:140 yx:self.view.frame.size.width - 10 yy:140];
    
    [self.view.layer addSublayer:lineViewTwo];
    
}
- (void)createUpView
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16];
    
//    self.titleLabel.backgroundColor = [UIColor blackColor];
    
    self.titleLabel.textColor = [UIColor zzdColor];
    
    [self.view addSubview:self.titleLabel];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectZero];

    self.cityLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    
//    self.cityLabel.backgroundColor = [UIColor blackColor];
    
    self.cityLabel.textAlignment = 0;
    
    self.cityLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:self.cityLabel];
    
    self.yearLabel  = [[UILabel alloc]initWithFrame:CGRectZero];

    self.yearLabel.textAlignment = 1;
    
//    self.yearLabel.backgroundColor = [UIColor cyanColor];
    
    self.yearLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    
    self.yearLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:self.yearLabel];
    
    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.eduLabel.textAlignment = 1;
    
    self.eduLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    
    self.eduLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:self.eduLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.priceLabel.textAlignment = 1;

//    self.priceLabel.backgroundColor = [UIColor greenColor];
    
    self.priceLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    
    self.priceLabel.textColor = [UIColor orangeColor];
    
    [self.view addSubview:self.priceLabel];
    
}
- (void)createImage
{
    self.cityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
//    self.cityImage.backgroundColor = [UIColor redColor];
    
    self.cityImage.image = [UIImage imageNamed:@"ico-01.png"];

    [self.view addSubview:self.cityImage];
    
    self.yearImage = [[UIImageView alloc]initWithFrame:CGRectZero];

//    self.yearImage.backgroundColor = [UIColor blueColor];
    
    self.yearImage.image = [UIImage imageNamed:@"ico-03.png"];
    
    [self.view addSubview:self.yearImage];
    
    self.eduImage = [[UIImageView alloc]initWithFrame:CGRectZero];

//    self.eduImage.backgroundColor = [UIColor yellowColor];
    
    self.eduImage.image = [UIImage imageNamed:@"ico-04.png"];
    
    [self.view addSubview:self.eduImage];
    
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    dateLabel.text = @"最近回复: 今日";
    dateLabel.textAlignment = 2;
    CGSize dateSize = [UILableFitText fitTextWithHeight:20 label:dateLabel];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.frame = CGRectMake(self.view.frame.size.width - dateSize.width  - 10, 142, dateSize.width, 20);
    dateLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12];
    [self.view addSubview:dateLabel];
}

- (void)createDownView
{
    self.userHeadImage = [[UIImageView alloc]initWithFrame:CGRectZero];

    self.userHeadImage.layer.masksToBounds = YES;
    
    self.userHeadImage.layer.cornerRadius = 55 / 2;
    
    [self.view addSubview:self.userHeadImage];
    
    self.userInforLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.userInforLabel.textColor = [UIColor grayColor];
    
    self.userInforLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
//    self.userInforLabel.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:self.userInforLabel];
    
    self.peoNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.peoNumLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
//    self.peoNumLabel.backgroundColor = [UIColor cyanColor]; 
    
    self.peoNumLabel.textColor = [UIColor grayColor];

    [self.view addSubview:self.peoNumLabel];
}
- (void)getValueFromDic:(NSDictionary *)dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
    CGSize titleSize = [UILableFitText fitTextWithHeight:30 label:self.titleLabel];
    self.titleLabel.frame = CGRectMake(10,  6, titleSize.width, 30);
    
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[dic objectForKey:@"salary"]];
    CGSize priceSize = [UILableFitText fitTextWithHeight:20 label:self.priceLabel];
    self.priceLabel.frame = CGRectMake(10, 36, priceSize.width, 25);
    
    
    
    self.cityImage.frame = CGRectMake(25 + priceSize.width, 41, 14, 14);
    
    self.cityLabel.text = [dic objectForKey:@"city"];
    CGSize citySize = [UILableFitText fitTextWithHeight:20 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(self.cityImage.frame.origin.x + 18, 36, citySize.width, 25);
    
    self.yearImage.frame = CGRectMake(self.cityLabel.frame.origin.x + citySize.width + 16, 42, 13, 13);
    
    
    self.yearLabel.text = [dic objectForKey:@"work_year"];
    
    CGSize yearSize = [UILableFitText fitTextWithHeight:20 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.yearImage.frame.origin.x + 18, 36, yearSize.width, 25);
    
    
    
    self.eduImage.frame = CGRectMake(self.yearLabel.frame.origin.x + yearSize.width + 16, 42, 14, 14);
    
    
    self.eduLabel.text = [dic objectForKey:@"education"];
    CGSize eduSize = [UILableFitText fitTextWithHeight:20 label:self.eduLabel];
    self.eduLabel.frame = CGRectMake(self.eduImage.frame.origin.x + 20, 36, eduSize.width, 25);
    
    
    
    
    self.peoNumLabel.text = [NSString stringWithFormat:@"公司规模 %@",[[dic objectForKey:@"cp"]objectForKey:@"size"]];
    CGSize peoNumSize = [UILableFitText fitTextWithHeight:20 label:self.peoNumLabel];
    self.peoNumLabel.frame = CGRectMake(80, 104, peoNumSize.width, 20);
    
    
    
    [self.userHeadImage sd_setImageWithURL:[[dic objectForKey:@"user"]objectForKey:@"avatar"]];
    self.userHeadImage.frame = CGRectMake(10, 75, 55, 55);
    
    
    self.userInforLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[[dic objectForKey:@"user"]objectForKey:@"name"],[[dic objectForKey:@"cp"]objectForKey:@"sub_name"],[[dic objectForKey:@"user"]objectForKey:@"title"]];
    
    CGSize userInforSize = [UILableFitText fitTextWithHeight:20 label:self.userInforLabel];
    self.userInforLabel.frame = CGRectMake(80, 81, userInforSize.width, 20);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
