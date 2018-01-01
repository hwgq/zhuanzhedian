//
//  MyViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MyViewController.h"
#import "MyViewTableViewCell.h"
#import "PostOfficeViewController.h"
#import "MyInforViewController.h"
#import "CollectPersonViewController.h"
#import "MySettingViewController.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AddColor.h"
#import "CreateNewJobTableViewCell.h"
#import "UILableFitText.h"
#import "MyCAShapeLayer.h"
#import "ButtonSelectView.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "MBProgressHUD.h"
//#import <AVOSCloudIM/AVOSCloudIM.h>
#import "AVOSCloud/AVOSCloud.h"
#import "InternetRequest.pch"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AboutUsViewController.h"
#import "PeopleCheatWithMeController.h"
#import "FMDBMessages.h"
#import "ZZDAlertView.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *myMainTableView;
@property (nonatomic, strong)UIImageView *backGroundImage;
@property (nonatomic, strong)UIVisualEffectView *effectView;
@property (nonatomic, strong)UIImageView *userHeaderImage;
@property (nonatomic, strong)UIImageView *settingButtonImage;
@property (nonatomic, strong)UILabel *userInforLabel;
@property (nonatomic, strong)UILabel *userNameLabel;

@property (nonatomic, strong)NSDictionary *userDic;

@property (nonatomic, strong)NSArray *imageArr;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation MyViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageArr = @[@"v1.png",@"v2.png",@"v3.png",@"v4.png",@"v5.png",@"v6.png"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"我的";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;

    
    
    
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_boss"]isEqualToString:@"0"]) {
        MyInforViewController *myInfor = [[MyInforViewController alloc]init];
        myInfor.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfor animated:YES];
    }

    [self getLocalUserData];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.000];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    [self createMainView];
    [self createTableHeaderView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: YES];
    [AVAnalytics beginLogPageView:@"MyView"];
//    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"MyView"];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self getUserInfor];
    //测试用
    [self getLocalUserData];
    self.userInforLabel.text = [NSString stringWithFormat:@"%@  %@",[self.userDic objectForKey:@"cp_sub_name"],[self.userDic objectForKey:@"title"]];
    NSString *imageUrl = [self.userDic objectForKey:@"avatar"];
    self.userNameLabel.text = [self.userDic objectForKey:@"name"];
    [self.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
//    self.backGroundImage.backgroundColor = [UIColor zzdColor];
//    self.effectView.alpha = 0;
    
    CGSize inforSize = [UILableFitText fitTextWithHeight:25 label:self.userInforLabel];
    self.userInforLabel.frame = CGRectMake(100, 62, inforSize.width, 25);
    
    CGSize nameSize = [UILableFitText fitTextWithHeight:25 label:self.userNameLabel];
    self.userNameLabel.frame = CGRectMake(100, 33, nameSize.width, 25);
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 耗时的操作
//        BOOL a = [self judgeImageEqual:imageUrl];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//            if (a) {
//                self.effectView.alpha = 0;
//                self.backGroundImage.image = nil;
//                self.backGroundImage.backgroundColor = [UIColor zzdColor];
//                
//            }else{
//                self.effectView.alpha = 0.7;
//                [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//                
//            }
//        });
//    });
    
}
- (void)getUserInfor
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"http://api.zzd.hidna.cn/v1/user/property";
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[dic objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                NSDictionary *numDic = [responseObject objectForKey:@"data"];
   
                ButtonSelectView *btn1 = [self.view viewWithTag:300];
                btn1.numLabel.text = [NSString stringWithFormat:@"%ld",[[numDic objectForKey:@"jdCount"]integerValue]];
                
                ButtonSelectView *btn2 = [self.view viewWithTag:302];
                btn2.numLabel.text = [NSString stringWithFormat:@"%ld",[[numDic objectForKey:@"favoriteRSCount"]integerValue]];
                NSMutableArray *conver = [FMDBMessages selectAllConversation];
                ButtonSelectView *btn3 = [self.view viewWithTag:301];
                btn3.numLabel.text = [NSString stringWithFormat:@"%ld",conver.count];
                
                
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
- (BOOL)judgeImageEqual:(NSString *)imageUrl
{
   
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    NSInteger a = 0;
    for (NSString *imageName in self.imageArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        [image drawInRect:CGRectMake(0, 0, 200, 200)];
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
        NSData *imageData = UIImagePNGRepresentation(scaledImage);
        if ([imageData isEqual:data]) {
            a = 1;
        }
    }
    if (a == 1) {
        return YES;
    }else{
        return NO;
    }
    
}
- (void)getLocalUserData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.userDic = [user objectForKey:@"user"];
    
    
    
}
- (void)createMainView
{
    self.myMainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30) style:UITableViewStyleGrouped];
    self.myMainTableView.delegate = self;
    self.myMainTableView.dataSource = self;
    self.myMainTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.000];
    //设置不可滚动
