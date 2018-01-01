//
//  NewZZDPeopleViewController.m
//  NewPeopleDetail
//
//  Created by Gaara on 16/7/12.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "NewZZDPeopleViewController.h"
#import "WordEduDetailView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AddColor.h"
#import "UILableFitText.h"
#import "MD5NSString.h"
#import "ZZDAlertView.h"
#import "InternetRequest.pch"
#import "SelectJobViewController.h"
#import "FontTool.h"
#import "CheatViewController.h"
#import "RobotViewController.h"
#import "JobHelperViewController.h"
#import "CreateNewJobViewController.h"
#import "ScanBeforeViewController.h"
#import "AppDelegate.h"
@interface NewZZDPeopleViewController ()

@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)NSDictionary *rsDic;

@property (nonatomic, strong)UIView *firstView;
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *userInforLabel;
@property (nonatomic, strong)UILabel *userSummaryLabel;

@property (nonatomic, strong)UIImageView *yearImg;
@property (nonatomic, strong)UIImageView *eduImg;
@property (nonatomic, strong)UIImageView *sexImg;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UILabel *eduLabel;
@property (nonatomic, strong)UILabel *sexLabel;



@property (nonatomic, strong)UIView *secondView;
@property (nonatomic, strong)UILabel *salaryLabel;
@property (nonatomic, strong)UILabel *categoryLabel;
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UILabel *tagLabel;


@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIView *selfSummaryView;

@property (nonatomic, strong)UIImageView *collectImg;
@property (nonatomic, strong)UIButton *connectButton;
@property (nonatomic, strong)UIView *bossCreateBackView;


@end
@implementation NewZZDPeopleViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
//    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - 49 , self.view.frame.size.width, 49);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.mainScroll.frame.size.height  + 49);
//    if (self.bottomView.frame.origin.y != (self.view.frame.size.height - 49 - 64)) {
//        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height  - 49 - 64, self.view.frame.size.width, 49);
//        
//    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 49)];
    self.mainScroll.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    
//    self.mainScroll.contentSize = CGSizeMake( 0, 1500);
//    self.mainScroll.bounces = NO;
    [self.view addSubview:self.mainScroll];
    
    [self createOtherBottonButton];
    [self createFirstView];
    [self setFirstViewValue];
    [self createSecondView];
    [self setSecondValue];
    [self createSummaryView];
    [self getEduAndWorkValue];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://api.zzd.hidna.cn/v1/rs/263?sign=2de8557d81b477457d0281225b44bf1b&timestamp=1468394317&uid=84" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//         if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//             self.rsDic = [responseObject objectForKey:@"data"];
