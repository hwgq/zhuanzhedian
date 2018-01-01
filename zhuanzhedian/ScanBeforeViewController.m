//
//  ScanBeforeViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/5/16.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "ScanBeforeViewController.h"
#import "UIColor+flat.h"
#import "ScanViewController.h"
@interface ScanBeforeViewController ()

@end

@implementation ScanBeforeViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    UIImageView *mainImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300) / 2, 50, 300, 180)];
    mainImg.image = [UIImage imageNamed:@"mac1111.png"];
    [self.view addSubview:mainImg];
    
    UILabel *firstStepLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300) / 2, 260, 300, 30)];
    firstStepLabel.textColor = [UIColor colorWithHexCode:@"bbb"];
    firstStepLabel.text = @"第一步:用电脑浏览器打开网址";
    firstStepLabel.textAlignment = 1;
    [self.view addSubview:firstStepLabel];
    
    UILabel *webStrLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300) / 2, 300, 300, 30)];
    webStrLabel.text = @"izhuanzhe.com/a";
    webStrLabel.textAlignment = 1;
    webStrLabel.font = [UIFont systemFontOfSize:18];
    webStrLabel.textColor = [UIColor colorWithHexCode:@"333"];
    [self.view addSubview:webStrLabel];
    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 50 - 79, self.view.frame.size.width - 40, 40)];
    enterBtn.backgroundColor = [UIColor colorWithHexCode:@"38ab99"];
    [enterBtn setTitle:@"已打开网址,点击开始扫码" forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    enterBtn.layer.cornerRadius = 7;
    enterBtn.layer.masksToBounds = YES;
    [enterBtn addTarget:self action:@selector(beginScan) forControlEvents:UIControlEventTouchUpInside];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:enterBtn];
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)beginScan
{
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
