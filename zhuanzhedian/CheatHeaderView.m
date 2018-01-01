//
//  CheatHeaderView.m
//  CheatHeaderView
//
//  Created by Gaara on 15/11/17.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CheatHeaderView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AddColor.h"
#import "UILableFitText.h"

@interface CheatHeaderView ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *jobLabel;
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UILabel *eduLabel;
@property (nonatomic, strong)UILabel *jobNameLabel;
@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UIImageView *headImage;
@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UIImageView *cityImage;
@property (nonatomic, strong)UIImageView *eduImage;
@property (nonatomic, strong)UIImageView *yearImage;



@end
@implementation CheatHeaderView

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
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 23, 150, 22)];
    
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    self.titleLabel.textColor = [UIColor zzdColor];

    [self addSubview:self.titleLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.priceLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.priceLabel.textColor = [UIColor orangeColor];

    [self addSubview:self.priceLabel];
    
    self.jobLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.jobLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    self.jobLabel.textColor = [UIColor grayColor];

    [self addSubview:self.jobLabel];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectZero];

    self.cityLabel.textColor = [UIColor grayColor];
    
    self.cityLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];

    [self addSubview:self.cityLabel];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.yearLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    self.yearLabel.textColor = [UIColor grayColor];
    
    [self addSubview:self.yearLabel];

    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectZero];

    self.eduLabel.textColor = [UIColor grayColor];
    
    self.eduLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    [self addSubview:self.eduLabel];
    
    self.jobNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 85, 150, 18)];
;
    self.jobNameLabel.textColor = [UIColor grayColor];
    
    self.jobNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    [self addSubview:self.jobNameLabel];
    
    self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 104, 150, 18)];

    self.companyLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    self.companyLabel.textColor = [UIColor grayColor];
    
    [self addSubview:self.companyLabel];
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 65 , 15, 50, 50)];
    
    self.headImage.layer.masksToBounds = YES;
    
    self.headImage.layer.cornerRadius = 25;
    
    self.headImage.layer.borderWidth = 0.5;
    
    self.headImage.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self addSubview:self.headImage];
    
    self.cityImage = [[UIImageView alloc]initWithFrame:CGRectZero];

    self.cityImage.image = [UIImage imageNamed:@"ico-01.png"];
    
    [self addSubview:self.cityImage];
    
    self.yearImage = [[UIImageView alloc]initWithFrame:CGRectZero];

    self.yearImage.image = [UIImage imageNamed:@"ico-03.png"];
    
    [self addSubview:self.yearImage];
    
    self.eduImage = [[UIImageView alloc]initWithFrame:CGRectZero];

    self.eduImage.image = [UIImage imageNamed:@"ico-04.png"];
    [self addSubview:self.eduImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 65 , 73, 50, 15)];
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    self.nameLabel.textColor = [UIColor grayColor];
    
    self.nameLabel.textAlignment = 1;
    
    [self addSubview:self.nameLabel];
    
    
    
}

- (void)setLabelValue:(NSDictionary *)dic text:(NSString *)text name:(NSString *)name
{
    NSDictionary *valueDic = [NSDictionary dictionary];
    
    NSArray *keys = [dic allKeys];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    if (keys.count != 0) {
        
        valueDic = dic;
        
        self.titleLabel.text = [valueDic objectForKey:@"title"];
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[valueDic objectForKey:@"salary"]];
        
        self.jobLabel.text = [NSString stringWithFormat:@"%@ | %@",[valueDic objectForKey:@"category"],[valueDic objectForKey:@"sub_category"]];
        
        self.cityLabel.text = [valueDic objectForKey:@"city"];
        
        self.yearLabel.text = [valueDic objectForKey:@"work_year"];
        
        self.eduLabel.text = [valueDic objectForKey:@"education"];
        
        self.jobNameLabel.text = [NSString stringWithFormat:@"Boss职位 : %@",[[valueDic objectForKey:@"user"]objectForKey:@"title"]];
        
        self.companyLabel.text = [NSString stringWithFormat:@"公司 : %@",[[valueDic objectForKey:@"cp"]objectForKey:@"sub_name"]];
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[[valueDic objectForKey:@"user"]objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"head1200.png"]];
        
           }else{
               
               valueDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.titleLabel.text = [valueDic objectForKey:@"title"];
               
               self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[valueDic objectForKey:@"salary"]];
               
               self.jobLabel.text = [NSString stringWithFormat:@"%@",[valueDic objectForKey:@"category"]];
               
               self.cityLabel.text = [valueDic objectForKey:@"city"];
               
               self.yearLabel.text = [valueDic objectForKey:@"workYear"];
               
               self.eduLabel.text = [valueDic objectForKey:@"education"];
               
               self.jobNameLabel.text = [NSString stringWithFormat:@"Boss职位 : %@",[valueDic objectForKey:@"bossTitle"]];
              
               self.companyLabel.text = [NSString stringWithFormat:@"公司 : %@",[valueDic objectForKey:@"subCpName"]];
               
               [self.headImage sd_setImageWithURL:[NSURL URLWithString:[valueDic objectForKey:@"avatar"]]placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    }
    
    CGSize priceSize = [UILableFitText fitTextWithHeight:20 label:self.priceLabel];
    self.priceLabel.frame = CGRectMake(25, 46, priceSize.width, 18);
    
    CGSize jobSize = [UILableFitText fitTextWithHeight:20 label:self.jobLabel];
    self.jobLabel.frame = CGRectMake(45 + priceSize.width, 46, jobSize.width, 18);
    
    self.cityImage.frame = CGRectMake(25, 68, 15, 15);
    
    CGSize citySize = [UILableFitText fitTextWithHeight:18 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(43, 66, citySize.width, 18);
    
    self.yearImage.frame = CGRectMake(53 + citySize.width, 68, 15, 15);
    
    CGSize yearSize = [UILableFitText fitTextWithHeight:18 label:self.yearLabel];
    
    self.yearLabel.frame = CGRectMake(self.yearImage.frame.origin.x + 18, 66, yearSize.width, 18);
    
    self.eduImage.frame = CGRectMake(self.yearLabel.frame.origin.x + yearSize.width + 10, 68, 15, 15);
    
    CGSize eduSize = [UILableFitText fitTextWithHeight:18 label:self.eduLabel];
    
    self.eduLabel.frame = CGRectMake(self.eduImage.frame.origin.x + 18, 66, eduSize.width, 18);
    
    if (name.length > 0) {
        self.nameLabel.text = name;
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]){
        self.nameLabel.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"name"];
    }
    
    
}
@end
