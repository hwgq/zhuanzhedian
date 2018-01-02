//
//  ZZDRegistViewController.m
//  LoginAndRegist
//
//  Created by Gaara on 16/6/30.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDRegistViewController.h"
#import "ZZDEditFieldView.h"
#import "ZZDAlertView.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "ChangeKeyViewController.h"
#import "ChangeIdentityViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface ZZDRegistViewController ()
@property (nonatomic, assign)NSInteger second;
@property (nonatomic, strong)ZZDEditFieldView *phoneField;
@property (nonatomic, strong)ZZDEditFieldView *numberField;
@property (nonatomic, strong)ZZDEditFieldView *keyField;

@end
@implementation ZZDRegistViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"RegistVC"];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [AVAnalytics beginLogPageView:@"RegistVC"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubViews];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backTap
{
    [self.view endEditing:YES];
    
}
- (void)createSubViews
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap)]];
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 2 / 5 + 20)];
//    titleView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
//    [self.view addSubview:titleView];
//    
//    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 + 20, 20, self.view.frame.size.width / 2 - 40, titleView.frame.size.height - 60)];
//    titleImg.image = [UIImage imageNamed:@"titleIm.png"];
//    [self.view addSubview:titleImg];
//    
//    UIImageView *titleTextImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 10, titleView.frame.size.height - 30, self.view.frame.size.width / 2 + 20, 18)];
//    titleTextImg.image = [UIImage imageNamed:@"titleText.png"];
//    [self.view addSubview:titleTextImg];
//    
//    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 30, 30)];
//    backImg.userInteractionEnabled = YES;
//    [backImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)]];
//    backImg.image = [UIImage imageNamed:@"backBtn.png"];
//    [self.view addSubview:backImg];
    
    
    UILabel *telTitle = [[UILabel alloc]initWithFrame:CGRectMake(24, 66, 35, 18)];
    telTitle.text = @"账号";
    telTitle.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    telTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:telTitle];
    
    self.phoneField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 96, self.view.frame.size.width - 48, 40) key:@"mobilePhone" placeHolder:@"请输入11位手机号"];
    self.phoneField.loginField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneField];
    
    
    UILabel *numTitle = [[UILabel alloc]initWithFrame:CGRectMake(24, 156, 50, 18)];
    numTitle.text = @"验证码";
    numTitle.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    numTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:numTitle];
    
    
    self.numberField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 186, self.view.frame.size.width - 48 - 100, 40) key:@"number" placeHolder:@"请输入验证码"];
    [self.view addSubview:self.numberField];

    UIButton * keyNumberBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 118, 192, 98,30)];
//    keyNumberBtn.backgroundColor = [UIColor orangeColor];
    [keyNumberBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [keyNumberBtn addTarget:self action:@selector(receiveLink:) forControlEvents:UIControlEventTouchUpInside];
    keyNumberBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [keyNumberBtn setTitleColor:[UIColor colorFromHexCode:@"#4ab7a6"] forState:UIControlStateNormal];
    keyNumberBtn.layer.cornerRadius = 6;
    keyNumberBtn.layer.borderWidth = 1;
    keyNumberBtn.layer.borderColor = [UIColor colorFromHexCode:@"#4ab7a6"].CGColor;
    [self.view addSubview:keyNumberBtn];
    
    UILabel *keyTitle = [[UILabel alloc]initWithFrame:CGRectMake(24, 246, 50, 18)];
    keyTitle.text = @"密码";
    keyTitle.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    keyTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:keyTitle];
    
    self.keyField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 276, self.view.frame.size.width - 48, 40) key:@"key" placeHolder:@"请设置密码"];
    self.keyField.loginField.secureTextEntry = YES;
    [self.view addSubview:self.keyField];
    
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 346, self.view.frame.size.width - 32, 36)];
    registBtn.backgroundColor = [UIColor colorFromHexCode:@"#4ab7a6"];
