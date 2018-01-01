//
//  ChangeKeyViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/26.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ChangeKeyViewController.h"
#import "KeyWordTableViewCell.h"
#import "UIColor+AddColor.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
#import "ZZDAlertView.h"
#import "FontTool.h"
#import "ZZDEditFieldView.h"
@interface ChangeKeyViewController ()<UITableViewDataSource,UITableViewDelegate,KeyWordCellDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong)UITableView *changeKeyTable;
@property (nonatomic, strong)NSMutableDictionary *dataDic;

//text
@property (nonatomic, copy)NSString *telString;
@property (nonatomic, copy)NSString *linkString;
@property (nonatomic, copy)NSString *newkeyString;
@property (nonatomic, copy)NSString *confirmKeyString;

@property (nonatomic, strong)ZZDEditFieldView *telField;
@property (nonatomic, strong)ZZDEditFieldView *linkField;
@property (nonatomic, strong)ZZDEditFieldView *neKeyField;
@property (nonatomic, strong)ZZDEditFieldView *confirmKeyField;



@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, assign)NSInteger second;

// 手机号错误弹出的框
@property (nonatomic, strong)MBProgressHUD *wrongTelHud;
@end

@implementation ChangeKeyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataDic = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
 
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    [self createChangeKeyTable];
    
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)]];
   
}
- (void)resign
{
    [self.view endEditing:YES];
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createChangeKeyTable
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.changeKeyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.changeKeyTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    
    self.changeKeyTable.delegate = self;
    
    self.changeKeyTable.dataSource = self;
    
    self.changeKeyTable.rowHeight = 48;
    
    self.changeKeyTable.sectionFooterHeight = 0;
    
    self.changeKeyTable.scrollEnabled = NO;
    
//    [self.view addSubview:self.changeKeyTable];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 60 - 64, self.view.frame.size.width - 30, 40)];
    
//    submitButton.layer.cornerRadius = 7;
    
//    submitButton.layer.masksToBounds = YES;
    
    [submitButton setTitle:@"提交" forState:
     UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    
    submitButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    submitButton.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.view addSubview:submitButton];
    
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 20 , 100, 18)];
    telLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    telLabel.text = @"账号";
    telLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    [self.view addSubview:telLabel];
    
    self.telField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24,  50, self.view.frame.size.width - 48, 40) key:@"mobilePhone" placeHolder:@"请输入11位手机号"];
    [self.view addSubview:self.telField];
    
    UILabel *linkLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 110, 100, 18)];
    linkLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    linkLabel.text = @"验证码";
    linkLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    [self.view addSubview:linkLabel];
    
    self.linkField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 140, self.view.frame.size.width - 48 - 100, 40) key:@"number" placeHolder:@"请输入验证码"];
    [self.view addSubview:self.linkField];
    
    UIButton * keyNumberBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 118, 145, 98,30)];
    //    keyNumberBtn.backgroundColor = [UIColor orangeColor];
    [keyNumberBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [keyNumberBtn addTarget:self action:@selector(receiveLink:) forControlEvents:UIControlEventTouchUpInside];
    keyNumberBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [keyNumberBtn setTitleColor:[UIColor colorFromHexCode:@"#4ab7a6"] forState:UIControlStateNormal];
    keyNumberBtn.layer.cornerRadius = 6;
    keyNumberBtn.layer.borderWidth = 1;
    keyNumberBtn.layer.borderColor = [UIColor colorFromHexCode:@"#4ab7a6"].CGColor;
    [self.view addSubview:keyNumberBtn];
    
    
    UILabel *neKeyLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 200, 100, 18)];
    neKeyLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    neKeyLabel.text = @"新密码";
    neKeyLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    [self.view addSubview:neKeyLabel];
    
    self.neKeyField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 230, self.view.frame.size.width - 48, 40) key:@"newKey" placeHolder:@"请输入密码"];
    
    [self.view addSubview:self.neKeyField];
    
    UILabel *confirmKeyLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 290, 100, 18)];
    confirmKeyLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    confirmKeyLabel.text = @"确认密码";
    confirmKeyLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    [self.view addSubview:confirmKeyLabel];
    
    self.confirmKeyField = [[ZZDEditFieldView alloc]initWithFrame:CGRectMake(24, 320, self.view.frame.size.width - 48, 40) key:@"confirmKey" placeHolder:@"请再次输入密码"];
    [self.view addSubview:self.confirmKeyField];
    
    
}
// 提交的方法
- (void)submitData
{
    self.telString = self.telField.loginField.text;
    self.newkeyString = self.neKeyField.loginField.text;
    self.confirmKeyString = self.confirmKeyField.loginField.text;
    self.linkString = self.linkField.loginField.text;
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.telString];
    
