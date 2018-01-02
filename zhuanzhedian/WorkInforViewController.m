//
//  WorkInforViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/27.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "WorkInforViewController.h"
#import "MyViewTableViewCell.h"
#import "WorkResumeViewController.h"
#import "MySettingViewController.h"
#import "WorkUserInforViewController.h"
#import "WorkResumeDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CollectPersonViewController.h"
#import "UIColor+AddColor.h"
#import "MyCAShapeLayer.h"
#import "ButtonSelectView.h"
#import "CreateNewJobTableViewCell.h"
#import "UILableFitText.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "AVOSCloud/AVOSCloud.h"
//#import <AVOSCloudIM/AVOSCloudIM.h>
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "FMDBMessages.h"
#import "PeopleCheatWithMeController.h"
#import "AboutUsViewController.h"
#import "ZZDAlertView.h"
#import <UMMobClick/MobClick.h>
@interface WorkInforViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *myMainTableView;
@property (nonatomic, strong)UIImageView *backGroundImage;
@property (nonatomic, strong)UIVisualEffectView *effectView;
@property (nonatomic, strong)UIImageView *userHeaderImage;
@property (nonatomic, strong)UIImageView *settingButtonImage;
@property (nonatomic, strong)UILabel *userInforLabel;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)NSArray *imageArr;
@property (nonatomic, strong)NSDictionary *mainDic;
@end

@implementation WorkInforViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.imageArr = @[@"v1.png",@"v2.png",@"v3.png",@"v4.png",@"v5.png",@"v6.png"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBarHidden = YES;
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"我的";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;

    
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_user"]isEqualToString:@"0"]) {
        WorkUserInforViewController *workInfor = [[WorkUserInforViewController alloc]init];
        workInfor.hidesBottomBarWhenPushed = YES;
        workInfor.isFirst = @"YES";
        [self.navigationController pushViewController:workInfor animated:YES];
    }
 [self getLocalUserData];
    [self createMainView];
    [self createTableHeaderView];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"WorkInforView"];
    [MobClick beginLogPageView:@"WorkInforView"];
   
    [self getLocalUserData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self getLocalUserData];
    [self getUserInfor];
    self.userInforLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.mainDic objectForKey:@"name"],[self.mainDic objectForKey:@"sex"],[self.mainDic objectForKey:@"highest_edu"]];
    self.userNameLabel.text = [self.mainDic objectForKey:@"name"];
    [self.userHeaderImage sd_setImageWithURL:[self.mainDic objectForKey:@"avatar"]];
    self.backGroundImage.backgroundColor = [UIColor zzdColor];
    
    
    
    CGSize inforSize = [UILableFitText fitTextWithHeight:25 label:self.userInforLabel];
    self.userInforLabel.frame = CGRectMake(100, 62, inforSize.width, 25);
    
    CGSize nameSize = [UILableFitText fitTextWithHeight:25 label:self.userNameLabel];
    self.userNameLabel.frame = CGRectMake(100, 33, nameSize.width, 25);
    
    
//    self.effectView.alpha = 0;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 耗时的操作
//        BOOL a = [self judgeImageEqual:[self.mainDic objectForKey:@"avatar"]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//            if (a) {
//                self.effectView.alpha = 0;
//                self.backGroundImage.image = nil;
//                self.backGroundImage.backgroundColor = [UIColor zzdColor];
//                
//            }else{
//                self.effectView.alpha = 0.7;
//                [self.backGroundImage sd_setImageWithURL:[self.mainDic objectForKey:@"avatar"]];
//                
//                
//            }
//        });
//    });

}
- (void)getUserInfor
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"http://api.zzd.hidna.cn/v1/user/property";
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[dic objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                NSDictionary *numDic = [responseObject objectForKey:@"data"];

                
                
                ButtonSelectView *btn2 = [self.view viewWithTag:402];
                btn2.numLabel.text = [NSString stringWithFormat:@"%ld",[[numDic objectForKey:@"favoriteJDCount"]integerValue]];
                 NSMutableArray *conver = [FMDBMessages selectAllConversation];
                ButtonSelectView *btn1 = [self.view viewWithTag:401];
                btn1.numLabel.text = [NSString stringWithFormat:@"%ld",conver.count];
                
                ButtonSelectView *btn3 = [self.view viewWithTag:400];
                btn3.numLabel.text = [self judgeRSPercent];
                
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
- (NSString *)judgeRSPercent
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]isKindOfClass:[NSArray class]]) {
        return @"0%";
    }else{
        NSArray *eduArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"edu"];
        NSArray *jobArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"job"];
        
        if(jobArr.count != 0  && eduArr.count != 0 ){
        return @"100%";
    }else if(jobArr.count != 0  || eduArr.count != 0){
        return @"75%";
    }else{
    
    
    
    return @"50%";
    }
    }
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

