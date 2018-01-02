//
//  WorkResumeDetailViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/30.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "WorkResumeDetailViewController.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
#import "WorkResumeViewController.h"
#import "AFNetworking.h"
#import "WorkAndEduView.h"
#import "CheatViewController.h"
#import "SelectJobViewController.h"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "MyCAShapeLayer.h"
#import "UILableFitText.h"
#import "ZZDAlertView.h"
#import <UMMobClick/MobClick.h>
@interface WorkResumeDetailViewController ()<changeMainResumeDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong)NSArray *workArr;
@property (nonatomic, strong)NSArray *eduArr;
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)NSDictionary *mainDic;
//first
@property (nonatomic, strong)UIView *firstView;
@property (nonatomic, strong)UIImageView *userHeadImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UILabel *sexLabel;
@property (nonatomic, strong)UILabel *eduLabel;
@property (nonatomic, strong)UILabel *jobLabel;
@property (nonatomic ,strong)UILabel *jobDetailLabel;
@property (nonatomic, strong)UILabel *stateLabel;
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UIImageView *cityImage;
@property (nonatomic, strong)UIImageView *priceImage;
@property (nonatomic, strong)UIImageView *sexImage;
@property (nonatomic, strong)UIImageView *eduImage;
@property (nonatomic, strong)UIImageView *yearImage;
//second
@property (nonatomic, strong)UIView *secondView;
@property (nonatomic, strong)UILabel *selfLabel;


//third
@property (nonatomic, strong)UIView *thirdView;


//forth
@property (nonatomic, strong)UIView *forthView;

@property (nonatomic, assign)NSInteger length;


@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)UIView *whiteView;
@property (nonatomic, strong)NSArray *tagArr;

@property (nonatomic, strong) NSMutableArray *receiveArr; // 接收后一页的传值
@property (nonatomic, strong) UILabel *itemLabel; // 显示标签
@property (nonatomic, strong) UILabel *tagLabel; // 期望行业

@end

@implementation WorkResumeDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.receiveArr = [NSMutableArray array];
    }
    return self;
}
- (instancetype)initWithButton:(NSString *)buttonType
{
    self = [super init];
    if (self) {
        self.buttonType = buttonType;
        self.dic = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"WorkResumeDetailView"];
    [AVAnalytics beginLogPageView:@"WorkResumeDetailView"];
    // 创建标签label
    //    [self creatLabel];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"WorkResumeDetailView"];
    [AVAnalytics endLogPageView:@"WorkResumeDetailView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#f4f6f7"];
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.textAlignment = 1;
    titleLabel.text = @"微简历";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mainScroll];
    [self createFirstView];
    [self createSecondView];
    [self createThirdView];
    [self createForthView];
    [self getEduAndWorkValue];
    if ([self.buttonType isEqualToString:@"2"]) {
        [self createOtherBottonButton];
    }else{
    [self createBottomButton];
    }
    [self setFirstViewValue:self.dic];
    
    [self goToBrowser];
    
}
- (void)goToBrowser
{
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/browser"];
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    [parameters setObject:[self.dic objectForKey:@"id"] forKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                
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
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}






- (void)changeTagValue:(NSDictionary *)dic
{
    NSMutableArray *arr = [dic objectForKey:@"tag_user"];
    self.receiveArr = arr;
    if (arr.count > 0) {
        
//    self.secondView.frame = CGRectMake(10, 170 +  50, self.view.frame.size.width - 20,self.secondView.frame.size.height);
//    self.thirdView.frame = CGRectMake(10, 170 + 60 + self.secondView.frame.size.height, self.view.frame.size.width - 20, self.thirdView.frame.size.height);
//    self.forthView.frame = CGRectMake(10, 170 + 60 + self.thirdView.frame.size.height + 10 + self.secondView.frame.size.height, self.view.frame.size.width - 20, self.forthView.frame.size.height);
//    self.firstView.frame = CGRectMake(10, self.firstView.frame.origin.y, self.view.frame.size.width - 20, self.firstView.frame.size.height + 50);
//        self.cityImage.frame = CGRectMake(12, self.firstView.frame.size.height - 30 + 2, 16, 16);
//        self.cityLabel.frame = CGRectMake(35, self.firstView.frame.size.height - 30, 60, 20);
//        self.priceImage.frame = CGRectMake(self.firstView.frame.size.width - 103, self.firstView.frame.size.height - 30+ 4, 13, 13);
        
//        self.priceLabel.frame = CGRectMake(self.firstView.frame.size.width - 100, self.firstView.frame.size.height - 30, 90, 20);
   
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.firstView.frame.size.height - 40, self.firstView.frame.size.width, 0.5)];
//        lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
//        [self.firstView addSubview:lineView];
        
        
//        self.tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.firstView.frame.size.height - 80, 80, 30)];
////        tagLabel.backgroundColor = [UIColor grayColor];
////        _tagLabel.text = @"期望行业:";
////        _tagLabel.textAlignment = 0;
//        _tagLabel.textColor = [UIColor grayColor];
//        _tagLabel.font = [UIFont systemFontOfSize:16];
//        [self.firstView addSubview:_tagLabel];

        // 创建标签label
//        [self creatLabel];
    }
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.forthView.frame.origin.y + self.forthView.frame.size.height + 60);
}


