//
//  NewZZDBossCell.m
//  NewZZDBossCell
//
//  Created by Gaara on 16/7/11.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "NewZZDBossCell.h"
#import "UIImageView+WebCache.h"
#import "UILableFitText.h"
#import "UIColor+AddColor.h"
#import <MAMapKit/MAMapKit.h>
#import "FontTool.h"
@interface NewZZDBossCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subTitleLabel;
@property (nonatomic, strong)UILabel *salaryLabel;
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *bossDetailLabel;
@property (nonatomic, strong)UILabel *compamyDetailLabel;
@property (nonatomic, strong)UILabel *distanceLabel;

@property (nonatomic, strong)UIImageView *cityImg;
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UIImageView *yearImg;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UIImageView *eduImg;
@property (nonatomic, strong)UILabel *eduLabel;
@property (nonatomic, strong)UILabel *tapLabel;
@property (nonatomic, strong)UIImageView *stateImg;
@end
@implementation NewZZDBossCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createFrame];
    }
    return self;
}
- (void)createFrame
{
  
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(96, 21, 100, 20)];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.titleLabel.font = [UIFont systemFontOfSize:18];
//    self.titleLabel.font = [arr objectAtIndex:2];
//    self.titleLabel.backgroundColor = [UIColor purpleColor];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2B2B2B"];
    [self.contentView addSubview:self.titleLabel];
    
    self.tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 23, 16, 16)];
    self.tapLabel.text = @"聘";
    self.tapLabel.layer.borderWidth = 1;
    self.tapLabel.layer.borderColor = [UIColor colorFromHexCode:@"38ab99"].CGColor;
    self.tapLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
    self.tapLabel.textAlignment = 1;
    self.tapLabel.font = [UIFont systemFontOfSize:11];
    
    [self.contentView addSubview:self.tapLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(96, 49, 100, 20)];
    self.subTitleLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    self.subTitleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.subTitleLabel.backgroundColor = [UIColor greenColor];
