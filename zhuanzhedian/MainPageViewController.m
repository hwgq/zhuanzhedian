//
//  MainPageViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MainPageViewController.h"
#import "UIColor+AddColor.h"
#import "MainViewTableViewCell.h"
#import "MJRefresh.h"
#import "ButtonView.h"
#import "AFNetworking.h"
#import "SecondViewTableViewCell.h"
#import "JobDetailViewController.h"
#import "WorkResumeDetailViewController.h"
#import "AppDelegate.h"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
#import "ZZDLoginViewController.h"
#import "CreateNewJobViewController.h"
#import "UsersViewController.h"
#import "WorkResumeViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "NewZZDBossCell.h"
#import "SRRefreshView.h"
#import "NewZZDPeopleViewController.h"
#import "NewZZDPeopleCell.h"
#import "FirstRegistGuideController.h"
#import "FontTool.h"
#import "MainSearchViewController.h"
#import "TimeTool.h"
#import "UIImageView+WebCache.h"
#import "NSTimer+CLBlockSupport.h"
#import "TitleLabel.h"
#import "UILableFitText.h"
#import <UMMobClick/MobClick.h>
#import "BossMainViewController.h"
#import "GoodCompanyDetailViewController.h"
#import "GoodCompanyJobsViewController.h"
#import "ScanBeforeViewController.h"
#import "JobSelectTypeViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "FMDBMessages.h"
#import "AboutUsViewController.h"
@interface MainPageViewController ()<UITableViewDataSource,UITableViewDelegate,ButtonViewDelegate,MBProgressHUDDelegate,SRRefreshDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,JobSelectTypeDelegate>
@property (nonatomic,  strong)AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong)AVIMClient *client;
@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, strong)UITableView *mainViewTable;
@property (nonatomic, strong)NSMutableArray *mainArr;

@property (nonatomic, strong)UIImageView *image;
@property (nonatomic, strong)UITableView *alertTable;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *backGroundView;
@property (nonatomic, strong)NSMutableArray *alertArr;
@property (nonatomic, copy)NSString *alertTitle;
@property (nonatomic, strong)NSMutableDictionary *otherDic;
@property (nonatomic, assign)NSInteger a;
@property (nonatomic, copy)NSString *userState;
//title
@property (nonatomic, strong)UIScrollView *titleButtonView;
@property (nonatomic, strong)UIImageView *titleImage;
@property (nonatomic, strong)UILabel *titleText;
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, strong)UITableView *titleTable;
@property (nonatomic, strong)UIImageView *titleTableView;
@property (nonatomic, assign)NSInteger b;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *collectArr;
@property (nonatomic, strong)UIImageView *backImage;
@property (nonatomic, strong)UIButton *backButton;

@property (nonatomic, strong)SRRefreshView*slimeView;

@property (nonatomic, strong)NSIndexPath *myIndex;

@property (nonatomic, strong)UIScrollView *scrollShowView;

@property (nonatomic, strong)UIScrollView *headerImg;
@property (nonatomic, strong)NSString *imgUrl;
@property (nonatomic, strong)NSArray *showArr;
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic, strong)NSMutableArray *titlesArr;
@property (nonatomic, strong)NSString *jdId;
@property (nonatomic, strong)NSArray *headerArr;

@property (nonatomic, strong)UIView *updateWordView;
@property (nonatomic, strong)UILabel *backLabel;

@property (nonatomic, strong)UITextView *updateWordField;

@property (nonatomic, strong)NSString *rsListUrl;
@property (nonatomic, strong)UIView *bossCreateBackView;
@property (nonatomic, strong)UILabel *cityBtn;

@property (nonatomic, strong)NSArray *pickerArr;
@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)UIView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;
@property (nonatomic, strong)NSString *currentValue;
@property (nonatomic, strong)NSString *currentId;
@property (nonatomic, strong)NSArray *pickerSubArr;


@property (nonatomic, strong)NSString *cityId;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *provinceId;
@property (nonatomic, strong)NSString *province;

@property (nonatomic, strong)UIImageView *firstRegView;
@property (nonatomic, strong)NSMutableArray *jobsArr;
@end

@implementation MainPageViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titlesArr = [NSMutableArray array];
        self.mainArr = [NSMutableArray array];
        self.alertArr = [NSMutableArray array];
        self.otherDic = [NSMutableDictionary dictionary];
        self.a = 0;
        self.isSelected = 0;
        self.titleArr = [NSMutableArray array];
        self.b = -10;
        self.collectArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [AVAnalytics endLogPageView:@"MainPage"];
    [MobClick endLogPageView:@"MainPage"];
    self.isSelected = 1;
    [self.hud removeFromSuperViewOnHide];
    self.hud.hidden = YES;
    [self openSetting:nil];
    [self.manager.operationQueue cancelAllOperations];
    self.slimeView.loading = NO;
    self.slimeView.slime.state = SRSlimeStateNormal;

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    [AVAnalytics beginLogPageView:@"MainPage"];
    [MobClick beginLogPageView:@"MainPage"];
    
    [self.titleArr removeAllObjects];
    [self.navigationController.navigationBar setHidden:NO];
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:self.userState]) {
 
        self.userState = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
        self.a = 0;
        
        [self.otherDic removeAllObjects];
        
        [self.mainArr removeAllObjects];
//
        [self.mainViewTable reloadData];
        
        [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"])
        {
            [self.titleButtonView removeFromSuperview];
            self.titleButtonView = nil;
            self.titleButtonView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 40)];
           
            self.titleButtonView.showsVerticalScrollIndicator = NO;
            self.titleButtonView.showsHorizontalScrollIndicator = NO;

         
            [self startCategoryConnection];
            
        }
    }
    if ([self.userState isEqualToString:@"2"]) {
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:self.titleButtonView];
        self.navigationItem.titleView = nil;
    }
    if ([self.userState isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cityBtn];
        self.cityBtn.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"city"];
        self.navigationItem.titleView = self.titleLabel;
    }
    [self.hud removeFromSuperview];
    
    [self.mainViewTable reloadData];
    
//    self.a = 0;
    
//    [self.mainArr removeAllObjects];
    
    if (self.b > 0) {
        
        if (self.titleArr.count > 0) {
            
        [self.otherDic setObject:[[self.titleArr objectAtIndex:self.b] objectForKey:@"id"] forKey:@"sub_category_id"];
        }
    }
    if (self.mainArr.count == 0) {
        [self getConnection:@"0" num:@"10" dic:self.otherDic];
    }
    UIView *searchAndOtherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    UIImageView *otherImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 26, 26)];
