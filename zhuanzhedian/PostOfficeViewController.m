//
//  PostOfficeViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "PostOfficeViewController.h"
#import "CreateNewJobViewController.h"
#import "UIColor+AddColor.h"
#import "AFNetworking.h"
#import "CollectPersonTableViewCell.h"
#import "JobDetailViewController.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "MBProgressHUD.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "FontTool.h"
#import "ScanBeforeViewController.h"
@interface PostOfficeViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong)UITableView *jobTableView;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation PostOfficeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.array = [NSMutableArray array];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"PostOfficeView"];
     [self startConnection];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"PostOfficeView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"发布的职位";
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    [self createButton];
    [self createJobTableView];
   
    // Do any additional setup after loading the view.
}
- (void)goToLastPage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//网络请求
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
    NSString *str = @"http://api.zzd.hidna.cn/v1/jd/my/all";
    
    
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
                [self.jobTableView reloadData];
                
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
        
        app.alert = [[ZZDAlertView alloc]initWithView:app.window];
        [app.alert setTitle:@"转折点提示" detail:@"您的账号在另外一台设备上登录" alert:ZZDAlertStateNormal];
        [app.window addSubview:app.alert];
        
    }
    
}


- (void)createJobTableView
{
    self.jobTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64) style:UITableViewStyleGrouped];
    self.jobTableView.backgroundColor = [UIColor whiteColor];
    self.jobTableView.delegate = self;
    self.jobTableView.dataSource = self;
    self.jobTableView.rowHeight = 70;
    [self.view addSubview:self.jobTableView];
}

- (void)createButton
{
    UIButton *createButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 49 - 64 + 2.5, self.view.frame.size.width * 2 / 3 - 30 - 5, 49 - 15)];
    createButton.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    [createButton setTitle:@"发布新职位" forState:UIControlStateNormal];
    
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(addJob:) forControlEvents:UIControlEventTouchUpInside];
    createButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    createButton.layer.borderWidth = 0.5;
    createButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.view addSubview:createButton];
    
    UIButton *pcButton = [[UIButton alloc]initWithFrame:CGRectMake(15  +self.view.frame.size.width * 2 / 3 - 30 , self.view.frame.size.height - 49 - 64 + 2.5, self.view.frame.size.width / 3 , 49 - 15)];
    pcButton.backgroundColor = [UIColor whiteColor];
    [pcButton setTitle:@"PC端发布职位" forState:UIControlStateNormal];
    
    [pcButton setTitleColor:[UIColor colorFromHexCode:@"38ab99"] forState:UIControlStateNormal];
    [pcButton addTarget:self action:@selector(goToScanVC) forControlEvents:UIControlEventTouchUpInside];
    pcButton.layer.borderColor = [UIColor colorFromHexCode:@"38ab99"].CGColor;
    pcButton.layer.borderWidth = 1;
    pcButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.view addSubview:pcButton];
}
- (void)goToScanVC
{
    ScanBeforeViewController *scanVC = [[ScanBeforeViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}
- (void)addJob:(id)sender
{
    CreateNewJobViewController *newJob = [[CreateNewJobViewController alloc]init];
    newJob.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newJob animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    CollectPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CollectPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    //18678308551
    [cell.label removeFromSuperview];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.array objectAtIndex:indexPath.row]];
    [cell getValueDic:[self.array objectAtIndex:indexPath.row]];
    if ([[dic objectForKey:@"state"]isEqualToString:@"1"]) {
        [cell.label removeFromSuperview];
        cell.label.text = @"";
        cell.label.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]init];
    jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.array objectAtIndex:indexPath.row]];
    jobDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jobDetail animated:YES];
}

@end