//    registBtn.layer.cornerRadius = 20;
    [registBtn addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    registBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registBtn];

    

}
- (void)receiveLink:(id)sender
{

        self.second = 60;
        //点击获取验证码， 有一个判断（手机号是否满足要求）
//        NSString *str = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9])|(170))\\d{8}$";
//        // 通过谓词来进行内容的比对
//        NSPredicate *cate = [NSPredicate predicateWithFormat:@"SELF  MATCHES%@", str];
        if (self.phoneField.loginField.text.length == 11) {
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refresh:) userInfo:sender repeats:YES];
        } else if (self.phoneField.loginField.text == nil){
            //        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
            //        self.hud.delegate = self;
            //        self.hud.labelText = @"请填写手机号";
            //        self.hud.mode = MBProgressHUDModeText;
            //        [self.view addSubview:self.hud];
            //        [self.hud show:YES];
            //        [self.hud hide:YES afterDelay:1];
            //        [self.hud removeFromSuperViewOnHide];
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"请填写手机号" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
            
        } else {
            // 手机号错误提示
            //        self.wrongTelHud = [[MBProgressHUD alloc]initWithView:self.view];
            //        self.wrongTelHud.delegate = self;
            //        self.wrongTelHud.labelText = @"不存在该手机号码";
            //        self.wrongTelHud.mode = MBProgressHUDModeText;
            //        [self.view addSubview:self.wrongTelHud];
            //        [self.wrongTelHud show:YES];
            //        [self.wrongTelHud hide:YES afterDelay:1];
            //        [self.wrongTelHud removeFromSuperViewOnHide];
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"不存在该手机号码" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
            
        }
        
    

}
- (void)refresh:(NSTimer *)timer
{
    
    UIButton *button = (UIButton *)timer.userInfo;
    button.userInteractionEnabled = NO;
    
    if (self.second == 60)
    {
        if (self.phoneField.loginField.text == nil) {
            //            self.hud = [[MBProgressHUD alloc]initWithView:self.view];
            //            self.hud.delegate = self;
            //            self.hud.labelText = @"请填写手机号";
            //            self.hud.mode = MBProgressHUDModeText;
            //            [self.view addSubview:self.hud];
            //            [self.hud show:YES];
            //            [self.hud hide:YES afterDelay:1];
            //            [self.hud removeFromSuperViewOnHide];
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"请填写手机号" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
            
        }
        else{
            //            self.hud = [[MBProgressHUD alloc]initWithView:self.view];
            //            self.hud.delegate = self;
            //            self.hud.labelText = @"验证码发送中";
            //            [self.view addSubview:self.hud];
            //            [self.hud show:YES];
            
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"验证码发送中..." alert:ZZDAlertStateLoad];
            [self.view addSubview:alertView];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.phoneField.loginField.text forKey:@"mobile"];
            [manager POST:@"http://api.zzd.hidna.cn/v1/comm/recode/register" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSString *str =   [(NSDictionary *)responseObject objectForKey:@"msg"];
                [alertView removeFromSuperview];
                if ([str isEqualToString:@"手机号码已经注册"] || [str isEqualToString:@"手机号有误"]) {
                    //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
                    //                [alert show];
                    [self.phoneField resignFirstResponder];
                    [self.numberField resignFirstResponder];
                    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
                    [alertView setTitle:@"转折点提示" detail:str alert:ZZDAlertStateNo];
                    [timer invalidate];
                    [self.view addSubview:alertView];
                    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.second = 60;
                    button.userInteractionEnabled = YES;
                }else{
                    //                self.linkField.text = [[(NSDictionary *)responseObject objectForKey:@"data"]objectForKey:@"recode"];
                    
                    //534139
                    [alertView loadDidSuccess:@"发送成功"];
                }
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
        
    }
    else if(self.second == 0){
        
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.second = 60;
        button.userInteractionEnabled = YES;
        [timer invalidate];
    }
    else
    {
        
        [button setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.second] forState:UIControlStateNormal];
    }
    self.second  = self.second - 1;
}