#pragma mark --- 创建标签label
- (void)creatLabel{
    for (NSInteger i = 1; i < 4; i++) {
        UILabel *label = [(UILabel *)self.view viewWithTag:(1000 + i)];
        [label removeFromSuperview];
    }
    
    double width = (self.firstView.frame.size.width  -150)/ 3.0;
    
    for (NSInteger i = 0; i < self.receiveArr.count; i ++) {
        self.itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(95 + i % 3 * (width + 16), self.firstView.frame.size.height - 74, width , 18)];
        self.itemLabel.backgroundColor = [UIColor zzdColor];
        self.itemLabel.layer.cornerRadius = 5;
        self.itemLabel.layer.masksToBounds = YES;
        self.itemLabel.textColor = [UIColor whiteColor];
        self.itemLabel.textAlignment = 1;
        self.itemLabel.tag = 1000 + i;
        self.itemLabel.text = self.receiveArr[i][@"name"];
        self.itemLabel.font = [UIFont systemFontOfSize:12];
        [self.firstView addSubview:self.itemLabel];
        
    }
    
}


// 实现协议方法
- (void)turnValue:(NSMutableArray *)turnArr{
    //
    self.receiveArr = turnArr;
}


- (void)goToLastPage
{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"pageUnCurl";
//    transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    self.tagArr =  [self.dic objectForKey:@"tag_user"];
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
            [self changeViewValue:[dataDic objectForKey:@"edu"] arr:[dataDic objectForKey:@"job"]];
            [self setFirstViewValue:dataDic];
                [self changeTagValue:dataDic];
                NSLog(@"dataDic:%@",dataDic);
                self.receiveArr = dataDic[@"tag_user"];
                
//                [self.whiteView removeFromSuperview];
//                self.hud.mode = MBProgressHUDModeText;
//                self.hud.hidden = YES;
//                [self.hud removeFromSuperViewOnHide];
                
                [alertView loadDidSuccess:@"加载成功"];
                
            if (dataDic != nil && self.a == 10) {
                [[NSUserDefaults standardUserDefaults]setObject:dataDic forKey:@"rs"];
            }
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
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
//        app.alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您的账号在另外一台设备上登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [app.alert show];
        app.alert = [[ZZDAlertView alloc]initWithView:app.window];
        [app.alert setTitle:@"转折点提示" detail:@"您的账号在另外一台设备上登录" alert:ZZDAlertStateNormal];
        [app.window addSubview:app.alert];
    }
    
}


