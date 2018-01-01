//
//  MainViewTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/28.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MainViewTableViewCell.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
#import "MyCAShapeLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "UILableFitText.h"
@interface MainViewTableViewCell ()

@property (nonatomic, strong)UIView *view;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *salaryLabel;
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic,strong)UIImageView * sexImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *assessLabel;

@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UILabel *eduLabel;

@property (nonatomic, strong)UILabel *askJobLabel;


@property (nonatomic, strong)UIImageView *eduImage;
@property (nonatomic, strong)UIImageView *yearImage;
@property (nonatomic, strong)UIImageView *cityImage;



@property (nonatomic, strong)UIVisualEffectView *effectView;
@end
@implementation MainViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMainViewInCell];
        [self createLineView];
        [self createLabels];
        [self createHeader];
        [self createImages];
        
    }
    return self;
}

- (void)createMainViewInCell
{
    self.contentView.backgroundColor = [UIColor colorFromHexCode:@"#f4f3f3"];
    
    self.view = [[UIView alloc]initWithFrame:CGRectMake( 10, 10, [UIScreen mainScreen].bounds.size.width - 20, 165)];
    
//    self.view.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    
//    self.view.layer.borderWidth = 0.5;
//    
    self.view.layer.cornerRadius = 7;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.view];
}

- (void)createLineView
{
    CAShapeLayer *line = [MyCAShapeLayer createLayerWithXx:10 xy:40 yx:[UIScreen mainScreen].bounds.size.width - 30 yy:40];
    

    
    [self.view.layer addSublayer:line];
    
    CAShapeLayer *lineTwo = [MyCAShapeLayer createLayerWithXx:10 xy:132 yx:[UIScreen mainScreen].bounds.size.width - 30 yy:132];
    
    
    [self.view.layer addSublayer:lineTwo];
}

- (void)createHeader
{
    self.headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 55, 55)];
    
    self.headerImage.layer.cornerRadius = self.headerImage.frame.size.width / 2;
    
    self.headerImage.layer.masksToBounds = YES;
    
    [self.view addSubview:self.headerImage];
    
    self.sexImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.sexImage.layer.cornerRadius = self.sexImage.frame.size.width/2;
    self.sexImage.layer.masksToBounds = YES;
    [self .view addSubview:self.sexImage];
}
- (void)createLabels
{
    // 上窜10, 高度增加20
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 55, self.view.frame.size.width - 100 , 25)];
    
    self.titleLabel.textColor = [UIColor darkGrayColor];
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    [self.view addSubview:self.titleLabel];
    
    self.salaryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.salaryLabel.textColor = [UIColor darkGrayColor];
    
    self.salaryLabel.textAlignment = 2;
    
    self.salaryLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
//    self.salaryLabel.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.salaryLabel];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.nameLabel.backgroundColor = [UIColor greenColor];
    self.nameLabel.textColor = [UIColor hcColor];
    
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];

    [self.view addSubview:self.nameLabel];
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    
    
    [self.view addSubview:self.effectView];
    
    
    
    // 下窜10
    self.assessLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 138, self.view.frame.size.width - 50, 22)];
    
    self.assessLabel.textColor = [UIColor darkGrayColor];
    
    self.assessLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    UIImageView *assessImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 141, 18, 15)];
    assessImage.image = [UIImage imageNamed:@"advantage.png"];
    [self.view addSubview:assessImage];
    
    
    
    [self.view addSubview:self.assessLabel];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.cityLabel.textColor = [UIColor colorWithWhite:0.439 alpha:1.000];
    
    self.cityLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
//    self.cityLabel.backgroundColor = [UIColor greenColor];
    
    self.cityLabel.textAlignment = 1;
    
    [self.view addSubview:self.cityLabel];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    self.yearLabel.textAlignment = 1;
    
    self.yearLabel.textColor = [UIColor darkGrayColor];
    
    self.yearLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
//    self.yearLabel.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.yearLabel];
    
    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 85, self.view.frame.size.width - 100 , 25)];
    
    self.eduLabel.textColor = [UIColor darkGrayColor];
    
//    self.eduLabel.textAlignment = 1;
    
