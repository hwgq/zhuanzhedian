//
//  ChangeIdentityViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/27.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ChangeIdentityViewController.h"
#import "UIColor+AddColor.h"
#import "WorkInforViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
#import "JudgeLocalUnreadMessage.h"
#import "WorkResumeViewController.h"
#import "LoginViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "MineMainViewController.h"
#import "ZZDLoginViewController.h"
#import "BossMainViewController.h"
#import "GoodCompanyViewController.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
@interface ChangeIdentityViewController ()<MBProgressHUDDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, assign)NSInteger a;
@end

@implementation ChangeIdentityViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
//    [MobClick beginLogPageView:@"ChangeIdentity"];
}
- (void)viewWillDisappear:(BOOL)animated
{
//    [MobClick endLogPageView:@"ChangeIdentity"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"选择身份";
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
   
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    [self createLabel];
    [self createButtonView];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createLabel
{
    UIImageView *appLabel = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 105) / 2 , self.view.frame.size.height / 5, 105, 35)];
//    appLabel.textAlignment = 1;
//    appLabel.text = @"转折点";
//    appLabel.font = [UIFont systemFontOfSize:18];
//    appLabel.textColor = [UIColor zzdColor];
    appLabel.image = [UIImage imageNamed:@"zzdselect.png"];
    [self.view addSubview:appLabel];
}

- (void)createButtonView
{
    UIView * workerView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 110, self.view.frame.size.height / 4 + 40, 220, 50)];
    workerView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    workerView.layer.masksToBounds = YES;
    workerView.layer.cornerRadius = 7;
    workerView.tag = 1;
    [self.view addSubview:workerView];
    
    UITapGestureRecognizer *workTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirm:)];
    [workerView addGestureRecognizer:workTap];
    
    
    
    UILabel *workerLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 90, 50)];
    workerLabel.text = @"我是求职者";
    workerLabel.textColor = [UIColor whiteColor];
    workerLabel.textAlignment = 1;
    workerLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    workerLabel.backgroundColor = [UIColor redColor];
    [workerView addSubview:workerLabel];
    
    UIImageView *workerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//    workerImage.backgroundColor = [UIColor greenColor];
    workerImage.image = [UIImage imageNamed:@"iamuser.png"];
    [workerView addSubview:workerImage];
    
    
    
    
    UIView *bossView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 110, self.view.frame.size.height / 4 + 110, 220, 50)];
    bossView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    bossView.layer.masksToBounds = YES;
    bossView.layer.cornerRadius = 7;
    bossView.tag = 2;
    [self.view addSubview:bossView];
    
    
    UITapGestureRecognizer *bossTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirm:)];
    [bossView addGestureRecognizer:bossTap];
    
    
    UILabel *bossLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 90, 50)];
    bossLabel.text = @"我是Boss";
    bossLabel.textAlignment = 1;
    bossLabel.textColor = [UIColor whiteColor];