- (void)changeViewValue:(NSArray *)edu arr:(NSArray *)work
{
    self.workArr = work;
    self.eduArr = edu;
    NSInteger eduCount = edu.count;
    NSInteger workCount = work.count;
    self.thirdView.frame = CGRectMake(10, self.secondView.frame.origin.y + self.secondView.frame.size.height + 10 , self.view.frame.size.width - 20, 45 + workCount * 70);
    //clearn thirdView
    for(UIView *myview in [self.thirdView subviews])
    {
        if ([myview isKindOfClass:[WorkAndEduView class]]) {
            [myview removeFromSuperview];
        }
    }
    for (int i = 0; i < workCount; i++) {
        WorkAndEduView *view = [[WorkAndEduView alloc]initWithFrame:CGRectMake(0, 45 + i * 70, self.thirdView.frame.size.width, 70)];
        [view changeViewValue:[work objectAtIndex:i] titleValue:1];
        [self.thirdView addSubview:view];
    }
    for(UIView *myview in [self.forthView subviews])
    {
        if ([myview isKindOfClass:[WorkAndEduView class]]) {
            [myview removeFromSuperview];
        }
    }
    for (int i = 0 ; i < eduCount; i++) {
        WorkAndEduView *view = [[WorkAndEduView alloc]initWithFrame:CGRectMake(0, 45 + i * 70, self.forthView.frame.size.width, 70)];
        [view changeViewValue:[edu objectAtIndex:i] titleValue:0];
        [self.forthView addSubview:view];
    }
    self.forthView.frame = CGRectMake(10, self.secondView.frame.origin.y + self.secondView.frame.size.height + 10 + workCount * 70  + 45 + 10, self.view.frame.size.width - 20, 45 + eduCount * 70);
//    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.secondView.frame.origin.y + self.secondView.frame.size.height + 10 +self.secondView.frame.size.height + 10  +workCount * 80 +  75 + 80 + eduCount * 80 + (self.length - 1) * 20);
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.forthView.frame.origin.y + self.forthView.frame.size.height + 60);
}

#pragma mark 创建四个视图
- (void)createFirstView
{
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 170)];
    self.firstView.backgroundColor = [UIColor whiteColor];
    self.firstView.layer.cornerRadius = 7;
//    self.firstView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    self.firstView.layer.borderWidth = 0.7;
    [self.mainScroll addSubview:self.firstView];
    
    CAShapeLayer *lineView = [MyCAShapeLayer createLayerWithXx:0 xy:90 yx:self.firstView.frame.size.width yy:90];
    
    [self.firstView.layer addSublayer:lineView];
    
    
    
    
    self.userHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.firstView.frame.size.width - 80, 15, 60, 60)];
//    self.userHeadImage.backgroundColor = [UIColor greenColor];
    self.userHeadImage.layer.masksToBounds = YES;
    self.userHeadImage.layer.cornerRadius = 30;
//    self.userHeadImage.layer.borderWidth = 0.7;
//    self.userHeadImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.firstView addSubview:self.userHeadImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    self.nameLabel.textColor = [UIColor zzdColor];
//    self.nameLabel.backgroundColor = [UIColor pumpkinColor];
    [self.firstView addSubview:self.nameLabel];
    
    
    self.yearImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//    yearImage.backgroundColor = [UIColor blackColor];
    self.yearImage.image = [UIImage imageNamed:@"ico-03.png"];
    [self.firstView addSubview:self.yearImage];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.yearLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    self.yearLabel.textAlignment = 0;
    self.yearLabel.textColor = [UIColor darkGrayColor];
//    self.yearLabel.backgroundColor = [UIColor redColor];
    [self.firstView addSubview:self.yearLabel];
    
    self.sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.firstView.frame.size.width - 38, 10, 25, 25)];
//    self.sexImage.backgroundColor = [UIColor blackColor];
    
    [self.firstView addSubview:self.sexImage];
    
//    self.sexLabel = [[UILabel alloc]initWithFrame:CGRectZero];
////    self.sexLabel.backgroundColor = [UIColor redColor];
//    self.sexLabel.textColor = [UIColor darkGrayColor];
//    self.sexLabel.font = [UIFont systemFontOfSize:12];
//    self.sexLabel.textAlignment = 0;
//    [self.firstView addSubview:self.sexLabel];
    
    self.eduImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.eduImage.image = [UIImage imageNamed:@"ico-04.png"];
