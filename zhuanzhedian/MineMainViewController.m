//
//  MineMainViewController.m
//  Mine
//
//  Created by Gaara on 16/6/30.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "MineMainViewController.h"
#import "VWWWaterView.h"
#import "UIView+MySet.h"
#import "ZZDMineTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WorkResumeViewController.h"
#import "WorkResumeDetailViewController.h"
#import "CollectPersonViewController.h"
#import "PeopleCheatWithMeController.h"
#import "MySettingViewController.h"
#import "AboutUsViewController.h"
#import "CompleteRSViewController.h"
#import "FirstRegistGuideController.h"
#import "AppDelegate.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import "ScanViewController.h"
#import "JobHelperViewController.h"
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
@interface MineMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mineTableView;
@property (nonatomic, strong)VWWWaterView *waterView;
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *userNameLabel;

@end
@implementation MineMainViewController
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
    NSLog(@"%@",[user objectForKey:@"rs"]);
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.mainDic = [user objectForKey:@"user"];
    if ([self.mainDic objectForKey:@"avatar"]) {
        
        [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[self.mainDic objectForKey:@"avatar"]]];
    }
    if ([self.mainDic objectForKey:@"name"] && [self.mainDic objectForKey:@"sex"] && [self.mainDic objectForKey:@"highest_edu"]) {
        
        self.userNameLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.mainDic objectForKey:@"name"],[self.mainDic objectForKey:@"sex"],[self.mainDic objectForKey:@"highest_edu"]];
    }
}
- (void)manageMyRS
{
    CompleteRSViewController *rsVC = [[CompleteRSViewController alloc]init];
    FirstRegistGuideController *firstRegist = [[FirstRegistGuideController alloc]init];
    if ([[self.mainDic objectForKey:@"resume_id"]integerValue] > 0) {
        //                    resumeDetail.hidesBottomBarWhenPushed = YES;
        //                    resumeDetail.a = 10;
        //                    // 从微简历push到英雄出处那页
        //                    [self.navigationController pushViewController:resumeDetail animated:YES];
        rsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rsVC animated:YES];
    }else{
        firstRegist.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: firstRegist animated:YES];}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocalUserData];
//    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"] ;
    [self createMineTable];
//    self.waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200 + 20)color:[UIColor whiteColor]];
//
//    [self.view addSubview:self.waterView];

    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80) / 2, 20, 80, 80)];
//    self.headerImg.image = [UIImage imageNamed:@"图层-4.png"];
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[self.mainDic objectForKey:@"avatar"]]];
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 40;
    self.headerImg.userInteractionEnabled = YES;
    [self.headerImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(manageMyRS)]];
    self.headerImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImg.layer.borderWidth = 2;
    [self.view addSubview:self.headerImg];
    
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 110, 200, 30)];
    self.userNameLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.mainDic objectForKey:@"name"],[self.mainDic objectForKey:@"sex"],[self.mainDic objectForKey:@"highest_edu"]];
    self.userNameLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userNameLabel.textAlignment = 1;
    [self.view addSubview:self.userNameLabel];
    
    
    UIView  *lineUp = [[UIView alloc]initWithFrame:CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width, 1)];
    lineUp.backgroundColor = [UIColor colorFromHexCode:@"#EEEEEE"];
    [self.view addSubview:lineUp];
    
    
    //初始化控制台
//    [self initSetPanel];
    
    //初始化波浪参数
