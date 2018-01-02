//
//  AppDelegate.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "AppDelegate.h"
#import "MyViewController.h"
#import "MainPageViewController.h"
#import "MessageViewController.h"
#import "ZZDLoginViewController.h"
#import "AFNetworking.h"
#import "UIColor+AddColor.h"
#import "UsersViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
//#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
#import "JudgeLocalUnreadMessage.h"
#import "JudgeCreateCheatWindow.h"
#import "MD5NSString.h"
#import "ChangeIdentityViewController.h"
#import "GuidePageViewController.h"
#import "FMDB.h"
#import "FMDBMessages.h"
#import "PreviewViewController.h"
#import "PreviewViewController.h"
#import "WXApi.h" // 微信分享
#import "MessageUtils.h"
#import <ShareSDK/ShareSDK.h>

#import <ShareSDKConnector/ShareSDKConnector.h>
#import "UIImageView+WebCache.h"
#import "JPUSHService.h"
#import "ZZDAlertView.h"
#import "BossMainViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "FontTool.h"
#import "AFNInternetTool.h"
#import <Bugly/Bugly.h>
#import <UserNotifications/UserNotifications.h>
#import <UMMobClick/MobClick.h>
@interface AppDelegate ()<AVIMClientDelegate,UIScrollViewDelegate,UIAlertViewDelegate, WXApiDelegate,AMapLocationManagerDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, assign)CGFloat currentTime;
@property (nonatomic, strong)UIButton *timeLabel;
@property (nonatomic, strong)UIView *launchView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL hasGot;
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)UIView *backView;
@end

@implementation AppDelegate

// 高德地图定位成功或改变，将经纬度存入NSUserDefaults，停止定位
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
   
    NSString *lat = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"lon"];
    [manager stopUpdatingLocation];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self registerForRemoteNotification];
    
    // 注册友盟
    UMConfigInstance.appKey = @"59509f2df43e480973000f13";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 获取app当前版本
    NSString *key = @"CFBundleShortVersionString";
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 注册Bugly
    [Bugly startWithAppId:@"900057125"];
    
    // 注册微信分享
//    [WXApi registerApp:@"wxb2f8e4167b52e6ec"];
    
    // 注册高德地图并开始定位
    [AMapServices sharedServices].apiKey = @"aaa5b293cfc0a6f3d1f789a81c00f7d8";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.hasGot = NO;
    
    // 注册ShareSDK,只有分享微信平台
    [ShareSDK registerApp:@"1027772379c53" activePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb2f8e4167b52e6ec" appSecret:@"d02c4cc7bdb3919e675c779699a440a0"];
                 break;
             default:
                 break;
         }
     }];
    
    // 判断当前手机系统来注册极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService  setupWithOption:launchOptions appKey:@"a75fc04636b24317a7dc5302" channel:nil apsForProduction:@"YES" advertisingIdentifier:nil ];

/*
 SQLM3-29H3A-23383-LDCZD123456783456782345678
 */
//    [AVOSCloud setApplicationId:@"4DxnDI9vrPNqiQtrVc4xGA4i"
//                      clientKey:@"CxFl740MnKDepiA8nRuoTAcx"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    // 申请推送权限
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
            | UIUserNotificationTypeBadge
            | UIUserNotificationTypeSound
                          categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
//    [AVOSCloudCrashReporting enable];
    
#pragma mark 测试版 服务器IP：139\196\7\234  api.zzd.hidna.cn  api.zzd.hidna.cn
//    [AVOSCloud setApplicationId:@"YgAH5qTJzLnpERIGxX7QgV8v"clientKey:@"KRP40QlkF1GcwRcqcHfeygSt"];
    