//    eduImage.backgroundColor = [UIColor blackColor];
    [self.firstView addSubview:self.eduImage];
    
    self.eduLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.eduLabel.backgroundColor = [UIColor redColor];
    self.eduLabel.textAlignment = 0;
    self.eduLabel.textColor = [UIColor darkGrayColor];
    self.eduLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    [self.firstView addSubview:self.eduLabel];
    
    // 具体工作label
    self.jobLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.jobLabel.textColor = [UIColor zzdColor];
    self.jobLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
//    self.jobLabel.backgroundColor = [UIColor cyanColor];
    [self.firstView addSubview:self.jobLabel];
    
    
    self.jobDetailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.jobDetailLabel.font = [UIFont systemFontOfSize:16];
    self.jobDetailLabel.textColor = [UIColor darkGrayColor];
//    self.jobDetailLabel.backgroundColor = [UIColor brownColor];
    [self.firstView addSubview:self.jobDetailLabel];
   
 /*!!!*/   self.stateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.stateLabel.textColor = [UIColor lightGrayColor];
    self.stateLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
//    self.stateLabel.backgroundColor = [UIColor orangeColor];
    
    [self.firstView addSubview:self.stateLabel];
    
    self.cityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _cityImage.image = [UIImage imageNamed:@"ico-01.png"];
//    cityImage.backgroundColor = [UIColor cyanColor];
    [self.firstView addSubview:_cityImage];
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.cityLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    self.cityLabel.textColor = [UIColor darkGrayColor];
//    self.cityLabel.backgroundColor = [UIColor yellowColor];
    [self.firstView addSubview:self.cityLabel];
    
    self.priceImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _priceImage.image = [UIImage imageNamed:@"renminbi.png"];
//    priceImage.backgroundColor = [UIColor asbestosColor];
    [self.firstView addSubview:_priceImage];

    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.priceLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    self.priceLabel.textColor = [UIColor darkGrayColor];
    self.priceLabel.textAlignment = 1;
//    self.priceLabel.backgroundColor = [UIColor greenColor];
    [self.firstView addSubview:self.priceLabel];
    
    
    self.tagLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //        tagLabel.backgroundColor = [UIColor grayColor];
    //        _tagLabel.text = @"期望行业:";
    //        _tagLabel.textAlignment = 0;
    self.tagLabel.textColor = [UIColor darkGrayColor];
    self.tagLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    [self.firstView addSubview:_tagLabel];
}