- (BOOL)judgeImageEqual:(NSString *)imageUrl
{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    NSInteger a = 0;
    for (NSString *imageName in self.imageArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        [image drawInRect:CGRectMake(0, 0, 200, 200)];
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImagePNGRepresentation(scaledImage);
        if ([imageData isEqual:data]) {
            a = 1;
        }
    }
    if (a == 1) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)getLocalUserData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.mainDic = [user objectForKey:@"user"];
    
    
    
}

- (void)createMainView
{
    self.myMainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30) style:UITableViewStyleGrouped];
    self.myMainTableView.delegate = self;
    self.myMainTableView.dataSource = self;
    self.myMainTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.000];
    //设置不可滚动
    //    self.myMainTableView.scrollEnabled = NO;
    self.myMainTableView.rowHeight = 48;
    self.myMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.view addSubview:self.myMainTableView];
    //    [self.myMainTableView bringSubviewToFront:self.view];
    [self.view insertSubview:self.myMainTableView atIndex:1];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (void)createTableHeaderView
{
    //    NSString *imageUrl = [self.userDic objectForKey:@"avatar"];
    
    UIView *mainHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    mainHeaderView.backgroundColor = [UIColor whiteColor];
    
    //    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(2, 200, self.view.frame.size.width / 2 - 3, 50 - 4)];
    //    labelOne.backgroundColor = [UIColor whiteColor];
    //    [mainHeaderView addSubview:labelOne];
    //
    //
    //    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 1, 200, self.view.frame.size.width / 2 - 3, 50 - 4)];
    //    labelTwo.backgroundColor = [UIColor whiteColor];
    //    [mainHeaderView addSubview:labelTwo];
    
    //    self.backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.width)];
    //    self.backGroundImage.image = [UIImage imageNamed:@"123.jpg"];
    
    //测试
    //    [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    //    [mainHeaderView addSubview:self.backGroundImage];
    
    //    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    //
    //    self.effectView.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.width);
    //    self.effectView.alpha = 0.7;
    //    [mainHeaderView addSubview:self.effectView];
    
    
    self.userHeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(15,25, 70, 70)];
    //    self.userHeaderImage.image = [UIImage imageNamed:@"123.jpg"];
    
    //测试
    //    [self.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.userHeaderImage.layer.borderWidth = 2;
    self.userHeaderImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userHeaderImage.layer.masksToBounds = YES;
    self.userHeaderImage.layer.cornerRadius = 35;
    [mainHeaderView addSubview:self.userHeaderImage];
    
    
    self.settingButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 30, 30, 30)];
    //    self.settingButtonImage.image = [UIImage imageNamed:@"ico-36.png"];
    self.settingButtonImage.image = [UIImage imageNamed:@"e-5.png"];
    self.settingButtonImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *settingTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingTap:)];
    [self.settingButtonImage addGestureRecognizer: settingTap];
    //    self.settingButtonImage.backgroundColor = [UIColor blackColor];
    //    [mainHeaderView addSubview:self.settingButtonImage];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.settingButtonImage];
    
    self.userInforLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //    self.userInforLabel.backgroundColor = [UIColor lightGrayColor];
    self.userInforLabel.textColor = [UIColor darkGrayColor];
    self.userInforLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    [mainHeaderView addSubview:self.userInforLabel];
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    self.userNameLabel.textColor = [UIColor darkGrayColor];
    //    self.userNameLabel.backgroundColor = [UIColor lightGrayColor];
    [mainHeaderView addSubview:self.userNameLabel];
    
    
    //    CAShapeLayer *lineView = [MyCAShapeLayer createLayerWithXx:0 xy:120 yx:self.view.frame.size.width yy:120];
    //
    //    [mainHeaderView.layer addSublayer:lineView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [mainHeaderView addSubview:lineView];
    
    
    
    //    [self.view addSubview:mainHeaderView];
    //    [self.view sendSubviewToBack:mainHeaderView];
    self.myMainTableView.tableHeaderView = mainHeaderView;
    
    CAShapeLayer *lineOne = [MyCAShapeLayer createLayerWithXx:self.view.frame.size.width / 3 xy:135 yx:self.view.frame.size.width / 3 yy:185];
    [mainHeaderView.layer addSublayer:lineOne];
    
    CAShapeLayer *lineTwo = [MyCAShapeLayer createLayerWithXx:self.view.frame.size.width * 2 / 3 xy:135 yx:self.view.frame.size.width  * 2/ 3 yy:185];
    [mainHeaderView.layer addSublayer:lineTwo];
    
    NSArray *titleArr = @[@"管理简历",@"沟通过的",@"收藏的人"];
    NSArray *imageArr = @[@"ico-06.png",@"ico-37.png",@"ico-11.png"];
    for (int i = 0 ; i < 3; i++) {
        ButtonSelectView *btnView = [[ButtonSelectView alloc]initWithFrame:CGRectMake(5 + self.view.frame.size.width / 3 * i, 125, self.view.frame.size.width / 3 - 10, 70)];
        [btnView getValueWithNum:@"0" title:[titleArr objectAtIndex:i] image:[imageArr objectAtIndex:i]];
        btnView.tag = 400 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage:)];
        [btnView addGestureRecognizer:tap];
        [mainHeaderView addSubview:btnView];
        
    }
    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 45, 80, 30)];
    
    editBtn.layer.cornerRadius = 15;
    editBtn.layer.borderWidth = 0.6;
    editBtn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    [editBtn setTitle:@"资料     " forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor colorWithWhite:0.45 alpha:1] forState:UIControlStateNormal];
    editBtn.titleLabel.textAlignment = 0;
    editBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    [editBtn addTarget:self action:@selector(editInforSelf) forControlEvents:UIControlEventTouchUpInside];
    [mainHeaderView addSubview:editBtn];
    
    UIImageView *editImg = [[UIImageView alloc]initWithFrame:CGRectMake(53, 8, 14, 14)];
    editImg.image = [UIImage imageNamed:@"jtz.png"];
    [editBtn addSubview:editImg];

}
- (void)editInforSelf
{
    WorkUserInforViewController *myInfor = [[WorkUserInforViewController alloc]init];
    myInfor.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myInfor animated:YES];

    
    
}
- (void)goToLastPage:(UITapGestureRecognizer *)tap
{
    WorkResumeViewController *resume = [[WorkResumeViewController alloc]init];
    
    WorkResumeDetailViewController *resumeDetail  = [[WorkResumeDetailViewController alloc]init];
    CollectPersonViewController *collect = [[CollectPersonViewController alloc]init];
    PeopleCheatWithMeController *peoCheat = [[PeopleCheatWithMeController alloc]init];
    switch (tap.view.tag) {
        case 400:
            if ([[self.mainDic objectForKey:@"resume_id"]integerValue] > 0) {
                resumeDetail.hidesBottomBarWhenPushed = YES;
                resumeDetail.a = 10;
                // 从微简历push到英雄出处那页
                [self.navigationController pushViewController:resumeDetail animated:YES];
            }else{
                resume.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController: resume animated:YES];}
            
            break;
        case 401:
            peoCheat.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:peoCheat animated:YES];
            break;
        case 402:
            collect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collect animated:YES];

            break;
        default:
            break;
    }
    
}

