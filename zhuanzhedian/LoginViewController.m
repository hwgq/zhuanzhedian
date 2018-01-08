//
//  LoginViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/29.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+AddColor.h"
#import "RegistViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "ChangeKeyViewController.h"
#import "AppDelegate.h"
#import "ChangeIdentityViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "MBProgressHUD.h"
#import "FMDBMessages.h"
#import "AVOSCloud/AVOSCloud.h"
#import "RCAnimatedImagesView.h"
#import "ZZDAlertView.h"
@interface LoginViewController ()<MBProgressHUDDelegate,RCAnimatedImagesViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UIView *telView;
@property (nonatomic, strong)UIView *keyView;

//telView
@property (nonatomic, strong)UITextField *telField;

//keyView
@property (nonatomic, strong)UITextField *keyField;
@property (nonatomic, strong)MBProgressHUD *hud;

@property (nonatomic, strong)RCAnimatedImagesView *animatedImagesView;
@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.animatedImagesView stopAnimating];
}
//视图将要出现时，执行方法
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.animatedImagesView startAnimating];
}
- (void)viewDidUnload
{
    [self setAnimatedImagesView:nil];
    [self viewDidUnload];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([AVUser currentUser]!=nil) {
        [AVFile clearAllCachedFiles];
    }
//    [FMDBMessages deleteAllConversation];
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.606];
    self.animatedImagesView = [[RCAnimatedImagesView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.animatedImagesView];
    self.animatedImagesView.delegate = self;
    

    
    
    [self createLoginView];
    
    [self telViewValue];
    
    [self keyViewValue];
    
    [self createOtherButtons];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)];
    
    [self.view addGestureRecognizer:tap];
}
- (NSUInteger)animatedImagesNumberOfImages:
(RCAnimatedImagesView *)animatedImagesView {
    return 2;
}
- (UIImage*)animatedImagesView:(RCAnimatedImagesView*)animatedImagesView imageAtIndex:(NSUInteger)index
{
//    return [UIImage imageNamed:@"login_background.png"];
    return [UIImage imageNamed:@"ccc.jpg"];
}

- (void)resignFirst
{
    [self.telField resignFirstResponder];
    [self.keyField resignFirstResponder];
}
#pragma mark 设置登陆界面
- (void)createLoginView
{
//    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.width / 3.5 / 2, self.view.frame.size.width / 5.5, self.view.frame.size.width / 3.5, self.view.frame.size.width / 3.5)];
//    
//    logoImage.layer.masksToBounds = YES;
//    
//    logoImage.layer.cornerRadius = self.view.frame.size.width / 3.5 / 2;
//    
//    logoImage.image = [UIImage imageNamed:@"zzd.png"];
//    
//    [self.view addSubview:logoImage];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 + 10 , self.view.frame.size.width / 3.5, self.view.frame.size.width / 2 - 20 , self.view.frame.size.width / 3.5 - 50)];
    
    
    logoImage.image = [UIImage imageNamed:@"zzd6.png"];
    
    [self.view addSubview:logoImage];
    
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3.5 * 2 - 40 , self.view.frame.size.width/ 3, 15)];
    titleImage.image = [UIImage imageNamed:@"gangbi.png"];
    [self.view addSubview:titleImage];
    
    self.telView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 - 75, self.view.frame.size.width - 80, 40)];
    self.telView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
    self.telView.layer.masksToBounds = YES;
    self.telView.layer.cornerRadius = 40 / 2;
    [self.view addSubview:self.telView];
    
    self.keyView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 - 20, self.view.frame.size.width - 80, 42)];
    
    self.keyView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
    
    self.keyView.layer.masksToBounds = YES;
    
    self.keyView.layer.cornerRadius = 42 / 2;
    
    [self.view addSubview:self.keyView];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 + 60, self.view.frame.size.width - 80, 38)];
    
    loginButton.layer.masksToBounds = YES;
    
    loginButton.layer.cornerRadius = 38 / 2;
    
    loginButton.backgroundColor = [UIColor zzdColor];
    
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

    loginButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    
    [self.view addSubview:loginButton];
}
//登录设置
- (void)login:(id)sender
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.telField.text];
    [self.keyField resignFirstResponder];
    [self.telField resignFirstResponder];
    if (self.telField.text.length == 0 || self.keyField.text.length == 0) {
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

    if (self.telField.text.length != 0 && self.keyField.text.length != 0) {
        
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
        
        [dic setObject:self.telField.text forKey:@"mobile"];
        
        [dic setObject:[MD5NSString md5HexDigest:self.keyField.text] forKey:@"password"];
        
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
    self.hud.hidden = YES;
    [self.hud removeFromSuperViewOnHide];
}
- (void)saveUserInfor:(NSDictionary *)dic
{
    NSDictionary *userDic = [dic objectForKey:@"data"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:userDic forKey:@"user"];
    [defaults setValue:[userDic objectForKey:@"current_role"] forKey:@"state"];
    [self getConnection];

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

- (void)telViewValue
{
    UIImageView *telImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 16, 18)];
    telImage.image = [UIImage imageNamed:@"sjh.png"];
    [self.telView addSubview:telImage];
    
    
    self.telField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, self.telView.frame.size.width - 50, 42)];
    
    self.telField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号码" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:14]}];
    self.telField.keyboardType = UIKeyboardTypeNumberPad;
    self.telField.delegate = self;
    self.telField.textColor = [UIColor whiteColor];
    [self.telView addSubview:self.telField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30, 13, 0.5, 16)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.telView addSubview:lineView];
  
    
}