#pragma mark 第一个cell赋值
- (void)setFirstViewValue:(NSDictionary *)dic
{
    if (dic == nil) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        dic = [userDefaults objectForKey:@"rs"];
    }
   
    NSMutableArray *arr = [dic objectForKey:@"tag_user"];
    if ([arr isKindOfClass:[NSString class]]) {
        NSData* data = [(NSString *)arr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        arr = [array mutableCopy];
    }
    self.receiveArr =  [arr mutableCopy];
    
    
    NSString *str = @"";
    for (NSDictionary *tagDic in self.receiveArr) {
        if (tagDic == self.receiveArr.lastObject) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", [tagDic objectForKey:@"name"]]];
                   }else{
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ | ",[tagDic objectForKey:@"name"]]];
                   }
    }
    
    NSString *tagStr = @"";
    if (str.length == 0) {
        tagStr = @"期望行业  不限";
    }else{
        tagStr = [NSString stringWithFormat:@"期望行业  %@",str];
    }
    self.tagLabel.text = tagStr;
    CGSize tagSize = [UILableFitText fitTextWithHeight:20 label:self.tagLabel];
    self.tagLabel.frame = CGRectMake(10, 140, tagSize.width, 20);
    
    
        self.mainDic = dic;
    
    
        self.nameLabel.text = [[dic objectForKey:@"user"]objectForKey:@"name"];
    CGSize nameSize = [UILableFitText fitTextWithHeight:30 label:self.nameLabel];
    self.nameLabel.frame = CGRectMake(10, 10, nameSize.width, 30);
    
    
        [self.userHeadImage sd_setImageWithURL:[[dic objectForKey:@"user"]objectForKey:@"avatar"]];
        NSString *sexStr = [[dic objectForKey:@"user"]objectForKey:@"sex"];
    if ([sexStr isEqualToString:@"女"]) {
        self.sexImage.image = [UIImage imageNamed:@"nvren.png"];
    }else {
        self.sexImage.image = [UIImage imageNamed:@"nanren.png"];
    }
    
    
        self.priceLabel.text = [dic objectForKey:@"salary"];
    CGSize priceSize = [UILableFitText fitTextWithHeight:30 label:self.priceLabel];
    self.priceLabel.frame = CGRectMake(self.firstView.frame.size.width - priceSize.width - 10, 100, priceSize.width, 30);
    self.priceImage.frame = CGRectMake(self.priceLabel.frame.origin.x - 20, 108, 15, 15);
    
    
    
    
    
        self.jobLabel.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"title"],[dic objectForKey:@"category"]];
    CGSize jobSize = [UILableFitText fitTextWithHeight:30 label:self.jobLabel];
    self.jobLabel.frame = CGRectMake(10, 100, jobSize.width, 30);
    
    
    
    self.eduImage.frame = CGRectMake(10, 58, 15, 15);
    self.eduLabel.text = [[dic objectForKey:@"user"]objectForKey:@"highest_edu"];
    CGSize eduSize = [UILableFitText fitTextWithHeight:20 label:self.eduLabel];
    self.eduLabel.frame = CGRectMake(30 , 55, eduSize.width, 20);
    
    
    self.cityImage.frame = CGRectMake(30 + eduSize.width + 10, 58, 15, 15);
    self.cityLabel.text = [dic objectForKey:@"city"];
    CGSize citySize = [UILableFitText fitTextWithHeight:20 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(self.cityImage.frame.origin.x + 20, 55, citySize.width, 20);
    
    self.yearImage.frame = CGRectMake(self.cityImage.frame.origin.x + 20 + citySize.width + 10, 58, 15, 15);
    self.yearLabel.text = [dic objectForKey:@"work_year"];
    CGSize yearSize = [UILableFitText fitTextWithHeight:20 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.yearImage.frame.origin.x + 20, 55,yearSize.width, 20);
    
        self.jobDetailLabel.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"category"],[dic objectForKey:@"sub_category"]];
    NSString *aString = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"work_state"]isEqualToString:@"0"]?@"在职-寻找机会":@"离职-随时上岗"];
//    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];
//        [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]range:NSMakeRange(0, 5)];
//    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
   
    [self.stateLabel setText:aString];
    CGSize stateSize = [UILableFitText fitTextWithHeight:30 label:self.stateLabel];
    self.stateLabel.frame = CGRectMake(20 + nameSize.width, 10, stateSize.width, 30);
    
    self.selfLabel.text = [dic objectForKey:@"self_summary"];
    CGFloat labelHeight = [self.selfLabel sizeThatFits:CGSizeMake(self.selfLabel.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.selfLabel.font.lineHeight);

    self.length = [count integerValue];
    
 
    self.selfLabel.frame = CGRectMake(10, 50, self.secondView.frame.size.width - 20, 35 + (self.length - 1) * 18);
    self.secondView.frame = CGRectMake(10, self.secondView.frame.origin.y, self.view.frame.size.width - 20, 90 + (self.length - 1) * 18);
    
    
    
    
}
- (void)createSecondView
{
    self.secondView = [[UIView alloc]initWithFrame:CGRectMake(10, 190, self.view.frame.size.width - 20, 90)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    self.secondView.layer.cornerRadius = 7;
//    self.secondView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    self.secondView.layer.borderWidth = 0.7;
    
    [self.mainScroll addSubview:self.secondView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 35)];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    titleLabel.text = @"我的优势";
    titleLabel.textColor = [UIColor zzdColor];
//    titleLabel.backgroundColor = [UIColor grayColor];
    [self.secondView addSubview:titleLabel];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.secondView.frame.size.width - 35, 12, 22, 20)];
