//
//  PreviewViewController.m
//  zhuanzhedian
//
//  Created by 转化医学网 on 16/1/8.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "PreviewViewController.h"
#import "UIColor+AddColor.h"
#import "MainViewTableViewCell.h"
#import "SecondViewTableViewCell.h"
#import "ZZDLoginViewController.h"
#import "RegistViewController.h"
#import "AFNetworking.h"
#import "ZZDRegistViewController.h"
#import "MBProgressHUD.h"
#import "NewZZDBossCell.h"
#import "NewZZDPeopleCell.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "AFNInternetTool.h"
#import <AVOSCloud/AVOSCloud.h>
@interface PreviewViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong)UIView * titleView;
@property (nonatomic,strong)UIView * selectView;
@property (nonatomic,strong)UIButton * button1;
@property (nonatomic,strong)UIButton * button2;
@property (nonatomic,strong)UIButton * button3;
@property (nonatomic,strong)UIButton * button4;
@property (nonatomic,strong)UITableView * LookTableView;
@property (nonatomic,strong)NSMutableArray * DicArr;
@property (nonatomic,copy)NSString * urlString;
@property (nonatomic,assign)BOOL open;
@property (nonatomic,  strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong)ZZDLoginViewController * loginView;
@property (nonatomic,strong)ZZDRegistViewController *registView;
@property (nonatomic, strong)MBProgressHUD *hud;

@property (nonatomic,strong)UIView *loginAlertView;
@property (nonatomic, strong)UIView *backView;
@end

@implementation PreviewViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.DicArr =  [[NSMutableArray alloc]init];
        

    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"PreviewVC"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [AVAnalytics beginLogPageView:@"PreviewVC"];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
//    self.navigationController.navigationBarHidden = NO;
//     self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, self.view.bounds.size.width, 50)];
//    self.titleView.backgroundColor = [UIColor clearColor];
////        [self.view addSubview:self.titleView];
//    self.navigationItem.titleView = self.titleView;
    
    
    
    self.LookTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 50) style:UITableViewStylePlain];
    self.LookTableView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.LookTableView.delegate = self;
    self.LookTableView.dataSource = self;
    self.LookTableView.rowHeight = 125;
    self.LookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.LookTableView];
    self.navigationController.navigationBarHidden = YES;
    
    
    
    
    [AFNInternetTool getPreListWithUrl:@"http://api.zzd.hidna.cn/v1/rs/pre_list" andBlock:^(id result, NSString *str) {
        if ([result isKindOfClass:[NSArray class]]) {
            
            self.DicArr = [result mutableCopy];
            self.open = YES;
            [self.LookTableView reloadData];
        }
    }];
    
    self.selectView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50 - 64,self.view.bounds.size.width, 50)];
    self.selectView.backgroundColor = [UIColor colorFromHexCode:@"555555"];
    
    [self titleButton];
    [self downButton];
    [self.view addSubview:self.selectView];
}