- (void)keyViewValue
{
    UIImageView *pwImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 14, 16)];
    pwImage.image = [UIImage imageNamed:@"mima.png"];
    [self.keyView addSubview:pwImage];
    
    
    self.keyField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, self.keyView.frame.size.width - 50, 42)];
    self.keyField.alpha = 1;
    
    UIColor *color = [[UIColor colorWithWhite:1 alpha:1]colorWithAlphaComponent:0.6];
    self.keyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:14]}];
    self.keyField.secureTextEntry = YES;
    self.keyField.delegate = self;
    self.keyField.textColor = [UIColor whiteColor];
//    self.keyField.backgroundColor = [UIColor blackColor];
    [self.keyView addSubview:self.keyField];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30, 13, 0.5, 16)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.keyView addSubview:lineView];
    
}
- (void)createOtherButtons
{
    UIButton *forgetKeyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40 - 70, self.view.frame.size.height / 2 + 110, 70, 25)];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [forgetKeyButton setAttributedTitle:title forState:UIControlStateNormal];
//    forgetKeyButton.backgroundColor = [UIColor blackColor];
    forgetKeyButton.titleLabel.textColor = [UIColor whiteColor];
    [forgetKeyButton addTarget:self action:@selector(forgetKey) forControlEvents:UIControlEventTouchUpInside];
    forgetKeyButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    forgetKeyButton.titleLabel.textAlignment = 2;
    [self.view addSubview:forgetKeyButton];

    
    
    UIButton *registButton = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 + 110, 70, 25)];
    NSMutableAttributedString *titleTwo = [[NSMutableAttributedString alloc] initWithString:@"注册用户"];

    NSRange titleRangeTwo = {0,[titleTwo length]};
    [titleTwo addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRangeTwo];
    [registButton setAttributedTitle:titleTwo forState:UIControlStateNormal];
    registButton.titleLabel.textColor = [UIColor whiteColor];
    registButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    registButton.titleLabel.textAlignment = 0;
    [registButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registButton];
}

- (void)forgetKey
{
    ChangeKeyViewController *change = [[ChangeKeyViewController alloc]init];
    
    [self.navigationController pushViewController:change animated:YES];
}
- (void)registerUser
{
    RegistViewController *regist = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -150.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}

#pragma mark -屏幕恢复
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
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
