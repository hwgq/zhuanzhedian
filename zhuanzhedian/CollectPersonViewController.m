//
//  CollectPersonViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CollectPersonViewController.h"
#import "AFNetworking.h"
#import "SecondViewTableViewCell.h"
#import "MainViewTableViewCell.h"
#import "JobDetailViewController.h"
#import "WorkResumeDetailViewController.h"
#import "UIColor+AddColor.h"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "NewZZDBossCell.h"
#import "NewZZDPeopleCell.h"
#import "NewZZDPeopleViewController.h"
#import "FontTool.h"
@interface CollectPersonViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong)NSMutableArray *mainArr;
@property (nonatomic, strong)UITableView *collectTable;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation CollectPersonViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTable];
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.textAlignment = 1;
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textColor = [UIColor whiteColor];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
        titleLabel.text = @"收藏的岗位";
    }else{
        titleLabel.text = @"收藏的人才";
    }
    self.navigationItem.titleView = titleLabel;
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"CollectPersonView"];
    [self getWhatILikeValue];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"CollectPersonView"];
}
- (void)getWhatILikeValue
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"加载中...  " alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/my/favorite";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                self.mainArr = [responseObject objectForKey:@"data"];
                [self.collectTable reloadData];
                
//                [self.hud hide:YES];
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
                    [self log];
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [alertView removeFromSuperview];
        }];
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [alertView removeFromSuperview];
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


- (void)createTable
{
    self.collectTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.collectTable.delegate = self;
    self.collectTable.dataSource = self;
    self.collectTable.rowHeight = 125;
    self.collectTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.collectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.collectTable];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
//        
//    
//    static NSString *cellIdentify = @"cell";
//    SecondViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
//    if (!cell) {
//        cell = [[SecondViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.mainArr.count != 0) {
//        
//        [cell getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
//    }
//    
//    return cell;
//    }else{
//        static NSString *cellIdentify1 = @"cell1";
//        MainViewTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
//        if (!cell1) {
//            cell1 = [[MainViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify1];
//        }
//        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell1 getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
//        return cell1;
//        
//    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
        
        static NSString *cellIdentify = @"cell";
        
        NewZZDPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        
        if (!cell) {
            cell = [[NewZZDPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.mainArr.count != 0) {
            
            //                [cell getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
            [cell setSubViewTextFromDic:[self.mainArr objectAtIndex:indexPath.row]];
            
        }
        return cell;
        
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]){
        static NSString *cellIdentify2 = @"cell2";
        
        NewZZDBossCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentify2];
        
        if (!cell2) {
            
            cell2 = [[NewZZDBossCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify2];
        }
        
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.mainArr.count != 0) {
            
            //                [cell2 getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
            [cell2 setSubViewTextFromDic:[self.mainArr objectAtIndex:indexPath.row]];
            
        }
        
        return cell2;
        
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"1"]) {
        
        JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
        jobDetail.collectType = @"YES";
        jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.mainArr objectAtIndex:indexPath.row]];
        jobDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jobDetail animated:YES];
        
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] isEqualToString:@"2"]){
//        WorkResumeDetailViewController *workDetail = [[WorkResumeDetailViewController alloc]initWithButton:@"2"];
//        workDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.mainArr objectAtIndex:indexPath.row]];
//        workDetail.collectType = @"YES";
//        workDetail.hidesBottomBarWhenPushed = YES;
        NewZZDPeopleViewController *workDetail = [[NewZZDPeopleViewController alloc]init];
        
        
//        if ([self judgeWhatILike:indexPath]) {
        
            workDetail.collectType = @"YES";
            
//        }else{
            
//            workDetail.collectType = @"NO";
//        }
        workDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.mainArr objectAtIndex:indexPath.row]];
        
        workDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workDetail animated:YES];
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