//    otherImg.backgroundColor = [UIColor redColor];
    otherImg.userInteractionEnabled = YES;
    otherImg.image = [UIImage imageNamed:@"意见反馈 (1).png"];
    [otherImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createUpdateWordView)] ];
    [searchAndOtherView addSubview:otherImg];
    
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(36, 6, 24, 18)];
    searchImg.image = [UIImage imageNamed:@"Group 2 Copy.png"];
    searchImg.userInteractionEnabled = YES;
    [searchImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSearch)]];
    
    [searchAndOtherView addSubview:searchImg];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchAndOtherView];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)createUpdateWordView
{
    
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeUpdateWordView)] ];
        [self.view addSubview:backView];
        
        self.updateWordView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 260)];
        self.updateWordView.center = CGPointMake(backView.center.x, backView.center.y - 100);
        self.updateWordView.backgroundColor = [UIColor whiteColor];
        self.updateWordView.layer.cornerRadius = 7;
        [backView addSubview:self.updateWordView];
    
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    titleLabel.textAlignment = 1;
    titleLabel.text = @"用户反馈";
    titleLabel.textColor = [UIColor colorFromHexCode:@"333"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.updateWordView addSubview:titleLabel];
    
    self.updateWordField = [[UITextView alloc]initWithFrame:CGRectMake(15, 50, 290, 150)];
    self.updateWordField.layer.cornerRadius = 3;
    self.updateWordField.delegate = self;
    self.updateWordField.font = [UIFont systemFontOfSize:16];
    self.updateWordField.backgroundColor = [UIColor colorFromHexCode:@"f2f2f2"];
    [self.updateWordView addSubview:self.updateWordField];
    
    self.backLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 54, 200, 24)];
    self.backLabel.text = [NSString stringWithFormat:@"请简要描述你的问题和建议"];
    self.backLabel.textColor = [UIColor lightGrayColor];
    self.backLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    //    self.backLabel.backgroundColor = [UIColor yellowColor];
    [self.updateWordView addSubview:self.backLabel];
    
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 215, 290, 30)];
    confirmBtn.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [confirmBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmBtn.layer.cornerRadius = 3;
    [confirmBtn addTarget:self action:@selector(updateWords) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.masksToBounds = YES;
    [self.updateWordView addSubview:confirmBtn];
    
    UIImageView *cancelImg = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 30, - 40, 30, 30)];
    cancelImg.image = [UIImage imageNamed:@"newX.png"];
     [cancelImg setTintColor:[UIColor colorFromHexCode:@"#fff"]];
    cancelImg.userInteractionEnabled = YES;
    [cancelImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeUpdateWordView)] ];
    [self.updateWordView addSubview:cancelImg];
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        self.backLabel.frame = CGRectMake(20, 54, 200, 24);
        
    }else{
        self.backLabel.frame = CGRectMake(20, 54, 0, 24);
        
        
    }
}
- (void)removeUpdateWordView
{
    [self.updateWordView.superview removeFromSuperview];
    [self.updateWordView removeFromSuperview];
}
- (void)updateWords
{
    
    if (self.updateWordField.text.length > 0) {
        
        
        self.manager = [AFHTTPRequestOperationManager manager];
        
        [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                
                NSString *url = @"http://api.zzd.hidna.cn/v1/user/userAdvice";
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                
                [parameters setObject:time forKey:@"timestamp"];
                
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
                
                [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                
                [parameters setObject:self.updateWordField.text forKey:@"message"];
                
                [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                        
                        [self removeUpdateWordView];
                        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
                        [alertView setTitle:@"转折点提示" detail:@"感谢您对转折点APP提出宝贵的建议!" alert:ZZDAlertStateNormal];
                        [self.view addSubview:alertView];
                        
                        
                    }
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    }
}
- (void)goToSearch
{
    MainSearchViewController *mainSearchVC = [[MainSearchViewController alloc]init];
    mainSearchVC.jdId = self.jdId;
    [self.navigationController pushViewController:mainSearchVC animated:YES];
    
}
- (void)createBossBackView
{
    if (!self.bossCreateBackView) {
        
    
    self.bossCreateBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64 + 46)];
    self.bossCreateBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 180, self.view.frame.size.width - 60, (self.view.frame.size.width - 60) * 340 / 777)];
    titleImg.image = [UIImage imageNamed:@"bosswenzi.png"];
    [self.bossCreateBackView addSubview:titleImg];
    
        UIButton *createJobBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 180 + (self.view.frame.size.width - 60) * 340 / 777 + 50, (self.view.frame.size.width - 140 ) / 2 , (self.view.frame.size.width - 140 ) / 2 * 48/ 145)];
        [createJobBtn setImage:[UIImage imageNamed:@"bossmobile.png"] forState:UIControlStateNormal];
        [createJobBtn addTarget:self action:@selector(goToCreate) forControlEvents:UIControlEventTouchUpInside];
        [self.bossCreateBackView addSubview:createJobBtn];
        
        UIButton *createPcBtn = [[UIButton alloc]initWithFrame:CGRectMake(50 + (self.view.frame.size.width - 140) / 2 + 40, 180 + (self.view.frame.size.width - 60) * 340 / 777 + 50, (self.view.frame.size.width - 140) / 2 , (self.view.frame.size.width - 140) / 2 * 48 / 145)];
        [createPcBtn setImage:[UIImage imageNamed:@"bosspc.png"] forState:UIControlStateNormal];
        [createPcBtn addTarget:self action:@selector(goToPc) forControlEvents:UIControlEventTouchUpInside];
        [self.bossCreateBackView addSubview:createPcBtn];
    
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 60, 50, 50)];
        [cancelBtn setImage:[UIImage imageNamed:@"bossdacha.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(removeBossBackView) forControlEvents:UIControlEventTouchUpInside];
        [self.bossCreateBackView addSubview:cancelBtn];
        
        
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.bossCreateBackView];
    }
}
- (void)goToPc
{
    [self removeBossBackView];
    ScanBeforeViewController *scanVC = [[ScanBeforeViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];

}
- (void)goToCreate
{
    [self removeBossBackView];
    [self createNewJob];
}
- (void)removeBossBackView
{
    [self.bossCreateBackView removeFromSuperview ];
    self.bossCreateBackView = nil;
}
- (void)createNewJob
{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"])
    {
//        WorkResumeViewController *detail = [[WorkResumeViewController alloc]init];
//        
//        detail.hidesBottomBarWhenPushed = YES;
        
//        [self.navigationController pushViewController:detail animated:YES];
        FirstRegistGuideController  *firstRegist = [[FirstRegistGuideController alloc]init];
        firstRegist.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:firstRegist animated:YES];
    }else{
        CreateNewJobViewController *create = [[CreateNewJobViewController alloc]init];
        
        create.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:create animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    self.slimeView.loading = NO;
    self.slimeView.slime.state = SRSlimeStateNormal;
    
    [self.backButton removeFromSuperview];
    
//    [self.backImage removeFromSuperview];
    
    [self getWhatILike];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"])
    {
//        self.backImage.image = [UIImage imageNamed:@"renc.png"];
        
        [self.backButton setTitle:@"创建简历" forState:UIControlStateNormal];
        
    }else{
//        self.backImage.image = [UIImage imageNamed:@"boss.png"];
        
        [self.backButton setTitle:@"创建职位" forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"rs"] == nil && [[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"1"])
    {
//        [self.view addSubview:self.backImage];
        
        [self.view addSubview:self.backButton];
        
//        [self.view sendSubviewToBack:self.backImage];
        
        [self.view sendSubviewToBack:self.backButton];
        
        [self.view sendSubviewToBack:self.mainViewTable];
    }else{
//        [self.backImage removeFromSuperview];
        
        [self.backButton removeFromSuperview];
        
        
        
          if (![[NSUserDefaults standardUserDefaults]objectForKey:@"firstUserRegist"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"title"]) {
              
              [[NSUserDefaults standardUserDefaults]setObject:@"firstUserRegist" forKey:@"firstUserRegist"];
        //弹窗
        NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
        self.manager = [AFHTTPRequestOperationManager manager];
        //                        [self.manager.operationQueue cancelAllOperations];
        [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                NSString *url = @"";
                if ([role isEqualToString:@"2"]) {
                    
                    url = @"http://api.zzd.hidna.cn/v1/rs/search";
                }else if ([role isEqualToString:@"1"])
                {
                    url = @"http://api.zzd.hidna.cn/v1/jd/search";
                }
                
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                
                [parameters setObject:time forKey:@"timestamp"];
                
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
                
                [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"title"] forKey:@"key"];
                
                [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                        NSArray *jobsArr = [responseObject objectForKey:@"data"];
                        self.jobsArr = [NSMutableArray arrayWithArray:jobsArr];
                        
                        NSLog(@"%ld",jobsArr.count);
                        
                        if (jobsArr.count > 0) {
                            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            
                            self.backView = [[UIView alloc]initWithFrame:self.view.frame];
                            self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                            [app.window addSubview:self.backView];
                            
                            self.firstRegView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 287, 408)];
                            self.firstRegView.layer.cornerRadius = 8;
                            self.firstRegView.layer.masksToBounds = YES;
                            self.firstRegView.userInteractionEnabled = YES;
                            self.firstRegView.image = [UIImage imageNamed:@"职位匹配@3x_02"];
                            self.firstRegView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
                            [self.backView addSubview:self.firstRegView];
                            
                            UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 408 - 40, 143.5 + 0.8, 40)];
                            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                            [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                            [cancelBtn addTarget:self action:@selector(removeFirstRegistView) forControlEvents:UIControlEventTouchUpInside];
                            
                            cancelBtn.layer.borderWidth = 1.5;
                            cancelBtn.layer.borderColor = [UIColor colorFromHexCode:@"ddd"].CGColor;
                            [self.firstRegView addSubview:cancelBtn];
                            
                            UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(143.5, 408 - 40, 143.5, 40)];
                            [sendBtn setTitle:@"一键发送" forState:UIControlStateNormal];
                            [sendBtn setTitleColor:[UIColor colorFromHexCode:@"#38ab99"] forState:UIControlStateNormal];
                            sendBtn.layer.borderWidth = 1.5;
                            sendBtn.layer.borderColor = [UIColor colorFromHexCode:@"ddd"].CGColor;
                            [sendBtn addTarget:self action:@selector(sendRegistMessage) forControlEvents:UIControlEventTouchUpInside];
                            [self.firstRegView addSubview:sendBtn];
                            
                            
                            for (int i = 0; i < jobsArr.count; i ++) {
                                if (i == 9) {
                                    break;
                                }
                                NSDictionary *dooc = [jobsArr objectAtIndex:i];
                                UIImageView *jobHeader = [[UIImageView alloc]initWithFrame:CGRectMake(i % 3 * 88 + 20, i / 3 * 88 + 80, 70, 70)];
                                [jobHeader sd_setImageWithURL:[NSURL URLWithString:[[dooc objectForKey:@"user"]objectForKey:@"avatar"]]];
                                jobHeader.userInteractionEnabled = YES;
                                jobHeader.layer.masksToBounds = YES;
                                jobHeader.layer.cornerRadius = 8;
                                jobHeader.layer.borderColor = [UIColor colorFromHexCode:@"eee"].CGColor;
                                jobHeader.layer.borderWidth = 1;
                                [self.firstRegView addSubview:jobHeader];
                                
                                UIImageView *confirmImg = [[UIImageView alloc]initWithFrame:CGRectMake(i % 3 * 88 + 20 + 60, i / 3 * 88 + 80 - 10, 20, 20)];
                                confirmImg.image = [UIImage imageNamed:@"职位匹配@3x_06.png"];
                                confirmImg.userInteractionEnabled = YES;
                                [confirmImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmTap:)]];
                                [self.firstRegView addSubview:confirmImg];
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                    {
                        
                        
                    }
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
        
        
            
            
            
        }
    }

    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"])
    {
    
        [self startCategoryConnection];
    }
    
   
    UITabBarController *tabController = self.navigationController.tabBarController;
    UIViewController *requiredViewController = [tabController.viewControllers objectAtIndex:2];
    if (requiredViewController!= nil) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"] == nil) {
            [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"lyArr"];
            
        }else{
            
            
        }
        NSArray *lyArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"];
        
        
        UITabBarItem *item = requiredViewController.tabBarItem;
        if (lyArr.count == 0) {
            [item setBadgeValue:nil];
        }else{
            [item setBadgeValue:[NSString stringWithFormat:@"%ld",lyArr.count]];
        }
    }
    
