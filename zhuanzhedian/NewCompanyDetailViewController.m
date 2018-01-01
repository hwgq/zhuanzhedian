//
//  NewCompanyDetailViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/8.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "NewCompanyDetailViewController.h"
#import "CompanyDetailLabelView.h"
#import "UILableFitText.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
#import "FontTool.h"
@interface NewCompanyDetailViewController ()
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)UIImageView *imgBackground;
@property (nonatomic, strong)UIImageView *headerImg;
@end
@implementation NewCompanyDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.mainScroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.mainScroll.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    [self.view addSubview:self.mainScroll];
    
    [self createBackGround];
    
    
}
- (void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createBackGround
{
    self.imgBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 235)];
    self.imgBackground.userInteractionEnabled = YES;
//    self.imgBackground.backgroundColor = [UIColor redColor];
    self.imgBackground.image = [UIImage imageNamed:@"WechatIMG426234.png"];
    [self.mainScroll addSubview:self.imgBackground];
    
//    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 74) / 2, 74, 74, 74)];
//    self.headerImg.layer.masksToBounds = YES;
//    self.headerImg.layer.cornerRadius = 37;
//    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[self.cpDic objectForKey:@""]]];
//    
//    [self.imgBackground addSubview:self.headerImg];
    UIImageView *imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 20, 15)];
    imgBack.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    imgBack.userInteractionEnabled = YES;
    [imgBack addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTo)]];
    [self.imgBackground addSubview:imgBack];
    
    
    
    UILabel *companyTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    companyTitleLabel.textAlignment = 1;
    companyTitleLabel.text = [self.cpDic objectForKey:@"name"];
    companyTitleLabel.textColor = [UIColor whiteColor];
    companyTitleLabel.font = [[FontTool customFontArrayWithSize:18]objectAtIndex:1];
    [self.imgBackground addSubview:companyTitleLabel];
    
    CGSize companyTitleSize = [UILableFitText fitTextWithHeight:30 label:companyTitleLabel];
    companyTitleLabel.frame = CGRectMake((self.view.frame.size.width -  companyTitleSize.width - 20) / 2, 95, companyTitleSize.width + 20, 40);
    
    
    UILabel *companyDetailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    companyDetailLabel.textAlignment = 1;
    companyDetailLabel.text = [NSString stringWithFormat:@"%@ | %@",[self.cpDic objectForKey:@"sub_name"],[self.cpDic objectForKey:@"size"]];
    companyDetailLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    companyDetailLabel.textColor = [UIColor whiteColor];
    [self.imgBackground addSubview:companyDetailLabel];
    CGSize companyDetailSize = [UILableFitText fitTextWithHeight:30 label:companyDetailLabel];
    companyDetailLabel.frame = CGRectMake((self.view.frame.size.width - companyDetailSize.width - 20) / 2, 135, companyDetailSize.width + 20, 40);
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, companyTitleLabel.frame.origin.y, self.view.frame.size.width, 80)];
    backImg.image = [UIImage imageNamed:@"WechatIMG43ccca1.png"];
    [self.imgBackground addSubview:backImg];
    [self.imgBackground sendSubviewToBack:backImg];
    
    
    
    CompanyDetailLabelView *introView = [[CompanyDetailLabelView alloc]initWithFrame:CGRectMake(0, 245, self.view.frame.size.width, 0) title:@"公司简介" detailStr:[self.cpDic objectForKey:@"intr"]];
    
    CGSize introSize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 20 label:introView.detailLabel];
    [introView setDetailLabelSize:introSize.height];
    [self.view addSubview:introView];
    
    CompanyDetailLabelView *addressView = [[CompanyDetailLabelView alloc]initWithFrame:CGRectMake(0, 275 + introView.frame.size.height, self.view.frame.size.width, 0) title:@"公司地址" detailStr:[self.cpDic objectForKey:@"address"]];
    
    CGSize addressSize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 20 label:addressView.detailLabel];
    [addressView setDetailLabelSize:addressSize.height];
    [self.view addSubview:addressView];
    
    
}
@end