//    self.myMainTableView.scrollEnabled = NO;
    self.myMainTableView.rowHeight = 48;
    self.myMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.myMainTableView];
//    [self.myMainTableView bringSubviewToFront:self.view];
    [self.view insertSubview:self.myMainTableView atIndex:1];
    
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


- (void)createTableHeaderView
{
//    NSString *imageUrl = [self.userDic objectForKey:@"avatar"];
    
    UIView *mainHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    mainHeaderView.backgroundColor = [UIColor whiteColor];
    
//    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(2, 200, self.view.frame.size.width / 2 - 3, 50 - 4)];
//    labelOne.backgroundColor = [UIColor whiteColor];
//    [mainHeaderView addSubview:labelOne];
//    
//    
//    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 1, 200, self.view.frame.size.width / 2 - 3, 50 - 4)];
//    labelTwo.backgroundColor = [UIColor whiteColor];
//    [mainHeaderView addSubview:labelTwo];
    
//    self.backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.width)];
//    self.backGroundImage.image = [UIImage imageNamed:@"123.jpg"];
    
    //测试
//    [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
//    [mainHeaderView addSubview:self.backGroundImage];
    
//    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
//    
//    self.effectView.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.width);
//    self.effectView.alpha = 0.7;
//    [mainHeaderView addSubview:self.effectView];
    
    
    self.userHeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(15,25, 70, 70)];
//    self.userHeaderImage.image = [UIImage imageNamed:@"123.jpg"];
    
    //测试
//    [self.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.userHeaderImage.layer.borderWidth = 2;
    self.userHeaderImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userHeaderImage.layer.masksToBounds = YES;
    self.userHeaderImage.layer.cornerRadius = 35;
    [mainHeaderView addSubview:self.userHeaderImage];
    
   
    self.settingButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 30, 30, 30)];
//    self.settingButtonImage.image = [UIImage imageNamed:@"ico-36.png"];
    self.settingButtonImage.image = [UIImage imageNamed:@"e-5.png"];
    self.settingButtonImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *settingTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingTap:)];
    [self.settingButtonImage addGestureRecognizer: settingTap];
//    self.settingButtonImage.backgroundColor = [UIColor blackColor];
//    [mainHeaderView addSubview:self.settingButtonImage];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.settingButtonImage];
    
    self.userInforLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.userInforLabel.backgroundColor = [UIColor lightGrayColor];
    self.userInforLabel.textColor = [UIColor darkGrayColor];
    self.userInforLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    [mainHeaderView addSubview:self.userInforLabel];
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    self.userNameLabel.textColor = [UIColor darkGrayColor];
//    self.userNameLabel.backgroundColor = [UIColor lightGrayColor];
    [mainHeaderView addSubview:self.userNameLabel];
    
    
//    CAShapeLayer *lineView = [MyCAShapeLayer createLayerWithXx:0 xy:120 yx:self.view.frame.size.width yy:120];
//
//    [mainHeaderView.layer addSublayer:lineView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [mainHeaderView addSubview:lineView];
    
    
    