//    UIViewController *rootController = self.navigationController.topViewController;
    
}
- (void)sendRegistMessage
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(sendMessageWithTime:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self removeFirstRegistView];
            

        
}
- (void)sendMessageWithTime:(NSTimer *)time
{
    if (self.jobsArr.count == 0) {
        [time invalidate];
        time = nil;
       
    }else{
    NSDictionary *diccc = [self.jobsArr objectAtIndex:0];
    [self.jobsArr removeObject:diccc];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:diccc];
    NSString *objectId = [[dic objectForKey:@"user"]objectForKey:@"im_id"];
    NSString *messageStr;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
        
        messageStr = [NSString stringWithFormat:@"您好，我对您发布的%@很感兴趣，想和您聊聊，期待您的回复",[dic objectForKey:@"title"]];
    }
    self.client = [AVIMClient defaultClient];
    
    [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
            
            [attributes setObject:[dic objectForKey:@"id"] forKey:@"jdId"];
            
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                
                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                
                
            }
            [attributes setObject:@"1" forKey:@"type"];
            
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:messageStr attributes:attributes];
            
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    [FMDBMessages saveMessageWhenSend:message Rid:objectId];
                    
                    
                    
                    NSDictionary *attributes = message.attributes;
                    NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                    //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                    [conDic setObject:objectId forKey:@"yourId"];
                    [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                    [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                    [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                    [conDic setObject:message.text forKey:@"lastText"];
                    [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                    [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
                    
                    
                    
                    AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:objectId];
                    
                    [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (error) {
                            
                            return ;
                        }
                        NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                        NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                        
                        
                        if (name == nil) {
                            [conDic setObject:@"" forKey:@"name"];
                        }else{
                            [conDic setObject:name forKey:@"name"];
                        }
                        if (header != nil) {
                            
                            [conDic setObject:header forKey:@"header"];
                        }
                        
                        [FMDBMessages judgeConversationExist:conDic];
                        
                    }];
                    
                    
                    
                }
                
            }];
            
        }];
        
    }];
    }
}
- (void)confirmTap:(UITapGestureRecognizer *)tap
{
    UIImageView *img = (UIImageView *)tap.view;
    if ([img.image isEqual: [UIImage imageNamed:@"职位匹配@3x_06.png"]]) {
        img.image = [UIImage imageNamed:@"职位匹配@3x_09.png"];
    }else if ([img.image isEqual: [UIImage imageNamed:@"职位匹配@3x_09.png"]])
    {
        img.image = [UIImage imageNamed:@"职位匹配@3x_06.png"];
    }
}
- (void)removeFirstRegistView
{
    for (UIView *view in self.backView.subviews) {
        [view removeFromSuperview];
        
    }
    [self.backView removeFromSuperview];
    self.backView = nil;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.titleArr = [NSMutableArray array];
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    self.rsListUrl = @"http://api.zzd.hidna.cn/v1/rs/list";
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    _titleLabel.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"title"];
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleSelect)]];
    _titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    _titleLabel.textAlignment = 1;
    
    _titleLabel.textColor = [UIColor whiteColor];
    
    self.titleButtonView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 120, 40)];
    
//    self.titleButtonView.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSetting:)];
    
//    [self.titleButtonView addGestureRecognizer:titleTap];
//    self.titleButtonView.backgroundColor = [UIColor whiteColor];
    self.titleButtonView.showsVerticalScrollIndicator = NO;
    self.titleButtonView.showsHorizontalScrollIndicator = NO;
    self.userState = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
    
//    self.titleText  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
//   
//    self.titleText.textColor = [UIColor whiteColor];
//    
//    self.titleText.font =  [[FontTool customFontArrayWithSize:18]objectAtIndex:1];
//    
//    self.titleText.textAlignment = 1;
//    
//    [self.titleButtonView addSubview:self.titleText];
    