//             [self createThirdView];
//             
//         }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//    }];
    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    imageBack.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [imageBack addGestureRecognizer:tap];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageBack];
    [self judgeIsInvite];
}
- (void)judgeIsInvite
{
    if ([self.isSelf isEqualToString:@"123"] || self.jdId == nil) {
        
    }else{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/is_invite1"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid" ] forKey:@"uid"];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [dic setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:self.jdId forKey:@"jdId"];
        [dic setObject:[self.dic objectForKey:@"uid"] forKey:@"id"];
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                if ([[[responseObject objectForKey:@"data"]objectForKey:@"is_invite"]integerValue] == 1) {
                    self.connectButton.backgroundColor = [UIColor colorFromHexCode:@"ccc"];
                    [self.connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self.connectButton setTitle:@"已请求约面试" forState:UIControlStateNormal];
                    [self.connectButton removeTarget:self action:@selector(goToConnect) forControlEvents:UIControlEventTouchUpInside];
                    [self.connectButton addTarget:self action:@selector(goToJobHelperDetail) forControlEvents:UIControlEventTouchUpInside];
                    self.connectButton.userInteractionEnabled = YES;
                    
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    }
}
- (void)goToJobHelperDetail
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"转折点提示" message:@"你已预约过该人才，点击按钮查看后台详细处理进度！" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"你已预约过该人才，点击按钮查看后台详细处理进度！"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"查看进度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JobHelperViewController *jobHelperVC = [[JobHelperViewController alloc]init];
        [self.navigationController pushViewController:jobHelperVC animated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
- (void)createSummaryView
{
    self.selfSummaryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.selfSummaryView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    lineView.backgroundColor = [UIColor zzdColor];
    [self.selfSummaryView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    titleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.text = @"自我评价";
    //    self.titleLabel.backgroundColor = [UIColor blueColor];
    UILabel *summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.view.frame.size.width - 30, 100)];
//    summaryLabel.text = [self.dic objectForKey:@"self_summary"];
    NSString *labelText = [self.dic objectForKey:@"self_summary"];
    if ([self.dic objectForKey:@"self_summary"] == nil) {
        labelText = @"无";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    summaryLabel.attributedText = attributedString;
    

    summaryLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    summaryLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    summaryLabel.numberOfLines = 0;
    [self.selfSummaryView addSubview:titleLabel];
    [self.selfSummaryView addSubview:summaryLabel];
    CGSize summarySize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 30 label:summaryLabel];
    summaryLabel.frame = CGRectMake(15, 40, self.view.frame.size.width - 30, summarySize.height + 40);
    self.selfSummaryView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80 + summarySize.height);
    [self.mainScroll addSubview:self.selfSummaryView];
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getEduAndWorkValue
{
    //    self.whiteView = [[UIView alloc]initWithFrame:self.view.frame];
    //    self.whiteView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:self.whiteView];
    
    
    //    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //    self.hud.delegate = self;
    //    self.hud.color = [UIColor lightGrayColor];
    //    self.hud.dimBackground = YES;
    //    [self.view addSubview:self.hud];
    //    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"加载中...  " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"rs"];
    
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionary];
    if (self.dic == nil) {
        self.dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
//    self.tagArr =  [self.dic objectForKey:@"tag_user"];
    [parameters setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[self.dic objectForKey:@"id"]];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                
                NSDictionary *dataDic = [responseObject objectForKey:@"data"];

                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    self.rsDic = [responseObject objectForKey:@"data"];
                    [self createThirdView];
                    
                }
                [alertView loadDidSuccess:@"加载成功"];
                

            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)createNewJob
{
    
    
        CreateNewJobViewController *create = [[CreateNewJobViewController alloc]init];
        
        create.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:create animated:YES];
    
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
- (void)goToPc
{
    [self removeBossBackView];
    ScanBeforeViewController *scanVC = [[ScanBeforeViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
    
}
- (void)createBossBackView
{
    if (!self.bossCreateBackView) {
        
        
        self.bossCreateBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64 + 46)];
        self.bossCreateBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 180, self.view.frame.size.width - 60, (self.view.frame.size.width - 60) * 99 / 264)];
        titleImg.image = [UIImage imageNamed:@"1bala.png"];
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
- (void)createOtherBottonButton
{
    

    
    
//    UIButton * loveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.frame.size.width  / 2 - 0.5,49)];
//    loveButton.backgroundColor = [UIColor zzdColor];
//    loveButton.layer.cornerRadius = 3;
//    loveButton.layer.masksToBounds = YES;
    
//    UIImageView *loveImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 15, 15)];
//    loveImage.image = [UIImage imageNamed:@"whiteXin.png"];
//    [loveButton addSubview:loveImage];
    
//    if ([self.collectType isEqualToString:@"YES"]) {
//        [loveButton setTitle:@"取消收藏" forState:UIControlStateNormal];
//        [loveButton addTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }else{
//        [loveButton setTitle:@"收藏" forState:UIControlStateNormal];
//        [loveButton addTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    [loveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    loveButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    [self.bottomView addSubview:loveButton];
    if (self.buttonCount == 10) {
        
    }else{
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 36 - 64 - 15, self.view.frame.size.width * 2 / 3 - 30, 36)];
        //    bottomView.backgroundColor = [UIColor redColor];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        //      returnView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
        //      returnView.layer.shadowOffset = CGSizeMake(1,1);
        
        //      returnView.layer.shadowOpacity = 0.6;
        
        //        returnView.layer.shadowRadius = 1.0;
        //    self.bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        //    self.bottomView.layer.shadowOffset = CGSizeMake(1, 1);
        //    self.bottomView.layer.shadowOpacity = 0.6;
        [self.view addSubview:self.bottomView];
        
        
    UIButton *talkButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.frame.size.width  ,self.bottomView.frame.size.height  )];
    talkButton.backgroundColor = [UIColor colorFromHexCode:@"#38AB99"];
