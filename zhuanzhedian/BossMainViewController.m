//
//  BossMainViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/7/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "BossMainViewController.h"
#import "VWWWaterView.h"
#import "UIView+MySet.h"
#import "ZZDMineTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PostOfficeViewController.h"
#import "CollectPersonViewController.h"
#import "PeopleCheatWithMeController.h"
#import "MySettingViewController.h"
#import "AboutUsViewController.h"
#import "MyInforViewController.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import "ScanViewController.h"
#import "AppDelegate.h"
#import "GoodCompanyViewController.h"
#import "ScanBeforeViewController.h"
#import "BossMessageViewController.h"
#import "JobHelperViewController.h"
#import "FirstBossRegistGuideViewController.h"
typedef enum kSliderTag{
    kHeight_Tag             = 11,
    kSpeed_Tag              = 12,
    kWave_Tag               = 13,
    kWaveIncrease_Tag       = 16,
    kWaveMin_Tag            = 17,
    kWaveMax_Tag            = 18,
    kWaveW_Tag              = 19,
    
}SliderTag;

#define showValueLableTag   10

#define waveDelta 0.01

//  当前屏幕宽度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
//  当前屏幕高度
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
//  tabbar高度
#define TABBAR_HEIGHT   self.tabBarController.tabBar.frame.size.height
//  状态栏高度
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
//  Navigationbar高度
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
//  判断系统版本
#define iOS8Over [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface BossMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mineTableView;
@property (nonatomic, strong)VWWWaterView *waterView;
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UILabel *badgeLabel;
@end
@implementation BossMainViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)getLocalUserData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.mainDic = [user objectForKey:@"user"];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    
    [self removeGuide];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.mainDic = [user objectForKey:@"user"];
    if ([self.mainDic objectForKey:@"avatar"]) {
        
        [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[self.mainDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"v2.png"]];
    }
    if ([self.mainDic objectForKey:@"name"] && [self.mainDic objectForKey:@"title"] && [self.mainDic objectForKey:@"cp_sub_name"]) {
        
        self.userNameLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.mainDic objectForKey:@"name"],[self.mainDic objectForKey:@"title"],[self.mainDic objectForKey:@"cp_sub_name"]];
    }
    
    [self.mineTableView reloadData];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    NSLog(@"%c",self.navigationController.navigationBar.hidden);
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
    

        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"] == nil) {
            [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"lyArr"];
            
        }else{
            
            
        }
        NSArray *lyArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"];
    if (lyArr.count == 0) {
        [self.navigationController.tabBarItem setBadgeValue:nil];
    }else{
        [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",lyArr.count]];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocalUserData];
//self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"] ;
    [self createMineTable];
//    self.waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200 + 20)color:[UIColor whiteColor]];
//    
//    [self.view addSubview:self.waterView];
    
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80) / 2, 20, 80, 80)];
    //    self.headerImg.image = [UIImage imageNamed:@"图层-4.png"];
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[self.mainDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"v2.png"]];
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 40;
    self.headerImg.userInteractionEnabled = YES;
    [self.headerImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editInforSelf)]];
    self.headerImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImg.layer.borderWidth = 2;
    [self.view addSubview:self.headerImg];
    
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 110, 200, 30)];
    self.userNameLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.mainDic objectForKey:@"name"],[self.mainDic objectForKey:@"title"],[self.mainDic objectForKey:@"cp_sub_name"]];
    self.userNameLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userNameLabel.userInteractionEnabled = YES;
    [self.userNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editInforSelf)]];
    self.userNameLabel.textAlignment = 1;
    [self.view addSubview:self.userNameLabel];
    
    UIImageView *pencilBtn = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2 + 200, 120, 10, 10)];
    pencilBtn.userInteractionEnabled = YES;
    [pencilBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editInforSelf)]];
    
    pencilBtn.image = [UIImage imageNamed:@"bi.png"];
    [self.view addSubview:pencilBtn];
    
    //初始化控制台
    //    [self initSetPanel];
    
    //初始化波浪参数