//    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(85, 12, 15, 15)];
//    
//    self.titleImage.image = [UIImage imageNamed:@"39.png"];
// 
//    [self.titleButtonView addSubview:self.titleImage];
    
    
    self.cityBtn = [[UILabel alloc]initWithFrame:CGRectMake(-20, 0, 100, 40)];
    self.cityBtn.textColor = [UIColor whiteColor];
    self.cityBtn.textAlignment = 1;
    self.cityBtn.userInteractionEnabled = YES;
    [self.cityBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCity)]];
    self.cityBtn.font = [UIFont systemFontOfSize:14];

    UIImageView *locationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(9, 11, 15, 16)];
    UIImage *img = [UIImage imageNamed:@"Group 9 Copy 2.png"];
       locationIcon.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate
                             ];
    locationIcon.userInteractionEnabled = YES;
    [locationIcon setTintColor:[UIColor whiteColor]];
    [self.cityBtn addSubview:locationIcon];
    if ([self.userState isEqualToString:@"2"]) {
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:self.titleButtonView];
        self.navigationItem.titleView = nil;
    }
    if ([self.userState isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cityBtn];
        self.cityBtn.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"city"];
        self.navigationItem.titleView = self.titleLabel;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBackImage];
    [self createMainViewTable];
    [self createSearchRange];
    [self getConnection];
    [self createAlertTable];
    [self createTitleTable];
            [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
    [self getScrollShowViewValue];
    
    
    
    
    
    __weak typeof(self)weakSelf = self;
    
    self.timer = [NSTimer clscheduledTimerWithTimeInterval:3.0 block:^{
        if (weakSelf.scrollShowView) {
            
            
            if (weakSelf.scrollShowView.contentOffset.y == (weakSelf.showArr.count - 1) * 30) {
                weakSelf.scrollShowView.contentOffset = CGPointMake(0, 0);
            }
            [weakSelf.scrollShowView setContentOffset:CGPointMake(0, weakSelf.scrollShowView.contentOffset.y + 30) animated:YES];
        }
        if (weakSelf.headerArr.count > 1) {
            
        
        if (weakSelf.headerImg) {
            
            [weakSelf.headerImg setContentOffset:CGPointMake((NSInteger)(weakSelf.headerImg.contentOffset.x/weakSelf.view.frame.size.width) * weakSelf.view.frame.size.width  + weakSelf.view.frame.size.width, 0) animated:YES];
        }
        }
    } repeats:YES];
    
    
   
}
- (void)titleSelect
{
    JobSelectTypeViewController *jobSelect = [[JobSelectTypeViewController alloc]init];
    jobSelect.dataArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"] objectForKey:@"category"];
    jobSelect.delegate = self;
    jobSelect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jobSelect animated:YES];
}
- (void)getTitleAndCategory:(NSDictionary *)dic
{
    
    NSMutableDictionary *rsDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]];
    [rsDic setValuesForKeysWithDictionary:dic];
    
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *urlRS;
    if ([[userDic objectForKey:@"resume_id"] isEqualToString: @"0"]) {
        urlRS = @"http://api.zzd.hidna.cn/v1/rs";
    }else
    {
        urlRS = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[userDic objectForKey:@"resume_id"]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlRS,[userDic objectForKey:@"token"],time];
        [rsDic setObject:time forKey:@"timestamp"];
        [rsDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [rsDic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        
        if ([rsDic objectForKey:@"tag_user"]!= nil){
            if ([[rsDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:[rsDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                [rsDic setObject:jsonString1 forKey:@"tag_user"];
                
            }else{
                [rsDic setObject:[rsDic objectForKey:@"tag_user"] forKey:@"tag_user"];
            }
        }
        [manager POST:urlRS  parameters:rsDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                
                
                
                
                [rsDic setObject:userDic forKey:@"user"];
                
                [rsDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"id"];
                [[NSUserDefaults standardUserDefaults]setObject:rsDic forKey:@"rs"];
               
                _titleLabel.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"title"];
                [self refreshHeader];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
    

    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)selectCity
{
    
    self.pickerArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    self.pickerSubArr = [[self.pickerArr objectAtIndex:0]objectForKey:@"data"];
    //        self.currentValue = @"上海";
    self.city = @"上海";
    self.province = @"上海";
    self.cityId = @"862";
    self.provinceId = @"861";
  
    
    
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.pickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height - 200)];
        self.pickerBackView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        self.pickerBackView.userInteractionEnabled = YES;
        [app.window addSubview:self.pickerBackView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToWindow)];
        [self.pickerBackView addGestureRecognizer:tap];
        
        self.pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, app.window.frame.size.height - 200, app.window.frame.size.width, 200)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [app.window addSubview:self.pickerView];
        
        self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, app.window.frame.size.width, 150)];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self.pickerView addSubview:self.picker];
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(app.window.frame.size.width - 50, 10, 30, 30)];
        rightView.image = [UIImage imageNamed:@"icon_right(1).png"];
        rightView.userInteractionEnabled = YES;
        UITapGestureRecognizer *completeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(completeTap)];
        [rightView addGestureRecognizer:completeTap];
        [self.pickerView addSubview:rightView];
        
    
}
- (void)completeTap
{
    [self backToWindow];
    NSMutableDictionary *rsDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]];
    [rsDic setObject:self.provinceId forKey:@"province_id"];
    [rsDic setObject:self.province forKey:@"province"];
    [rsDic setObject:self.city forKey:@"city"];
    [rsDic setObject:self.cityId forKey:@"city_id"];
    
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *urlRS;
    if ([[userDic objectForKey:@"resume_id"] isEqualToString: @"0"]) {
        urlRS = @"http://api.zzd.hidna.cn/v1/rs";
    }else
    {
        urlRS = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[userDic objectForKey:@"resume_id"]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlRS,[userDic objectForKey:@"token"],time];
        [rsDic setObject:time forKey:@"timestamp"];
        [rsDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [rsDic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        
        if ([rsDic objectForKey:@"tag_user"]!= nil){
            if ([[rsDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:[rsDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                [rsDic setObject:jsonString1 forKey:@"tag_user"];
                
            }else{
                [rsDic setObject:[rsDic objectForKey:@"tag_user"] forKey:@"tag_user"];
            }
        }
        [manager POST:urlRS  parameters:rsDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
               
                
                
               
                [rsDic setObject:userDic forKey:@"user"];
              
                [rsDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"id"];
                [[NSUserDefaults standardUserDefaults]setObject:rsDic forKey:@"rs"];
                self.cityBtn.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"city"];
                [self refreshHeader];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    



}
- (void)backToWindow
{
    [self.picker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.pickerBackView removeFromSuperview];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
   
        return 2;
    
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 1) {
        return [self.pickerSubArr count];
    }else{
        return [self.pickerArr count];
    }
    
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 1) {
        return [[self.pickerSubArr objectAtIndex:row]objectForKey:@"name"];
    }else{
        return [[self.pickerArr objectAtIndex:row]objectForKey:@"name"];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        if (component == 1) {
            
            self.cityId = [[self.pickerSubArr objectAtIndex:row]objectForKey:@"id"];
            self.city = [[self.pickerSubArr objectAtIndex:row]objectForKey:@"name"];
            
            
        }else if(component == 0)
        {
            self.pickerSubArr = [[self.pickerArr objectAtIndex:row]objectForKey:@"data"];
            [self.picker reloadComponent:1];
            self.province = [[self.pickerArr objectAtIndex:row]objectForKey:@"name"];
            self.provinceId = [[self.pickerArr objectAtIndex:row]objectForKey:@"id"];
            self.city = [[self.pickerSubArr objectAtIndex:0]objectForKey:@"name"];
            self.cityId = [[self.pickerSubArr objectAtIndex:0]objectForKey:@"id"];
            
        }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[[FontTool customFontArrayWithSize:16]objectAtIndex:1]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)createBackImage
{
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3 + 10, self.view.frame.size.height * 2 /3 + 20, self.view.frame.size.width / 3 - 20, 30)];
    
    self.backButton.backgroundColor = [UIColor zzdColor];
    
    self.backButton.layer.masksToBounds = YES;
    
    self.backButton.layer.cornerRadius = 7;
    
    self.backButton.alpha = 0.8;
    
    self.backButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.backButton addTarget:self action:@selector(createNewJob) forControlEvents:UIControlEventTouchUpInside];
    
//    self.backImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3 - 20, self.view.frame.size.height /3  , self.view.frame.size.width/3 + 40, self.view.frame.size.height /3 - 10)];
//    
//    self.backImage.alpha = 0.8;
    
}

- (void)getWhatILike
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *url = @"http://api.zzd.hidna.cn/v1/my/favorite";
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:time forKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
            
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
            
            [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    [self.collectArr removeAllObjects];
                    
                    self.collectArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
                
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                   if ([AVUser currentUser].objectId != nil) {
                    AVIMClient * client = [AVIMClient defaultClient];
                    [client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
                        
                    }];
                    
                    if (client!=nil && client.status == AVIMClientStatusOpened) {
                        [AVUser logOut];
                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    } else {
                        [AVUser logOut];
                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    }
                   }else{
                       [AVUser logOut];
                       [self log];
                   }
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)log
{
    [AVUser logOut];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
    ZZDLoginViewController *login = [[ZZDLoginViewController alloc]init];
    
    UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:login];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = navLogin;
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (app.alert == nil) {
        app.alert = [[ZZDAlertView alloc]initWithView:app.window];
        [app.alert setTitle:@"转折点提示" detail:@"您的账号在另外一台设备上登录" alert:ZZDAlertStateNormal];
        [app.window addSubview:app.alert];
    }else
    {
//        app.alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您的账号在另外一台设备上登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [app.alert show];
    }
    
}


