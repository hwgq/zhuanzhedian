//
//  JobShareViewController.m
//  zhuanzhedian
//
//  Created by 李文涵 on 16/1/11.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "JobShareViewController.h"
#import "WXApi.h" // 微信分享
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "AppDelegate.h"
#import "ZZDLoginViewController.h"
#import "MainPageViewController.h"
#import "PostOfficeViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "InternetRequest.pch"


@interface JobShareViewController ()<WXApiDelegate>
@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong)UIImageView *centerImageView;
@property (nonatomic, strong)UILabel *centerLabel;

@property (nonatomic, strong)UIButton *clickButton;
@property (nonatomic, strong)UILabel *downLabel;

@property (nonatomic, strong)UIImageView *roundImageView;

@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSMutableDictionary *dictionary;
@end

@implementation JobShareViewController
{
    enum WXScene _scene; //请求发送场景
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.array = [NSMutableArray array];
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.backImageView.image = [UIImage imageNamed:@"qd_icon.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [self.backImageView addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backImageView];
    // 隐藏返回按钮
    [self.navigationItem setHidesBackButton:YES];
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    t.font = [UIFont systemFontOfSize:12];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = 1;
    t.text = @"发布职位";
    self.navigationItem.titleView = t;
    
    
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size. width / 3 - 25 , self.view.frame.size. width / 3 , self.view.frame.size. width / 3 + 50, self.view.frame.size. width / 3 + 50)];
    self.centerImageView.image = [UIImage imageNamed:@"cen_icon"];
    [self.view addSubview:self.centerImageView];
    
    
    self.centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, self.view.frame.size. width / 3 * 2 + 60 , self.view.frame.size. width - 100, 40)];
    [self.view addSubview:self.centerLabel];
    self.centerLabel.text = @"发布职位成功";
    self.centerLabel.textColor = [UIColor grayColor];
    self.centerLabel.textAlignment = 1;
    
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.clickButton];
    self.clickButton.frame = CGRectMake(10, self.view.frame.size.height - 150, self.view.frame.size.width - 20, 40);
    self.clickButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.75 blue:0.95 alpha:1];
    self.clickButton.layer.cornerRadius = 7;
    
    // 上面的图片和字
    self.roundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.clickButton.frame.size.width / 3 - 30, 5, 30, 30)];
    self.roundImageView.image = [UIImage imageNamed:@"icon_f"];
    [self.clickButton addSubview:self.roundImageView];
    
    [self.clickButton setTitle:@"   分享到朋友圈" forState:UIControlStateNormal];
    self.clickButton.titleLabel.textAlignment = 1;
    self.clickButton.titleLabel.frame = CGRectMake(self.clickButton.frame.size.width / 3 + 30, 10, self.clickButton.frame.size.width / 2, 20);
    [self.clickButton addTarget:self action:@selector(sharedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.downLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 100, self.view.frame.size.width - 20, 20)];
    [self.view addSubview:self.downLabel];
    self.downLabel.text = @"让发布的职位得到更多的曝光";
    self.downLabel.textAlignment = 1;
    self.downLabel.font = [UIFont systemFontOfSize:14];
    self.downLabel.textColor = [UIColor grayColor];
    
    
    
}

#pragma mark ------ 点击分享按钮
- (void)sharedAction:(UIButton *)button
{
    // 解决循环引用
    __weak typeof(id) ws = self;
    _scene = WXSceneTimeline;
    
    // 获取url
    [self sendUrlContent];
    
}

- (void)sendUrlContent{
    
    //    // 网络请求
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *str = @"http://api.zzd.hidna.cn/v1/jd/my/all";
#pragma 此处切换分享接口后会导致退出登陆
    NSString *str = [NSString stringWithFormat:@"%@jd/my/all", SHARE_URL];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[dic objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                self.array = [(NSDictionary *)responseObject objectForKey:@"data"];
                [[NSUserDefaults standardUserDefaults]setObject:self.array forKey:@"jd"];
                
                // 便利找id
                for (NSMutableDictionary *dic in self.array) {
                    if ([dic[@"id"]isEqualToString:self.jdId]) {
                        self.dictionary = dic;
                    }
                }
                

      
                
                NSString *strUrl =[NSString stringWithFormat: @"http://share.izhuanzhe.com/v1/share/jd?id=%@", self.jdId];
                
                
                
                if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                    
                    WXMediaMessage *message = [WXMediaMessage message];
                    
                    // 设置标题
                    message.title = [NSString stringWithFormat:@"【%@】%@正在转折点上招%@", [[self.dictionary objectForKey:@"cp"]objectForKey:@"sub_name"], [[self.dictionary objectForKey:@"user"]objectForKey:@"name"], [self.dictionary objectForKey:@"title"]];
                    
                    // 设置内容
                    message.description = [NSString stringWithFormat:@"【%@】%@正在转折点上招%@", [[self.dictionary objectForKey:@"cp"]objectForKey:@"sub_name"], [[self.dictionary objectForKey:@"user"]objectForKey:@"name"], [self.dictionary objectForKey:@"title"]];
                    
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.image = [UIImage imageNamed:@"DefaultSmall"];
                    [message setThumbImage:imageView.image];
                    
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = strUrl;
                    
                    message.mediaObject = ext;
                    
                    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = _scene;
                    
                    [WXApi sendReq:req];
                }
                
                
                
                
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


#pragma mark ------ 返回按钮执行方法
- (void)goToLastPage
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    // 跳到不同的tabBar, 不能用push
//    
   
//
    
//    PostOfficeViewController *postVC = [[PostOfficeViewController alloc]init];
//    [self.navigationController popToViewController:postVC animated:YES];
    NSInteger a = 0;
    NSArray *arr = self.navigationController.viewControllers;
    for (UIViewController *viewC in arr) {
        if ([viewC isKindOfClass:[PostOfficeViewController class]]) {
            a = 1;
            [self.navigationController popToViewController:viewC animated:YES];
        }
    }
    if (a == 0) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
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