//    bossLabel.backgroundColor = [UIColor redColor];
    bossLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [bossView addSubview:bossLabel];
    
    UIImageView *bossImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//    bossImage.backgroundColor = [UIColor greenColor];
    bossImage.image = [UIImage imageNamed:@"iamboss.png"];
    [bossView addSubview:bossImage];
    
    
}
- (void)confirm:(UITapGestureRecognizer *)tap
{

    self.a = tap.view.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份选择后无法修改,是否确认" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认", nil];

    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"确认"]) {
        if (self.a == 1) {
            [self workTap:nil];
        }
        if (self.a == 2) {
            [self bossTap:nil];
        }
    }
    if ([btnTitle isEqualToString:@"返回"]) {
        
    }
}
- (void)workTap:(UITapGestureRecognizer *)tap
{
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
    
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"切换身份中... " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"state"];
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/user";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [parameters setObject:@"1" forKey:@"current_role"];
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    
                    MineMainViewController *workInfor = [[MineMainViewController alloc]init];
                    
                    UINavigationController *navWork = [[UINavigationController alloc]initWithRootViewController:workInfor];
                    navWork.navigationController.navigationBarHidden = NO;
                    
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
                    
                    
                    NSMutableArray *arr = (NSMutableArray *)app.tabBar.viewControllers;
                    [arr removeLastObject];
                    UIImage *myViewImage = [[UIImage imageNamed:@"navbar _icon_personal.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    UIImage *myViewImageSelected = [[UIImage imageNamed:@"navbar _icon_personalS.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    navWork.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:myViewImage selectedImage:myViewImageSelected];
                    [arr addObject:navWork];
                    
                    if (arr.count == 3) {
                        GoodCompanyViewController *goodVC = [[GoodCompanyViewController alloc]init];
                        UINavigationController *goodNav = [[UINavigationController alloc]initWithRootViewController:goodVC];
                        UIImage *goodImage = [[UIImage imageNamed:@"saoselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        UIImage *goodImageSelected = [[UIImage imageNamed:@"saosao.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        goodNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"名企" image:goodImage selectedImage:goodImageSelected];
                        [arr insertObject:goodNav atIndex:1];
                    }
                    
                    app.tabBar.viewControllers = arr;
                    app.window.rootViewController = app.tabBar;
                    app.window.rootViewController.navigationController.navigationBarHidden = NO;
                   
                   
                    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_user"]isEqualToString:@"0"]) {

                        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userCheat"]!= nil) {
                            app.tabBar.selectedIndex =1;
                        }else{
                              app.tabBar.selectedIndex = 3;
                        }
                    }else{
                        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userCheat"]!= nil) {
                            app.tabBar.selectedIndex =1;
                        }else{
                        self.navigationController.navigationBarHidden = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                        app.tabBar.selectedIndex = 0;
                        }
                    }
                    
//                    self.hud.hidden = YES;
//                    [self.hud removeFromSuperViewOnHide];
                    [alertView loadDidSuccess:@"切换成功"];
                    [JudgeLocalUnreadMessage tellNavHowMuchMessage];
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    [alertView removeFromSuperview];
                    if ([AVUser currentUser].objectId != nil) {
                        
                    
                    AVIMClient * client = [AVIMClient defaultClient];
                    [client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
                        
                    }];
                    if (client!=nil && client.status == AVIMClientStatusOpened) {
                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    } else {
                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    }
                    }else{
                        [self log];
                    }
                    
                }
                

            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
         
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
   
//    }
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




//current_role
- (void)bossTap:(UITapGestureRecognizer *)tap
{
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
    
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"切换身份中... " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"state"];
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/user";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [parameters setObject:@"2" forKey:@"current_role"];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                BossMainViewController *bossInfor = [[BossMainViewController alloc]init];
                UINavigationController *navBoss = [[UINavigationController alloc]initWithRootViewController:bossInfor];
                
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                NSMutableArray *arr = (NSMutableArray *)app.tabBar.viewControllers;
                [arr removeLastObject];
                UIImage *myViewImage = [[UIImage imageNamed:@"navbar _icon_personal.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIImage *myViewImageSelected = [[UIImage imageNamed:@"navbar _icon_personalS.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                navBoss.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:myViewImage selectedImage:myViewImageSelected];
                [arr addObject:navBoss];
                
                
                
                if (arr.count == 4) {
                    [arr removeObjectAtIndex:1];
                }
                app.tabBar.viewControllers = arr;
                app.window.rootViewController = app.tabBar;
                bossInfor.tabBarController.tabBar.hidden = NO;
                bossInfor.navigationController.navigationBarHidden = NO;
          
                
                if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_boss"]isEqualToString:@"0"]) {
            
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userCheat"]!= nil) {
                        app.tabBar.selectedIndex =1;
                    }else{
                        app.tabBar.selectedIndex = 2;
                        
                    }
                }else{
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userCheat"]!= nil) {
                        app.tabBar.selectedIndex =1;
                    }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    app.tabBar.selectedIndex = 0;
                    }
                }
                
                
//                self.hud.hidden = YES;
//                [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"切换成功"];
                [JudgeLocalUnreadMessage tellNavHowMuchMessage];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened) {
                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                } else {
                    [self log];
                }
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
//    }
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