- (void)createTitleTable
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"jd"] == NULL) {
        [self startCategoryConnection];
        
    }else{
        [self startCategoryConnection];
    }
    
    self.titleTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 120, 0, 240, 0)];
    
    self.titleTable.tag = 70;
    
    self.titleTable.rowHeight = 40;
    
    self.titleTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.titleTable.layer.borderWidth = 0.5;
    
    self.titleTable.layer.cornerRadius = 7;
    
    self.titleTable.showsVerticalScrollIndicator = NO;
    
    self.titleTable.scrollEnabled = YES;
    
    self.titleTable.delegate = self;
    
    self.titleTable.dataSource = self;
    
    [self.view addSubview:self.titleTable];
    
    self.titleTableView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 10 , 65, 20, 0)];
    
    self.titleTableView.image = [UIImage imageNamed:@"icon_b.png"];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.window addSubview:self.titleTableView];
    
}
- (void)titleTap:(UITapGestureRecognizer *)tap
{
    TitleLabel *titleLabel = (TitleLabel *)tap.view;
    for (TitleLabel *titleLb in self.titlesArr) {
        titleLb.textColor = [UIColor colorFromHexCode:@"#999"];
        
        
    }
    titleLabel.textColor = [UIColor whiteColor];
    
    [self.titleButtonView setContentOffset:CGPointMake(titleLabel.frame.origin.x , 0) animated:YES];
    [self.otherDic setObject:titleLabel.idStr forKey:@"sub_category_id"];
    self.jdId = titleLabel.idStr;
    
    
    [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
    
}
- (void)startCategoryConnection
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
    
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        
        [parameters setObject:time forKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/my/category||%@||%@",[dic objectForKey:@"token"],time];
        
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        [self.manager GET:@"http://api.zzd.hidna.cn/v1/jd/my/category" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                self.titleArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
                for (TitleLabel *titleLb in self.titlesArr) {
                    if ([titleLb isKindOfClass:[TitleLabel class]]) {
                        [titleLb removeFromSuperview];
                    }
                }
                [self.titlesArr removeAllObjects];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
                    
                if (self.titleArr.count == 0) {
                    
                    self.rsListUrl = @"http://api.zzd.hidna.cn/v1/rs/em_lists";
                    
                    [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
//                    [self.view addSubview:self.backImage];
                    
//                    [self.view addSubview:self.backButton];
                    
//                    [self.view sendSubviewToBack:self.backImage];
                    
//                    [self.view sendSubviewToBack:self.backButton];
                    
//                    [self.view sendSubviewToBack:self.mainViewTable];
                    [self createBossBackView];
                    }else{
                        
                        

                        
                        
//                        [self.backImage removeFromSuperview];
                        self.rsListUrl = @"http://api.zzd.hidna.cn/v1/rs/list";
                        
                        [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
                        
                        
                        [self.backButton removeFromSuperview];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:self.titleArr forKey:@"jdList"];
                        CGFloat length = 0;
                        for (int i = 0; i < self.titleArr.count; i++) {
                            TitleLabel *titleLabel = [[TitleLabel alloc]initWithFrame:CGRectMake(length + 10, 5, 0, 30)];
                            titleLabel.text = [[self.titleArr objectAtIndex:i]objectForKey:@"name"];
                            titleLabel.titleStr = [[self.titleArr objectAtIndex:i]objectForKey:@"name"];
                            titleLabel.userInteractionEnabled = YES;
                            [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)]];
                            titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
                            titleLabel.textColor = [UIColor colorFromHexCode:@"#999"];
                            titleLabel.idStr = [[self.titleArr objectAtIndex:i]objectForKey:@"id"];
                            if (i == 0) {
                                titleLabel.textColor = [UIColor whiteColor];
                                
                                [self.otherDic setObject:titleLabel.idStr forKey:@"sub_category_id"];
                                self.jdId = titleLabel.idStr;
                                
                                
                                [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
                                
                            }
                            [self.titleButtonView addSubview:titleLabel];
                            CGSize labelSize = [UILableFitText fitTextWithHeight:30 label:titleLabel ];
                            titleLabel.frame = CGRectMake(length + 10, 5, labelSize.width, 30);
                            
                            length = length + 10 + labelSize.width;
                            [self.titlesArr addObject:titleLabel];
                            
                        }
                        if (length < (self.view.frame.size.width - 100)) {
                            length = self.view.frame.size.width - 100;
                        }
                        self.titleButtonView.contentSize = CGSizeMake(length + 10, 30);
                        
                    }
                    
                }
                
                if (self.b >= 0) {
                    if (self.titleArr.count > 0) {
 
                    self.titleText.text =  [[self.titleArr objectAtIndex:0]objectForKey:@"name"];
                        
                    [self.otherDic setObject:[[self.titleArr objectAtIndex:self.b] objectForKey:@"id"] forKey:@"sub_category_id"];
                        
                    [self.titleTable reloadData];
                        
                    }
                }else{
                    if (self.titleArr.count > 0) {
                        self.titleText.text = @"进行筛选";
                        
                        self.b = -10;
                        
                        [self.titleTable reloadData];
                        
                    }else{
                        self.titleText.text = @"暂无数据";
                    }
                }
                [self.titleTable reloadData];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                ZZDLoginViewController *login = [[ZZDLoginViewController alloc]init];
                
                UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:login];
                
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                app.window.rootViewController = navLogin;
                
                [self.navigationController popToRootViewControllerAnimated:YES];

                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
                    [AVUser logOut];
                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                } else
                {
                    [AVUser logOut];
                    [self log];
                }
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)openSetting:(id)sender
{
    if (self.isSelected) {
        
        self.titleImage.transform = CGAffineTransformMakeRotation(0*M_PI/180);
        
        self.isSelected = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.titleTable.frame =  CGRectMake(self.view.frame.size.width / 2 - 120, 0, 240, 0);
            
            self.titleTableView.frame = CGRectMake(self.view.frame.size.width / 2 - 15 , 65, 20, 0);
        }];
    }else{
        self.titleImage.transform = CGAffineTransformMakeRotation(180*M_PI/180);
        
        self.isSelected = 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.titleTable.frame = CGRectMake(self.view.frame.size.width / 2 - 120, 0, 240, 40 * self.titleArr.count);
            
            self.titleTableView.frame = CGRectMake(self.view.frame.size.width / 2 - 15 , 60, 20, 10);
        }];
    }
}
- (void)getConnection:(NSString *)page num:(NSString *)num dic:(NSDictionary *)otherDic
{
    if (!_slimeView.loading) {
        if (!self.hud) {
            
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        //    self.hud.labelText = @"加载中";
        
        //    self.hud.labelColor = [UIColor whiteColor];
        //    self.hud.detailsLabelColor = [UIColor whiteColor];
        self.hud.activityIndicatorColor = [UIColor zzdColor];
        [self.hud setColor:[UIColor clearColor]];
        
        self.hud.delegate = self;
        [self.view addSubview:self.hud];
        [self.hud show:YES];
        }
        
    }else{
        self.view.userInteractionEnabled = NO;
    }
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:page forKey:@"page_num"];
    
    [dic setObject:num forKey:@"limit"];
    
    [dic addEntriesFromDictionary:otherDic];
    
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    NSString *urlStr = @"";
    
    
    
    if ([self.userState isEqualToString:@"1"])
    {
        urlStr = @"http://api.zzd.hidna.cn/v1/jd/list";
        
    }else if ([self.userState isEqualToString:@"2"])
    {
        urlStr = self.rsListUrl;
    }
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlStr,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        [dic setObject:time forKey:@"timestamp"];
        
        [self.manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                if ([page isEqualToString:@"0"]) {
                    
                [self.mainArr removeAllObjects];
                    
                NSArray *arr = [responseObject objectForKey:@"data"];
                    
                if (arr.count == 0) {
                    NSLog(@"查无结果");
                    }
                }
                
                [self.mainArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
                
                
//                if ([self.userState isEqualToString:@"2"])
//                {
//                    NSMutableDictionary *robotDic = [[NSMutableDictionary alloc]init];
//                    [robotDic setObject:@"13" forKey:@"browser_num"];
//                    [robotDic setObject:@"销售" forKey:@"category"];
//                    [robotDic setObject:@"3" forKey:@"category_id"];
//                    [robotDic setObject:@"上海市" forKey:@"city"];
//                    [robotDic setObject:@"862" forKey:@"city_id"];
//                    [robotDic setObject:@[] forKey:@"edu"];
//                    [robotDic setObject:@"0" forKey:@"favorite"];
//                    [robotDic setObject:@"1" forKey:@"favorite_num"];
//                    [robotDic setObject:@"1158" forKey:@"id"];
//                    [robotDic setObject:@[] forKey:@"job"];
//                    [robotDic setObject:@"861" forKey:@"province_id"];
//                    [robotDic setObject:@"5k-10k" forKey:@"salary"];
//                    [robotDic setObject:@"4" forKey:@"salary_id"];
//                    [robotDic setObject:@"" forKey:@"self_summary"];
//                    [robotDic setObject:@"" forKey:@"sub_category"];
//                    [robotDic setObject:@"0" forKey:@"sub_category_id"];
//                    [robotDic setObject:@[@{@"id":@"7",@"name":@"制药企业"},@{@"id":@"8",@"name":@"移动医疗"},@{@"id":@"14",@"name":@"试剂耗材"}] forKey:@"tag_user"];
//                    [robotDic setObject:@"区域经理" forKey:@"title"];
//                    [robotDic setObject:@"0" forKey:@"uid"];
//                    [robotDic setObject:@"" forKey:@"work_address"];
//                    [robotDic setObject:@"1" forKey:@"work_state"];
//                    [robotDic setObject:@"5-10年" forKey:@"work_year"];
//                    [robotDic setObject:@"5" forKey:@"work_year_id"];
//                    [robotDic setObject:@{@"avatar":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489715280&di=07dd0eecf34225578b4be6f408d779c8&imgtype=jpg&er=1&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-06%2F034453410.jpg",@"highest_edu":@"学历未填",@"im_id":@"5853f182b123db006565110e",@"name":@"千画",@"sex":@"女",@"title":@"区域经理"} forKey:@"user"];
//                    [robotDic setObject:@"yes" forKey:@"robot"];
//                    [self.mainArr insertObject:robotDic atIndex:0];
                
                    
                    
//                }
                [self.mainViewTable reloadData];
                
                [self.titleTable reloadData];
                self.slimeView.loading = NO;
                self.slimeView.slime.state = SRSlimeStateNormal;
                
                
                [self.mainViewTable.footer endRefreshing];
                
                [self.mainViewTable.header endRefreshing];
                
                self.hud.hidden = YES;
                [self judgeConversationArr:self.mainArr.copy];
                [self.hud removeFromSuperViewOnHide];
                self.hud = nil;
                
            }
            self.view.userInteractionEnabled = YES;
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
           self.view.userInteractionEnabled = YES;
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
    }];
}
- (void)judgeConversationArr:(NSArray *)arr
{
    if (arr.count > 0) {
        if (self.backGroundView) {
            [self.backGroundView removeFromSuperview];
            self.backGroundView = nil;
        }
    }else{
        if (self.backGroundView) {
            
        }else{
            self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height / 3 + 30, 100, 100)];
            UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, 50, 50)];
            backImage.image = [UIImage imageNamed:@"duihuakuang.png"];
            
            UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50,100, 30)];
            backLabel.text = @"查无搜索结果";
            backLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
            backLabel.textColor = [UIColor colorFromHexCode:@"#999999"];
            backLabel.textAlignment = 1;
            [self.backGroundView addSubview:backLabel];
            [self.backGroundView addSubview:backImage];
            [self.mainViewTable addSubview:self.backGroundView];
        }
    }
}