- (void)settingTap:(UITapGestureRecognizer *)tap
{

    MySettingViewController *mySetting = [[MySettingViewController alloc]init];
    mySetting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySetting animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            //微简历
//            [cell setLabelValue:@"微简历" imageView:@"ico-06.png"];
            [cell getTitleLabelText:@"功能教程与攻略"];
            
            break;
        case 1:
            //个人信息
//            [cell setLabelValue:@"个人信息" imageView:@"ico-37.png"];
            break;
        case 2:
            //收藏的岗位
//            [cell setLabelValue:@"收藏的岗位" imageView:@"ico-11.png"];
            break;
        default:
            break;
    }
    return cell;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"WorkInforView"];
    [AVAnalytics endLogPageView:@"WorkInforView"];
    self.navigationController.navigationBarHidden = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    WorkResumeViewController *resume = [[WorkResumeViewController alloc]init];
//    WorkUserInforViewController *userInfor = [[WorkUserInforViewController alloc]init];
//    WorkResumeDetailViewController *resumeDetail  = [[WorkResumeDetailViewController alloc]init];
//    CollectPersonViewController *collect = [[CollectPersonViewController alloc]init];
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
    switch (indexPath.row) {
        case 0:
        aboutUs.url  = @"http://api.zzd.hidna.cn/v1/conf/help";
        aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];

            break;
        case 1:

            break;
        case 2:

            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    
    
    
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
