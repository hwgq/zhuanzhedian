
//
//  CompanyDetailViewController.m
//  CompanyDetail
//
//  Created by Gaara on 16/7/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "UIColor+AddColor.h"
#import "UILableFitText.h"
@interface CompanyDetailViewController ()
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)UIImageView *backGroundImg;
@property (nonatomic, strong)UILabel *companyTitleLabel;
@property (nonatomic, strong)UIView *titleView;
@property (nonatomic, strong)UIView *generalInforView;
@property (nonatomic, strong)UIView *companySummaryView;
@property (nonatomic, strong)UILabel *personNumberLabel;
@property (nonatomic, strong)UILabel *tagArrLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UILabel *summaryLabel;

@end
@implementation CompanyDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self createSubViews];
}
- (void)createSubViews
{
    
    
    
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.mainScroll.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:self.mainScroll];
    
    
    UIImage *backGroundImage = [UIImage imageNamed:@"beijing_gongsi.png"];
    
    self.backGroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * backGroundImage.size.height / backGroundImage.size.width)];
    self.backGroundImg.image = backGroundImage;
    self.backGroundImg.userInteractionEnabled = YES;
    [self.mainScroll addSubview:self.backGroundImg];
    
    self.companyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, (self.backGroundImg.frame.size.height - 30) / 2, self.view.frame.size.width - 100, 50)];
    self.companyTitleLabel.layer.borderWidth = 2;
    self.companyTitleLabel.textAlignment = 1;
    self.companyTitleLabel.text = [self.cpDic objectForKey:@"name"];
    self.companyTitleLabel.textColor = [UIColor whiteColor];
    self.companyTitleLabel.font = [UIFont systemFontOfSize:20];
    self.companyTitleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.backGroundImg addSubview:self.companyTitleLabel];
    
    CGSize companyTitleSize = [UILableFitText fitTextWithHeight:50 label:self.companyTitleLabel];
    self.companyTitleLabel.frame = CGRectMake((self.view.frame.size.width -  companyTitleSize.width - 20) / 2, (self.backGroundImg.frame.size.height - 30) / 2, companyTitleSize.width + 20, 50);
    
    
    
    
    
    UIImageView *zzdBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 30, 30)];
    zzdBackImg.image = [UIImage imageNamed:@"backZZD.png"];
    zzdBackImg.userInteractionEnabled = YES;
    [zzdBackImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap)]];
    [self.backGroundImg addSubview:zzdBackImg];
    
    
    
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backGroundImg.frame.size.height, self.view.frame.size.width, 50)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *companyInfor = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 49)];
    companyInfor.text = @"公司信息";
    companyInfor.textAlignment = 1;
    companyInfor.textColor = [UIColor zzdColor];
    [self.titleView addSubview:companyInfor];
    
    UIView *titleLine = [[UIView alloc]initWithFrame:CGRectMake(0, 47, 100, 3)];
    titleLine.backgroundColor = [UIColor zzdColor];
    [self.titleView addSubview:titleLine];
    
    
    [self.mainScroll addSubview:self.titleView];
    
    self.generalInforView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backGroundImg.frame.size.height + 80, self.view.frame.size.width, 200)];
    self.generalInforView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.generalInforView];
   
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, (i + 1) * 50, self.view.frame.size.width - 20, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self.generalInforView addSubview:lineView];
    }
    
    
    
    UIImageView *generalImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 45, 35)];
    generalImg.image = [UIImage imageNamed:@"xinxi_gongsi.png"];
    [self.generalInforView addSubview:generalImg];
    
    UILabel *generalLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 100, 40)];
    generalLabel.textColor = [UIColor colorFromHexCode:@"#333333"];
    generalLabel.text = @"基本信息";
    [self.generalInforView addSubview:generalLabel];
    
    
    self.personNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, self.view.frame.size.width - 20, 40)];
    self.personNumberLabel.text = [NSString stringWithFormat:@"%@ : %@",@"规模",[self.cpDic objectForKey:@"size"]];
    self.personNumberLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    [self.generalInforView addSubview:self.personNumberLabel];
    
    self.tagArrLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, self.view.frame.size.width - 20, 40)];
    self.tagArrLabel.text = [NSString stringWithFormat:@"%@ : %@",@"行业",[self.cpDic objectForKey:@"sub_name"]];
    self.tagArrLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    [self.generalInforView addSubview:self.tagArrLabel];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 155, self.view.frame.size.width - 20, 40)];
    self.addressLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ : %@",@"地址",[self.cpDic objectForKey:@"address"]];
    [self.generalInforView addSubview:self.addressLabel];
 
    self.companySummaryView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backGroundImg.frame.size.height + 310, self.view.frame.size.width, 100)];
    self.companySummaryView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.companySummaryView];
    
    UIImageView *summaryImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 45, 35)];
    summaryImg.image = [UIImage imageNamed:@"qiye_gongsi.png"];
    [self.companySummaryView addSubview:summaryImg];
    
    UILabel *summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 100, 40)];
    summaryLabel.textColor = [UIColor colorFromHexCode:@"#333333"];
    summaryLabel.text = @"公司简介";
    [self.companySummaryView addSubview:summaryLabel];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width - 20, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.companySummaryView addSubview:lineView];

    self.summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 30)];
    self.summaryLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.backgroundColor = [UIColor whiteColor];
    self.summaryLabel.text = [self.cpDic objectForKey:@"intr"];
    [self.companySummaryView addSubview:self.summaryLabel];
    
    CGSize summarySize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 40 label:self.summaryLabel];
    self.summaryLabel.frame = CGRectMake(20, 60, self.view.frame.size.width - 40, summarySize.height  );
    self.companySummaryView.frame = CGRectMake(0, self.backGroundImg.frame.size.height + 310, self.view.frame.size.width, 100 - 30 + summarySize.height + 10);
    
    self.mainScroll.contentSize = CGSizeMake(0, self.backGroundImg.frame.size.height + 310 + 100 - 30 + summarySize.height + 20);
    
    
}
- (void)backTap
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