- (void)createAlertTable
{
    self.alertTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    
    self.alertTable.tag = 23;
    
    self.alertTable.delegate = self;
    
    self.alertTable.dataSource = self;
    
    self.alertTable.rowHeight = 40;
    
    self.alertTable.backgroundColor = [UIColor whiteColor];
    
    self.alertTable.scrollEnabled = NO;
    
    self.alertTable.showsVerticalScrollIndicator = NO;
    
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.backView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMain)];
    
    [self.backView addGestureRecognizer:backTap];
    
    [self.view addSubview:self.backView];
    
    [self.view addSubview:self.alertTable];
}
- (void)backToMain
{
    self.alertTable.frame = CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, 0);
    
    self.backView.backgroundColor = [UIColor clearColor];
    
    self.backView.frame = CGRectZero;
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.image.transform = CGAffineTransformMakeRotation(0*M_PI/180);
    
}
- (void)createSearchRange
{
    
    UIView *mainSearchView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    mainSearchView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:mainSearchView];
    
    NSArray *titleArr = @[@"薪水",@"经验",@"学历"];
    
    for (int i = 0; i < 3; i++) {
        
        ButtonView *buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width / 3, 0, self.view.frame.size.width / 3 - 0.5, 50) title:[titleArr objectAtIndex:i]];
        
        buttonView.delegate = self;
        
        buttonView.tag = 150 + i;
        
        buttonView.backgroundColor = [UIColor whiteColor];
        
        [mainSearchView addSubview:buttonView];
    }
    for (int i = 0; i < 2; i++) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake( (i + 1) * self.view.frame.size.width / 3 - 0.5, 15, 0.5, 20)];
        
        lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        [mainSearchView addSubview:lineView];
    }
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, self.view.frame.size.width, 0.5)];
//    
//    lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
//    
//    [mainSearchView addSubview:lineView];
    
    mainSearchView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    mainSearchView.layer.shadowOffset = CGSizeMake(0, 0);
    mainSearchView.layer.shadowOpacity = 0.6;
    
    }
- (void)getConnection
{
    self.dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];
}
- (void)toDoSomeThingWithTitle:(NSString *)title image:(UIImageView *)image
{
    self.image = image;
    
    _image.transform = CGAffineTransformMakeRotation(180*M_PI/180);
    
    self.alertTitle = title;
    
    if (self.dataDic.count != 0) {
        
        if ([title isEqualToString:@"薪水"]) {
            
            self.alertArr = [self.dataDic objectForKey:@"salary"];
        }
        else if([title isEqualToString:@"经验"]){
            
            self.alertArr = [self.dataDic objectForKey:@"work_year"];
            
        }
        else if([title isEqualToString:@"学历"]){
            
            self.alertArr = [self.dataDic objectForKey:@"education"];
        }
    }
    [self toChangeSomething];
}

- (void)toChangeSomething
{
    self.backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.alertTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40 * self.alertArr.count);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        self.alertTable.frame = CGRectMake(0, self.view.frame.size.height - (self.alertArr.count + 2) * 40, self.view.frame.size.width, 40 * (self.alertArr.count + 2 ));
        
        self.tabBarController.tabBar.hidden = YES;
    }];
    
    [self.alertTable reloadData];
}
- (void)getScrollShowViewValue
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *url = @"http://api.zzd.hidna.cn/v1/user/getApplicantInfo";
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:time forKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
            
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            
            [parameters setObject:([self.userState isEqualToString: @"1"])?@"2":@"1" forKey:@"userStatus"];
//            [parameters setObject:self.userState forKey:@"userStatus"];
            
            [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    [self createScrollShowViewWithArray:[responseObject objectForKey:@"data"]];
                    self.showArr = [responseObject objectForKey:@"data"];
                    [self upLoadHeaderImg];
                }
                        
                
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (void)upLoadHeaderImg
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *url = @"http://api.zzd.hidna.cn/v1/getHomeImageList";
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:time forKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
            
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            
          
            [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[[responseObject objectForKey:@"data"]objectForKey:@"pics"]]placeholderImage:[UIImage imageNamed:@"wwxxswwww.png"]];