//    [self.contentView addSubview:self.subTitleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 124, [UIScreen mainScreen].bounds.size.width - 30, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.contentView addSubview:lineView];
    
    
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(22, 31, 64, 64)];
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 32;
//    self.headerImg.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.headerImg];
    
    self.stateImg = [[UIImageView alloc]initWithFrame:CGRectMake(27, 87, 54, 15)];
    self.stateImg.image = [UIImage imageNamed:@"vipvip.png"];
    [self.contentView addSubview:self.stateImg];
    
    self.bossDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 110, 180, 20)];
    self.bossDetailLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    self.bossDetailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.bossDetailLabel.backgroundColor = [UIColor yellowColor];
    self.bossDetailLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    [self.contentView addSubview:self.bossDetailLabel];
    
    self.compamyDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 130, 180, 20)];
    self.compamyDetailLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    self.compamyDetailLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    self.compamyDetailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.compamyDetailLabel.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:self.compamyDetailLabel];

    
    self.salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 21, 60, 20)];
    self.salaryLabel.textColor = [UIColor colorFromHexCode:@"FF5908"];
    self.salaryLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.salaryLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.salaryLabel];
    
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 60, 85, 15)];
    self.distanceLabel.textAlignment = 1;
    self.distanceLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    self.distanceLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
    [self.contentView addSubview:self.distanceLabel];
    
    self.cityImg = [[UIImageView alloc]initWithFrame:CGRectMake(96, 49, 15, 14)];
    self.cityImg.image = [UIImage imageNamed:@"Group 6 Copy 6.png"];
    [self.contentView addSubview:self.cityImg];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(116, 49, 20, 15)];
    self.cityLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    self.cityLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.cityLabel];
    
    self.yearImg = [[UIImageView alloc]initWithFrame:CGRectMake(130, 49, 15, 15)];
    self.yearImg.image = [UIImage imageNamed:@"Group 4 Copy 5.png"];
    [self.contentView addSubview:self.yearImg];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 49, 20, 15)];
    self.yearLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    self.yearLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.yearLabel];
    
    self.eduImg = [[UIImageView alloc]initWithFrame:CGRectMake(180, 49, 15, 15)];
    self.eduImg.image = [UIImage imageNamed:@"Group 5 Copy 5.png"];
    [self.contentView addSubview:self.eduImg];
    
    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 49, 15, 15)];
    self.eduLabel.textColor = [UIColor colorFromHexCode:@"#B0B0B0"];
    self.eduLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.eduLabel];
    
    
}
- (void)setSubViewTextFromDic:(NSDictionary *)dic
{
    if (![[dic objectForKey:@"is_mq"]isEqualToString:@"1"]) {
        self.stateImg.hidden = YES;
    }else
    {
        self.stateImg.hidden = NO;
    }
    self.titleLabel.text = [dic objectForKey:@"title"];
    CGSize titleSize = [UILableFitText fitTextWithHeight:25 label:self.titleLabel];
    self.titleLabel.frame = CGRectMake(96, 21, titleSize.width, 23);
    
    self.tapLabel.frame = CGRectMake(96 + titleSize.width + 5, 23, 16, 16);
//    NSString *subTitleStr = [NSString stringWithFormat:@"%@ | %@ | %@",[dic objectForKey:@"city"],[dic objectForKey:@"work_year"],[dic objectForKey:@"education"]];
//    self.subTitleLabel.text = subTitleStr;
//    CGSize subTitleSize = [UILableFitText fitTextWithHeight:25 label:self.subTitleLabel];
//    self.subTitleLabel.frame = CGRectMake(96, 49, subTitleSize.width, 20);
    
    self.cityLabel.text = [dic objectForKey:@"city"];
    CGSize citySize = [UILableFitText fitTextWithHeight:15 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(113, 49, citySize.width, 15);
    
    self.yearImg.frame = CGRectMake(124 + citySize.width, 49, 15, 14);
    
    self.yearLabel.text = [dic objectForKey:@"work_year"];
    CGSize yearSize = [UILableFitText fitTextWithHeight:15 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.yearImg.frame.origin.x + 17, 49, yearSize.width, 15);
    
    self.eduImg.frame = CGRectMake(self.yearLabel.frame.origin.x + 13 + yearSize.width, 49, 15, 13);
    self.eduLabel.text = [dic objectForKey:@"education"];
    CGSize eduSize = [UILableFitText fitTextWithHeight:15 label:self.eduLabel];
    self.eduLabel.frame = CGRectMake(self.eduImg.frame.origin.x + 17, 49, eduSize.width, 15);
    
    
    
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"user"]objectForKey:@"avatar"]]placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    
    NSString *bossDetailStr = [NSString stringWithFormat:@"%@ | %@ | %@",[[dic objectForKey:@"user"]objectForKey:@"name"],[[dic objectForKey:@"cp"]objectForKey:@"sub_name"],[[dic objectForKey:@"user"]objectForKey:@"title"]];
    self.bossDetailLabel.text = bossDetailStr;
    CGSize bossDetailSize = [UILableFitText fitTextWithHeight:20 label:self.bossDetailLabel];
    self.bossDetailLabel.frame = CGRectMake(96, 71, bossDetailSize.width, 20);
    
    
    
    
    NSString *companyDetailStr = [NSString stringWithFormat:@"%@ : %@",@"公司规模",[[dic objectForKey:@"cp"]objectForKey:@"size"]];
    self.compamyDetailLabel.text = companyDetailStr;
    CGSize companyDetailSize = [UILableFitText fitTextWithHeight:20 label:self.compamyDetailLabel];
    self.compamyDetailLabel.frame = CGRectMake(96, 93, companyDetailSize.width, 20);
    
    
    self.salaryLabel.text = [dic objectForKey:@"salary"];
    CGSize salarySize = [UILableFitText fitTextWithHeight:25 label:self.salaryLabel];
    self.salaryLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - salarySize.width - 31, 24, salarySize.width, 22);
    
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lat"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"] && [[dic objectForKey:@"cp"]objectForKey:@"lat"] && [[dic objectForKey:@"cp"]objectForKey:@"lon"]) {
        if (([[[dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue] != 0) && ([[[dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue] != 0)) {
            
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"]doubleValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"lon"]doubleValue]));
            
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue],[[[dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue]));
            
            
            
            //2.计算距离
            
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            self.distanceLabel.text = [NSString stringWithFormat:@"距离%.2fkm",distance / 1000.0];
            CGSize distanceSize = [UILableFitText fitTextWithHeight:25 label:self.distanceLabel];
            self.distanceLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - distanceSize.width - 31, 93, distanceSize.width + 10, 20);
            
        }else{
                        self.distanceLabel.text = @"";
        }
    }else{
        
        self.distanceLabel.text = @"";
        
    }
}

@end
