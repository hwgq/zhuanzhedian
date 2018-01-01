//
//  MySettingViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/26.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MySettingViewController.h"
#import "CreateNewJobTableViewCell.h"
#import "ChangeKeyViewController.h"
#import "ChangeIdentityViewController.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AboutUsViewController.h"
#import "UIColor+AddColor.h"
#import "AVOSCloud/AVOSCloud.h"
#import "FontTool.h"
#import "WXApi.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import <UMMobClick/MobClick.h>
@interface MySettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *settingTable;
@end

@implementation MySettingViewController
{
    enum WXScene _scene; //请求发送场景
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [AVAnalytics beginLogPageView:@"MySetting"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"MySetting"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"设置";
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSettingTable];
    [self createBottomButton];
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createBottomButton
{
    UIButton *goBackButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 170 + 48, self.view.frame.size.width, 48)];
    goBackButton.layer.borderColor = [UIColor colorWithWhite:0.93 alpha:1].CGColor;
    goBackButton.layer.borderWidth = 0.5;
    goBackButton.titleLabel.textAlignment = 1;
    [goBackButton setTitleColor:[UIColor colorFromHexCode:@"666666"] forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setTitle:@"退出登录" forState:UIControlStateNormal];
    goBackButton.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    goBackButton.backgroundColor = [UIColor whiteColor];
    [self.settingTable addSubview:goBackButton];
    
}
- (void)alert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"确定退出登录?"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333333"] range:NSMakeRange(0, 7)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 7)];
    
   
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];

  
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goBack];
    }];
    [cancelAction setValue:[UIColor colorFromHexCode:@"333333"] forKey:@"titleTextColor"];
    [okAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
  
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)clearnUserAndLogin
{
    [AVUser logOut];
    //清理UserDefault
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"first"];
     [[NSUserDefaults standardUserDefaults]setObject:@"firstUserRegist" forKey:@"firstUserRegist"];
    ZZDLoginViewController *login = [[ZZDLoginViewController alloc]init];
    //跳转到登录
    UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:login];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = navLogin;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)goBack
{
    //pip:bug #7 退出时，im未退
    //im 退出
    
    
    
    
    AVIMClient *client = [AVIMClient defaultClient];
    [client openWithClientId:[AVUser
                              currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            
            if (client!=nil && client.status == AVIMClientStatusOpened) {
                [AVUser logOut];
                [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self clearnUserAndLogin];
                        NSLog(@"成功关闭1");
                    }else
                    {
                        NSLog(@"%@",error);
                    }
                    
                }];
            }else{
                [AVUser logOut];
                [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                    [self clearnUserAndLogin];
                    NSLog(@"成功关闭2");
                }];
            }
        }
        else{
            NSLog(@"无法退出");
        }
    }];

   }

- (void)createSettingTable
{
    self.settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.settingTable.delegate = self;
    self.settingTable.dataSource = self;
    self.settingTable.rowHeight = 48;
    self.settingTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.settingTable.separatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:self.settingTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            [cell getTitleLabelText:@"修改密码"];
            break;
            
        case 1:
            [cell getTitleLabelText:@"客服热线"];
            cell.returnLabel.text = @"工作日9:00-18:00";
            break;
            
        case 2:
            [cell getTitleLabelText:@"关于我们"];
            break;
        case 3:
            [cell getTitleLabelText:@"分享APP"];
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeKeyViewController *changeKey = [[ChangeKeyViewController alloc]init];
    ChangeIdentityViewController *changeId = [[ChangeIdentityViewController alloc]init];
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
    NSMutableString * str1 =[[NSMutableString alloc]initWithFormat:@"tel:%@",@"4008072022"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:changeKey animated:YES];
            break;
            
        case 1:
           
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str1]]];
            [self.view addSubview:callWebview];
            break;
        
        case 2:
            aboutUs.url = @"http://api.zzd.hidna.cn/v1/conf/about_us";
            [self.navigationController pushViewController:aboutUs animated:YES];
            break;
        case 3:
            
            [self sharedAction:nil];
            break;
        default:
            break;
    }
}
#pragma mark -- 分享按钮
- (void)sharedAction:(UIButton*)button{
    
    // 解决循环引用
    //    __weak typeof(id) ws = self;
    //
    //    UIActionSheet *acSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈", nil];
    //    acSheet.tag =2;
    //    acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //    [acSheet showInView:[[UIApplication sharedApplication]keyWindow]];
    
    NSString *str =[NSString stringWithFormat: @"http://download.izhuanzhe.com"];
    //        // 设置标题
    NSString * title = @"转折点APP";
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSArray* imageArray = @[[UIImage imageNamed:@"iico.png"]];
        
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"转折点直聘-专注生物医药移动求职招聘，邀请您加入" images:imageArray  url:[NSURL URLWithString:str] title:title
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [AVAnalytics event:@"APPShare"];
                                   [MobClick event:@"APPShare"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}
        
    }
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==2){
        if (buttonIndex == 0) {
            _scene = WXSceneSession;
            
        }
        else if (buttonIndex == 1) {
            _scene = WXSceneTimeline;
            
        }
    }
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