//    [self initWaveValue];
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_user"]isEqualToString:@"0"]) {
//        WorkUserInforViewController *workInfor = [[WorkUserInforViewController alloc]init];
//        workInfor.hidesBottomBarWhenPushed = YES;
//        workInfor.isFirst = @"YES";
//        [self.navigationController pushViewController:workInfor animated:YES];
        FirstRegistGuideController *firstGuide = [[FirstRegistGuideController alloc]init];
        firstGuide.hidesBottomBarWhenPushed = YES;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tabBar = (UITabBarController *)app.window.rootViewController;
        UINavigationController *nav = [tabBar.viewControllers objectAtIndex:3];
        [nav pushViewController:firstGuide animated:YES];
    }

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    titleLabel.text = @"我的";
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    UIImageView *setImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 22, 19)];
    setImg.image = [UIImage imageNamed:@"icon_set.png"];
    setImg.userInteractionEnabled = YES;
    [setImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSetting)]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setImg];
    
}
#pragma mark 初始化波浪参数
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

#pragma mark 初始化控制台
- (void)initSetPanel
{
    NSMutableArray *subViewArray = [[NSMutableArray alloc] init];
    
    //高度
    [self setSliderDetail:0.0f maxNumValue:SCREEN_HEIGHT title:@"waveHeight" tag:kHeight_Tag subViewArray:subViewArray initValue:self.waterView.waveHeight];
    //速度
    [self setSliderDetail:0.0f maxNumValue:0.2f title:@"waveSpeed" tag:kSpeed_Tag subViewArray:subViewArray initValue:self.waterView.waveSpeed];
    
    //波浪幅度
    [self setSliderDetail:0.0f maxNumValue:10.0f title:@"wave" tag:kWave_Tag subViewArray:subViewArray initValue:self.waterView.wave];
    
    //waveIncrease
    [self setSliderDetail:0.0f maxNumValue:0.5f title:@"waveIncrease" tag:kWaveIncrease_Tag subViewArray:subViewArray initValue:self.waterView.waveIncrease];
    //waveMin
    [self setSliderDetail:0.0f maxNumValue:10.0f title:@"waveMin" tag:kWaveMin_Tag subViewArray:subViewArray initValue:self.waterView.waveMin];
    //waveMax
    [self setSliderDetail:0.0f maxNumValue:10.0f title:@"waveMax" tag:kWaveMax_Tag subViewArray:subViewArray initValue:self.waterView.waveMax];
    //频率，周期
    [self setSliderDetail:0.1f maxNumValue:360.0f title:@"周期，频率" tag:kWaveW_Tag subViewArray:subViewArray initValue:self.waterView.w];
    
    [UIView BearHorizontalAutoLay:subViewArray parentView:self.view offStart:200 offEnd:20 centerEqualParent:YES horizontalOrNot:NO offDistanceEqualViewDistance:NO];
}

- (void)setSliderDetail:(CGFloat)mininumValue maxNumValue:(CGFloat)maxNumValue title:(NSString *)title tag:(NSInteger)tag subViewArray:(NSMutableArray *)subViewArray initValue:(CGFloat)initvalue
{
    /**
     ** 初始化参数
     **/
    CGFloat offX    = 15.0f;    //  左边距
    CGFloat deltaX  = 10.0f;    //  间距
    
    //parentView
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [self.view addSubview:parentView];
    parentView.tag = tag;
    [subViewArray addObject:parentView];
    
    //左侧label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX, 0, 0, 0)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    [parentView addSubview:label];
    [label setMyDirectionDistance:dir_Down destinationView:parentView parentRelation:YES distance:CGRectGetHeight(parentView.frame) center:NO];
    
    //初始化slider布局
    CGFloat height = 10;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake( deltaX, 0, SCREEN_WIDTH - offX - deltaX, height)];
    slider.tag = tag;
    slider.value = initvalue;
    [parentView addSubview:slider];
    [slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    [slider setMyCenter:dir_Vertical destinationView:nil parentRelation:YES];
    
    //显示数值的label
    UILabel *showValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX + CGRectGetMaxX(label.frame), 0, 0, 0)];
    showValueLabel.tag = showValueLableTag;
    showValueLabel.text = [NSString stringWithFormat:@"%0.2f", initvalue];
    showValueLabel.font = [UIFont systemFontOfSize:13.0f];
    [showValueLabel sizeToFit];
    [parentView addSubview:showValueLabel];
    [showValueLabel setMyDirectionDistance:dir_Down destinationView:parentView parentRelation:YES distance:CGRectGetHeight(parentView.frame) center:NO];
    
    //设置slider参数
    slider.minimumValue = mininumValue;
    slider.maximumValue = maxNumValue;
}