#pragma mark 线上版 139|196|60|54
    // 注册LeanCloud
    [AVOSCloud setApplicationId:@"yr5XqjmeR6rjBkjp29hLMB5k"clientKey:@"3Xq44y4zBecVhzcbXA1ATxPK"];
    // 开启统计功能
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //创建启动界面，判断是否为第一次启动app
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"first"] integerValue] != 1) {
        //引导页
        GuidePageViewController *guideVC = [[GuidePageViewController alloc] init];
//        [self doBigThing];
        self.window.rootViewController = guideVC;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
    } else {
        [self doBigThing];
    }
    
    //由远程通知启动UIApplicationLaunchOptionsRemoteNotificationKey对应的是启动应用程序的的远程通知信息userInfo（NSDictionary）
    if (launchOptions) {
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            //            self.window.rootViewController.tabBarController.selectedIndex = 1;
            [[NSUserDefaults standardUserDefaults]setObject:[pushNotificationKey objectForKey:@"clientId"] forKey:@"userCheat"];
        }
        
        [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    }
    
    
    self.launchView = [[UIView alloc]initWithFrame:self.window.frame];
    self.launchView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.launchView];
    UIImageView *launchImg = [[UIImageView alloc]initWithFrame:self.window.frame];
    launchImg.alpha = 1;
    launchImg.image = [UIImage imageNamed:@"qdyqdyqdy.png"];
    
    [self.launchView addSubview:launchImg];
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:self.launchView repeats:YES];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != 0 ) {
            [AFNInternetTool getLaunchViewWithBlock:^(id result, NSString *str) {
                NSArray *arr = result;
                self.hasGot = YES;
                if ([str isEqualToString:@"0"]) {
                if ([arr isKindOfClass:[NSNull class]]) {
                    [self.launchView removeFromSuperview];
                }else{
                    NSInteger arrCount = arr.count;
                    NSInteger count = arc4random() % arrCount;
                    NSDictionary *dic = [arr objectAtIndex:count];
                    
                    [launchImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]]placeholderImage:[UIImage imageNamed:@"qdyqdyqdy.png"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        launchImg.frame = self.window.frame;
                        self.currentTime = 0;
                        self.timeLabel = [[UIButton alloc]initWithFrame:CGRectMake(self.window.frame.size.width - 80, 30, 70, 30)];
                        [self.timeLabel addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
                        [self.timeLabel setTitle:@"跳过" forState:UIControlStateNormal];
                        self.timeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                        self.timeLabel.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
                        self.timeLabel.layer.cornerRadius = 5;
                        self.timeLabel.layer.masksToBounds = YES;
                        [self.launchView addSubview:self.timeLabel];
                    }];
                }
                }else{
                    [self.launchView removeFromSuperview];
                }
            }];
            
        }
        }];
            
        

    return  YES;
}

- (void)doBigThing
{
    NSMutableArray *tabBarArr = [NSMutableArray array];
    MainPageViewController *mainPage = [[MainPageViewController alloc]init];
    UINavigationController *mainPageNav = [[UINavigationController alloc]initWithRootViewController:mainPage];
    mainPageNav.navigationBar.barTintColor = [UIColor zzdColor];
    [tabBarArr addObject:mainPageNav];
    
    UIImage *mainImage = [[UIImage imageNamed:@"navbar _icon_home.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mainImageSelected = [[UIImage imageNamed:@"navbar _icon_homeS.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainPageNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:mainImage selectedImage:mainImageSelected];
    
    self.message = [[UsersViewController alloc]init];
    
    UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:self.message];
    
    messageNav.navigationBar.barTintColor = [UIColor zzdColor];
    
    [tabBarArr addObject:messageNav];
    
    UIImage *messageImage = [[UIImage imageNamed:@"navbar _icon_message.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *messageImageSelected = [[UIImage imageNamed:@"navbar _icon_messageS.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    messageNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:messageImage selectedImage:messageImageSelected];
    
    self.bossVC = [[BossMainViewController alloc]init];
    
    self.bossNav = [[UINavigationController alloc]initWithRootViewController:self.bossVC];
    
    self.bossNav.navigationBar.barTintColor = [UIColor zzdColor];
    
    [tabBarArr addObject:self.bossNav];
    
    UIImage *myViewImage = [[UIImage imageNamed:@"navbar _icon_personal.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *myViewImageSelected = [[UIImage imageNamed:@"navbar _icon_personalS.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.bossNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:myViewImage selectedImage:myViewImageSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor hcColor], NSForegroundColorAttributeName,[[FontTool customFontArrayWithSize:12]objectAtIndex:0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName,[[FontTool customFontArrayWithSize:12]objectAtIndex:0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.tabBar = [[UITabBarController alloc]init];
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 49)];
//    backView.backgroundColor = [UIColor hcColor];
//    [self.tabBar.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.tabBar.opaque = YES;
    
    
    self.tabBar.viewControllers = tabBarArr;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar.tabBar insertSubview:backView atIndex:0];
    self.tabBar.tabBar.opaque = YES;
  
    
//判断本地缓存是否为空
    if ([AVUser currentUser] != nil) {
        [self tellUser];
        
    }
    
    //测试用
    ChangeIdentityViewController *change = [[ChangeIdentityViewController alloc]init];
    ZZDLoginViewController *login = [[ZZDLoginViewController alloc]init];
    PreviewViewController * preview = [[PreviewViewController alloc]init];
    UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:login];
    UINavigationController *navPreview = [[UINavigationController alloc]initWithRootViewController:preview];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"user"] != nil) {
        [AFNInternetTool getCityListAndSave];
        if ([user objectForKey:@"state"]!= nil) {
            
            if ([[user objectForKey:@"state"] isEqualToString:@"1"]) {
                
                [change workTap:nil];
               
                self.window.rootViewController = _tabBar;
            }else if([[user objectForKey:@"state"]isEqualToString:@"2"]){
            
                [change bossTap:nil];
                
                
                
                
                self.window.rootViewController = _tabBar;
                
               
            }else{
                [FMDBMessages deleteAllConversation];
                //self.window.rootViewController = navLogin;
                
                self.window.rootViewController = navPreview;
            }
        }else{
             [FMDBMessages deleteAllConversation];
            //self.window.rootViewController = navLogin;
          
            self.window.rootViewController = navPreview;
        }
        
    }else{
            [FMDBMessages deleteAllConversation];
        //self.window.rootViewController =navLogin;
        self.window.rootViewController = navPreview;
    }
    
}
- (void)imClientPaused:(AVIMClient *)imClient
{
    
}
- (void)tellUser
{
    //接收消息
    
    
    if ([AVUser currentUser].objectId) {
        
        
    
    self.mainClient = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].objectId tag:@"Mobile"];
    self.mainClient.delegate = self;