//    // 如果不是手机号
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
//    if (self.newkeyString.length < 8)
//    {
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        self.hud.labelText = @"密码长度不可以小于8位";
//        self.hud.mode = MBProgressHUDModeText;
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
//        [self.hud hide:YES afterDelay:1];
//        [self.hud removeFromSuperViewOnHide];
//    }
//    
//    if (![self.newkeyString isEqualToString:self.confirmKeyString])
//    {
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        self.hud.labelText = @"密码两次输入不一致";
//        self.hud.mode = MBProgressHUDModeText;
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
//        [self.hud hide:YES afterDelay:1];
//        [self.hud removeFromSuperViewOnHide];
//    }

    if (isMatch && self.newkeyString.length != 0 && self.confirmKeyString.length != 0 && self.linkString.length != 0 && [self.newkeyString isEqualToString:self.confirmKeyString]) {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:self.telString forKey:@"mobile"];
        [dic setObject:self.linkString forKey:@"recode"];
        NSString *urlStr = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/comm/recode/check?mobile=%@&recode=%@",self.telString,self.linkString];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [dic setObject:[MD5NSString md5HexDigest:self.newkeyString] forKey:@"password"];
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        self.hud.labelText = @"修改信息提交中";
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"修改信息提交中..." alert:ZZDAlertStateLoad];
        [self.view addSubview:alertView];

        [manager POST:@"http://api.zzd.hidna.cn/v1/user/password_modify" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                self.hud.labelText = @"修改成功";
//                self.hud.mode = MBProgressHUDModeText;
//                [self.hud removeFromSuperViewOnHide];
//                [self.hud hide:YES afterDelay:1];
                [alertView loadDidSuccess:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            self.hud.labelText = @"修改失败";
//            self.hud.mode = MBProgressHUDModeText;
//            [self.hud removeFromSuperViewOnHide];
//            [self.hud hide:YES afterDelay:1];
            [alertView loadDidSuccess:@"修改失败"];
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        self.hud.labelText = @"验证码不正确";
//        self.hud.mode = MBProgressHUDModeText;
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
//        [self.hud hide:YES afterDelay:1];
//        [self.hud removeFromSuperViewOnHide];
        
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"验证码不正确" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
    }];
    }else{
//        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//        self.hud.delegate = self;
//        self.hud.labelText = @"请把内容填写完整";
//        self.hud.mode = MBProgressHUDModeText;
//        [self.view addSubview:self.hud];
//        [self.hud show:YES];
//        [self.hud hide:YES afterDelay:1];
//        [self.hud removeFromSuperViewOnHide];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请把内容填写完整" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    KeyWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[KeyWordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell setValueText:@"手机号码" placeHolder:@"请填写手机号码"];
                    break;
                    
                case 1:
                    [cell createButton];
                    [cell setValueText:@"验 证 码" placeHolder:@"请填写验证码"];

                    [cell.button addTarget:self action:@selector(receiveLink:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    [cell setValueText:@"新 密 码" placeHolder:@"设置新密码"];
                    cell.keyTextField.secureTextEntry = YES;
                    break;
                    
                case 1:
                    [cell setValueText:@"确认密码" placeHolder:@"请输入确认密码"];
                    cell.keyTextField.secureTextEntry = YES;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;



}
- (void)getKey:(NSString *)key title:(NSString *)title
{
    [self.dataDic setObject:key forKey:title];
}
//获取验证码执行的方法
- (void)receiveLink:(id)sender
{
    self.second = 60;
    //点击获取验证码， 有一个判断（手机号是否满足要求）
//    NSString *str = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9])|(170))\\d{8}$";
//    // 通过谓词来进行内容的比对
//    NSPredicate *cate = [NSPredicate predicateWithFormat:@"SELF  MATCHES%@", str];
    if (self.telField.loginField.text.length == 11) {
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refresh:) userInfo:sender repeats:YES];
    } else if (self.telField.loginField.text == nil){
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
        if (self.telField.loginField.text == nil) {
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
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.telField.loginField.text forKey:@"mobile"];
            [manager POST:@"http://api.zzd.hidna.cn/v1/comm/recode/password_forget" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    //发送成功
//                    self.hud.labelText = @"发送成功";
//                    self.hud.mode = MBProgressHUDModeText;
//                    [self.hud hide:YES afterDelay:1];
//                    [self.hud removeFromSuperViewOnHide];
                    [alertView loadDidSuccess:@"发送成功"];
                    
                }else{
                    [timer invalidate];
                    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.second = 60;
                    button.userInteractionEnabled = YES;
                }
                [alertView removeFromSuperview];
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                [alertView removeFromSuperview];
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.second = 60;
                button.userInteractionEnabled = YES;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
