//
//  AboutUsViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/12/3.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MD5NSString.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import <UMMobClick/MobClick.h>
#import "FontTool.h"
#import "WXApi.h" // 微信分享
@interface AboutUsViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong)UIWebView *myWebView;
@property (nonatomic, strong)NSDictionary *mainDic;
@property (nonatomic, strong)MBProgressHUD *hud;
@end
//4008072022
@implementation AboutUsViewController
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
    [MobClick beginLogPageView:@"AboutUsView"];
    [AVAnalytics beginLogPageView:@"AboutUsView"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"SelectJobView"];
    [AVAnalytics endLogPageView:@"AboutUsView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    if ([self.ddd isEqualToString:@"1"]) {
        NSString *webUrl = self.url;
        //                    NSString *webUrl = @"http://www.baidu.com";
        NSURL *myUrl = [NSURL URLWithString:webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
        [self.myWebView loadRequest:request];
        
        UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 20, 20)];
        shareImage.image = [UIImage imageNamed:@"fenxiang copy.png"];
        UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharedAction:)];
        shareImage.userInteractionEnabled = YES;
        
        [shareImage addGestureRecognizer:shareTap];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareImage];
    }else{
    [self startNetWorking];
    
    }
    // 最上面的返回按钮
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    // Do any additional setup after loading the view.
    
    
    
     NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",@"http://api.zzd.hidna.cn/v1/jd/communicate",[dic objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [manager GET:@"http://api.zzd.hidna.cn/v1/jd/communicate" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                   
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    if ([self.ddd isEqualToString:@"1"]) {
        
    }else{
    titleLabel.text = @"功能教程与攻略";
    
    }
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;

}
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
    NSString *str = @"http://api.zzd.hidna.cn/v1/car/share";
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[dic objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                
                
                
                if ([[responseObject objectForKey:@"share"]integerValue] == -1) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"绑定车牌,即可分享"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"返回"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }else{
                
                NSString *strUrl =[NSString stringWithFormat: @"http://share.izhuanzhe.com/v1/car/click?car=%@", [dic objectForKey:@"uid"]];
                
                
                
                if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                    
                    NSArray* imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]]];
                    
                    if (imageArray) {
                        
                        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                        [shareParams SSDKSetupShareParamsByText:@"转折点-老司机电影票就在眼前，小伙伴们赶快动动您的手指，帮我点击头像踩住油门，让我向着胜利的方向狂飙吧！"
                                                         images:imageArray
                                                            url:[NSURL URLWithString:strUrl]
                                                          title:@"我在开车，十万火急，快来帮我加速抢电影票！"
                                                           type:SSDKContentTypeAuto];
                        //2、分享（可以弹出我们的分享菜单和编辑界面）
                        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                 items:nil
                                           shareParams:shareParams
                                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                       
                                       switch (state) {
                                           case SSDKResponseStateSuccess:
                                           {
                                               [AVAnalytics event:@"JDShare"];
                                               [MobClick event:@"JDShare"];
                                               
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
                                   
                
                                   }];
                
                         }
                }
                }
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
            }
         
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
}
// 返回按钮执行的方法
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)startNetWorking
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"加载中...   " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",self.url,[dic objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [manager GET:self.url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    self.mainDic = [responseObject objectForKey:@"data"];
                    NSString *webUrl = [self.mainDic objectForKey:@"url"];
//                    NSString *webUrl = @"http://www.baidu.com";
                    NSURL *myUrl = [NSURL URLWithString:webUrl];
                    NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
                    [self.myWebView loadRequest:request];
                    
//                    [self.hud removeFromSuperViewOnHide];
//                    [self.hud hide:YES];
                    [alertView loadDidSuccess:@"加载成功"];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)createWebView
{
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.myWebView];
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
