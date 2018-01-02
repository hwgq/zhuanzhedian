//
//  AFNInternetTool.m
//  zhuanzhedian
//
//  Created by Gaara on 16/10/24.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "AFNInternetTool.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "ZZDAlertView.h"
#import "UIColor+AddColor.h"
@interface AFNInternetTool ()

@end
@implementation AFNInternetTool
+ (void)getLaunchViewWithBlock:(void (^)( id result, NSString *str))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.360zhyx.com/api-ads-launch-app_id-1" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        block([responseObject objectForKey:@"data"],[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ret"]]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(NULL,@"-1");
    }];
}

+ (void)getCityListAndSave
{
    [[self class] getTimeStampWithBlock:^(id time, NSString *str) {
        if ([time isKindOfClass:[NSString class]]) {
            
        
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
        NSString *urlStr = @"http://api.zzd.hidna.cn/v1/conf/city";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlStr,[userDic objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    NSArray *cityArr = [dic objectForKey:@"data"];
                    [[NSUserDefaults standardUserDefaults]setObject:cityArr forKey:@"city"];
                    
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
         
        }
    }];
}

+ (void)getTimeStampWithBlock:(void (^)(id time, NSString *str))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            block(time,@"0");
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       
    }];
}

- (void)logOutUser
{
    if ([AVUser currentUser].objectId != nil) {
        AVIMClient * client = [AVIMClient defaultClient];
        [client openWithCallback:^(BOOL succeeded, NSError *error) {
            
        }];
        if (client!=nil && client.status == AVIMClientStatusOpened) {
            [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                [[self class] log];
            }];
        } else {
            [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                [[self class] log];
            }];
        }
        
    }else{
        [[self class] log];
    }
}
+(void)log
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
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.window.rootViewController = navLogin;
    
    if (appdelegate.alert == nil) {
        appdelegate.alert = [[ZZDAlertView alloc]initWithView:appdelegate.window];
        [appdelegate.alert setTitle:@"转折点提示" detail:@"您的账号在另外一台设备上登录" alert:ZZDAlertStateNormal];
        [appdelegate.window addSubview:appdelegate.alert];
        
    }
    
}

+ (void)getPreListWithUrl:(NSString *)url andBlock:(void (^)( id result, NSString *str))block
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"] isEqualToString:@"0"]) {
            
            NSMutableArray * arr = [responseObject objectForKey:@"data"];
            block(arr,@"0");
        }else{
            block(@[],@"-1");
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(@[],@"-1");
        
    }];
}
@end