//    self.eduLabel.backgroundColor = [UIColor greenColor];
    
    self.eduLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    [self.view addSubview:self.eduLabel];
    
}

- (void)createImages
{
    self.cityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    self.cityImage.image = [UIImage imageNamed:@"wz.png"];
    
    [self.view addSubview:self.cityImage];
    
    self.yearImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    self.yearImage.image = [UIImage imageNamed:@"gwb.png"];
    
    [self.view addSubview:self.yearImage];
    
    self.eduImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    self.eduImage.image = [UIImage imageNamed:@"rmb.png"];
    
    [self.view addSubview:self.eduImage];
    
}


- (void)getValueFromDic:(NSDictionary *)dic
{
    [self.headerImage sd_setImageWithURL:[[dic objectForKey:@"user"]objectForKey:@"avatar"]];
    
    
    NSString *contentStr = [NSString stringWithFormat:@"期望职位  %@", [dic objectForKey:@"title"]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    
    //设置：在0-5个单位长度内的内容显示成蓝色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor hcColor] range:NSMakeRange(6, contentStr.length - 6)];
    self.titleLabel.attributedText = str;
    
    
    
    
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ ",[[dic objectForKey:@"user"]objectForKey:@"name"]];
    CGSize nameSize = [UILableFitText fitTextWithHeight:30 label:self.nameLabel];
    self.nameLabel.frame = CGRectMake(10, (40 - nameSize.height) / 2 + 3, nameSize.width, nameSize.height);
    
    
    
    
    if ([[[dic objectForKey:@"user"]objectForKey:@"sex"] isEqualToString:@"男"]) {
        [self.sexImage setImage:[UIImage imageNamed:@"nanren.png"]];
    }else{
        [self.sexImage setImage:[UIImage imageNamed:@"nvren.png"]];
    }
    self.sexImage.frame = CGRectMake(10 + self.nameLabel.frame.size.width + 1, self.nameLabel.frame.origin.y , self.nameLabel.frame.size.height , self.nameLabel.frame.size.height );
    
    
    self.yearLabel.text = [dic objectForKey:@"work_year"];
    CGSize yearSize = [UILableFitText fitTextWithHeight:30 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.view.frame.size.width - yearSize.width - 10, (40 - yearSize.height) / 2 + 3,yearSize.width, yearSize.height);
    self.yearImage.frame = CGRectMake(self.view.frame.size.width - yearSize.width - 27, self.yearLabel.frame.origin.y + 1, 14, 14);
    
    
    self.cityLabel.text = [dic objectForKey:@"city"];
    CGSize citySize = [UILableFitText fitTextWithHeight:30 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(self.yearImage.frame.origin.x - citySize.width - 10, (40 - citySize.height) / 2 + 3, citySize.width, citySize.height);
    self.cityImage.frame = CGRectMake(self.cityLabel.frame.origin.x - 18, self.cityLabel.frame.origin.y + 1, 15, 15);
    
    
    
    self.salaryLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"salary"]];
    CGSize salarySize = [UILableFitText fitTextWithHeight:30 label:self.salaryLabel];
    self.salaryLabel.frame = CGRectMake(self.cityImage.frame.origin.x - salarySize.width - 10, (40 - salarySize.height) / 2 + 3, salarySize.width, salarySize.height);
    self.eduImage.frame = CGRectMake(self.salaryLabel.frame.origin.x - 18, self.salaryLabel.frame.origin.y + 2, 13, 13);
    
    
    NSString *eduStr = [NSString stringWithFormat:@"最高学历  %@", [[dic objectForKey:@"user"]objectForKey:@"highest_edu"]];
    NSMutableAttributedString *eduAtt = [[NSMutableAttributedString alloc]initWithString:eduStr];
    
    //设置：在0-5个单位长度内的内容显示成蓝色
    [eduAtt addAttribute:NSForegroundColorAttributeName value:[UIColor hcColor] range:NSMakeRange(6, eduStr.length - 6)];
    
    self.eduLabel.attributedText = eduAtt;
    
    self.assessLabel.text = [dic objectForKey:@"self_summary"];
}

- (void)setVisualView
{
    self.effectView.frame = CGRectMake(self.nameLabel.frame.origin.x + 17, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width - 17, self.nameLabel.frame.size.height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

@end