#pragma mark 更新slider的值
- (void)updateSliderValue:(UISlider *)slider
{
    switch (slider.tag) {
            //更新高度
        case kHeight_Tag:
            self.waterView.waveHeight = slider.value;
            break;
            
            //更新速度
        case kSpeed_Tag:
            self.waterView.waveSpeed = slider.value;
            break;
            
            //波形幅度
        case kWave_Tag:
            self.waterView.wave = slider.value;
            break;
            
            //更新幅度增长速度
        case kWaveIncrease_Tag:
            self.waterView.waveIncrease = slider.value;
            break;
            
        case kWaveMin_Tag:
            self.waterView.waveMin = slider.value;
            //限定最大幅度和最小幅度符合逻辑
            if (self.waterView.waveMax - self.waterView.waveMin < waveDelta) {
                self.waterView.waveMax = self.waterView.waveMin + waveDelta;
            }
            break;
            
        case kWaveMax_Tag:
            self.waterView.waveMax = slider.value;
            //限定最大幅度和最小幅度符合逻辑
            if (self.waterView.waveMax < waveDelta) {
                self.waterView.waveMax = waveDelta;
            }
            if (self.waterView.waveMax - self.waterView.waveMin < waveDelta) {
                self.waterView.waveMin = self.waterView.waveMax - waveDelta;
            }
            break;
            
        case kWaveW_Tag:
            self.waterView.w = slider.value;
            break;
            
        default:
            break;
    }
    
    return;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    
    }else{
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
                [cell setImage:@"personal_icon_resume.png" title:@"管理简历"];
                break;
            case 1:
                [cell setImage:@"personal_icon_collect.png" title:@"收藏的岗位"];
                break;
            case 2:
                [cell setImage:@"interview_icon.png" title:@"我的面试通"];
                break;
            case 3:
                [cell setImage:nil title:@"功能教程与攻略"];
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [cell setImage:nil title:@"功能教程与攻略"];
                break;
            case 1:
                [cell setImage:@"图层-9.png" title:@"设置"];
                break;
            default:
                break;
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
    
    WorkResumeViewController *resume = [[WorkResumeViewController alloc]init];
    WorkResumeDetailViewController *resumeDetail  = [[WorkResumeDetailViewController alloc]init];
    CollectPersonViewController *collect = [[CollectPersonViewController alloc]init];
    PeopleCheatWithMeController *peoCheat = [[PeopleCheatWithMeController alloc]init];
    MySettingViewController *mySetting = [[MySettingViewController alloc]init];
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
    CompleteRSViewController *rsVC = [[CompleteRSViewController alloc]init];
    FirstRegistGuideController *firstRegist = [[FirstRegistGuideController alloc]init];
    JobHelperViewController *jobHelperVC = [[JobHelperViewController alloc]init];
    if (indexPath.section == 0) {
        self.navigationController.navigationBar.hidden = NO;
        switch (indexPath.row) {
            case 0:
                if ([[self.mainDic objectForKey:@"resume_id"]integerValue] > 0) {
//                    resumeDetail.hidesBottomBarWhenPushed = YES;
//                    resumeDetail.a = 10;
//                    // 从微简历push到英雄出处那页
//                    [self.navigationController pushViewController:resumeDetail animated:YES];
                    rsVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:rsVC animated:YES];
                }else{
                    firstRegist.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController: firstRegist animated:YES];}
                break;
            case 1:
                collect.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collect animated:YES];
                break;
            case 2:
                jobHelperVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:jobHelperVC animated:YES];
                break;
            case 3:
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
