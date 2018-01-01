//
//  JobHelperDetailViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/8/28.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "JobHelperDetailViewController.h"
#import "BossCheatTitleView.h"
#import "PersonCheatTitleView.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "JobHelperTimerView.h"
#import "JobDetailViewController.h"
#import "NewZZDPeopleViewController.h"
@interface JobHelperDetailViewController ()

@end

@implementation JobHelperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self createSubView];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    titleLabel.text = @"面试通";
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSubView
{
    BossCheatTitleView *bossView = [[BossCheatTitleView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 85)];
    [bossView setValueFromDic:@{@"avatar":[[[self.dic objectForKey:@"jd"]objectForKey:@"user"] objectForKey:@"avatar"],@"bossTitle":[[[self.dic objectForKey:@"jd"]objectForKey:@"user"] objectForKey:@"name"],@"education":[[self.dic objectForKey:@"jd"]objectForKey:@"education"],@"workYear":[[self.dic objectForKey:@"jd"]objectForKey:@"work_year"],@"city":[[self.dic objectForKey:@"jd"]objectForKey:@"city"] }];
    bossView.userInteractionEnabled = YES;
    [bossView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bossTap:)]];
    [self.view addSubview:bossView];
    
    PersonCheatTitleView *personView = [[PersonCheatTitleView alloc]initWithFrame:CGRectMake(0, 125, self.view.frame.size.width, 85)];
    personView.userInteractionEnabled = YES;
    [personView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personTap:)]];
    [personView setValueFromDic:@{@"rsAvatar":[[[self.dic objectForKey:@"rs"]objectForKey:@"user"] objectForKey:@"avatar"],@"rsName":[[[self.dic objectForKey:@"rs"]objectForKey:@"user"] objectForKey:@"name"],@"rsEdu":[[[self.dic objectForKey:@"rs"]objectForKey:@"user"]objectForKey:@"highest_edu" ],@"rsWork_year":[[self.dic objectForKey:@"rs"]objectForKey:@"work_year"],@"rsCity":[[self.dic objectForKey:@"rs"]objectForKey:@"city"] }];
    [self.view addSubview:personView];
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 50)];
    stateLabel.backgroundColor = [UIColor whiteColor];
    stateLabel.text = [NSString stringWithFormat:@"   状态 : %@",[self.dic objectForKey:@"feedbackWord"]];
    stateLabel.textColor = [UIColor colorFromHexCode:@"999"];
    stateLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:stateLabel];
    
    JobHelperTimerView *timeView = [[JobHelperTimerView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 240)];
    timeView.backgroundColor = [UIColor whiteColor];
    [timeView setStatusAndWords:self.dic];
    [self.view addSubview:timeView];
    
}
- (void)bossTap:(UITapGestureRecognizer *)tap
{
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"123"];
    jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.dic objectForKey:@"jd"]];
    [self.navigationController pushViewController:jobDetail animated:YES];
                    
                    
    
}
- (void)personTap:(UITapGestureRecognizer *)tap
{
    NewZZDPeopleViewController *detail = [[NewZZDPeopleViewController alloc]init];
    detail.buttonCount = 10;
    detail.isSelf = @"123";
    detail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.dic objectForKey:@"rs"]];
    [self.navigationController pushViewController:detail animated:YES];
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
