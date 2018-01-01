//
//  ZZDLoginViewController.m
//  LoginAndRegist
//
//  Created by Gaara on 16/6/29.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDLoginViewController.h"
#import "ZZDEditFieldView.h"
#import "ZZDRegistViewController.h"
#import "AFNetworking.h"
#import "ZZDAlertView.h"
#import "MD5NSString.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AppDelegate.h"
#import "InternetRequest.pch"
#import "ChangeIdentityViewController.h"
#import "ChangeKeyViewController.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface ZZDLoginViewController ()
@property (nonatomic, strong)ZZDEditFieldView *telField;
@property (nonatomic, strong)ZZDEditFieldView *keyField;
@end
@implementation ZZDLoginViewController

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
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLoginView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    titleLabel.text = @"登录";
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:lb];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"LoginVC"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [AVAnalytics beginLogPageView:@"LoginVC"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)backTap
{
    [self.view endEditing:YES];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)createLoginView
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap)]];
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 2 / 5 + 30)];
//    titleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
//    [self.view addSubview:titleView];
//    
//    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 + 20, 20, self.view.frame.size.width / 2 - 40, titleView.frame.size.height - 60)];
//    titleImg.image = [UIImage imageNamed:@"titleIm.png"];
//    [self.view addSubview:titleImg];
//    
//    UIImageView *titleTextImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 10, titleView.frame.size.height - 30, self.view.frame.size.width / 2 + 20, 18)];
//    titleTextImg.image = [UIImage imageNamed:@"titleText.png"];
//    [self.view addSubview:titleTextImg];
    
    UILabel *telTitle = [[UILabel alloc]initWithFrame:CGRectMake(24, 66, 35, 18)];
    telTitle.text = @"账号";
    telTitle.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    telTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:telTitle];
    
    self.telField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 96, self.view.frame.size.width - 48, 40) key:@"mobilePhone" placeHolder:@"请输入11位手机号"];
    self.telField.loginField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.telField];
    
    UILabel *keyTitle = [[UILabel alloc]initWithFrame:CGRectMake(24, 156, 35, 18)];
    keyTitle.text = @"密码";
    keyTitle.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    keyTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:keyTitle];
    
    self.keyField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 186, self.view.frame.size.width - 48, 40) key:@"key" placeHolder:@"请输入登录密码"];
    self.keyField.loginField.secureTextEntry = YES;
    [self.view addSubview:self.keyField];
    
    
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 270, self.view.frame.size.width  - 32, 36)];
    loginBtn.backgroundColor = [UIColor colorFromHexCode:@"#4ab7a6"];
    loginBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(4, 325, 80, 25)];
    registBtn.backgroundColor = [UIColor whiteColor];
    registBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [registBtn addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
  
    [registBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor colorFromHexCode:@"#b0b0b0"] forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    
    UIButton * forgetKeyBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, 325, 80, 25)];