//    talkButton.layer.cornerRadius = 3;
//    talkButton.layer.masksToBounds = YES;
    [talkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkButton setTitle:@"立刻沟通" forState:UIControlStateNormal];
    [talkButton addTarget:self action:@selector(takeConversation) forControlEvents:UIControlEventTouchUpInside];
    talkButton.titleLabel.font = [[FontTool customFontArrayWithSize:15]objectAtIndex:1];
    [self.bottomView addSubview:talkButton];
        
        
        //    UIImageView *talkImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 16, 16)];
        //    talkImage.image = [UIImage imageNamed:@"whiteTalk.png"];
        //    //    talkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //    //    talkButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        //    [talkButton addSubview:talkImage];
        
        
        UIView *bottomOtherView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 30) * 2 / 3 + 20, self.view.frame.size.height - 36 - 64 - 15, (self.view.frame.size.width - 30) / 3 - 5 , 36)];
        //    bottomView.backgroundColor = [UIColor redColor];
        //    bottomOtherView.backgroundColor = [UIColor whiteColor];
        //      returnView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
        //      returnView.layer.shadowOffset = CGSizeMake(1,1);
        
        //      returnView.layer.shadowOpacity = 0.6;
        
        //        returnView.layer.shadowRadius = 1.0;
        bottomOtherView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        bottomOtherView.layer.shadowOffset = CGSizeMake(1, 1);
        bottomOtherView.layer.shadowOpacity = 0.6;
        [self.view addSubview:bottomOtherView];
        //
        
        
        
        self.connectButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width - 30) / 3 - 5, 36)];
        self.connectButton.backgroundColor = [UIColor whiteColor];
        
        //    talkButton.layer.cornerRadius = 3;
        self.connectButton.layer.masksToBounds = YES;
        [self.connectButton setTitleColor:[UIColor colorFromHexCode:@"38ab99"] forState:UIControlStateNormal];
        //    self.connectButton.backgroundColor = [UIColor whiteColor];
        [self.connectButton setTitle:@"帮我约面试" forState:UIControlStateNormal];
        [self.connectButton addTarget:self action:@selector(showConnnectInfo) forControlEvents:UIControlEventTouchUpInside];
        self.connectButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        [bottomOtherView addSubview:self.connectButton];
        
        
    }
    
}
- (void)showConnnectInfo
{
    if (self.jdId == nil && [[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"]isEqualToString:@"2"]) {
        
        [self createBossBackView];
    }else{
    if ([self.isSelf isEqualToString:@"123"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"这是您自己的简历" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self PayAction];
        }];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    if ([[dic objectForKey:@"is_allow"]integerValue] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"面试通服务" message:@"您尚未开通转折点面试通服务，该服务能让BOSS更快、更精准的面试相关人才；转折点专业团队收到您的面试请求后，将尽快为您确认该人才的意向情况，反馈给您，如需开通，请点击确定按钮！" preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"您尚未开通转折点面试通服务，该服务能让BOSS更快、更精准的面试相关人才；转折点专业团队收到您的面试请求后，将尽快为您确认该人才的意向情况，反馈给您，如需开通，请点击确定按钮！"];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"申请开通" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self PayAction];
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else{
        if ([[dic objectForKey:@"is_pay"]integerValue] == 1) {
            
        }else{
            if ([[dic objectForKey:@"count_invite"]integerValue] == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"面试通服务" message:@"您已经预约了3位求职者面试啦，在转折点团队为您确认求职者意向之前，您将不能继续约面试" preferredStyle:UIAlertControllerStyleAlert];
                
                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"您已经预约了3位求职者面试啦，在转折点团队为您确认求职者意向之前，您将不能继续约面试"];
                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
                [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
                [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
                
                
                
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"查看进度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    JobHelperViewController *jobHelperVC = [[JobHelperViewController alloc]init];
                    [self.navigationController pushViewController:jobHelperVC animated:YES];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                
               
                
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }else{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"面试通服务" message:@"欢迎您使用转折点面试通服务，该服务能让BOSS更快、更精准的面试相关人才；转折点专业团队收到您的面试请求后，将尽快为您确认该人才的意向情况，反馈给您，请您留意APP消息，及保持电话畅通！" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"欢迎您使用转折点面试通服务，该服务能让BOSS更快、更精准的面试相关人才；转折点专业团队收到您的面试请求后，将尽快为您确认该人才的意向情况，反馈给您，请您留意APP消息，及保持电话畅通！"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self goToConnect];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
        }
        }
    }
    }
    }
}
- (void)goToConnect
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/invite1"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid" ] forKey:@"uid"];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [dic setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:self.jdId forKey:@"jdId"];
        [dic setObject:[self.dic objectForKey:@"uid"] forKey:@"id"];
        
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                NSMutableDictionary *reloadDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]];
                [reloadDic setObject:[NSString stringWithFormat:@"%ld",[[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"count_invite"]integerValue] - 1] forKey:@"count_invite"];
                [[NSUserDefaults standardUserDefaults]setObject:reloadDic.copy forKey:@"user"];
                
                
                self.connectButton.backgroundColor = [UIColor colorFromHexCode:@"ccc"];
                [self.connectButton setTitle:@"已请求约面试" forState:UIControlStateNormal];
                [self.connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.connectButton removeTarget:self action:@selector(goToConnect) forControlEvents:UIControlEventTouchUpInside];
                [self.connectButton addTarget:self action:@selector(goToJobHelperDetail) forControlEvents:UIControlEventTouchUpInside];
                self.connectButton.userInteractionEnabled = YES;
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)PayAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/user/payRequest"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid" ] forKey:@"uid"];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [dic setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)createFirstView
{
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85)];
    self.firstView.backgroundColor = [UIColor whiteColor];
