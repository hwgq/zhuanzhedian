//
//  RegistViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/29.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "RegistViewController.h"
#import "UIColor+AddColor.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ChangeIdentityViewController.h"
#import "InternetRequest.pch"
#import "RCAnimatedImagesView.h"
#import "ZZDAlertView.h"
@interface RegistViewController ()<MBProgressHUDDelegate,RCAnimatedImagesViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UIView *telView;
@property (nonatomic, strong)UIView *keyView;
@property (nonatomic, strong)UIView *linkView;

//telView
@property (nonatomic, strong)UITextField *telField;

//keyView
@property (nonatomic, strong)UITextField *keyField;

//linkView
@property (nonatomic, strong)UITextField *linkField;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)UIButton *getLinkButton;
@property (nonatomic, assign)NSInteger second;

@property (nonatomic, strong)RCAnimatedImagesView *animatedImagesView;
@end

@implementation RegistViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self.animatedImagesView startAnimating];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.animatedImagesView stopAnimating];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createLogoImage];
    [self createView];
    [self telViewValue];
    [self keyViewValue];
    [self linkViewValue];
}

- (void)createLogoImage
{
//    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.width / 3.5 / 2, self.view.frame.size.width / 5.5, self.view.frame.size.width / 3.5, self.view.frame.size.width / 3.5)];
//    
//    logoImage.layer.cornerRadius = self.view.frame.size.width / 3.5 /2 ;
//    
//    logoImage.layer.masksToBounds = YES;
//    
//    logoImage.image = [UIImage imageNamed:@"appicon.png"];
//    
//    [self.view addSubview:logoImage];
    
    
    
    self.animatedImagesView = [[RCAnimatedImagesView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.animatedImagesView];
    self.animatedImagesView.delegate = self;
    
    
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 + 10 , self.view.frame.size.width / 3.5 + 20, self.view.frame.size.width / 2 - 20 , self.view.frame.size.width / 3.5 - 50)];
    
    
    logoImage.image = [UIImage imageNamed:@"zzd6.png"];
    
    [self.view addSubview:logoImage];
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3.5 * 2 - 20 , self.view.frame.size.width/ 3, 15)];
    titleImage.image = [UIImage imageNamed:@"gangbi.png"];
    [self.view addSubview:titleImage];

    
    
    
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    
    backImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMain)];
    
    [backImage addGestureRecognizer:backTap];
    
    backImage.image = [UIImage imageNamed:@"backWhite.png"];
    
    [self.view addSubview:backImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)resignFirst
{
    [self.telField resignFirstResponder];
    [self.keyField resignFirstResponder];
    [self.linkField resignFirstResponder];
}


- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView
{
    self.telView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 - 75, self.view.frame.size.width - 80, 40)];
    
    self.telView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
    
    self.telView.layer.masksToBounds = YES;
    
    self.telView.layer.cornerRadius = 20;
    
    [self.view addSubview:self.telView];
    
    self.keyView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 - 20, self.view.frame.size.width - 80, 42)];
    
    self.keyView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
    
    self.keyView.layer.masksToBounds = YES;
    
    self.keyView.layer.cornerRadius = 21;
    
    [self.view addSubview:self.keyView];
    
    self.linkView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 + 35, self.view.frame.size.width - 80, 42)];
    
    self.linkView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
    
    self.linkView.layer.masksToBounds = YES;
    
    self.linkView.layer.cornerRadius = 21;
    
    [self.view addSubview:self.linkView];

    UIButton *registButton = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 + 117, self.view.frame.size.width - 80, 38)];
    
    registButton.layer.masksToBounds = YES;
    
    registButton.layer.cornerRadius = 19;
    
    registButton.backgroundColor = [UIColor zzdColor];
    
    [registButton setTitle:@"注  册" forState:UIControlStateNormal];
    
    [registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    
    registButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    
    [self.view addSubview:registButton];
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
- (void)regist:(id)sender
{
//    NSString * regex = @"^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}$";
// //   NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2-9]))\\d{8}$";
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    BOOL isMatch = [pred evaluateWithObject:self.telField.text];
//    
//    if (!isMatch) {
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        self.hud.labelText = @"请输入正确的手机号";
//        self.hud.mode = MBProgressHUDModeText;
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
//        [self.hud hide:YES afterDelay:1];
//        [self.hud removeFromSuperViewOnHide];
//    }
//    
    if (self.keyField.text.length < 6)
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
    if (self.linkField.text.length ==0) {
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
    
    if (self.keyField.text.length >=6 && self.linkField.text.length > 0) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:self.telField.text forKey:@"mobile"];
        
        [dic setValue:[MD5NSString md5HexDigest:self.keyField.text]  forKey:@"password"];
        
        [dic setValue:self.linkField.text forKey:@"recode"];
        
        [manager POST:@"http://api.zzd.hidna.cn/v1/user/register" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
           
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                
//                [alert show];
                ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
                [alertView setTitle:@"转折点提示" detail:@"注册成功" alert:ZZDAlertStateYes];
                [self.view addSubview:alertView];
                
                [UIView animateWithDuration:1 animations:^{
//                    [alert removeFromSuperview];
                    [alertView removeFromSuperview];
                    [self login:self.telField.text key:self.keyField.text];
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

- (void)telViewValue
{
    UIImageView *telImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 15, 20)];
    telImage.image = [UIImage imageNamed:@"sjh.png"];
    [self.telView addSubview:telImage];
    
    
    self.telField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, self.telView.frame.size.width - 50, 42)];
    self.telField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号码" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:14]}];
    self.telField.delegate = self;
    self.telField.keyboardType = UIKeyboardTypeNumberPad;
    self.telField.font = [UIFont systemFontOfSize:14];
    self.telField.textColor = [UIColor whiteColor];
    [self.telView addSubview:self.telField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30, 13, 0.5, 16)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.telView addSubview:lineView];
    
}