//    forgetKeyBtn.backgroundColor = [UIColor orangeColor];
    [forgetKeyBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetKeyBtn addTarget:self action:@selector(forgetKey) forControlEvents:UIControlEventTouchUpInside];
    
    forgetKeyBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [forgetKeyBtn setTitleColor:[UIColor colorFromHexCode:@"#b0b0b0"] forState:UIControlStateNormal];
    
        [self.view addSubview:forgetKeyBtn];
}
- (void)forgetKey
{
    ChangeKeyViewController *change = [[ChangeKeyViewController alloc]init];
    
    [self.navigationController pushViewController:change animated:YES];
}
- (void)loginAction:(id)sender
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.telField.loginField.text];
    [self.keyField resignFirstResponder];
    [self.telField resignFirstResponder];
    if (self.telField.loginField.text.length == 0 || self.keyField.loginField.text.length == 0) {
        //        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        //        self.hud.delegate = self;
        //        self.hud.labelText = @"请输入正确的手机号与匹配的密码";
        //        self.hud.mode = MBProgressHUDModeText;
        //        [self.view addSubview:self.hud];
        //        [self.hud show:YES];
        //        [self.hud hide:YES afterDelay:1];
        //        [self.hud removeFromSuperViewOnHide];
        
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请输入正确的手机号与匹配的密码" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
    }
    
    if (self.telField.loginField.text.length != 0 && self.keyField.loginField.text.length != 0) {
        
        //        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        //        self.hud.delegate = self;
        //        self.hud.labelText = @"登录中...";
        //        self.hud.labelFont = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
        //        self.hud.activityIndicatorColor = [UIColor zzdColor];
        //        [self.view addSubview:self.hud];
        //        [self.hud show:YES];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"登录中... " alert:ZZDAlertStateLoad];
        [self.view addSubview:alertView];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:self.telField.loginField.text forKey:@"mobile"];
        
        [dic setObject:[MD5NSString md5HexDigest:self.keyField.loginField.text] forKey:@"password"];
        
        [manager POST:@"http://api.zzd.hidna.cn/v1/user/login" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
         {
             
             NSString *str =  [responseObject objectForKey:@"ret"];
             
             if ([str isEqualToString:@"0"]) {
                 AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:[[responseObject objectForKey:@"data"]objectForKey:@"im_id"]];
                 
                 [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                     
                     [alertView loadDidSuccess:@"登陆成功"];
                  
                     NSString * name = [[object objectForKey:@"localData"]objectForKey:@"username"];
                     if (name == nil) {
                         
                     }else{
                         
                         [AVUser logInWithUsernameInBackground:name password:[MD5NSString md5HexDigest:name] block:^(AVUser *user, NSError *error) {
                             if (user != nil) {
                                 
                                 [self saveUserInfor:responseObject];
                             }
                         }];
                     }
                 }];
                 
             }else{
                 
                 //            self.hud.labelText = [responseObject objectForKey:@"msg"];
                 //
                 //            self.hud.mode = MBProgressHUDModeText;
                 //
                 //            [self.hud hide:YES afterDelay:1];
                 //
                 //            [self.hud removeFromSuperViewOnHide];
                 
                 [alertView removeFromSuperview];
                 ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
                 [alertView setTitle:@"转折点提示" detail:[responseObject objectForKey:@"msg"] alert:ZZDAlertStateNo];
                 [self.view addSubview:alertView];
             }
             
         } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             [alertView removeFromSuperview];
         }];
        
    }

}
- (void)saveUserInfor:(NSDictionary *)dic
{
    NSDictionary *userDic = [dic objectForKey:@"data"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDic forKey:@"user"];
    [defaults setObject:[userDic objectForKey:@"current_role"] forKey:@"state"];
  
    if ([[userDic objectForKey:@"resume_id"]isEqualToString:@"0"]) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app tellUser];
        [self jumpToMain];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[userDic objectForKey:@"resume_id"]];
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            
            [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    NSDictionary *rsDic = [responseObject objectForKey:@"data"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:rsDic forKey:@"rs"];
                    NSLog(@"获取用户简历成功");
                    
                    
#warning  重大修改
                    
                    [defaults setObject:@"123" forKey:@"firstInTo"];
                    
                    
                    
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app tellUser];
                    [self jumpToMain];
                    
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                //                self.hud.labelText = @"登录失败";
                //                self.hud.mode = MBProgressHUDModeText;
                //                [self.hud hide:YES afterDelay:1];
                //                [self.hud removeFromSuperViewOnHide];
            }];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    }
    [self getConnection];
    
}
- (void)getConnection
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = @"http://api.zzd.hidna.cn/v1/conf/comm";
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlStr,[userDic objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign]forKey:@"sign"];
        
        [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"data"] forKey:@"comm"];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
    
    
}
- (void)jumpToMain
{
    ChangeIdentityViewController *change = [[ChangeIdentityViewController alloc]init];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"1"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"2"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"1"]) {
            [self.navigationController pushViewController:change animated:YES];
            [change workTap:nil];
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"2"]) {
            [self.navigationController pushViewController:change animated:YES];
            [change bossTap:nil];
        }
        
    }else{
        [self.navigationController pushViewController:change animated:YES];
        
        NSLog(@"登陆成功");
        
    }
    
}
- (void)registAction:(id)sender
{
    ZZDRegistViewController *registVC = [[ZZDRegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
    
}
@end