//    self.firstView.backgroundColor = [UIColor redColor];
    [self.mainScroll addSubview:self.firstView];
    
    UIView *longLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 85)];
    longLineView.backgroundColor = [UIColor colorFromHexCode:@"#38AB99"];
    [self.firstView addSubview:longLineView];
    
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 65, 65)];
    self.headerImg.layer.cornerRadius = 65.0 / 2;
    self.headerImg.layer.masksToBounds = YES;
//    self.headerImg.backgroundColor = [UIColor redColor];
    [self.firstView addSubview:self.headerImg];
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 17, 65, 18)];
    self.userNameLabel.textAlignment = 0;
    self.userNameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.userNameLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
//    self.userNameLabel.backgroundColor = [UIColor greenColor];
    [self.firstView addSubview:self.userNameLabel];
    
    self.yearImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.yearImg.image = [UIImage imageNamed:@"Group 4 Copy 5.png"];
    [self.firstView addSubview:self.yearImg];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.yearLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.yearLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.firstView addSubview:self.yearLabel];
    
    self.eduImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.eduImg.image = [UIImage imageNamed:@"Group 5 Copy 5.png"];
    [self.firstView addSubview:self.eduImg];
    
    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.eduLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.eduLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.firstView addSubview:self.eduLabel];
    
    self.sexImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.sexImg.image = [UIImage imageNamed:@"Group 2.png"];
    [self.firstView addSubview:self.sexImg];
    
    self.sexLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.sexLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.sexLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.firstView addSubview:self.sexLabel];
    
    self.collectImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 32, 22, 21)];
    //    self.collectImg.backgroundColor = [UIColor redColor];
    self.collectImg.userInteractionEnabled = YES;
    if ([self.collectType isEqualToString:@"YES"]) {
        self.collectImg.image = [UIImage imageNamed:@"Group 10"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
        
        
    }else{
        self.collectImg.image = [UIImage imageNamed:@"Fill 1 Copy 6"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        
    }
    [self.firstView addSubview:self.collectImg];

 
    
}
- (void)setFirstViewValue
{
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[[self.dic objectForKey:@"user"]objectForKey:@"avatar"]]];
    self.userNameLabel.text = [[self.dic objectForKey:@"user"]objectForKey:@"name"];
    CGSize userNameSize = [UILableFitText fitTextWithHeight:18 label:self.userNameLabel];
    self.userNameLabel.frame = CGRectMake(100, 17, userNameSize.width, 18);
    
    self.yearImg.frame = CGRectMake(101, 48, 15, 13);
    self.yearLabel.text = [self.dic objectForKey:@"work_year"];
    CGSize yearSize= [UILableFitText fitTextWithHeight:15 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(118, 48, yearSize.width, 15);
    
    self.eduImg.frame = CGRectMake(118 + yearSize.width + 8, 48, 15, 13);
    self.eduLabel.text = [[self.dic objectForKey:@"user"]objectForKey:@"highest_edu"];
    CGSize eduSize = [UILableFitText fitTextWithHeight:15 label:self.eduLabel];
    self.eduLabel.frame = CGRectMake(self.eduImg.frame.origin.x + 15 + 3, 48, eduSize.width, 15);
    
    self.sexImg.frame = CGRectMake(self.eduLabel.frame.origin.x + eduSize.width + 8, 48, 15, 13);
    self.sexLabel.text = [[self.dic objectForKey:@"user"]objectForKey:@"sex"];
    CGSize sexSize = [UILableFitText fitTextWithHeight:15 label:self.sexLabel];
    self.sexLabel.frame = CGRectMake(self.sexImg.frame.origin.x + 15 + 3, 48, sexSize.width, 15);
    
    self.firstView.frame = CGRectMake(0, 0, self.view.frame.size.width, 85);
    
}