- (void)keyViewValue
{
    UIImageView *pwImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 16, 18)];
    
    pwImage.image = [UIImage imageNamed:@"mima.png"];
    
    [self.keyView addSubview:pwImage];
    
    self.keyField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, self.keyView.frame.size.width - 50, 42)];
    
    self.keyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的登录密码" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:14]}];
    self.keyField.textColor = [UIColor whiteColor];
    self.keyField.secureTextEntry = YES;
    
    self.keyField.font = [UIFont systemFontOfSize:14];
    self.keyField.delegate = self;
    [self.keyView addSubview:self.keyField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30, 13, 0.5, 16)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.keyView addSubview:lineView];
}

- (void)linkViewValue
{
    UIImageView *linkImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 15, 18)];
    
    linkImage.image = [UIImage imageNamed:@"yzm.png"];
    
    [self.linkView addSubview:linkImage];
    
    self.linkField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, self.linkView.frame.size.width - 140, 42)];
    self.linkField.textColor = [UIColor whiteColor];
    self.linkField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.6],NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:14]}];
    self.linkField.delegate = self;
    self.linkField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.linkField.font = [UIFont systemFontOfSize:14];
    
    [self.linkView addSubview:self.linkField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30, 13, 0.5, 16)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.linkView addSubview:lineView];
    
    self.second = 60;
    
    self.getLinkButton = [[UIButton alloc]initWithFrame:CGRectMake(self.linkView.frame.size.width - 90, 9, 80, 24)];
    
    [self.getLinkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [self.getLinkButton setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
    
    self.getLinkButton.layer.cornerRadius = 12;
    
    [self.getLinkButton addTarget:self action:@selector(getLink:) forControlEvents:UIControlEventTouchUpInside];
    
    self.getLinkButton.layer.borderColor = [UIColor zzdColor].CGColor;
    self.getLinkButton.layer.borderWidth = 0.5;
    
    self.getLinkButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];

    [self.linkView addSubview:self.getLinkButton];
}
//获取验证码
- (void)getLink:(id)sender
{
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2-9]))\\d{8}$";
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    BOOL isMatch = [pred evaluateWithObject:self.telField.text];
//    
//    
//    if (!isMatch) {
//            
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
//        
//    }
//    else
//    {
    if (self.telField.text.length != 0) {
        
    
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reflashGetKeyBt:) userInfo:nil repeats:YES];
    }
//    }
   }
- (void)reflashGetKeyBt:(NSTimer *)timer
{
    self.getLinkButton.userInteractionEnabled = NO;
    if (self.second == 60)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.telField.text forKey:@"mobile"];
        
        
        [manager POST:@"http://api.zzd.hidna.cn/v1/comm/recode/register" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSString *str =   [(NSDictionary *)responseObject objectForKey:@"msg"];
            if ([str isEqualToString:@"手机号码已经注册"] || [str isEqualToString:@"手机号有误"]) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//                [alert show];
                [self.keyField resignFirstResponder];
                [self.telField resignFirstResponder];
                ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
                [alertView setTitle:@"转折点提示" detail:str alert:ZZDAlertStateNo];
                [self.view addSubview:alertView];
            }else{
//                self.linkField.text = [[(NSDictionary *)responseObject objectForKey:@"data"]objectForKey:@"recode"];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];

    }
    else if(self.second == 0){
        
      [self.getLinkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.second = 60;
        self.getLinkButton.userInteractionEnabled = YES;
        [timer invalidate];
    }else
    {
        [self.getLinkButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.second] forState:UIControlStateNormal];
        
    }
    self.second  = self.second - 1;
    
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
- (void)viewDidUnload
{
    [self setAnimatedImagesView:nil];
    [self viewDidUnload];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