//                    self.headerImg.userInteractionEnabled = YES;
//                    [self.headerImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap)]];
//                    
//                    self.imgUrl = [[responseObject objectForKey:@"data"]objectForKey:@"href"];
                    
                    self.headerArr =[responseObject objectForKey:@"data"];
                    if (self.headerArr.count > 1) {
                        NSMutableArray *headerMutableArr = [NSMutableArray arrayWithArray:self.headerArr];
                        
                        [headerMutableArr addObject:[self.headerArr firstObject]];
                        [headerMutableArr insertObject:[self.headerArr lastObject] atIndex:0];
                        self.headerArr = headerMutableArr.copy;
                        
                    }
                    for (int i = 0 ; i < self.headerArr.count; i ++) {
                        UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.width / 2)];
                        [headerImg sd_setImageWithURL:[NSURL URLWithString:[[self.headerArr objectAtIndex:i]objectForKey:@"pics"]]placeholderImage:[UIImage imageNamed:@"banner1750.png"]];
                       headerImg.userInteractionEnabled = YES;
                        headerImg.tag = 400 + i;
                        [headerImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)]];
                        [self.headerImg addSubview:headerImg];
                    }
                    if (self.headerArr.count > 1) {
                        self.headerImg.contentOffset = CGPointMake(self.view.frame.size.width, 0);
                    }
                    self.headerImg.contentSize = CGSizeMake(self.view.frame.size.width * self.headerArr.count, self.view.frame.size.width / 2);
                }
                
                
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)imgTap:(UITapGestureRecognizer *)tap
{
    NSInteger count = tap.view.tag - 400;
    NSDictionary *dic = [self.headerArr objectAtIndex:count];
    GoodCompanyDetailViewController *companyDetail = [[GoodCompanyDetailViewController alloc]init];
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
    NewZZDPeopleViewController *workDetail = [[NewZZDPeopleViewController alloc]init];
    GoodCompanyJobsViewController *bossJobs = [[GoodCompanyJobsViewController alloc]init];
     AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
     NSString *uid1  = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"];
    switch ([[dic objectForKey:@"show_type"]integerValue]) {
        case 1://人才普通
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[dic objectForKey:@"href"]]];
            break;
        case 2://人id
            
            bossJobs.jobId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"href"]];
            [self.navigationController pushViewController:bossJobs animated:YES];
            break;
        case 3://名企id
            
            companyDetail.mainDic = [[dic objectForKey:@"data"]objectAtIndex:0];
            [self.navigationController pushViewController:companyDetail animated:YES];
            break;
        case 4://岗位id
            
            jobDetail.dic = [[dic objectForKey:@"data"]objectAtIndex:0];
            
            jobDetail.hidesBottomBarWhenPushed = YES;
           
                
          jobDetail.collectType = @"NO";
                
            
            
            [self.navigationController pushViewController:jobDetail animated:YES];
            break;
            
        case 5://boss普通
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[dic objectForKey:@"href"]]];
            break;
        case 6://人id
            
            workDetail.collectType = @"NO";
            workDetail.dic = [[dic objectForKey:@"data"]objectAtIndex:0];
            workDetail.jdId = self.jdId;
            workDetail.hidesBottomBarWhenPushed = YES;
            if (self.jdId != nil) {
                [self.navigationController pushViewController:workDetail animated:YES];
            }
            break;
        case 7://人id
           
           
            aboutUs.url = [NSString stringWithFormat:@"%@?uid=%@",[dic objectForKey:@"href"],uid1];
            aboutUs.ddd = @"1";
            aboutUs.imgUrl = [dic objectForKey:@"share_img"];
            aboutUs.hidesBottomBarWhenPushed = YES;
            if (uid1.length > 0) {
                
            
            [self.navigationController pushViewController:aboutUs animated:YES];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先登录/注册"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"返回"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
            break;
        default:
            break;
    }
    [MobClick event:@"HeaderBanner"];
    [AVAnalytics event:@"HeaderBanner"]; 
    
}
- (void)createScrollShowViewWithArray:(NSArray *)arr
{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width  / 2 + 30)];
    self.scrollShowView = [[UIScrollView alloc]initWithFrame:CGRectMake(30,  self.view.frame.size.width  / 2, self.view.frame.size.width - 30, 30)];
    self.scrollShowView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    for (int i = 0 ; i < arr.count; i++) {
        UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 * i, self.view.frame.size.width - 90, 30)];
        
        
        NSString *str;
        NSMutableAttributedString *AttributedStr;
        if ([self.userState isEqualToString:@"1"])
        {
            
            if ([[[arr objectAtIndex:i]objectForKey:@"type"]intValue]==2) {
                
            
            str = [NSString stringWithFormat:@"%@%@%@发布了%@",[[arr objectAtIndex:i]objectForKey:@"cp_sub_name"],[[arr objectAtIndex:i]objectForKey:@"boss_title"],[[arr objectAtIndex:i]objectForKey:@"name"],[[arr objectAtIndex:i]objectForKey:@"title"]];
            
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:14.0]
             
                                  range:NSMakeRange(0, str.length)];
            
            NSString *titleStr = [[arr objectAtIndex:i]objectForKey:@"title"];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorFromHexCode:@"#666"]
             
                                  range:NSMakeRange(0, str.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorFromHexCode:@"#38ab99"]
             
                                  range:NSMakeRange(str.length - titleStr.length, titleStr.length)];
            }else{
                str = [NSString stringWithFormat:@"%@%@%@来招人了",[[arr objectAtIndex:i]objectForKey:@"cp_sub_name"],[[arr objectAtIndex:i]objectForKey:@"title"],[[arr objectAtIndex:i]objectForKey:@"name"]];
                
                AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:14.0]
                 
                                      range:NSMakeRange(0, str.length)];
                
                NSString *titleStr = [[arr objectAtIndex:i]objectForKey:@"cp_sub_name"];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:[UIColor colorFromHexCode:@"#666"]
                 
                                      range:NSMakeRange(0, str.length)];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:[UIColor colorFromHexCode:@"#38ab99"]
                 
                                      range:NSMakeRange(0, titleStr.length)];
            }
        }else if ([self.userState isEqualToString:@"2"])
        {
            str = [NSString stringWithFormat:@"%@加入了转折点,求职方向%@",[[arr objectAtIndex:i]objectForKey:@"name"],[[arr objectAtIndex:i]objectForKey:@"title"]];
            
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:14.0]
             
                                  range:NSMakeRange(0, str.length)];
            
            NSString *titleStr = [[arr objectAtIndex:i]objectForKey:@"title"];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorFromHexCode:@"#666"]
             
                                  range:NSMakeRange(0, str.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorFromHexCode:@"#38ab99"]
             
                                  range:NSMakeRange(str.length - titleStr.length, titleStr.length)];
        }
        
        showLabel.attributedText = AttributedStr;
        showLabel.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
//        showLabel.textColor = [UIColor colorFromHexCode:@"#666"];
        showLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        [self.scrollShowView addSubview:showLabel];
        
        UILabel *timeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 93, 30 * i, 72, 30)];
        timeShowLabel.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
        timeShowLabel.textColor = [UIColor colorFromHexCode:@"#999"];
        timeShowLabel.text = [NSString stringWithFormat:@"%@前",[TimeTool judgeTimeBetweenNow:[[arr objectAtIndex:i]objectForKey:@"created_at"]]];
        timeShowLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        [self.scrollShowView addSubview:timeShowLabel];
        
        self.scrollShowView.userInteractionEnabled = NO;
    }
    
    UIImageView *labaView = [[UIImageView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.width / 2 + 3, 24, 24)];
    labaView.image = [UIImage imageNamed:@"dalaba.png"];
    [tableHeaderView addSubview:labaView];
    self.scrollShowView.contentSize = CGSizeMake(0, arr.count * 30);
    
    [tableHeaderView addSubview:self.scrollShowView];
    
    self.headerImg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 2)];
    self.headerImg.pagingEnabled = YES;
    self.headerImg.tag = 776;
    self.headerImg.delegate = self;
//    self.headerImg.image = [UIImage imageNamed:@"wwxxswwww.png"];
    [tableHeaderView addSubview:self.headerImg];
    
    self.mainViewTable.tableHeaderView = tableHeaderView;
    
    
    
}
- (void)createMainViewTable
{
    self.mainViewTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50 , self.view.frame.size.width, self.view.frame.size.height - 50 ) style:UITableViewStylePlain];
    
    self.mainViewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mainViewTable.delegate = self;
    
    self.mainViewTable.dataSource = self;
    
    self.mainViewTable.rowHeight = 125;
    
    
    self.mainViewTable.showsVerticalScrollIndicator = YES;
    
    self.mainViewTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    
    [self.view addSubview:self.mainViewTable];
    
//    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshHeader) userInfo:nil repeats:NO];
//    }];
//    normalHeader.stateLabel.textColor = [UIColor zzdColor];
////    normalHeader.stateLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    normalHeader.lastUpdatedTimeLabel.hidden = YES;
////    normalHeader.lastUpdatedTimeLabel.textColor = [UIColor zzdColor];
////    normalHeader.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    [normalHeader setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
//    
//    self.mainViewTable.header = normalHeader;
    