- (void)backAction:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registAction:(id)sender
{
        if (self.keyField.loginField.text.length < 6)
    {
        //        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        //        self.hud.delegate = self;
        //        self.hud.labelText = @"密码长度不可以小于6位";
        //        self.hud.mode = MBProgressHUDModeText;
        //        [self.view addSubview:self.hud];
        //        [self.hud show:YES];
        //        [self.hud hide:YES afterDelay:1];
        //        [self.hud removeFromSuperViewOnHide];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"密码长度不可以小于6位" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        
        return;
    }
    if (self.numberField.loginField.text.length ==0) {
        //        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        //        self.hud.delegate = self;
        //        self.hud.labelText = @"请输入验证码";
        //        self.hud.mode = MBProgressHUDModeText;
        //        [self.view addSubview:self.hud];
        //        [self.hud show:YES];
        //        [self.hud hide:YES afterDelay:1];
        //        [self.hud removeFromSuperViewOnHide];
        
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请输入验证码" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        return;
    }
    
    if (self.keyField.loginField.text.length >=6 && self.numberField.loginField.text.length > 0) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
              
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:self.phoneField.loginField.text forKey:@"mobile"];
        
        [dic setValue:[MD5NSString md5HexDigest:self.keyField.loginField.text]  forKey:@"password"];
        
        [dic setValue:self.numberField.loginField.text forKey:@"recode"];
        
        [manager POST:@"http://api.zzd.hidna.cn/v1/user/register" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                //
                //                [alert show];
                //     var appid = 'wx92db4c827da95678'; //填写微信小程序appid
                //     var secret = '78209601bb66f1996a4a769893344877'; //填写微信小程序secret
                ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
                [alertView setTitle:@"转折点提示" detail:@"注册成功" alert:ZZDAlertStateYes];
                [self.view addSubview:alertView];
                
                [UIView animateWithDuration:1 animations:^{
                    //                    [alert removeFromSuperview];
                    [alertView removeFromSuperview];
                    [self login:self.phoneField.loginField.text key:self.keyField.loginField.text];
                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
      
        }];
    }
}
- (void)login:(NSString *)name key:(NSString *)key
{
    
    //    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //    self.hud.delegate = self;
    //    self.hud.labelText = @"登录中";
    //    [self.view addSubview:self.hud];
    //    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"登录中...  " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:name forKey:@"mobile"];
    
    [dic setObject:[MD5NSString md5HexDigest:key] forKey:@"password"];
    
    [manager POST:@"http://api.zzd.hidna.cn/v1/user/login" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *str =  [responseObject objectForKey:@"ret"];
        
        if ([str isEqualToString:@"0"]) {
            
            AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:[[responseObject objectForKey:@"data"]objectForKey:@"im_id"]];
            
            [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                
                NSString * name = [[object objectForKey:@"localData"]objectForKey:@"username"];
                if (name == nil) {
                    
                }else{
                    [AVUser logInWithUsernameInBackground:name password:[MD5NSString md5HexDigest:name] block:^(AVUser *user, NSError *error) {
                        if (user != nil) {
                            NSLog(@"leanCloud登录成功");
                            [self saveUserInfor:responseObject];
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
                                
                                NSLog(@"登陆成功");
                                [self.navigationController pushViewController:change animated:YES];
                            }
                            //                            self.hud.hidden = YES;
                            //                            [self.hud removeFromSuperViewOnHide];
                            [alertView loadDidSuccess:@"登陆成功"];
                        } else {
                            
                        }
                    }];
                }
            }];
            
        }else{
            
            //            self.hud.labelText = [responseObject objectForKey:@"msg"];
            //            self.hud.mode = MBProgressHUDModeText;
            //            [self.hud hide:YES afterDelay:1];
            //            [self.hud removeFromSuperViewOnHide];
            [alertView removeFromSuperview];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
}
- (void)saveUserInfor:(NSDictionary *)dic
{
    NSDictionary *userDic = [dic objectForKey:@"data"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:userDic forKey:@"user"];
    [defaults setValue:[userDic objectForKey:@"current_role"] forKey:@"state"];
    [self getConnection];
    
    if ([[userDic objectForKey:@"resume_id"]isEqualToString:@"1"]) {
        
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
@end
