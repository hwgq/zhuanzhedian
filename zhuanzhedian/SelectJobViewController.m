//
//  SelectJobViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/17.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "SelectJobViewController.h"
#import "SelectJobTableViewCell.h"
#import "UIColor+AddColor.h"
#import "CheatViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "UILableFitText.h"
#import "ZZDAlertView.h"
#import "FontTool.h"
#import "CollectPersonTableViewCell.h"
#import "RobotViewController.h"
#import <UMMobClick/MobClick.h>
@interface SelectJobViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong)UITableView *jobTable;
@property (nonatomic, strong)NSMutableArray *jobArr;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation SelectJobViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.jobArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"SelectJobView"];
    [AVAnalytics beginLogPageView:@"SelectJobView"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"SelectJobView"];
    [AVAnalytics endLogPageView:@"SelectJobView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    
    
    self.navigationController.navigationBar.translucent = NO;
//    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"jd"];
    [self createJobTableView];
//    if (arr.count == 0) {
    if ([self.type isEqualToString:@"self"]) {
        [self startOtherConnected];
    }else{
        [self startConnection];
    }
//        self.jobTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
//    }else{
//        self.jobArr = [NSMutableArray arrayWithArray:arr];
//        [self.jobTable reloadData];
//    }
}
- (void)startOtherConnected
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    self.hud.activityIndicatorColor = [UIColor zzdColor];
//    self.hud.labelText = @"加载中...";
//    
//    self.hud.labelFont = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"加载中... " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"http://api.zzd.hidna.cn/v1/jd/user";
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:self.uid forKey:@"userId"];
        [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[dic objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                self.jobArr = [(NSDictionary *)responseObject objectForKey:@"data"];
                [[NSUserDefaults standardUserDefaults]setObject:self.jobArr forKey:@"jd"];
                [self.jobTable reloadData];
                
//                self.hud.hidden = YES;
//                [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"加载成功"];
                
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
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
- (void)goToLastPage
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)startConnection
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    self.hud.activityIndicatorColor = [UIColor zzdColor];
//    self.hud.labelText = @"加载中...";
//    
//    self.hud.labelFont = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    
    
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"加载中...  " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"http://api.zzd.hidna.cn/v1/jd/my";
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[dic objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                self.jobArr = [(NSDictionary *)responseObject objectForKey:@"data"];
                [[NSUserDefaults standardUserDefaults]setObject:self.jobArr forKey:@"jd"];
                [self.jobTable reloadData];
                
//                self.hud.hidden = YES;
//                [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"加载成功"];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
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


- (void)createJobTableView
{
    self.jobTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.jobTable.delegate = self;
    self.jobTable.dataSource = self;
    self.jobTable.rowHeight = 65;
    self.jobTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self.view addSubview:self.jobTable];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    if ([self.alertType isEqualToString:@"YES"]) {
    headerLabel.text = @"你想和Boss沟通哪个职位";
    }else{
    headerLabel.text = @"请选择一个职位进行沟通";
    }
    headerLabel.font = [[FontTool customFontArrayWithSize:15]objectAtIndex:1];
   headerLabel.textAlignment = 0;
    headerLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    headerLabel.frame = CGRectMake(10, 0, 200, 30);
    
    
    
    [headerView addSubview:headerLabel];
    
    
    
//    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(30 , 29.5, (self.view.frame.size.width - headerSize.width - 50) / 2 - 15, 1)];
//    line1.image = [UIImage imageNamed:@"line2.png"];
//    [headerView addSubview:line1];
//    
//    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20 - (self.view.frame.size.width - headerSize.width - 50) / 2 +  5 , 29.5, (self.view.frame.size.width - headerSize.width - 50) / 2 - 15, 1)];
//    line2.image = [UIImage imageNamed:@"line1.png"];
//    [headerView addSubview:line2];
    
    
    
    
    self.jobTable.tableHeaderView = headerView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jobArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    CollectPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CollectPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getValueDic:[self.jobArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [self.jobArr objectAtIndex:indexPath.row];
    if ([self.robot isEqualToString:@"yes"]) {
        RobotViewController *robot = [[RobotViewController alloc]init];
        robot.jdDic = [self.jobArr objectAtIndex:indexPath.row];
        robot.rsDic = self.rsDic;
        if ([self.type isEqualToString:@"self"]) {
            robot.cheatHeader = [[dic objectForKey:@"user"]objectForKey:@"avatar"];
            robot.title = [[dic objectForKey:@"user"]objectForKey:@"name"];
            robot.objectId = [[dic objectForKey:@"user"]objectForKey:@"im_id"];
        }else{
            robot.cheatHeader = self.cheatHeader;
            robot.title = self.name;
            robot.objectId = @"robot";
        }
        
        robot.rsId = self.rsId;
        robot.jdId = [[self.jobArr objectAtIndex:indexPath.row]objectForKey:@"id"];
        [self.navigationController pushViewController:robot animated:YES];

    }else{
    CheatViewController *cheat = [[CheatViewController alloc]init];
    cheat.jdDic = [self.jobArr objectAtIndex:indexPath.row];
    cheat.rsDic = self.rsDic;
    if ([self.type isEqualToString:@"self"]) {
        cheat.cheatHeader = [[dic objectForKey:@"user"]objectForKey:@"avatar"];
        cheat.title = [[dic objectForKey:@"user"]objectForKey:@"name"];
        cheat.objectId = [[dic objectForKey:@"user"]objectForKey:@"im_id"];
    }else{
    cheat.cheatHeader = self.cheatHeader;
    cheat.title = self.name;
    cheat.objectId = self.objectId;
    }
    
    cheat.rsId = self.rsId;
    cheat.jdId = [[self.jobArr objectAtIndex:indexPath.row]objectForKey:@"id"];
    
    
    [self.navigationController pushViewController:cheat animated:YES];
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