//    self.mainViewTable.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor hcColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 0.5;
    _slimeView.slime.shadowBlur = 3;
    _slimeView.slime.shadowColor = [UIColor whiteColor];
    
    self.mainViewTable.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self.mainViewTable addSubview:_slimeView];
    self.mainViewTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_slimeView update:0];

    
    
    
    MJRefreshBackNormalFooter *normalFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.a = self.a + 1;
        
        [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
    }];
    
    [normalFooter setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    
    normalFooter.stateLabel.textColor = [UIColor hcColor];
//    normalFooter.backgroundColor = [UIColor hcColor];
    normalFooter.arrowView.alpha = 0;
//    normalFooter.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    self.mainViewTable.mj_footer = normalFooter;
    
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            [_slimeView update:64];
        }else {
            [_slimeView update:32];
        }
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 776) {
        if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake( self.view.frame.size.width * (self.headerArr.count - 2), 0) ;
        }else
            if (scrollView.contentOffset.x ==  self.view.frame.size.width * (self.headerArr.count - 1))
        {
            scrollView.contentOffset = CGPointMake( self.view.frame.size.width, 0) ;
        }
    }else{
    [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
//    [_slimeView performSelector:@selector(endRefresh)
//                     withObject:nil afterDelay:3
//                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    [self refreshHeader];
}

- (void)refreshHeader
{
    self.a = 0;
    
    [self.mainArr removeAllObjects];
    
    [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 70) {
        
        return self.titleArr.count;

    }else if (tableView.tag == 23) {
        
            return self.alertArr.count + 2;
        
        }else{
            return self.mainArr.count;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 70) {
        
        static NSString *cellIdentify3 = @"cell3";
        
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentify3];
        
        if (!cell3) {
            cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify3];
        }
        cell3.textLabel.textAlignment = 1;
        
        cell3.textLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        
        if (indexPath.row == self.b) {
            cell3.textLabel.textColor = [UIColor zzdColor];
            
            cell3.textLabel.text = [NSString stringWithFormat:@"%@(当前)",[[self.titleArr objectAtIndex:indexPath.row]objectForKey:@"name"]];
         
        }else{
            cell3.textLabel.textColor = [UIColor grayColor];
            
            cell3.textLabel.text = [[self.titleArr objectAtIndex:indexPath.row]objectForKey:@"name"];
            
        }

        return cell3;
 
    }else if (tableView.tag == 23) {
        static NSString *cellIdentify = @"cell1";
        
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        
        if (!cell1) {
            
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell1.textLabel.font = [[FontTool customFontArrayWithSize:15]objectAtIndex:1];
        
        cell1.textLabel.textAlignment = 1;
        
        if (indexPath.row == 0) {
            
            cell1.textLabel.text = self.alertTitle;
            
            cell1.textLabel.textColor = [UIColor zzdColor];
            
        }else if(indexPath.row == 1){
            
            cell1.textLabel.text = @"不限";
            
            cell1.textLabel.textColor = [UIColor grayColor];
        }else{
            NSDictionary *dic = [self.alertArr objectAtIndex:indexPath.row - 2];
            
            cell1.textLabel.text = [dic objectForKey:@"name"];
            
            cell1.textLabel.textColor = [UIColor grayColor];
        }
        return cell1;
    }else{
        if ([self.userState isEqualToString:@"2"]) {
            
            static NSString *cellIdentify = @"cell";
            
            NewZZDPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
            
            if (!cell) {
                cell = [[NewZZDPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.mainArr.count != 0) {
                
//                [cell getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
                [cell setSubViewTextFromDic:[self.mainArr objectAtIndex:indexPath.row]];
                
            }
            return cell;
            
        }else if([self.userState isEqualToString:@"1"]){
            static NSString *cellIdentify2 = @"cell2";
            
            NewZZDBossCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentify2];
            
            if (!cell2) {
                
                cell2 = [[NewZZDBossCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify2];
            }
            
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.mainArr.count != 0) {
                
//                [cell2 getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
                [cell2 setSubViewTextFromDic:[self.mainArr objectAtIndex:indexPath.row]];
                
            }
            
            return cell2;
            
        }else{
            return nil;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"薪水",@"经验",@"学历"];
    self.myIndex = indexPath;
    NSInteger a = [titleArr indexOfObject:self.alertTitle];
    
    if (tableView.tag == 70) {
        
        self.b = (NSInteger)indexPath.row;
        
        NSDictionary *dic = [self.titleArr objectAtIndex:indexPath.row];
        
        self.titleText.text = [dic objectForKey:@"name"];
        
        self.titleImage.transform = CGAffineTransformMakeRotation(0*M_PI/180);
        
        self.isSelected = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.titleTable.frame =  CGRectMake(self.view.frame.size.width / 2 - 120, 0, 240, 0);
            
            self.titleTableView.frame = CGRectMake(self.view.frame.size.width / 2 - 15 , 65, 20, 0);
        }];
        self.a = 0;
        
        [self.otherDic removeAllObjects];
        
        [self.otherDic setObject:[dic objectForKey:@"id"] forKey:@"sub_category_id"];
        
        [self.mainArr removeAllObjects];
        
        [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
        
    }else if (tableView.tag == 23) {
        
        ButtonView *button = (ButtonView *)[self.view viewWithTag:150 + a];
        
        switch (indexPath.row) {
            case 0:
                
                break;
                
            case 1:
                
                [self.mainArr removeAllObjects];
                
                [self startAnotherConnection:indexPath.row - 2];
                
                button.titleLabel.text = self.alertTitle;
                
                break;
                
            default:
    
                [self.mainArr removeAllObjects];
                
                [self startAnotherConnection:indexPath.row - 2];
                
                button.titleLabel.text = [[self.alertArr objectAtIndex:indexPath.row - 2]objectForKey:@"name"];
                
                break;
        }
        [self backToMain];
    }else{
        
        if ([self.userState isEqualToString:@"1"]) {
            
            JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
            
            jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.mainArr objectAtIndex:indexPath.row]];
        
            jobDetail.hidesBottomBarWhenPushed = YES;
            if ([self judgeWhatILike:indexPath]) {
                
                jobDetail.collectType = @"YES";
                
            }else{
                
                jobDetail.collectType = @"NO";
                
            }
            
            [self.navigationController pushViewController:jobDetail animated:YES];
            
        }else if([self.userState isEqualToString:@"2"]){
//            WorkResumeDetailViewController *workDetail = [[WorkResumeDetailViewController alloc]initWithButton:@"2"];
            NSDictionary *indexDic = [NSMutableDictionary dictionaryWithDictionary:[self.mainArr objectAtIndex:indexPath.row]];
             
            
            NewZZDPeopleViewController *workDetail = [[NewZZDPeopleViewController alloc]init];
            
            if ([[indexDic objectForKey:@"robot"]isEqualToString:@"yes"]) {
                workDetail.robot = @"yes";
            }
            if ([self judgeWhatILike:indexPath]) {
                
                workDetail.collectType = @"YES";
                
            }else{
                
                workDetail.collectType = @"NO";
            }
            workDetail.dic = indexDic.mutableCopy;
            workDetail.jdId = self.jdId;
            workDetail.hidesBottomBarWhenPushed = YES;
            
//            CATransition *transition = [CATransition animation];
//            transition.duration = 1.0f;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = @"cube";
//            transition.subtype = kCATransitionFromTop;
//            transition.delegate = self;
//            [self.navigationController.view.layer addAnimation:transition forKey:nil];
//            CATransition *transition = [CATransition animation];
//            transition.duration = 1.0f;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = @"pageCurl";
//            transition.subtype = kCATransitionFromRight;
//            transition.delegate = self;
//            [self.navigationController.view.layer addAnimation:transition forKey:nil];
//
            [self.navigationController pushViewController:workDetail animated:YES];
            
        }
    }
}
- (BOOL)judgeWhatILike:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.mainArr objectAtIndex:indexPath.row];
    
    for (NSDictionary *collectDic in self.collectArr) {
        
        if ([[dic objectForKey:@"id"]isEqualToString:[collectDic objectForKey:@"id"]]) {
            
            return YES;
        }
    }
    return NO;
}
- (void)startAnotherConnection:(NSInteger)indexRow
{
    NSString *str = @"";
    
    if ([self.alertTitle isEqualToString:@"薪水"]) {
        str = @"salary_id";
    }
    if ([self.alertTitle isEqualToString:@"经验"]) {
        str = @"year_id";
    }
    if ([self.alertTitle isEqualToString:@"学历"]) {
        str = @"education_id";
    }
    if (indexRow == -1) {
        
        self.a = 0;
        
        [self.otherDic removeObjectForKey:str];
        
        [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
    }else{
        
        NSString *strId = [[self.alertArr objectAtIndex:indexRow]objectForKey:@"id"];
        
        self.a = 0;
        
        [self.mainArr removeAllObjects];
        
        [self.otherDic setObject:strId forKey:str];
        
        [self getConnection:[NSString stringWithFormat:@"%ld",self.a] num:@"10" dic:self.otherDic];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
