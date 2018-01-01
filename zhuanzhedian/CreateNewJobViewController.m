//
//  CreateNewJobViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CreateNewJobViewController.h"
#import "CreateNewJobTableViewCell.h"
#import "JobNameViewController.h"
#import "PriceRangeViewController.h"
#import "StudyRequireViewController.h"
#import "ExperienceViewController.h"
#import "JobRequireViewController.h"
#import "JobPlaceViewController.h"
#import "AFNetworking.h"
#import "UIColor+AddColor.h"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "JobShareViewController.h"
#import "JobNewPlaceViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "JobSelectTypeViewController.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
@interface CreateNewJobViewController ()<UITableViewDataSource,UITableViewDelegate,JobNameDelegate,PriceRangeViewControllerDelegate,JobPlaceViewDelegate,JobRequireDelegate, JobNewPlaceViewDelegate,JobSelectTypeDelegate>
@property (nonatomic, strong)UITableView *jobTableView;
@property (nonatomic, strong)NSDictionary *dataDic;

@end

@implementation CreateNewJobViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"CreateNewJobView"];
    [AVAnalytics beginLogPageView:@"CreateNewJobView"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"back"]) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"back"];

}

    
          [self.jobTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"CreateNewJobView"];
    [AVAnalytics endLogPageView:@"CreateNewJobView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, 0, 60, 30)];
    titleLabel.text = @"编辑职位";
    if (self.mainDic.allKeys.count == 0) {
    titleLabel.text = @"创建新职位";
    }
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
  
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];

    
    
    
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    [self createTableView];
    [self createButton];
    [self getConnection];
    // Do any additional setup after loading the view.
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
//进行网络请求
- (void)getConnection
{
    
   
    self.dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];
    
}

- (void)createTableView
{
    self.jobTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 ) style:UITableViewStyleGrouped];
    self.jobTableView.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    self.jobTableView.delegate = self;
    self.jobTableView.dataSource = self;
    self.jobTableView.rowHeight = 48;
    self.jobTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.jobTableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    NSString *str = [self.mainDic objectForKey:@"work_content"];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell getTitleLabelText:@"职位信息"];
                    cell.returnLabel.text = [self.mainDic objectForKey:@"title"];
                  
                    break;
                    
                    //                case 1:
                    //                    [cell getTitleLabelText:@"职位名称"];
                    //                      cell.returnLabel.text = [self.mainDic objectForKey:@"title"];
                    //                    break;
                    //
                case 1:
                    [cell getTitleLabelText:@"薪资范围"];
                    cell.returnLabel.text = [self.mainDic objectForKey:@"salary"];
                    break;
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    [cell getTitleLabelText:@"经验要求"];
                    cell.returnLabel.text = [self.mainDic objectForKey:@"work_year"];
                    break;
                    
                case 1:
                    [cell getTitleLabelText:@"学历要求"];
                    cell.returnLabel.text = [self.mainDic objectForKey:@"education"];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    [cell getTitleLabelText:@"工作地点"];
                    cell.returnLabel.text = [self.mainDic objectForKey:@"city"];
                    break;
                case 1:
                    [cell getTitleLabelText:@"职位要求"];
                    
                    switch (str.length) {
                        case 0:
                            cell.returnLabel.text = @"未填写";
                            break;
                            
                        default:
                            cell.returnLabel.text = @"已填";
                            
                            break;
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobSelectTypeViewController *jobSelect = [[JobSelectTypeViewController alloc]init];
    JobNameViewController *jobName = [[JobNameViewController alloc]init];
    PriceRangeViewController *priceRange = [[PriceRangeViewController alloc]init];
    StudyRequireViewController *studyRequire = [[StudyRequireViewController alloc]init];
    ExperienceViewController *experience = [[ExperienceViewController alloc]init];
    JobRequireViewController *jobRequire = [[JobRequireViewController alloc]init];
    JobPlaceViewController *jobPlace = [[JobPlaceViewController alloc]init];
    JobNewPlaceViewController *jobNewPlaceVC = [[JobNewPlaceViewController alloc]init];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    //职位类型
//                    jobPlace.dataArr = [self.dataDic objectForKey:@"category"];
//                    jobPlace.delegate =self;
//                    jobPlace.mainTitle = @"job";
//                    
//                    jobPlace.word = @"职位类型";
//                    jobPlace.delegate = self;
//                    [self.navigationController pushViewController:jobPlace animated:YES];
                    jobSelect.dataArr = [self.dataDic objectForKey:@"category"];
                    jobSelect.delegate = self;
                    if ([self.mainDic objectForKey:@"title"]) {
                        jobSelect.currentStr = [self.mainDic objectForKey:@"title"];
                    }
                    [self.navigationController pushViewController:jobSelect animated:YES];
                    break;
                    
                    //                case 1:
                    //                   //职位名称
                    //                    jobName.placeHolderStr = @"请填写职位名称";
                    //                    jobName.mainTitle = @"title";
                    //                    jobName.delegate = self;
                    //                    jobName.len = 10;
                    //                    jobName.currentStr = [self.mainDic objectForKey:@"title"];
                    //                    jobName.word = @"职位名称";
                    //                    [self.navigationController pushViewController:jobName animated:YES];
                    
                    
                    break;
                    
                case 1:
                    //薪资范围
                    priceRange.array = [self.dataDic objectForKey:@"salary"];
                    priceRange.delegate = self;
                    priceRange.mainTitle = @"salary";
                    priceRange.word = @"薪资范围";
                    [self.navigationController pushViewController:priceRange animated:YES];
                    break;
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    //经验要求
                    priceRange.array = [self.dataDic objectForKey:@"work_year"];
                    priceRange.mainTitle = @"work_year";
                    priceRange.delegate = self;
                    priceRange.word = @"经验要求";
                    [self.navigationController pushViewController:priceRange animated:YES];
                    break;
                    
                case 1:
                    //学历要求
                    priceRange.array = [self.dataDic objectForKey:@"education"];
                    priceRange.mainTitle = @"education";
                    priceRange.delegate = self;
                    priceRange.word = @"学历要求";
                    [self.navigationController pushViewController:priceRange animated:YES];
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    //工作地点
                    jobNewPlaceVC.value = @"10";
                    jobNewPlaceVC.mainTitle = @"city";
                    jobNewPlaceVC.delegate = self;
                    jobNewPlaceVC.word = @"工作地点";
                    [self.navigationController pushViewController:jobNewPlaceVC animated:YES];
                    
                    break;
                    
                case 1:
                    // 职位要求
                    jobRequire.currentStr = [self.mainDic objectForKey:@"work_content"];
                    jobRequire.delegate = self;
                    jobRequire.word = @"职位要求";
                    [self.navigationController pushViewController:jobRequire animated:YES];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}