//
        AVIMClientOpenOption *option = [[AVIMClientOpenOption alloc] init];
        option.force = YES;
        [self.mainClient openWithOption:option callback:^(BOOL succeeded, NSError * _Nullable error) {
            
        }];
    
    
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"] == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"messageArr"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"serviceArr"] == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"serviceArr"];
    }                                                                                     
    [JudgeLocalUnreadMessage tellNavHowMuchMessage];
}
-(void)client:(AVIMClient *)client didOfflineWithError:(NSError *)error{
    if ([error code]  == 4111) {
        //适当的弹出友好提示，告知当前用户的 Client Id 在其他设备上登陆了
        self.mainClient = [[AVIMClient alloc] initWithClientId:client.clientId tag:@"Mobile"];
        if (client!=nil && client.status == AVIMClientStatusOpened) {
            [AVUser logOut];
            [self.mainClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                [self log];
            }];
        } else {
            
            [AVUser logOut];
            [self.mainClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                [self log];
            }];
        }
        
    }
}
- (void)removeSelf:(UITapGestureRecognizer *)tap
{
    for (UIView *view in tap.view.subviews) {
        [view removeFromSuperview];
    }
    [tap.view removeFromSuperview];
    self.backView = nil;
}
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message
{
    
    NSLog(@"%@",message.attributes);
    NSNumber *lyNum = [message.attributes objectForKey:@"ly"];
    NSString *yms = [message.attributes objectForKey:@"yms"];
    if (lyNum != nil) {
        
        if (self.bossNav!= nil) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"] == nil) {
                [[NSUserDefaults standardUserDefaults]setObject:@[@""] forKey:@"lyArr"];
                
            }else{
                NSMutableArray *lyArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"]];
                [lyArr addObject:@""];
                [[NSUserDefaults standardUserDefaults]setObject:lyArr.copy forKey:@"lyArr"];
            
            }
            NSArray *lyArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"];
            
            [[self.tabBar.viewControllers objectAtIndex:2].tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",lyArr.count]];;
        }
        NSLog(@"2");
    }else{
    
    if ([AVUser currentUser].objectId != nil) {
        
        if ([[message.attributes objectForKey:@"wx"]isEqualToString:@"yes"]){
            
        }
        if ([[message.attributes objectForKey:@"show"]isEqualToString:@"1"]) {
            if (!self.backView) {
                
            
            self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
            self.backView.backgroundColor = [UIColor clearColor];
            [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf:)]];
            [self.window addSubview:self.backView];
            }
            NSData * data = [NSJSONSerialization dataWithJSONObject:message.text options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            UIImageView *showImage = [[UIImageView alloc]initWithFrame:CGRectZero];
            showImage.userInteractionEnabled = YES;
            
            
            UIImageView *cancelImage = [[UIImageView alloc]initWithFrame:CGRectZero];
            cancelImage.image = [UIImage imageNamed:@"cancelShow"];
            
            [showImage sd_setImageWithURL:[NSURL URLWithString:[jsonDic objectForKey:@"pic"]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                }];
                showImage.frame = CGRectMake(0, 0, self.window.frame.size.width - 80, (self.window.frame.size.width - 80) * image.size.height / image.size.width);
                showImage.center = self.window.center;
                if (self.backView) {
                    
                
                [self.backView addSubview:showImage];
                    
                    cancelImage.frame = CGRectMake(self.window.frame.size.width - 70, (self.window.frame.size.height - showImage.frame.size.height )/ 2 - 40, 30, 30);
                    [self.backView addSubview:cancelImage];
                }
            }];
            
            
            
            
            
        }else{
        //通知消息
        if ([message.attributes objectForKey:@"sub_type"]!= nil) {
            
            NSInteger subType = [[message.attributes objectForKey:@"sub_type"]integerValue];
            NSInteger bossOrWorker = [[message.attributes objectForKey:@"bossOrWorker"]integerValue];
            NSDictionary *attributes = [NSDictionary dictionary];
            if (bossOrWorker == 1) {
                attributes = [message.attributes objectForKey:@"jd"];
                
            }else if(bossOrWorker == 2){
                attributes = [message.attributes objectForKey:@"rs"];
            }
            NSString *str = @"";
            if (subType == 5 || subType == 6) {
                NSString *edu = @"";
                if (subType == 5) {
                    edu = [attributes objectForKey:@"education"];
                }else if (subType == 6){
                    edu = [[message.attributes objectForKey:@"user"]objectForKey:@"highest_edu"];
                    
                }
                str = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",[attributes objectForKey:@"salary"],[attributes objectForKey:@"work_year"],[attributes objectForKey:@"city"],edu];
            }else{
                if ([[message.attributes objectForKey:@"bossOrWorker"]isEqualToString:@"1"]) {
                    str = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",[attributes objectForKey:@"salary"],[attributes objectForKey:@"work_year"],[attributes objectForKey:@"city"],[attributes objectForKey:@"education"]];
                }else if([[message.attributes objectForKey:@"bossOrWorker"]isEqualToString:@"2"]){
                    str = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",[attributes objectForKey:@"salary"],[attributes objectForKey:@"work_year"],[attributes objectForKey:@"city"],[[message.attributes objectForKey:@"user"]objectForKey:@"highest_edu"]];
                }
            }
            
            
            [FMDBMessages saveNotificationMessage:message text:str];
            
        }
//    if (![[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"-1"]) {
        
        [FMDBMessages saveMessage:message];
//    }
    
    NSDictionary *attributes = message.attributes;
    
    NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
    //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
    [conDic setObject:message.clientId forKey:@"yourId"];
    [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
    
    if ([attributes objectForKey:@"jdId"]!= nil) {
        
        [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
    }
    if ([attributes objectForKey:@"rsId"]!= nil) {
        
        [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
    }
    [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
    [conDic setObject:[attributes objectForKey:@"bossOrWorker"] forKey:@"bossOrWorker"];
    
    AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:message.clientId];
    
    [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
        NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
        if ([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]] isEqualToString:@"0"]) {
            [conDic setObject:[NSString stringWithFormat:@"您正在与%@沟通",name] forKey:@"lastText"];
        }else if([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"-1"]){
            
   //之后修改
          
            if ([message.text isKindOfClass:[NSDictionary class]]) {
                NSData * data = [NSJSONSerialization dataWithJSONObject:message.text options:NSJSONWritingPrettyPrinted error:nil];
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [conDic setObject:[jsonDic objectForKey:@"title"] forKey:@"lastText"];
            }else{
            
            
            
            


            
            
            
                [conDic setObject:message.text forKey:@"lastText"];
           
            }
        }else{
            NSString *content = [MessageUtils getMessageBrief:message];
            [conDic setObject:content forKey:@"lastText"];
        }
      
        if (name.length != 0) {
            
            [conDic setObject:name forKey:@"name"];
        }
        if (header.length != 0) {
            [conDic setObject:header forKey:@"header"];
            
        }
        if ([message.attributes objectForKey:@"sub_type"]== nil) {
        if (![[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"-1"]) {
            
            [FMDBMessages judgeConversationExist:conDic];
        }else{
            [FMDBMessages judgeServiceConversationExist:conDic];
        }
        }
    }];

    if ([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"-1"])
    {
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"]mutableCopy];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:message.clientId forKey:@"clientId"];
        [dic setObject:[message.attributes objectForKey:@"bossOrWorker"]  forKey:@"state"];
        [array addObject:dic];
        
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"messageArr"];
        [JudgeLocalUnreadMessage tellNavHowMuchMessage];
//        [JudgeCreateCheatWindow judgeServiceConversationExist:message objectId:message.clientId];
        
        NSMutableArray *serviceArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"serviceArr"]mutableCopy];
        NSMutableDictionary *serviceDic = [NSMutableDictionary dictionary];
        [serviceDic setObject:message.text forKey:@"text"];
        [serviceDic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
        [serviceDic setObject:[message.attributes objectForKey:@"bossOrWorker"] forKey:@"state"];
        [serviceDic setObject:message.clientId forKey:@"sendId"];
        [serviceDic setObject:[AVUser currentUser].objectId forKey:@"receiveId"];
        if ([message.attributes objectForKey:@"yms"]) {
             [serviceDic setObject:[message.attributes objectForKey:@"yms"] forKey:@"yms"];
        }
        [serviceDic setObject:[NSString stringWithFormat:@"%d", message.mediaType] forKey:@"mediaType"];
        if ([message.attributes objectForKey:@"type"]) {
            [serviceDic setObject:[message.attributes objectForKey:@"type"] forKey:@"type"];
        }
        [serviceArr addObject:serviceDic];
        [[NSUserDefaults standardUserDefaults]setObject:serviceArr forKey:@"serviceArr"];
        
        
    }else{
        //通知
        if (![[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"0"] ) {
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"]mutableCopy];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:message.clientId forKey:@"clientId"];
            [dic setObject:[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"bossOrWorker"]]  forKey:@"state"];
        [dic setObject:[NSString stringWithFormat:@"%@", [message.attributes objectForKey:@"jdId"]] forKey:@"jdId"];
        
        [array addObject:dic];
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"messageArr"];
        [JudgeLocalUnreadMessage tellNavHowMuchMessage];
                
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
        NSString *jdId = [NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"jdId"]];
        NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@",jdId];
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:uid forKey:@"uid"];
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                    NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                    [para setObject:time forKey:@"timestamp"];
                    [para setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                    
                    [manager GET:url parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                            NSDictionary *jdDic = [responseObject objectForKey:@"data"];
                            
                            AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:message.clientId];
                            
                            [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                                
                                [JudgeCreateCheatWindow judgeConversationExist:message objectId:message.clientId jdDic:jdDic userDic:[object objectForKey:@"localData"]state:[message.attributes objectForKey:@"bossOrWorker"]];
                            }];
                        }
                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                        
                    }];
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            
            }
        }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"message" object:message];
    
}
    }
    }
}
//可以改动＝＝＝＝＝＝＝＝＝
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive) {
        
           } else {
       
        self.tabBar.selectedIndex = 1;
 
        [[NSUserDefaults standardUserDefaults]setObject:[userInfo objectForKey:@"clientId"] forKey:@"userCheat"];
               
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
     [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    [JPUSHService registerDeviceToken:deviceToken];
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)registerForRemoteNotification {
    // iOS10 兼容
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        // 监听回调事件
        [uncenter setDelegate:self];
        //iOS10 使用以下方法注册，才能得到授权
        [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    //TODO:授权状态改变
                                    NSLog(@"%@" , granted ? @"授权成功" : @"授权失败");
                                }];
        // 获取当前的通知授权状态, UNNotificationSettings
        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
            /*
             UNAuthorizationStatusNotDetermined : 没有做出选择
             UNAuthorizationStatusDenied : 用户未授权
             UNAuthorizationStatusAuthorized ：用户已授权
             */
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                NSLog(@"未选择");
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                NSLog(@"未授权");
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"已授权");
            }
        }];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
#pragma clang diagnostic pop
}
#pragma mark 处理微信通过URL启动App时传递的数据
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return  [WXApi handleOpenURL:url delegate:nil];
    
}


// 添加app回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}
- (void)action:(NSTimer *)timer
{
    self.currentTime = self.currentTime + 1;
    
    if (self.currentTime >= 5.0) {
        
        [timer.userInfo removeFromSuperview];
        [timer invalidate];
        self.currentTime = 0;
    }else if(self.currentTime >= 2.0 && self.hasGot == NO){
        
        [timer.userInfo removeFromSuperview];
        [timer invalidate];
        self.currentTime = 0;
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
    self.window.rootViewController = navLogin;
    
    if (self.alert == nil) {
        //        app.alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您的账号在另外一台设备上登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
        
        self.alert = [[ZZDAlertView alloc]initWithView:self.window];
        [self.alert setTitle:@"转折点提示" detail:@"您的账号在另外一台设备上登录" alert:ZZDAlertStateNormal];
        [self.window addSubview:self.alert];
    }
}


- (void)jumpPage:(id)sender
{
    [self.timer invalidate];
    [self.launchView removeFromSuperview];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    int num=(int)application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