//    [self initWaveValue];
    
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_boss"]isEqualToString:@"0"]) {
        MyInforViewController *myInfor = [[MyInforViewController alloc]init];
        myInfor.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfor animated:YES];
    }
 
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    titleLabel.text = @"我的";
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    UIView  *lineUp = [[UIView alloc]initWithFrame:CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width, 1)];
    lineUp.backgroundColor = [UIColor colorFromHexCode:@"#EEEEEE"];
    [self.view addSubview:lineUp];
    
    UIImageView *setImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 22, 19)];
    setImg.image = [UIImage imageNamed:@"icon_set.png"];
    setImg.userInteractionEnabled = YES;
    [setImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSetting)]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setImg];
    
    
    UIImageView *scanImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    scanImg.image = [UIImage imageNamed:@"macIcon.png"];
    
    scanImg.userInteractionEnabled = YES;
    [scanImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scan:)]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scanImg];
    
    
    [self createGuideView];
}
- (void)createGuideView
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"bossGuide"]) {
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.backView.backgroundColor = [UIColor clearColor];
        [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGuide)]];
        
        
        CGRect rect = self.view.bounds;
        
        CGRect holeRection = CGRectMake(8, 22, 40, 40);
        
        
        //背景
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
        //镂空
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:holeRection cornerRadius:5];
        
        [path appendPath:circlePath];
        [path setUsesEvenOddFillRule:YES];
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        [self.backView.layer addSublayer:fillLayer];
        
        
        
        UIImageView *handImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 300, 185)];
        handImage.image = [UIImage imageNamed:@"scanBoss.png"];
        [self.backView addSubview:handImage];
        