- (void)getNameTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}
- (void)getMyValue:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}
- (void)getJobPlaceTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}


- (void)getChangedText:(NSString *)str
{
    
    [self.mainDic setObject:str forKey:@"work_content"];
    
}
// 新添加的 地点那页的协议方法
- (void)getJobNewPlaceTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}

- (void)createButton
{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 49 - 64 + 2.5, self.view.frame.size.width - 30, 49 - 15)];
    //    createButton.backgroundColor = [UIColor blueColor];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveJob:) forControlEvents:UIControlEventTouchUpInside];
//    saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    saveButton.layer.borderWidth = 0.5;
    saveButton.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    saveButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    [self.view addSubview:saveButton];
}

#pragma mark -------- 保存按钮
- (void)saveJob:(id)sender
{
    
    
    
    
    JobPlaceViewController *placeVC = [[JobPlaceViewController alloc] init];
    placeVC.delegate = self;
    
 
    
    if ([self.mainDic objectForKey:@"category"] == nil || [self.mainDic objectForKey:@"salary"] == nil || [self.mainDic objectForKey:@"work_year"]== nil ||[self.mainDic objectForKey:@"education"]==nil||[self.mainDic objectForKey:@"city"]==nil || [self.mainDic objectForKey:@"work_content"] ==  nil) {
        
        
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您填写的信息不完整，请完善信息后保存" preferredStyle:UIAlertControllerStyleAlert];
//        
//        // Create the actions.
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        }];
//        [alertController addAction:cancelAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
        
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"您填写的信息不完整，请完善信息后保存" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        
        
        return;
    }else{
        UIButton *btn = (UIButton *)sender;
        btn.userInteractionEnabled = NO;
    }
    
   
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    [self.mainDic setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"";
    if (self.state == 10) {
        url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@",[self.mainDic objectForKey:@"id"]];
    }else{
        url = @"http://api.zzd.hidna.cn/v1/jd";
    }
    
    
    
    [manager GET:@"http://api.zzd.hidna.cn/v1/comm/timestamp" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[dic objectForKey:@"token"],time];
        [self.mainDic setObject:time forKey:@"timestamp"];
        [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        [manager POST:url parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                if (self.state == 10) {
                    
                    
                    [self.delegate changeMainValue:self.mainDic];
                                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                // 保存成功跳到分享那页
                JobShareViewController *jobShareVC = [[JobShareViewController alloc]init];
                
                jobShareVC.jdId = [[responseObject objectForKey:@"data"]objectForKey:@"id"];
                
                [self.navigationController pushViewController:jobShareVC animated:YES];
                
                
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


- (void)scanSuccess
{
    if (self.state == 10) {
        
    }else{
    [self saveJob:nil];
    }
}
// 获取createNewJob的职位title
- (void)getJobChangeTextDic:(NSDictionary *)dic{
    
    [self.mainDic addEntriesFromDictionary:dic];
}
- (void)getTitleAndCategory:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
    [self.navigationController popToViewController:self animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