- (void)createSecondView
{
    self.secondView = [[UIView alloc]initWithFrame:CGRectMake(0, self.firstView.frame.origin.y + self.firstView.frame.size.height + 30, self.view.frame.size.width, 160)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.secondView];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    lineView.backgroundColor = [UIColor zzdColor];
    [self.secondView addSubview:lineView];
    
    
    UILabel *jobTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    jobTitleLabel.text = @"期望工作";
    jobTitleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    jobTitleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
//    jobTitleLabel.backgroundColor = [UIColor yellowColor];
    [self.secondView addSubview:jobTitleLabel];
    
    UIImageView *salaryImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 37, 15, 15)];
    salaryImg.image = [UIImage imageNamed:@"Group 9 Copy 4.png"];
    [self.secondView addSubview:salaryImg];
    
    self.salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 30,self.view.frame.size.width - 80, 30)];
    self.salaryLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.salaryLabel.backgroundColor = [UIColor orangeColor];
    self.salaryLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.secondView addSubview:self.salaryLabel];
    
    UIImageView *categoryImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 67, 15, 15)];
    categoryImg.image = [UIImage imageNamed:@"Group 9 Copy 3.png"];
    [self.secondView addSubview:categoryImg];
    
    self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 60, self.view.frame.size.width - 80, 30)];
    self.categoryLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.categoryLabel.backgroundColor = [UIColor purpleColor];
    self.categoryLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.secondView addSubview:self.categoryLabel];
    
    UIImageView *cityImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 97, 15, 15)];
    cityImg.image = [UIImage imageNamed:@"Group 9 Copy 2.png"];
    [self.secondView addSubview:cityImg];
    
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 90, self.view.frame.size.width - 80, 30)];
//    self.cityLabel.backgroundColor = [UIColor lightGrayColor];
    self.cityLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.cityLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.secondView addSubview:self.cityLabel];
    
    UIImageView *tagImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 127, 15, 15)];
    tagImg.image = [UIImage imageNamed:@"Group 9 Copy.png"];
    [self.secondView addSubview:tagImg];
    
    self.tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 120, self.view.frame.size.width - 50, 30)];