//        UILabel *strLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 75, self.view.frame.size.width - 160, 100)];
//        NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc]initWithString:@"嫌手机发布职位麻烦?点击按钮扫码登录电脑端操作"];
//        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, searchStr.length)];
//        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(16, 4)];
//        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(21, 4)];
//        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//        paragraphStyle.paragraphSpacing = 15;  //段落高度
//        paragraphStyle.lineSpacing = 10;   //行高
//        
//        
//        [searchStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, searchStr.length)];
//        [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:18]objectAtIndex:1] range:NSMakeRange(0, searchStr.length)];
//        strLabel.attributedText = searchStr;
//        strLabel.numberOfLines = 0;
//        
//        [self.backView addSubview:strLabel];
        
        
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:self.backView];
     
    }
}
- (void)removeGuide
{
    [self.backView removeFromSuperview];
    self.backView = nil;
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"bossGuide"];
}
- (void)editInforSelf
{
    MyInforViewController *myInfor = [[MyInforViewController alloc]init];
    myInfor.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myInfor animated:YES];
    
    
}
- (void)initWaveValue
{
    //公式中用到(起始幅度)
    self.waterView.wave = 1.0005;
    //判断加减
    self.waterView.jia = NO;
    //幅度增长速度
    self.waterView.waveIncrease = 0.003;
    //减阈值 a
    self.waterView.waveMin = 1.3;
    //增阈值 a
    self.waterView.waveMax = 1.3;
    //b的增幅（速度控制）
    self.waterView.waveSpeed = 0.008;
    //起始Y值
    self.waterView.waveHeight = 186;
    //起始频率
    self.waterView.w = 185.5;
    
}
- (void)createMineTable
{
    self.mineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 161, self.view.frame.size.width, self.view.frame.size.height - 161) style:UITableViewStylePlain];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    self.mineTableView.rowHeight = 50;
    self.mineTableView.scrollEnabled = NO;
    self.mineTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mineTableView.layer.borderWidth = 1;
    self.mineTableView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.mineTableView.sectionHeaderHeight = 0.001;
    //    self.mineTableView.sectionFooterHeight = 0;
    [self.view addSubview:self.mineTableView];
    
    
   
    
}
- (void)scan:(UITapGestureRecognizer *)tap
{
    ScanBeforeViewController *scanVC = [[ScanBeforeViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else {
        return 0;
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    ZZDMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ZZDMineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [cell setImage:@"position.png" title:@"发布职位"];
                break;
            case 1:
                [cell setImage:@"collect.png" title:@"收藏的人才"];
                break;
            
            case 2:
                [cell setImage:@"company.png" title:@"行业名企"];
                break;
                
            case 3:
                 [cell setImage:@"message.png" title:@"职位留言"];
                break;
            case 4:
                [cell setImage:@"interview.png" title:@"我的面试通"];
                break;
            case 5:
                [cell setImage:@"strategy.png" title:@"功能教程与攻略"];
                break;

            default:
                break;
        }
        if (indexPath.row == 3) {
            if (!self.badgeLabel) {
                self.badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 35, 15, 20, 20)];
                self.badgeLabel.layer.masksToBounds = YES;
                self.badgeLabel.layer.cornerRadius = 10;
                self.badgeLabel.font = [UIFont systemFontOfSize:12];
                self.badgeLabel.backgroundColor = [UIColor redColor];
                self.badgeLabel.textColor = [UIColor whiteColor];
                self.badgeLabel.textAlignment = 1;
                NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"];
                self.badgeLabel.text = [NSString stringWithFormat:@"%ld",arr.count];
                [cell.contentView addSubview:self.badgeLabel];
                
                if (arr.count == 0) {
                    [self.badgeLabel removeFromSuperview];
                    self.badgeLabel = nil;
                }
            }else{
                NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"];
                self.badgeLabel.text = [NSString stringWithFormat:@"%ld",arr.count];
                if (arr.count == 0) {
                    [self.badgeLabel removeFromSuperview];
                     self.badgeLabel = nil;
                }
            }
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostOfficeViewController *postOffice = [[PostOfficeViewController alloc]init];
    CollectPersonViewController *collectPerson = [[CollectPersonViewController alloc]init];
    PeopleCheatWithMeController *peopleCheat = [[PeopleCheatWithMeController alloc]init];
    MySettingViewController *mySetting = [[MySettingViewController alloc]init];
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
    GoodCompanyViewController *goodCompanyVC = [[GoodCompanyViewController alloc]init];
    BossMessageViewController *bossMesVC = [[BossMessageViewController alloc]init];
    JobHelperViewController *jobHelper = [[JobHelperViewController alloc]init];
    
    if (indexPath.section == 0) {
        self.navigationController.navigationBar.hidden = NO;
        switch (indexPath.row) {
            case 0:
                postOffice.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:postOffice animated:YES];
                break;
            case 1:
                collectPerson.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collectPerson animated:YES];
                break;
       
         
            case 2:
                goodCompanyVC.hidesBottomBarWhenPushed = YES;
                goodCompanyVC.state = @"hide";
                [self.navigationController pushViewController:goodCompanyVC animated:YES];
                break;
            case 3:
                bossMesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bossMesVC animated:YES];
                
                break;
            case 4:
                jobHelper.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:jobHelper animated:YES];
                break;
            case 5:
                
                
                aboutUs.url  = @"http://api.zzd.hidna.cn/v1/conf/help";
                aboutUs.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUs animated:YES];
                
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        self.navigationController.navigationBar.hidden = NO;
        switch (indexPath.row) {
            case 0:
                
                
                aboutUs.url  = @"http://api.zzd.hidna.cn/v1/conf/help";
                aboutUs.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUs animated:YES];
                
                break;
            case 1:
                
                mySetting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mySetting animated:YES];
                break;
            default:
                break;
        }
    }

}
- (void)goToSetting
{
    MySettingViewController *mySetting = [[MySettingViewController alloc]init];
    mySetting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySetting animated:YES];
}
@end
