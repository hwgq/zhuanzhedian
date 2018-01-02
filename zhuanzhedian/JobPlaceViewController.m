//
//  JobPlaceViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobPlaceViewController.h"
#import "AFNetworking.h"
#import "UIColor+AddColor.h"
#import "JobPlaceTableViewCell.h"
#import "JobCityTableViewCell.h"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "JobNameViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
// 往前传值第四部
@interface JobPlaceViewController ()<UITableViewDataSource,UITableViewDelegate, JobNameDelegate>

@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSString *provinceStr;

@property (nonatomic, strong)NSNumber * provinceStr_id;
@property (nonatomic, strong)NSNumber * cityStr_id;

@property (nonatomic, strong)NSString *cityStr;
@property (nonatomic, strong)UITableView *cityTable;
@property (nonatomic,strong)UIButton * button;
@property (nonatomic,assign)NSInteger   number;

@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *iamgeView;
@end

@implementation JobPlaceViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageArr = [NSMutableArray array];
        self.dataArr = [NSMutableArray array];
        self.cityArr = [NSMutableArray array];
        self.mainDic = [NSMutableDictionary dictionary];
        self.provinceStr_id = 0;
        self. cityStr_id = 0;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
   
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"back"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"back"];
         [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    for (int i = 0; i<7; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"zw_icon%d",i+1]];
        [self.imageArr addObject:image];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = self.word;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if ([self.value isEqualToString:@"10"]) {
        
        [self getConnection];
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
    self.provinceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.bounds.size.height) style:UITableViewStylePlain];
    self.provinceTable.tag = 1;
    self.provinceTable.delegate = self;
    self.provinceTable.dataSource = self;
    [self.provinceTable setSeparatorColor:[UIColor lightGrayColor]];
    self.provinceTable.backgroundColor = [UIColor whiteColor];
    self.provinceTable.allowsSelection = NO;
    if ([self.value isEqualToString:@"10"]) {
        self.provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else
    {
        self.provinceTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.view addSubview:self.provinceTable];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float f = (self.cityArr.count + 1) /2;
    if (f<=1.000000) {
        self.label.frame = CGRectMake(40, 30 / 2, self.view.bounds.size.width/3+10, 20);
        self.iamgeView.frame = CGRectMake(15, 30 / 2, 20, 20);
        
        return 10 + 40 * 1;
    } else if (f <= 2.000000&&f>1.000000) {
        
        self.label.frame = CGRectMake(40, 70 / 2, self.view.bounds.size.width/3+10, 20);
        self.iamgeView.frame = CGRectMake(15, 70 / 2, 20, 20);
        
        return 10 + 40 * 2;
    }
    else if(f<=3.000000&&f>2.000000)
    {
        self.label.frame = CGRectMake(40, 110 / 2, self.view.bounds.size.width/3+10, 20);
        self.iamgeView.frame = CGRectMake(15, 110 / 2, 20, 20);
        
        return 10 + 40 * 3;
    }
    else  if(f<=4.000000&&f>3.000000)
    {
        self.iamgeView.frame = CGRectMake(15, 150 / 2, 20, 20);
        
        self.label.frame = CGRectMake(40, 150 / 2, self.view.bounds.size.width/3+10, 20);
        
        return 10 + 40 * 4;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        if (self.dataArr.count > 0) {
            NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
            [self tableView:self.provinceTable didSelectRowAtIndexPath:path];
        }
        return self.dataArr.count;
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *cellIdentify = @"cell";
        // 不进行重用
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
        
        if ([self.value isEqualToString:@"10"]) {
            self.cityArr = [dic objectForKey:@"data"];
            self.provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        }else
        {
            self.cityArr = [dic objectForKey:@"sub_category"];
        }
        
        NSString *provinceName = [dic objectForKey:@"name"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            self.iamgeView = [[UIImageView alloc]init];
            self.iamgeView.image = self.imageArr[indexPath.row];
            [cell.contentView addSubview:self.iamgeView];
            
            self.label = [[UILabel alloc]init];
            self.label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
            self.label.text = provinceName;
            [cell.contentView addSubview:self.label];
            
            
        }
        for (int i = 0; i<self.cityArr.count; i++) {
            
            self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.button.titleLabel.font = [UIFont systemFontOfSize:14];
            self.button.tag = i+10*indexPath.row;
            [self.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.button setTitle:[self.cityArr[i] objectForKey:@"name"] forState:UIControlStateNormal];
            self.button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
            [self.button setShowsTouchWhenHighlighted:YES];
            [self.button setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
            [self.button.layer setMasksToBounds:YES];
            [self.button.layer setCornerRadius:10];
            [self.button.layer setBorderWidth:1];
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0,0,0,0.48});
            [self.button.layer setBorderColor:color];
            int w = i/2;
            int h = i%2;
            self.button.frame = CGRectMake(125+h*self.view.bounds.size.width/3, 10+w*40, self.view.bounds.size.width/3-30, 30);
            [cell.contentView addSubview:self.button];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.number = indexPath.row;
}
-(void)btnClick:(UIButton *)sender
{
    
    // 新添的跳到下一页
    JobNameViewController *jobName = [[JobNameViewController alloc]init];
    
    
    int a;
    if (sender.tag<10) {
        a=0;
    }else if(sender.tag>=10 && sender.tag<20)
    {
        a=1;
    }
    else if(sender.tag>=20 && sender.tag<30)
    {
        a=2;
    }
    else if(sender.tag>=30 && sender.tag<40)
    {
        a=3;
    }
    else if(sender.tag>=40 && sender.tag<50)
    {
        a=4;
    }
    else if(sender.tag>=50 && sender.tag<60)
    {
        a=5;
    }
    else if(sender.tag>=60 && sender.tag<70)
    {
        a=6;
    }
    
    NSDictionary *dic = [self.dataArr objectAtIndex:a];
    if ([self.value isEqualToString:@"10"]) {
        self.cityArr = [dic objectForKey:@"data"];
        self.provinceStr = [[self.dataArr objectAtIndex:a]objectForKey:@"name"];
        self.provinceStr_id = [NSNumber numberWithInteger:a];
    }else{
        self.cityArr = [dic objectForKey:@"sub_category"];
        self.provinceStr = [[self.dataArr objectAtIndex:a]objectForKey:@"name"];
        self.provinceStr_id = [NSNumber numberWithInteger:a];
    }

    NSInteger n = sender.tag-a*10;
    self.cityStr = [[self.cityArr objectAtIndex:n]objectForKey:@"name"];
    
    
    self.cityStr_id = [NSNumber numberWithInteger:n];
    
    NSString * str = self.cityStr;
    if ([self.mainTitle isEqualToString:@"job"]) {
        
        NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
        [dic setObject:self.provinceStr forKey:@"category"];
        [dic setObject:self.cityStr forKey:@"sub_category"];
        
        [dic setObject:[[self.dataArr objectAtIndex:[_provinceStr_id integerValue] ]objectForKey:@"id"] forKey:@"category_id"];
        
        [dic setObject:[[[[self.dataArr objectAtIndex:[_provinceStr_id integerValue]]objectForKey:@"sub_category"]objectAtIndex:[_cityStr_id integerValue] ]objectForKey:@"id"] forKey:@"sub_category_id"];
        
        [self.delegate getJobPlaceTextDic:dic];
        [self.navigationController pushViewController:jobName animated:YES];
    }else if([self.mainTitle isEqualToString:@"city"]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:str forKey:self.mainTitle];
        [dic setObject:[[self.dataArr objectAtIndex:[self.provinceStr_id integerValue]]objectForKey:@"id"] forKey:@"province_id"];
        [dic setObject:[[[[self.dataArr objectAtIndex:[self.provinceStr_id integerValue]]objectForKey:@"data"]objectAtIndex:[self.cityStr_id integerValue]]objectForKey:@"id"] forKey:@"city_id"];
        
        [self.delegate getJobPlaceTextDic:dic];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    jobName.placeHolderStr = @"请填写职位名称";
    jobName.mainTitle = @"title";
    // 协议第五部
    jobName.delegate = self;
    jobName.len = 10;
    jobName.word = self.cityStr;
    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
    
}
// 第六步：执行协议方法
- (void)getNameTextDic:(NSDictionary *)dictionary
{
    
    // san
    [self.delegate getJobChangeTextDic:dictionary];
    
    [self.mainDic addEntriesFromDictionary:dictionary];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