//    self.tagLabel.backgroundColor = [UIColor cyanColor];
    self.tagLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.tagLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    [self.secondView addSubview:self.tagLabel];
}
- (void)setSecondValue
{
    NSString *salaryStr = [NSString stringWithFormat:@"%@ : %@",@"期望薪资",[self.dic objectForKey:@"salary"]];
    self.salaryLabel.text = salaryStr;
    
    NSString *categoryStr = [NSString stringWithFormat:@"%@ : %@",@"期望职位",[self.dic objectForKey:@"category"]];
    self.categoryLabel.text = categoryStr;
    
    NSString *cityStr = [NSString stringWithFormat:@"%@ : %@",@"期望城市",[self.dic objectForKey:@"city"]];
    self.cityLabel.text = cityStr;
    
    NSMutableString *tagStr = [NSMutableString string];
    id tagArr = [self.dic objectForKey:@"tag_user"];
    if ([tagArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *tagDic in tagArr) {
            if (tagStr.length == 0) {
                
                [tagStr appendString:[tagDic objectForKey:@"name"]];
                
            }else{
                [tagStr appendString:[NSString stringWithFormat:@" | %@",[tagDic objectForKey:@"name"]]];
            }
        }
    }
    NSString *tagArrStr = [NSString stringWithFormat:@"%@ : %@",@"期望行业",tagStr];
    self.tagLabel.text = tagArrStr;
    
}
- (void)createThirdView
{
    NSArray *jobArr = [self.rsDic objectForKey:@"job"];
    NSArray *eduArr = [self.rsDic objectForKey:@"edu"];
    for (int i = 0; i < jobArr.count; i++) {
        NSDictionary *jobDic = [jobArr objectAtIndex:i];
        WordEduDetailView *workView = [[WordEduDetailView alloc]initWithFrame:CGRectMake(0, self.secondView.frame.origin.y + self.secondView.frame.size.height + 30 + i * 130 + self.selfSummaryView.frame.size.height + 30, self.view.frame.size.width, 130)];
        if (i != 0) {
            workView.frame = CGRectMake(0, self.secondView.frame.origin.y + self.secondView.frame.size.height + 30 +  (i - 1) * 100 + 130 + self.selfSummaryView.frame.size.height + 30, self.view.frame.size.width, 100);
        }
        [workView setValueWithDic:jobDic title:@"工作经历" count:i];
        [self.mainScroll addSubview:workView];
    }
    
    for (int j = 0; j < eduArr.count; j++) {
        NSDictionary *eduDic = [eduArr objectAtIndex:j];
        CGFloat jobLength = 0;
        if (jobArr.count > 1) {
            jobLength = 130 + (jobArr.count -1) * 100 + 30;
        }else if(jobArr.count == 0){
            jobLength = 0;
        }else{
            jobLength = jobArr.count * 130 + 30;
        }
        WordEduDetailView *eduView = [[WordEduDetailView alloc]initWithFrame:CGRectMake(0, self.secondView.frame.origin.y + self.secondView.frame.size.height  + jobLength   + j * 130 + 30 + self.selfSummaryView.frame.size.height + 30, self.view.frame.size.width, 130)];
        if (j != 0) {
            eduView.frame = CGRectMake(0, self.secondView.frame.origin.y + self.secondView.frame.size.height  + jobLength   + (j - 1) * 100 + 130 + 30 + self.selfSummaryView.frame.size.height + 30, self.view.frame.size.width, 100);
        }
        [eduView setValueWithDic:eduDic title:@"教育经历" count:j];
        [self.mainScroll addSubview:eduView];
    }
   
    
    self.selfSummaryView.frame = CGRectMake(0, self.secondView.frame.origin.y + self.secondView.frame.size.height  + 30 , self.view.frame.size.width, self.selfSummaryView.frame.size.height);
    
    self.mainScroll.contentSize = CGSizeMake(0, self.secondView.frame.origin.y + self.secondView.frame.size.height + 60 + jobArr.count * 130 + eduArr.count * 130 + 30 + 100 + self.selfSummaryView.frame.size.height);
    
    
}
- (void)notLoveThis:(UITapGestureRecognizer *)sender
{
    //    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //    self.hud.delegate = self;
    //    [self.view addSubview:self.hud];
    //    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"取消收藏中..." alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    
    UIImageView *loveButton = (UIImageView *)sender.view;
    if ([self.collectType isEqualToString:@"YES"]) {
        [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
        self.collectType = @"NO";
        self.collectImg.image = [UIImage imageNamed:@"Fill 1 Copy 6"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        
        
    }else{
        [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        self.collectType = @"YES";
        self.collectImg.image = [UIImage imageNamed:@"Group 10"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
    }
    
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/my/favorite/%@/delete",[self.dic objectForKey:@"favorite_id"]];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
        [parameters setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSLog(@"取消成功");
                //                        self.hud.labelText = @"取消成功";
                //                        self.hud.mode = MBProgressHUDModeText;
                //                        [self.hud hide:YES afterDelay:1];
                //                        [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"取消成功"];
                [self.dic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"]  forKey:@"favorite_id"];
                
            
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
}
- (void)loveThis:(UITapGestureRecognizer *)sender
{
    //    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //    self.hud.delegate = self;
    //    [self.view addSubview:self.hud];
    //    [self.hud show:YES];
    
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"收藏中...  " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    
    UIImageView *loveButton = (UIImageView *)sender.view;
    if ([self.collectType isEqualToString:@"YES"]) {
        [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
        self.collectType = @"NO";
        self.collectImg.image = [UIImage imageNamed:@"Fill 1 Copy 6"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        
        
    }else{
        [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        self.collectType = @"YES";
        self.collectImg.image = [UIImage imageNamed:@"Group 10"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
    }

    
    
    NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
    [dic setObject:[self.dic objectForKey:@"id"] forKey:@"origin_id"];
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/my/favorite";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSLog(@"收藏成功");
                //                    self.hud.labelText = @"收藏成功";
                //                    self.hud.mode = MBProgressHUDModeText;
                //                    [self.hud hide:YES afterDelay:1];
                //                    [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"收藏成功"];
                [self.dic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"]  forKey:@"favorite_id"];
                
//            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
//            {
//                
//                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
//                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
//                        [self log];
//                    }];
//                } else {
//                    [self log];
//                }
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)takeConversation
{
//    if (self.buttonCount == 10) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
    
//        NSString *objectId = [[self.dic objectForKey:@"user"]objectForKey:@"im_id"];
//        //    CheatViewController *cheat = [[CheatViewController alloc]init];
//        //    cheat.objectId = objectId;
//        //    cheat.jdDic = self.dic;
//        //    [self.navigationController pushViewController:cheat animated:YES];
//        SelectJobViewController *selectJob = [[SelectJobViewController alloc]init];
//        selectJob.rsId = [NSNumber numberWithInt:[[self.dic objectForKey:@"id"]intValue]];
//        selectJob.objectId = objectId;
//        selectJob.rsDic = self.rsDic;
//        selectJob.cheatHeader = [[self.dic objectForKey:@"user"]objectForKey:@"avatar"];
//        selectJob.name = [[self.dic objectForKey:@"user"]objectForKey:@"name"];
//        if ([self.robot isEqualToString:@"yes"]) {
//        selectJob.robot = @"yes";
//        }
//        [self.navigationController pushViewController:selectJob animated:YES];
//    }
    
    if (self.jdId == nil && [[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"]isEqualToString:@"2"]) {
        [self createBossBackView];
    }else{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
//        JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"108"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                
                
                
                NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
                if (self.jdId == NULL) {
                    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"jdList"];
                    NSLog(@"%@",arr);
                    if (arr.count > 0) {
                        self.jdId = [[arr objectAtIndex:0]objectForKey:@"id"];
                    }
                    
                }
                NSString *str  = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@",self.jdId];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                [dic setObject:uid forKey:@"uid"];
                [dic setObject:time forKey:@"timestamp"];
                [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                [manager GET:str parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                        self.jdDic = [responseObject objectForKey:@"data"];
//                        jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:self.jdDic];
//                        [self.navigationController pushViewController:jobDetail animated:YES];
                        
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
                        
                        CheatViewController *cheat = [[CheatViewController alloc]init];
                        cheat.jdDic = dic;
                        cheat.rsDic = self.rsDic;
//                        if ([self.type isEqualToString:@"self"]) {
//                            cheat.cheatHeader = [[dic objectForKey:@"user"]objectForKey:@"avatar"];
//                            cheat.title = [[dic objectForKey:@"user"]objectForKey:@"name"];
//                            cheat.objectId = [[dic objectForKey:@"user"]objectForKey:@"im_id"];
//                        }else{
                            cheat.cheatHeader = [[self.rsDic objectForKey:@"user"]objectForKey:@"avatar"];
                            cheat.title = [[self.rsDic objectForKey:@"user"]objectForKey:@"name"];
                            cheat.objectId = [[self.rsDic objectForKey:@"user"]objectForKey:@"im_id"];
//                        }
                    
                        cheat.rsId = [self.rsDic objectForKey:@"id"];
                        cheat.jdId = [dic objectForKey:@"id"];
                        
                        
                        [self.navigationController pushViewController:cheat animated:YES];
                        
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
}
@end
