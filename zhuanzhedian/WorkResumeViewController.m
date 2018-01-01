//
//  WorkResumeViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/27.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "WorkResumeViewController.h"
#import "CreateNewJobTableViewCell.h"
#import "WorkButtonTableViewCell.h"
#import "AFNetworking.h"
#import "JobNameViewController.h"
#import "JobPlaceViewController.h"
#import "PriceRangeViewController.h"
#import "UIColor+AddColor.h"
#import "JobRequireViewController.h"
#import "EduAndWorkViewController.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "JobTagViewController.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
// 保存返回到上一页
#import "WorkResumeDetailViewController.h"
#import "JobNewPlaceViewController.h"
#import <UMMobClick/MobClick.h>
// 协议第四部
@interface WorkResumeViewController ()<UITableViewDataSource,UITableViewDelegate,JobNameDelegate,JobPlaceViewDelegate,PriceRangeViewControllerDelegate,JobRequireDelegate,EduAndWorkChangeDelegate,EduAndWorkSaveDelegate,EduAndWorkDeleteDelegate,JobTagDelegate, JobNewPlaceViewDelegate>

@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, strong)UITableView *resumeTable;
@property (nonatomic, assign)NSInteger nb;
@property (nonatomic, strong) NSMutableArray *turnArr; // 向前传送标签的值
@property (nonatomic, strong)UIButton *saveButton;
@end

@implementation WorkResumeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainDic = [NSMutableDictionary dictionary];
        self.eduArr = [NSMutableArray array];
        self.workArr = [NSMutableArray array];
        self.turnArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // 刷新了数据
    [MobClick beginLogPageView:@"WorkResumeView"];
    [AVAnalytics beginLogPageView:@"WorkResumeView"];
    [self.resumeTable reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"WorkResumeView"];
    [AVAnalytics endLogPageView:@"WorkResumeView"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"back"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"back"];

    }
    self.saveButton.userInteractionEnabled = YES;
    self.nb = 0;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[self.mainDic objectForKey:@"id"]];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];

        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
#warning 重大问题
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"firstInTo"]isEqualToString:@"123"]) {
        
        [self saveJob:nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:@"firstInTo"];
        
        
    }else
    {
        

    }
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"编辑微简历";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    [self getConnection];
    [self createResumeTable];
    [self createButton];
    

}

- (void)getJobNewPlaceTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}



// 最上面返回按钮执行的方法
- (void)goToLastPage
{
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
    
    [self.resumeChangeDelegate changeResumeWithDic:self.mainDic eduArr:self.eduArr jobArr:self.workArr];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createButton
{
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 36, self.view.frame.size.width, 36)];
    
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveJob:) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.saveButton.layer.borderWidth = 0.5;
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.saveButton.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.saveButton];
}
#warning 要进行判断!!
//title
//work_state
//work_year
//tag_user
//city
//salary
//self_summary




// 保存实现的方法
- (void)saveJob:(id)sender
{
    if ([self.mainDic objectForKey:@"title"] == nil || [self.mainDic objectForKey:@"work_state"] == nil || [self.mainDic objectForKey:@"work_year"] == nil || [self.mainDic objectForKey:@"tag_user"] == nil || [self.mainDic objectForKey:@"city"] == nil || [self.mainDic objectForKey:@"salary"] == nil || [self.mainDic objectForKey:@"self_summary"] == nil) {
        
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请完善信息后保存" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        return;

        
    }else{
    // 向前传值
        self.saveButton.userInteractionEnabled = NO;
    [self.resumeChangeDelegate turnValue:self.turnArr];
    

    
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *url = @"";
    if ([[dic objectForKey:@"resume_id"] isEqualToString: @"0"]) {
        url = @"http://api.zzd.hidna.cn/v1/rs";
    }else
    {
        url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[dic objectForKey:@"resume_id"]];
    }
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[dic objectForKey:@"token"],time];
        [self.mainDic setObject:time forKey:@"timestamp"];
        [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [self.mainDic setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        if ([self.mainDic objectForKey:@"tag_user"]!= nil){
            if ([[self.mainDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                [self.mainDic setObject:jsonString1 forKey:@"tag_user"];

            }else{
                [self.mainDic setObject:[self.mainDic objectForKey:@"tag_user"] forKey:@"tag_user"];
            }
        }
        [manager POST:url  parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                [self.mainDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"id"];
                [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"rs"];
                
                
                if ([self.mainDic objectForKey:@"tag_user"]!= nil) {
                    
                
                NSMutableDictionary *dic  =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                [dic setObject:[self.mainDic objectForKey:@"tag_user"] forKey:@"tag_user"];
                [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"user"];
                
                }
                
                
                if ([[dic objectForKey:@"resume_id"] isEqualToString: @"0"]) {
                   NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                    [userDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"] forKey:@"resume_id"];
                    [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:@"user"];
                }
                [self.resumeChangeDelegate changeResumeWithDic:self.mainDic eduArr:self.eduArr jobArr:self.workArr];
                
                if (self.nb == 100) {
                    
                }else{

                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"firstInTo"]isEqualToString:@"123"]) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
 

                    }
                    
                }
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


//进行网络请求
- (void)getConnection
{
    self.dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];

    
}

- (void)createResumeTable
{
    self.resumeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49) style:UITableViewStyleGrouped];
    self.resumeTable.delegate = self;
    self.resumeTable.dataSource = self;
    self.resumeTable.rowHeight = 48;
    self.resumeTable.sectionFooterHeight = 0;
    [self.view addSubview:self.resumeTable];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1 + self.workArr.count;
            break;
        case 3:
            return 1 + self.eduArr.count;
            break;
        default:
            return 0;
            break;
    }
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 20;
}

