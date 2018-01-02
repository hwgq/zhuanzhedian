//
//  JobNewPlaceViewController.m
//  zhuanzhedian
//
//  Created by 李文涵 on 16/1/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "JobNewPlaceViewController.h"
#import "AFNetworking.h"
#import "UIColor+AddColor.h"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "JobNewPlaceTableViewCell.h"
#import "JobNewCityTableViewCell.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
@interface JobNewPlaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSString *provinceStr;

@property (nonatomic, strong)NSNumber * provinceStr_id;
@property (nonatomic, strong)NSNumber * cityStr_id;

@property (nonatomic, strong)NSString *cityStr;
@property (nonatomic, strong)UITableView *cityTable;

@end

@implementation JobNewPlaceViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.cityArr = [NSMutableArray array];
        self.provinceStr_id = 0;
        self. cityStr_id = 0;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"JobNewPlaceView"];
    [AVAnalytics beginLogPageView:@"JobNewPlaceView"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"JobNewPlaceView"];
    [AVAnalytics endLogPageView:@"JobNewPlaceView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = self.word;
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if ([self.value isEqualToString:@"10"]) {
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"place"];
        if (arr.count > 0) {
            self.dataArr = [arr mutableCopy];
            
        }else{
        [self getConnection];
        }
    }
    [self createTableViews];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getConnection
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *urlStr = @"http://api.zzd.hidna.cn/v1/conf/city";
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlStr,[userDic objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                
                NSDictionary *dic = (NSDictionary *)responseObject;
                self.dataArr = [dic objectForKey:@"data"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[dic objectForKey:@"data"] forKey:@"place"];
                
                [self.provinceTable reloadData];
               
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


- (void)createTableViews
{
    self.provinceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 4, self.view.frame.size.height) style:UITableViewStylePlain];
    self.provinceTable.tag = 1;
    self.provinceTable.delegate = self;
    self.provinceTable.dataSource = self;
    self.provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.provinceTable.rowHeight = 48;
    self.provinceTable.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.provinceTable.showsVerticalScrollIndicator = NO;
    
    
    
    [self.view addSubview:self.provinceTable];
    
    self.cityTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4, 0, self.view.frame.size.width * 3 / 4, self.view.frame.size.height ) style:UITableViewStylePlain];
    self.cityTable.tag = 2;
    self.cityTable.delegate = self;
    self.cityTable.dataSource = self;
    self.cityTable.rowHeight = 48;
    self.cityTable.showsVerticalScrollIndicator = NO;
    self.cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cityTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
     
        if (self.dataArr.count > 0) {
            NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
            [self tableView:self.provinceTable didSelectRowAtIndexPath:path];
            
        }
        return self.dataArr.count;
    }else if(tableView.tag == 2) {
        return self.cityArr.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *cellIdentify = @"cell";
        JobNewPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[JobNewPlaceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
        NSString *provinceName = [dic objectForKey:@"name"];
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        
        
        [cell getProvinceLabelText:provinceName];
        return cell;
    }
    
    
    if (tableView.tag == 2) {
        static NSString *cellIdentify1 = @"cell1";
        JobNewCityTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
        if (!cell1) {
            cell1 = [[JobNewCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify1];
        }
        NSDictionary *dic = [self.cityArr objectAtIndex:indexPath.row];
        [cell1 getCityLabelText:[dic objectForKey:@"name"]];
        return cell1;
        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
        if ([self.value isEqualToString:@"10"]) {
            
            self.cityArr = [dic objectForKey:@"data"];
            self.provinceStr = [[self.dataArr objectAtIndex:indexPath.row]objectForKey:@"name"];
            self.provinceStr_id = [NSNumber numberWithInteger:indexPath.row];
        }else{
            self.cityArr = [dic objectForKey:@"sub_category"];
            self.provinceStr = [[self.dataArr objectAtIndex:indexPath.row]objectForKey:@"name"];
            self.provinceStr_id = [NSNumber numberWithInteger:indexPath.row];
        }
        [self.cityTable reloadData];
    }
    if (tableView.tag == 2) {
        self.cityStr = [[self.cityArr objectAtIndex:indexPath.row]objectForKey:@"name"];
        self.cityStr_id = [NSNumber numberWithInteger:indexPath.row];
        
        NSString * str = self.cityStr;
        if ([self.mainTitle isEqualToString:@"job"]) {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
            [dic setObject:self.provinceStr forKey:@"category"];
            [dic setObject:self.cityStr forKey:@"sub_category"];
            
            [dic setObject:[[self.dataArr objectAtIndex:[_provinceStr_id integerValue] ]objectForKey:@"id"] forKey:@"category_id"];
            
            
            [dic setObject:[[[[self.dataArr objectAtIndex:[_provinceStr_id integerValue]]objectForKey:@"sub_category"]objectAtIndex:[_cityStr_id integerValue] ]objectForKey:@"id"] forKey:@"sub_category_id"];
            
            
            [self.delegate getJobNewPlaceTextDic:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        if([self.mainTitle isEqualToString:@"city"]){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:str forKey:self.mainTitle];
            [dic setObject:[[self.dataArr objectAtIndex:[self.provinceStr_id integerValue]]objectForKey:@"id"] forKey:@"province_id"];
            [dic setObject:[[[[self.dataArr objectAtIndex:[self.provinceStr_id integerValue]]objectForKey:@"data"]objectAtIndex:[self.cityStr_id integerValue]]objectForKey:@"id"] forKey:@"city_id"];
            
            [self.delegate getJobNewPlaceTextDic:dic];
            [self.navigationController popViewControllerAnimated:YES];
            
            
//        }else
//        {
//            
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