//    titleImage.backgroundColor = [UIColor blackColor];
    titleImage.image = [UIImage imageNamed:@"advantage.png"];
    [self.secondView addSubview:titleImage];
    
    
    
    
    CAShapeLayer *lineView = [MyCAShapeLayer createLayerWithXx:0 xy:45 yx:self.secondView.frame.size.width yy:45];
    [self.secondView.layer addSublayer:lineView];
    
    self.selfLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.secondView.frame.size.width - 20, 35)];
    self.selfLabel.numberOfLines = 0;
    self.selfLabel.textColor = [UIColor darkGrayColor];
//    self.selfLabel.backgroundColor = [UIColor brownColor];
    self.selfLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    [self.secondView addSubview:self.selfLabel];
}

- (void)createThirdView
{
    self.thirdView = [[UIView alloc]initWithFrame:CGRectMake(10, 330, self.view.frame.size.width - 20, 45)];
    self.thirdView.backgroundColor = [UIColor whiteColor];
    self.thirdView.layer.cornerRadius = 7;
//    self.thirdView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    self.thirdView.layer.borderWidth = 0.7;
    [self.mainScroll addSubview:self.thirdView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 35)];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    titleLabel.text = @"工作经历";
    titleLabel.textColor = [UIColor zzdColor];
//    titleLabel.backgroundColor = [UIColor grayColor];
    [self.thirdView addSubview:titleLabel];
    
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.secondView.frame.size.width - 32, 12, 18, 18)];
    //    titleImage.backgroundColor = [UIColor blackColor];
    titleImage.image = [UIImage imageNamed:@"gwb2.png"];
    [self.thirdView addSubview:titleImage];
    
  
}