/*
 一只羊的寿命是五年,在第二和第四年会生下一只小羊,每只小羊也一样,第二、四年会再生,第五年会死掉.
请用代码计算第几年会有多少只小羊
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{NSString *str = [self.mainDic objectForKey:@"self_summary"];
    if (indexPath.section == 0 || indexPath.section == 1) {
        
    
    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    
    }
        NSArray *arr = [NSArray array];
        if (indexPath.row == 3) {
            
            if ([self.mainDic objectForKey:@"tag_user"] != nil) {
                
            
        if ([[self.mainDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
            arr = [self.mainDic objectForKey:@"tag_user"];
        }else{
            NSData *data = [[self.mainDic objectForKey:@"tag_user"] dataUsingEncoding:NSUTF8StringEncoding];
            arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        }
        }
            
        }
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        [cell getTitleLabelText:@"求职类型"];
                        cell.returnLabel.text = [self.mainDic objectForKey:@"title"];
                        break;
                        
//                    case 1:
//                        [cell getTitleLabelText:@"职位名称"];
//                        cell.returnLabel.text = [self.mainDic objectForKey:@"title"];
//                        break;
                        
                    case 1:
                        [cell getTitleLabelText:@"目前状态"];
                        if ([[self.mainDic objectForKey:@"work_state"]isEqualToString:@"0"]) {
                            cell.returnLabel.text = @"在职";
                        }else if ([[self.mainDic objectForKey:@"work_state"]isEqualToString:@"1"]){
                            cell.returnLabel.text = @"离职";
                        }

                     break;
                        
                    case 2:
                        [cell getTitleLabelText:@"工作经验"];
                        cell.returnLabel.text = [self.mainDic objectForKey:@"work_year"];
                        break;
                        
                    case 3:
                        
                        [cell getTitleLabelText:@"期望行业"];
                        cell.returnLabel.text = [NSString stringWithFormat:@"%ld个标签",arr.count];
                        break;
                    default:
                        break;
                }
                break;
            
            case 1:
                switch (indexPath.row) {
                    case 0:
                        [cell getTitleLabelText:@"地点要求"];
                        cell.returnLabel.text = [self.mainDic objectForKey:@"city"];
                        break;
                        
                    case 1:
                        [cell getTitleLabelText:@"薪资要求"];
                        cell.returnLabel.text = [self.mainDic objectForKey:@"salary"];
                        break;
                        
                    case 2:
                        [cell getTitleLabelText:@"个人简介"];
                        if (str.length != 0) {
                            cell.returnLabel.text = @"已填";
                        }else{
                            cell.returnLabel.text = @"";
                        }
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    return cell;
    }else if ((indexPath.section == 2 &&indexPath.row == self.workArr.count)  || (indexPath.section == 3 &&indexPath.row == self.eduArr.count)) {
    static NSString *cellIdentify1 = @"cell1";
       WorkButtonTableViewCell  *cell1  = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
        if (!cell1) {
            cell1 = [[WorkButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify1];
            
        }
        switch (indexPath.section) {
            case 2:
                
                cell1.addButton.text = @"+添加工作经历";
                
                break;
            
            case 3:
                cell1.addButton.text = @"+添加教育经历";
                break;
            default:
                break;
        }
        return cell1;
    }else{
        static NSString *cellIdentify2 = @"cell2";
        CreateNewJobTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentify2];
        if (!cell2) {
            cell2 = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify2];
            
        }
        
        if (indexPath.section == 2) {
            NSDictionary *sc2Dic = [self.workArr objectAtIndex:indexPath.row];
            [cell2 getTitleLabelText:[sc2Dic objectForKey:@"cp_name"]];
            cell2.returnLabel.text = [NSString stringWithFormat:@"%@ - %@",[sc2Dic objectForKey:@"work_start_date"],[sc2Dic objectForKey:@"work_end_date"]];
        }
        if (indexPath.section == 3) {
            NSDictionary *sc3Dic = [self.eduArr objectAtIndex:indexPath.row];
            [cell2 getTitleLabelText:[sc3Dic objectForKey:@"edu_school"]];
            cell2.returnLabel.text = [NSString stringWithFormat:@"%@ - %@",[sc3Dic objectForKey:@"edu_start_date"],[sc3Dic objectForKey:@"edu_end_date"]];
        }
        return cell2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    JobNameViewController *jobName = [[JobNameViewController alloc]init];
    
    JobPlaceViewController *jobPlace = [[JobPlaceViewController alloc]init];
    PriceRangeViewController *priceRange = [[PriceRangeViewController alloc]init];
    JobRequireViewController *jobRequire = [[JobRequireViewController alloc]init];
    EduAndWorkViewController *edu = [[EduAndWorkViewController alloc]init];
    JobTagViewController *jobTag = [[JobTagViewController alloc]init];
    JobNewPlaceViewController *jobNewPlaceVC = [[JobNewPlaceViewController alloc]init];
    
    //在职 离职
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"在职" forKey:@"name"];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObject:@"离职" forKey:@"name"];
    [arr addObject:dic];
    [arr addObject:dic1];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    //"职位类型"
                jobPlace.dataArr = [self.dataDic objectForKey:@"category"];
                    jobPlace.delegate = self;
                    jobPlace.mainTitle = @"job";
                    jobPlace.word = @"职位类型";
                   
                    // 5. 前代理人
                    jobPlace.delegate = self;
                    
                    [self.navigationController pushViewController:jobPlace animated:YES];
                    
                    
                    break;
                    
//                case 1:
//                   //"职位名称"
//                    jobName.placeHolderStr = @"请填写职位名称";
//                    jobName.mainTitle = @"title";
//                    jobName.delegate = self;
//                    jobName.len = 10;
//                    jobName.word = @"职位名称";
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
//                    [self.navigationController pushViewController:jobName animated:YES];
//                    break;
                    
                    
                case 1:
                   //"求职状态"
                    priceRange.array = arr;
                    priceRange.delegate = self;
                    priceRange.mainTitle = @"work_state";
                    priceRange.word = @"求职状态";
                    [self.navigationController pushViewController:priceRange animated:YES];

                   
                    
                    break;
                    
                case 2:
                    //"工作经验"
                    priceRange.array = [self.dataDic objectForKey:@"work_year"];
                    priceRange.delegate = self;
                    priceRange.mainTitle = @"work_year";
                    priceRange.word = @"工作经验";
                    [self.navigationController pushViewController:priceRange animated:YES];
                    break;
                    
                case 3:
                    
                    jobTag.delegate = self;

                    jobTag.dic = self.mainDic;
                    
                    [self.navigationController pushViewController: jobTag animated:YES];
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
//                    //"工作地点"
//                    jobPlace.value = @"10";
//                    jobPlace.delegate = self;
//                    jobPlace.mainTitle = @"city";
//                    jobPlace.word = @"工作地点";
//                    [self.navigationController pushViewController:jobPlace animated:YES];
                    
                    //工作地点
                    jobNewPlaceVC.value = @"10";
                    jobNewPlaceVC.mainTitle = @"city";
                    jobNewPlaceVC.delegate = self;
                    jobNewPlaceVC.word = @"工作地点";
                    [self.navigationController pushViewController:jobNewPlaceVC animated:YES];

                    break;
                    
                case 1:
                    //"薪资范围"
                    priceRange.array = [self.dataDic objectForKey:@"salary"];
                    priceRange.delegate = self;
                    priceRange.mainTitle = @"salary";
                    priceRange.word = @"薪资范围";
                    [self.navigationController pushViewController:priceRange animated:YES];
                    break;
                    
                case 2:
                   //"个人简介"
                    jobRequire.currentStr = [self.mainDic objectForKey:@"self_summary"];
                    jobRequire.delegate = self;
                    jobRequire.word = @"个人简介";
                    [self.navigationController pushViewController:jobRequire animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            
            edu.titleArr = @[@"职位类型",@"公司名称",@"开始时间",@"结束时间",@"是否屏蔽该公司"];
            edu.arrTitle = @"job";
            if (indexPath.row < self.workArr.count ) {
                
                edu.mainDic = [NSMutableDictionary dictionaryWithDictionary: [self.workArr objectAtIndex:indexPath.row]];
                edu.b = indexPath.row;
                edu.count = self.workArr.count;
            }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]isKindOfClass:[NSArray class]]){
                
                self.nb = 100;
                [self saveJob:nil];
            }else if(!([[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] integerValue] > 0))
            {
                self.nb = 100;
                [self saveJob:nil];
            }
            edu.saveDelegate = self;
            edu.changeDelegate = self;
            edu.deleteDelegate = self;
            [self.navigationController pushViewController:edu animated:YES];
            
            break;
        case 3:
            edu.titleArr = @[@"学   校",@"专   业",@"学   历",@"开始时间",@"结束时间"];
            edu.arrTitle = @"edu";
            if (indexPath.row < self.eduArr.count) {
                edu.mainDic =[NSMutableDictionary dictionaryWithDictionary: [self.eduArr objectAtIndex:indexPath.row]];
                edu.count = self.eduArr.count;
                edu.b = indexPath.row;
            }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]isKindOfClass:[NSArray class]]){
                self.nb = 100;
                [self saveJob:nil];
            }else if(!([[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] integerValue] > 0)){
                self.nb = 100;
                [self saveJob:nil];
            }
            edu.saveDelegate = self;
            edu.changeDelegate = self;
            edu.deleteDelegate = self;
            [self.navigationController pushViewController:edu animated:YES];
            
            break;
        default:
            break;
     
            
    }

}

#pragma mark 获取标签
- (void)setBossTagArr:(NSMutableArray *)arr
{
    self.turnArr = arr;
    
      [self.mainDic setObject:arr forKey:@"tag_user"];


}
- (void)changeEduAndWork:(NSString *)arrTitle dic:(NSDictionary *)dic row:(NSInteger)row
{
   
    if ([arrTitle isEqualToString:@"edu"]) {
        [self.eduArr replaceObjectAtIndex:row withObject:dic];
    }
    if ([arrTitle isEqualToString:@"job"]) {
        [self.workArr replaceObjectAtIndex:row withObject:dic];
    }
    [self.resumeTable reloadData];
    
}
- (void)deleteEduAndWork:(NSString *)arrTitle dic:(NSDictionary *)dic
{
    if ([arrTitle isEqualToString:@"edu"]) {
        [self.eduArr removeObject:dic];
    }
    if ([arrTitle isEqualToString:@"job"]) {
        [self.workArr removeObject:dic];
    }
    [self.resumeTable reloadData];
}
- (void)saveNewEduAndWork:(NSString *)arrTitle dic:(NSDictionary *)dic
{
    if ([arrTitle isEqualToString:@"edu"]) {
        [self.eduArr addObject:dic];
    }
    if ([arrTitle isEqualToString:@"job"]) {
        [self.workArr addObject:dic];
    }
    [self.resumeTable reloadData];
}
- (void)getChangedText:(NSString *)str
{
    [self.mainDic setObject:str forKey:@"self_summary"];
}
- (void)getJobPlaceTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}

// 具体职位传值第六步
- (void)getNameTextDic:(NSDictionary *)dic
{
//    [self.mainDic addEntriesFromDictionary:dic];
    

}

- (void)getJobChangeTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}

- (void)getMyValue:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
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
