//
//  NotificationViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/2/18.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotifiTableViewCell.h"
#import "FMDBMessages.h"
#import "NotificationMessage.h"
#import "WorkResumeDetailViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AppDelegate.h"
#import "SelectJobViewController.h"
#import "JobDetailViewController.h"
#import "ZZDAlertView.h"
#import <UMMobClick/MobClick.h>
@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *notiTable;
@property (nonatomic, strong)NSMutableArray *notiArr;
@property (nonatomic, strong)AVIMClient *receiveClient;
@end

@implementation NotificationViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.notiArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"notificationView"];
    [AVAnalytics beginLogPageView:@"notificationView"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"notificationView"];
    [AVAnalytics endLogPageView:@"notificationView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *notifi = [FMDBMessages selectAllNotifiMessage];
    self.notiArr = notifi;
    
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    [self createNotificationTable];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    
    titleLabel.text = @"通知";
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.navigationItem.titleView = titleLabel;
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createNotificationTable
{
    self.notiTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.notiTable.delegate = self;
    self.notiTable.dataSource = self;
    self.notiTable.rowHeight = 80;
    self.notiTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.notiTable.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:self.notiTable];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notiArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    NotifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NotifiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getValueFrom:[self.notiArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationMessage *message = (NotificationMessage *)[self.notiArr objectAtIndex:indexPath.row];
    NSInteger subType = [message.subType integerValue];
    if (message.bossOrWorker == 1) {
        
        if (subType == 5) {
            [self goToJobDetail:message];
        }else{
        
        [self goToSelectJob:message];
        }
    }else if (message.bossOrWorker == 2)
    {
        [self goToWorkResumeDetail:message];
    }
    
    
}
- (void)goToJobDetail:(NotificationMessage *)message
{
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            
            
            NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
            
            NSString *str  = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%ld",message.jdId];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            [dic setObject:uid forKey:@"uid"];
            [dic setObject:time forKey:@"timestamp"];
            [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [manager GET:str parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    NSDictionary *dic = [responseObject objectForKey:@"data"];
                    jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [self.navigationController pushViewController:jobDetail animated:YES];
                    
                    
                    
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    
                    if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened) {
                        [AVUser logOut];
                        [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    } else {
                        [AVUser logOut];
                        [self log];
                    }
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)goToSelectJob:(NotificationMessage *)message
{
    SelectJobViewController *selectJob = [[SelectJobViewController alloc]init];
    selectJob.rsId = [NSNumber numberWithInteger: message.rsId];
    selectJob.objectId = message.receiveId;
    selectJob.type = @"self";
    selectJob.alertType = @"YES";
    selectJob.uid = message.uid;
    selectJob.cheatHeader = message.avatar;
    selectJob.name = message.name;
    selectJob.token = message.token;
    [self.navigationController pushViewController:selectJob animated:YES];
}
- (void)goToWorkResumeDetail:(NotificationMessage *)message
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%ld",message.rsId];
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
            
            [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    WorkResumeDetailViewController *detail = [[WorkResumeDetailViewController alloc]initWithButton:@"2"];
                   
                    detail.dic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                    [self.navigationController pushViewController:detail animated:YES];
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    
                    if (self.receiveClient!=nil && self.receiveClient.status == AVIMClientStatusOpened) {
                        [AVUser logOut];
                        [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    } else {
                        [AVUser logOut];
                        [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                            [self log];
                        }];
                    }
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
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
@end