- (void)createForthView
{
    self.forthView = [[UIView alloc]initWithFrame:CGRectMake(10, 385, self.view.frame.size.width - 20, 45)];
    self.forthView.backgroundColor = [UIColor whiteColor];
    self.forthView.layer.cornerRadius = 7;
//    self.forthView.layer.borderWidth = 0.7;
//    self.forthView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    [self.mainScroll addSubview:self.forthView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 35)];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    titleLabel.text = @"教育经历";
    titleLabel.textColor = [UIColor zzdColor];
//    titleLabel.backgroundColor = [UIColor grayColor];
    [self.forthView addSubview:titleLabel];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.secondView.frame.size.width - 32, 12, 22, 20)];
    //    titleImage.backgroundColor = [UIColor blackColor];
    titleImage.image = [UIImage imageNamed:@"ico-04.png"];
    [self.forthView addSubview:titleImage];
   
}
- (void)createBottomButton
{
    UIButton *createButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    createButton.backgroundColor = [UIColor whiteColor];
    
//    createButton.layer.borderColor = [UIColor colorFromHexCode:@"#cecece"].CGColor;
//    createButton.layer.borderWidth = 1;
    createButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    createButton.layer.shadowOffset = CGSizeMake(0, 0);
    createButton.layer.shadowOpacity = 0.6;
    [createButton setTitle:@"编辑微简历" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    createButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:createButton];
}
- (void)createOtherBottonButton
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    //    bottomView.backgroundColor = [UIColor redColor];
    bottomView.backgroundColor = [UIColor whiteColor];
    //      returnView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    //      returnView.layer.shadowOffset = CGSizeMake(1,1);
    
    //      returnView.layer.shadowOpacity = 0.6;
    
    //        returnView.layer.shadowRadius = 1.0;
    bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(1, 1);
    bottomView.layer.shadowOpacity = 0.6;
    [self.view addSubview:bottomView];

    
    UIButton * loveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 8, bottomView.frame.size.width / 2 - 40, 49 - 16)];
        loveButton.backgroundColor = [UIColor orangeColor];
    loveButton.layer.cornerRadius = 3;
    loveButton.layer.masksToBounds = YES;

    UIImageView *loveImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 15, 15)];
    loveImage.image = [UIImage imageNamed:@"whiteXin.png"];
    [loveButton addSubview:loveImage];
    
    if ([self.collectType isEqualToString:@"YES"]) {
        [loveButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        [loveButton addTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [loveButton setTitle:@"收藏" forState:UIControlStateNormal];
        [loveButton addTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [loveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    loveButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    [bottomView addSubview:loveButton];
    
    UIButton *talkButton  = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width / 2 + 20, 8, bottomView.frame.size.width  / 2 - 40,49  - 16)];
        talkButton.backgroundColor = [UIColor zzdColor];
    talkButton.layer.cornerRadius = 3;
    talkButton.layer.masksToBounds = YES;
    [talkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkButton setTitle:@"立刻沟通" forState:UIControlStateNormal];
     [talkButton addTarget:self action:@selector(takeConversation) forControlEvents:UIControlEventTouchUpInside];
    talkButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    [bottomView addSubview:talkButton];
    UIImageView *talkImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 16, 16)];
    talkImage.image = [UIImage imageNamed:@"whiteTalk.png"];
//    talkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    talkButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [talkButton addSubview:talkImage];
    
    
    
    
    
}
- (void)takeConversation
{
    if (self.buttonCount == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
    NSString *objectId = [[self.dic objectForKey:@"user"]objectForKey:@"im_id"];
//    CheatViewController *cheat = [[CheatViewController alloc]init];
//    cheat.objectId = objectId;
//    cheat.jdDic = self.dic;
//    [self.navigationController pushViewController:cheat animated:YES];
    SelectJobViewController *selectJob = [[SelectJobViewController alloc]init];
    selectJob.rsId = [NSNumber numberWithInt:[[self.dic objectForKey:@"id"]intValue]];
    selectJob.objectId = objectId;
    selectJob.cheatHeader = [[self.dic objectForKey:@"user"]objectForKey:@"avatar"];
    selectJob.name = [[self.dic objectForKey:@"user"]objectForKey:@"name"];
    
    [self.navigationController pushViewController:selectJob animated:YES];
    }
}
- (void)notLoveThis:(id)sender
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"取消收藏中..." alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    
    UIButton *loveButton = (UIButton *)sender;
    if ([self.collectType isEqualToString:@"YES"]) {
        [loveButton setTitle:@"收藏" forState:UIControlStateNormal];
        [loveButton removeTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
        [loveButton addTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
        self.collectType = @"NO";
        
    }else{
        [loveButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        [loveButton removeTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
        [loveButton addTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
        self.collectType = @"YES";
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
              
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
                    [AVUser logOut];
                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                } else {
                    [AVUser logOut];
                    [self log];
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

    
}
- (void)loveThis:(id)sender
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"收藏中...  " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    
    UIButton *loveButton = (UIButton *)sender;
    if ([self.collectType isEqualToString:@"YES"]) {
        [loveButton setTitle:@"收藏" forState:UIControlStateNormal];
        [loveButton removeTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
        [loveButton addTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
        self.collectType = @"NO";
        
    }else{
        [loveButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        [loveButton removeTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
        [loveButton addTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
        self.collectType = @"YES";
    }
    
    
    NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
    [dic setObject:[self.mainDic objectForKey:@"id"] forKey:@"origin_id"];
    
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
            
        }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
        {
            
            if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
                [AVUser logOut];
                [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                    [self log];
                }];
            } else {
                [AVUser logOut];
                [self log];
            }
            
            }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
} failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    
}];
}
- (void)edit:(id)sender
{
    WorkResumeViewController *workResume = [[WorkResumeViewController alloc]init];
    workResume.eduArr  = [NSMutableArray arrayWithArray: self.eduArr];
    workResume.workArr = [NSMutableArray arrayWithArray: self.workArr];
    workResume.resumeChangeDelegate = self;
    [workResume.mainDic addEntriesFromDictionary:self.mainDic];
    [self.navigationController pushViewController:workResume animated:YES];
}
- (void)changeResumeWithDic:(NSDictionary *)dic eduArr:(NSArray *)edu jobArr:(NSArray *)job
{
    [self setFirstViewValue:dic];
    [self changeViewValue:edu arr:job];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