//    [self.view addSubview:mainHeaderView];
//    [self.view sendSubviewToBack:mainHeaderView];
    self.myMainTableView.tableHeaderView = mainHeaderView;
    
    CAShapeLayer *lineOne = [MyCAShapeLayer createLayerWithXx:self.view.frame.size.width / 3 xy:135 yx:self.view.frame.size.width / 3 yy:185];
    [mainHeaderView.layer addSublayer:lineOne];
    
    CAShapeLayer *lineTwo = [MyCAShapeLayer createLayerWithXx:self.view.frame.size.width * 2 / 3 xy:135 yx:self.view.frame.size.width  * 2/ 3 yy:185];
    [mainHeaderView.layer addSublayer:lineTwo];
    
    NSArray *titleArr = @[@"管理职位",@"沟通过的",@"收藏的人"];
    NSArray *imageArr = @[@"ico-06.png",@"ico-37.png",@"ico-11.png"];
    for (int i = 0 ; i < 3; i++) {
        ButtonSelectView *btnView = [[ButtonSelectView alloc]initWithFrame:CGRectMake(5 + self.view.frame.size.width / 3 * i, 125, self.view.frame.size.width / 3 - 10, 70)];
        [btnView getValueWithNum:@"0" title:[titleArr objectAtIndex:i] image:[imageArr objectAtIndex:i]];
        btnView.tag = 300 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage:)];
        [btnView addGestureRecognizer:tap];
        [mainHeaderView addSubview:btnView];
        
    }
    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 45, 80, 30)];
    
    editBtn.layer.cornerRadius = 15;
    editBtn.layer.borderWidth = 0.6;
    editBtn.layer.borderColor = [UIColor colorWithWhite:0.50 alpha:1].CGColor;
    [editBtn setTitle:@"资料     " forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor colorWithWhite:0.45 alpha:1] forState:UIControlStateNormal];
    editBtn.titleLabel.textAlignment = 0;
    editBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    [editBtn addTarget:self action:@selector(editInforSelf) forControlEvents:UIControlEventTouchUpInside];
    [mainHeaderView addSubview:editBtn];
    
    UIImageView *editImg = [[UIImageView alloc]initWithFrame:CGRectMake(53, 8, 14, 14)];
    editImg.image = [UIImage imageNamed:@"jtz.png"];
    [editBtn addSubview:editImg];
    
}
- (void)editInforSelf
{
    MyInforViewController *myInfor = [[MyInforViewController alloc]init];
                myInfor.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myInfor animated:YES];
    
    
}
- (void)goToLastPage:(UITapGestureRecognizer *)tap
{
    PostOfficeViewController *postOffice = [[PostOfficeViewController alloc]init];
    CollectPersonViewController *collectPerson = [[CollectPersonViewController alloc]init];
    PeopleCheatWithMeController *peopleCheat = [[PeopleCheatWithMeController alloc]init];
    
    switch (tap.view.tag) {
        case 300:
            postOffice.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postOffice animated:YES];
            
            break;
        case 301:
            peopleCheat.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:peopleCheat animated:YES];
            
            break;
        case 302:
            [self.navigationController pushViewController:collectPerson animated:YES];
            break;
        default:
            break;
    }

}
- (void)settingTap:(UITapGestureRecognizer *)tap
{
   
    MySettingViewController *mySetting = [[MySettingViewController alloc]init];
    mySetting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySetting animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            //发布职位
//            [cell setLabelValue:@"发布职位" imageView:@"ico-06.png"];
            [cell getTitleLabelText:@"功能教程与攻略"];
            break;
        case 1:
            //个人信息
//            [cell setLabelValue:@"个人信息" imageView:@"ico-37.png"];
            break;
        case 2:
            //收藏的人才
//            [cell setLabelValue:@"收藏的人才" imageView:@"ico-11.png"];
            break;
        default:
            break;
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
    aboutUs.url  = @"http://api.zzd.hidna.cn/v1/conf/help";
    aboutUs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUs animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
