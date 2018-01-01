//
//  EduAndWorkViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/4.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "EduAndWorkViewController.h"
#import "UIColor+AddColor.h"
#import "CreateNewJobTableViewCell.h"
#import "JobNameViewController.h"
#import "PriceRangeViewController.h"
#import "JobPlaceViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "HideCompanyTableViewCell.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import <UMMobClick/MobClick.h>
@interface EduAndWorkViewController ()<UITableViewDataSource,UITableViewDelegate,JobNameDelegate,UIPickerViewDataSource,UIPickerViewDelegate,PriceRangeViewControllerDelegate,JobPlaceViewDelegate>
@property (nonatomic, strong)UITableView *eduTableView;
@property (nonatomic, strong)UIPickerView *datePicker;
@property (nonatomic, strong)UIView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;
@property (nonatomic, strong)UILabel *pickTitleLabel;
@property (nonatomic, copy)NSString *pickTitle;

@property (nonatomic, copy)NSString *yearStr;
@property (nonatomic, copy)NSString *monthStr;
@property (nonatomic, assign)NSInteger a;
@end

@implementation EduAndWorkViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titleArr = [NSArray array];
        self.mainDic = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"EduAndWork"];
    [AVAnalytics beginLogPageView:@"EduAndWork"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"back"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"back"];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"EduAndWork"];
    [AVAnalytics endLogPageView:@"EduAndWork"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, 0, 60, 30)];
    [titleLable setTextColor:[UIColor whiteColor]];
    
    if ([self.arrTitle isEqualToString:@"job"]) {
        titleLable.text = @"工作经历";
        
    }else if([self.arrTitle isEqualToString:@"edu"])
    {
        
        titleLable.text = @"教育背景 ";
    }
    titleLable.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLable;
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createEduTable];
    [self createBottonButton];
     if ([self.mainDic objectForKey:@"id"] != nil) {
         if (self.count <= 1) {
             
         }else{
             [self createDeleteButton];
         }
     }
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.eduTableView reloadData];
}
- (void)createEduTable
{
    self.eduTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.eduTableView.delegate = self;
    self.eduTableView.dataSource = self;
    self.eduTableView.rowHeight = 48;
    self.eduTableView.scrollEnabled = NO;
//    self.eduTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    [self.view addSubview:self.eduTableView];
}
- (void)createBottonButton
{
   
    UIButton * bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.layer.cornerRadius = 7;
    bottomButton.frame = CGRectMake(0, 0, 50, 30);
    bottomButton.layer.masksToBounds = YES;
    bottomButton.backgroundColor = [UIColor clearColor];
    [bottomButton setTitle:@"保存" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(saveEduAndWork) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bottomButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    //[self.view addSubview:bottomButton];
    
}
- (void)createDeleteButton
{
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 48 * 5 + 160, self.view.frame.size.width - 60, 40)];
    deleteButton.layer.cornerRadius = 7;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.backgroundColor = [UIColor zzdColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteEduAndWork) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:deleteButton];


}
- (void)deleteEduAndWork
{

    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@/%@/delete",self.arrTitle,[self.mainDic objectForKey:@"id"]];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
        
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                [self.deleteDelegate deleteEduAndWork:self.arrTitle dic:self.mainDic];
                [self.navigationController popViewControllerAnimated:YES];
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
                    [self log];
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


-(BOOL)judgeDate
{

    if ([self.arrTitle isEqualToString:@"job"]) {
        
       NSString * startTime = [self.mainDic objectForKey:@"work_start_date"];
       NSString * endTime = [self.mainDic objectForKey:@"work_end_date"];
        
        NSString *startYear = [startTime substringWithRange:NSMakeRange(0, 4)];
        NSString *startMonth = [startTime substringWithRange:NSMakeRange(5, startTime.length - 5)];
        NSString *endYear = [endTime substringWithRange:NSMakeRange(0, 4)];
        NSString *endMonth = [endTime substringWithRange:NSMakeRange(5, endTime.length - 5)];
        
        if ([startYear integerValue] <=  [endYear integerValue] && [startMonth integerValue] <= [endMonth integerValue] ) {
            return YES;
        }else if([startYear integerValue] <  [endYear integerValue] && [startMonth integerValue] >= [endMonth integerValue] ){
            return YES;
        }else{
            return NO;
        }
        
    }else if ([self.arrTitle isEqualToString:@"edu"]){
    
      NSString *  startTime = [self.mainDic objectForKey:@"edu_start_date"];
     NSString *   endTime = [self.mainDic objectForKey:@"edu_end_date"];
        
        NSString *startYear = [startTime substringWithRange:NSMakeRange(0, 4)];
        NSString *startMonth = [startTime substringWithRange:NSMakeRange(5, startTime.length - 5)];
        NSString *endYear = [endTime substringWithRange:NSMakeRange(0, 4)];
        NSString *endMonth = [endTime substringWithRange:NSMakeRange(5, endTime.length - 5)];
        
        if ([startYear integerValue] <=  [endYear integerValue] && [startMonth integerValue] <= [endMonth integerValue] ) {
            return YES;
        }else if([startYear integerValue] <  [endYear integerValue] && [startMonth integerValue] >= [endMonth integerValue] ){
            return YES;
        }else{
            return NO;
        }

    }else
    {
        return NO;
    }

}

#pragma mark --------- 保存按钮执行的方法
- (void)saveEduAndWork
{
    if ([self.arrTitle isEqualToString:@"job"]) {
        if ([self.mainDic objectForKey:@"title"] == nil || [self.mainDic objectForKey:@"cp_name" ] == nil || [self.mainDic objectForKey:@"work_start_date"] == nil || [self.mainDic objectForKey:@"work_end_date"] == nil) {
            
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"请完善信息后保存" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
            return;
        } else {
            
        }
        
    } else {
        if ([self.mainDic objectForKey:@"edu_school"] == nil || [self.mainDic objectForKey:@"edu_major"] == nil || [self.mainDic objectForKey:@"edu_experience"] == nil || [self.mainDic objectForKey:@"edu_start_date"] == nil || [self.mainDic objectForKey:@"edu_end_date"] == nil) {
            
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"请完善信息后保存" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
            return;
        } else {
            
        }

    }
    
   BOOL a =  [self judgeDate];
    
    
    if (a) {
        
    
    NSString *str = [self.titleArr firstObject];
    NSString *url = @"";
        
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    [self.mainDic setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
       if ([self.mainDic objectForKey:@"id"] != nil) {
           self.a = 1;
        if ([str isEqualToString:@"职位类型"]) {
            url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/job/%@",[self.mainDic objectForKey:@"id"]];
        }else if ([str isEqualToString:@"学   校"]){
            url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/edu/%@",[self.mainDic objectForKey:@"id"]];
        }
        
    }else{
        if ([str isEqualToString:@"职位类型"]) {
            self.a = 2;
            url = @"http://api.zzd.hidna.cn/v1/rs/job";
            [self.mainDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] forKey:@"rs_id"];

        }else if ([str isEqualToString:@"学   校"]){
            self.a = 2;
            url = @"http://api.zzd.hidna.cn/v1/rs/edu";
            [self.mainDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] forKey:@"rs_id"];

        }
    }
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[dic objectForKey:@"token"],time];
        [self.mainDic setObject:time forKey:@"timestamp"];
        [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager POST:url parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
            
            switch (self.a) {
                case 1:
                    [self.changeDelegate changeEduAndWork:self.arrTitle dic:self.mainDic row:self.b];
                    
                    break;
                case 2:
                    //设置id
                    [self.mainDic setObject:[[responseObject objectForKey:@"data"] objectForKey:@"id"] forKey:@"id"];
                    [self.saveDelegate saveNewEduAndWork:self.arrTitle dic:self.mainDic];
                    if ([self.arrTitle isEqualToString:@"edu"]) {
                        NSMutableDictionary *user = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                        [user setObject:[[responseObject objectForKey:@"data"]objectForKey:@"highest_edu"] forKey:@"highest_edu"];
                        [[NSUserDefaults standardUserDefaults]setObject:user forKey:@"user"];
                    }
                    break;
                default:
                    break;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    }else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"结束时间不能早于开始时间" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [alert show];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"结束时间不能早于开始时间" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.titleArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getTitleLabelText:[self.titleArr objectAtIndex:indexPath.row]];
    NSString *title = [self.titleArr objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"职位类型"]) {
        if ([self.mainDic objectForKey:@"sub_category"] == nil) {
            cell.returnLabel.text = nil;
        }else{
        cell.returnLabel.text = [NSString stringWithFormat:@"%@",[self.mainDic objectForKey:@"title"]];
        }
        
    }  else if ([title isEqualToString:@"公司名称"]){
        cell.returnLabel.text = [self.mainDic objectForKey:@"cp_name"];
        
    }else if ([title isEqualToString:@"开始时间"]){
        if (  [[self.titleArr firstObject]isEqualToString:@"学   校"]){
            
        
        cell.returnLabel.text = [self.mainDic objectForKey:@"edu_start_date"];
        }else {
      cell.returnLabel.text = [self.mainDic objectForKey:@"work_start_date"];
        }
        
    }else if ([title isEqualToString:@"结束时间"]){
         if (  [[self.titleArr firstObject]isEqualToString:@"学   校"]){
        cell.returnLabel.text = [self.mainDic objectForKey:@"edu_end_date"];
         }else{
    cell.returnLabel.text = [self.mainDic objectForKey:@"work_end_date"];
    
         }
        
    }else if ([title isEqualToString:@"学   历"]){
        cell.returnLabel.text = [self.mainDic objectForKey:@"edu_experience"];
        
    }else if ([title isEqualToString:@"专   业"]){
        cell.returnLabel.text = [self.mainDic objectForKey:@"edu_major"];
        
    }else if ([title isEqualToString:@"学   校"]){
        cell.returnLabel.text = [self.mainDic objectForKey:@"edu_school"];
        
    }else if ([title isEqualToString:@"是否屏蔽该公司"]){
        static NSString *cellId = @"cell1";
        HideCompanyTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell1) {
            cell1 = [[HideCompanyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
        }
        [cell1.setting addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1 getTitleLabelText:@"是否屏蔽该公司"];
        return cell1;
    }

    return cell;
}
- (void)switchAction:(UISwitch *)switcher
{
    if (switcher.on) {
        [AVAnalytics beginLogPageView:@"switchOn"];
    }else{
        [AVAnalytics endLogPageView:@"switchOff"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobNameViewController *jobName = [[JobNameViewController alloc]init];
    JobPlaceViewController *jobPlace = [[JobPlaceViewController alloc]init];
    PriceRangeViewController *priceRange = [[PriceRangeViewController alloc]init];
    
    
    NSString *title = [self.titleArr objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"职位类型"]) {
         NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];
        jobPlace.dataArr = [dic objectForKey:@"category"];
        jobPlace.mainTitle = @"job";
        jobPlace.delegate = self;
        jobPlace.word = @"职位类型";
        [self.navigationController pushViewController:jobPlace animated:YES];
        
    }else if ([title isEqualToString:@"职位名称"]){
        jobName.placeHolderStr = @"请填写职位名称";
        jobName.mainTitle = @"title";
        jobName.delegate = self;
        jobName.word = @"职位名称";
        jobName.len = 10;
        jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
        [self.navigationController pushViewController:jobName animated:YES];
        
        
    }else if ([title isEqualToString:@"公司名称"]){
        jobName.placeHolderStr = @"请填写公司名称";
        jobName.mainTitle = @"cp_name";
        jobName.delegate = self;
        jobName.word = @"公司名称";
        jobName.len = 18;
        jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
        [self.navigationController pushViewController:jobName animated:YES];
        
        
    }else if ([title isEqualToString:@"开始时间"]){
        self.pickTitle = title;
        [self createPickerView];
        
        
    }else if ([title isEqualToString:@"结束时间"]){
        self.pickTitle = title;
        [self createPickerView];
        
        
    }else if ([title isEqualToString:@"学   历"]){
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];
        
        priceRange.mainTitle = @"edu_experience";
        priceRange.delegate = self;
        priceRange.word = @"学   历";
        priceRange.array = [dic objectForKey:@"education"];
        [self.navigationController pushViewController:priceRange animated:YES];
        
    }else if ([title isEqualToString:@"专   业"]){
        jobName.placeHolderStr = @"请填写专业名称";
        jobName.mainTitle = @"edu_major";
        jobName.delegate = self;
        jobName.word = @"专   业";
        jobName.len = 12;
        jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
        [self.navigationController pushViewController:jobName animated:YES];
        
        
    }else if ([title isEqualToString:@"学   校"]){
        jobName.placeHolderStr = @"请填写学校名称";
        jobName.mainTitle = @"edu_school";
        jobName.delegate = self;
        jobName.word = @"学   校";
        jobName.len = 12;
        jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
        [self.navigationController pushViewController:jobName animated:YES];
        
        
    }
    
    
}
- (void)getJobPlaceTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}
- (void)getMyValue:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
    
}
- (void)getNameTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}
- (void)createPickerView
{
    self.pickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.pickerBackView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    self.pickerBackView.userInteractionEnabled = YES;
    [self.view addSubview:self.pickerBackView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToWindow)];
    [self.pickerBackView addGestureRecognizer:tap];
    
    self.pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    
    
    self.pickTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 60, 0, 120, 50)];
    self.pickTitleLabel.textAlignment = 1;
    self.pickTitleLabel.text = self.pickTitle;
    self.pickTitleLabel.textColor = [UIColor zzdColor];
    self.pickTitleLabel.font = [UIFont systemFontOfSize:16];
    [self.pickerView addSubview:self.pickTitleLabel];
    
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 10, 30, 30)];
    rightView.image = [UIImage imageNamed:@"icon_right(1).png"];
    rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *completeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(completeTap)];
    [rightView addGestureRecognizer:completeTap];
    [self.pickerView addSubview:rightView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.pickerView addSubview:lineView];
    
    self.datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150)];
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
   
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:self.datePicker];
    self.yearStr = @"2020";
    self.monthStr = @"1";
   
}
- (void)completeTap
{
   
    if ([self.pickTitle isEqualToString:@"开始时间"]) {
        if( [[self.titleArr firstObject]isEqualToString:@"学   校"]){
        [self.mainDic setObject:[NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr] forKey:@"edu_start_date"];
        }else {
            [self.mainDic setObject:[NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr] forKey:@"work_start_date"];

        }
    }else if ([self.pickTitle isEqualToString:@"结束时间"]){
        if( [[self.titleArr firstObject]isEqualToString:@"学   校"]){
            [self.mainDic setObject:[NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr] forKey:@"edu_end_date"];
        }else {
            [self.mainDic setObject:[NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr] forKey:@"work_end_date"];
            
        }
    }
    [self backToWindow];
    [self.eduTableView reloadData];
}
- (void)backToWindow
{

    [self.pickerBackView removeFromSuperview];
    [self.datePicker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.pickTitleLabel removeFromSuperview];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 43;
    }
    if (component == 1) {
        return 12;
    }
    return 0;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld年",2020 - row];
    }
    if (component == 1) {
        return [NSString stringWithFormat:@"%ld月",row + 1];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *str = [NSString stringWithFormat:@"%ld",2020 - row];
   
        self.yearStr = str;
    }
    if (component == 1) {
        if (row + 1 < 10) {
        NSString *str = [NSString stringWithFormat:@"0%ld",row + 1];
            self.monthStr = str;
        }else{
        NSString *str = [NSString stringWithFormat:@"%ld",row + 1];
            self.monthStr = str;
        }
        
    }
    
}

- (void)getJobChangeTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}
@end