-(void)titleButton
{
//    self.button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.button1.frame = CGRectMake(0, 0, self.view.bounds.size.width/2-0.5, 50) ;
//    [self.button1 setTitle:@"求职" forState:UIControlStateNormal];
//    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.button1 setTag:10];
//    [self.button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleView addSubview:self.button1];
//    
//    self.button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.button2.frame = CGRectMake(self.view.bounds.size.width/2+0.5, 0, self.view.bounds.size.width/2-0.5, 50) ;
//    [self.button2 setTitle:@"招聘" forState:UIControlStateNormal];
//    [self.button2 setBackgroundColor:[UIColor clearColor]];
//    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.button2 setTag:20];
//    [self.button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleView addSubview:self.button2];
//    
//    UIView * smallView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-0.5, 5, 1, 40)];
//    smallView.backgroundColor = [UIColor whiteColor];
//    [self.titleView addSubview:smallView];
    
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"我是Boss",@"我是人才",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(20, 10.0,self.view.frame.size.width - 40, 25.0);
//    segmentedControl.layer.cornerRadius = 0;
//    segmentedControl.layer.borderWidth = 1.5;
//    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[[FontTool customFontArrayWithSize:14]objectAtIndex:1],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName,  nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
//    [self.titleView addSubview:segmentedControl];
    self.navigationItem.titleView = segmentedControl;
   }
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index) {
        case 0:
        {
            if (!self.hud) {
                self.hud = [[MBProgressHUD alloc]initWithView:self.view];
                self.hud.delegate = self;
                self.hud.activityIndicatorColor = [UIColor zzdColor];
                self.hud.color = [UIColor clearColor];
                [self.view addSubview:self.hud];
                [self.hud show:YES];
            }
            [AFNInternetTool getPreListWithUrl:@"http://api.zzd.hidna.cn/v1/rs/pre_list" andBlock:^(id result, NSString *str) {
                if ([result isKindOfClass:[NSArray class]]) {
                    
                    self.DicArr = [result mutableCopy];
                    self.open = YES;
                    [self.LookTableView reloadData];
                    
                }
                self.hud.hidden = YES;
                [self.hud removeFromSuperViewOnHide];
                self.hud = nil;
                
            }];
            break;
        }
        case 1:
        {
            if (!self.hud) {
                self.hud = [[MBProgressHUD alloc]initWithView:self.view];
                self.hud.delegate = self;
                self.hud.activityIndicatorColor = [UIColor zzdColor];
                self.hud.color = [UIColor clearColor];
                [self.view addSubview:self.hud];
                [self.hud show:YES];
            }
            [AFNInternetTool getPreListWithUrl:@"http://api.zzd.hidna.cn/v1/jd/pre_list" andBlock:^(id result, NSString *str) {
                if ([result isKindOfClass:[NSArray class]]) {
                    
                    self.DicArr = [result mutableCopy];
                    self.open = NO;
                    [self.LookTableView reloadData];
                }
                self.hud.hidden = YES;
                [self.hud removeFromSuperViewOnHide];
                self.hud = nil;
            }];

         
                  break;
        }
        default:
            break;
    }

}
-(void)downButton
{
    self.button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button3.frame = CGRectMake(10, 5, self.view.bounds.size.width / 2 - 20 , 40) ;
    [self.button3 setTitle:@"登录" forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button3 setTag:30];
    [self.button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button3.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.selectView addSubview:self.button3];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button4.frame = CGRectMake(self.view.bounds.size.width/2 + 10, 5, self.view.bounds.size.width / 2 - 20, 40) ;
    [self.button4 setTitle:@"注册" forState:UIControlStateNormal];
    [self.button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button4 setTag:40];
    [self.button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.button4.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    [self.selectView addSubview:self.button4];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 0.5, 10, 1, 30)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.selectView addSubview:lineView];
    
    
}
-(void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {
            if (!self.hud) {
            self.hud = [[MBProgressHUD alloc]initWithView:self.view];
                self.hud.delegate = self;
                self.hud.color = [UIColor zzdColor];
                [self.view addSubview:self.hud];
                [self.hud show:YES];
            }
            [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           // [self.DicArr removeAllObjects];
            [AFNInternetTool getPreListWithUrl:@"http://api.zzd.hidna.cn/v1/rs/pre_list" andBlock:^(id result, NSString *str) {
                if ([result isKindOfClass:[NSArray class]]) {
                    
                    self.DicArr = [result mutableCopy];
                    self.open = YES;
                    [self.LookTableView reloadData];
                    self.hud.hidden = YES;
                    [self.hud removeFromSuperViewOnHide];
                    self.hud = nil;
                }
                
            }];
            
            break;
        }
        case 20:
        {
             [self.button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           //[self.DicArr removeAllObjects];
            [AFNInternetTool getPreListWithUrl:@"http://api.zzd.hidna.cn/v1/jd/pre_list" andBlock:^(id result, NSString *str) {
                if ([result isKindOfClass:[NSArray class]]) {
                    
                    self.DicArr = [result mutableCopy];
                    self.open = NO;
                    [self.LookTableView reloadData];
                    self.hud.hidden = YES;
                    [self.hud removeFromSuperViewOnHide];
                    self.hud = nil;
                }
            }];
            
            break;
    }
        case 30:
             _loginView = [[ZZDLoginViewController alloc]init];
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:self.loginView animated:YES];
           
            break;
        case 40:
            
            self.registView = [[ZZDRegistViewController alloc]init];
         [self.navigationController pushViewController:self.registView animated:YES];
    
            break;
        case 50:
            _loginView = [[ZZDLoginViewController alloc]init];
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:self.loginView animated:YES];
           
            break;
        case 60:
            self.registView = [[ZZDRegistViewController alloc]init];
            [self.navigationController pushViewController:self.registView animated:YES];
            break;
        default:
            break;
    }
}
//-(void)getData
//{
//    if (self.hud) {
//        
//    }else{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.LookTableView];
//    self.hud.activityIndicatorColor = [UIColor zzdColor];
//    [self.hud setColor:[UIColor clearColor]];
//    
////    self.hud.delegate = self;
//    [self.LookTableView addSubview:self.hud];
//    [self.hud show:YES];
//    }
//    
//    self.manager = [AFHTTPRequestOperationManager manager];
//    [self.manager GET:[NSString stringWithFormat:@"%@",self.urlString] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//
//        NSMutableArray * arr = [responseObject objectForKey:@"data"];
//        self.DicArr = arr;
//        [self.LookTableView reloadData];
//
//        self.hud.hidden = YES;
//        self.hud = nil;
//        [self.hud removeFromSuperViewOnHide];
//
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        self.hud.hidden = YES;
//        self.hud = nil;
//        [self.hud removeFromSuperViewOnHide];
//
//    }];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DicArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.open == NO)
    {
        static NSString *cellIdentify2 = @"cell2";
        
        NewZZDBossCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentify2];
        
        if (!cell2) {
            
            cell2 = [[NewZZDBossCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify2];
        }
        
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.DicArr.count != 0) {
            
            //                [cell2 getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
            [cell2 setSubViewTextFromDic:[self.DicArr objectAtIndex:indexPath.row]];
            
        }
        
        return cell2;

    }
    else
    {
        static NSString *cellIdentify = @"cell";
        
        NewZZDPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        
        if (!cell) {
            cell = [[NewZZDPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.DicArr.count != 0) {
            
            //                [cell getValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
            [cell setSubViewTextFromDic:[self.DicArr objectAtIndex:indexPath.row]];
            
        }
        return cell;
    }
}
- (void)removeBack
{
    [self.backView removeFromSuperview];
    self.backView = nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.backView) {
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBack)]];
        self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:self.backView];
        
        self.loginAlertView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300) / 2, (self.view.frame.size.height - 200) / 2 - 50, 300, 200)];
        self.loginAlertView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.loginAlertView];
        
        UIImageView *pinziImg = [[UIImageView alloc]initWithFrame:CGRectMake( (self.loginAlertView.frame.size.width - 60) / 2, -30, 60, 60)];
        pinziImg.image = [UIImage imageNamed:@"pinzi.png"];
        [self.loginAlertView addSubview:pinziImg];
        
        UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, self.loginAlertView.frame.size.width - 60, 50)];
        alertLabel.font = [[FontTool customFontArrayWithSize:18]objectAtIndex:2];
        alertLabel.textAlignment = 1;
        alertLabel.text = @"查看职位详情请登录";
        alertLabel.textColor = [UIColor colorFromHexCode:@"333"];
        [self.loginAlertView addSubview:alertLabel];
        
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.loginAlertView.frame.size.width - 200) / 3, 150, 100, 30)];
        loginBtn.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setTag:50];
        loginBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginAlertView addSubview:loginBtn];
        
        UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.loginAlertView.frame.size.width - 200) / 3 * 2 + 100, 150, 100, 30)];
        registBtn.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        [registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [registBtn setTag:60];
        registBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginAlertView addSubview:registBtn];
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
