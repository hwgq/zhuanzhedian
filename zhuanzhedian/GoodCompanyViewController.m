//
//  GoodCompanyViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 17/1/14.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "GoodCompanyViewController.h"
#import "AFNetworking.h"
#import "GoodCompanyTableViewCell.h"
#import "GoodCompanyDetailViewController.h"
#import <Wilddog.h>
#import "FontTool.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AddColor.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "WXApi.h"
#import <AVOSCloud/AVOSCloud.h>
#import <UMMobClick/MobClick.h>
@interface GoodCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *companyTable;
@property (nonatomic, strong)NSMutableArray *mainArr;
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic, assign)BOOL isGoodCompany;
@property (nonatomic, strong)NSDictionary *dic;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation GoodCompanyViewController
{
    enum WXScene _scene; //请求发送场景
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([self.state isEqualToString:@"hide"]) {
        self.navigationController.tabBarController.tabBar.hidden  = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGoodCompany = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _scene = WXSceneTimeline;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    self.titleLabel.text = @"名企";
    
    self.titleLabel.textAlignment = 1;
    
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.titleLabel;

    
    
    
    [self createCompanyTable];
    
    //初始化 WDGApp
    WDGOptions *option = [[WDGOptions alloc] initWithSyncURL:@"https://zzd.wilddogio.com/company"];
    [WDGApp configureWithOptions:option];
    //获取一个指向根节点的 WDGSyncReference 实例
    WDGSyncReference *ref = [[WDGSync sync] reference];
    [ref observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot *snapshot) {
//        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
//        self.mainArr = [NSMutableArray arrayWithArray:snapshot.value];
//        [self.companyTable reloadData];
    }];
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    NSString *urlStr = @"http://api.zzd.hidna.cn/v1/prise";

    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlStr,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        [dic setObject:time forKey:@"timestamp"];
        
        [self.manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                NSArray *arr = [[responseObject objectForKey:@"data"]objectForKey:@"data"];
                self.mainArr = [NSMutableArray arrayWithArray:arr];
                if (self.mainArr.count > 0) {
                    
                    NSDictionary *dic = [self.mainArr objectAtIndex:0];
                    if ([[dic objectForKey:@"me"]isEqualToString:@"1"]) {
                        [self createTableHeaderView:dic];
                        self.dic = dic;
                        [self.mainArr removeObjectAtIndex:0];
                        self.titleLabel.text = @"我的名企";
                        
                    }
                }
                [self.companyTable reloadData];
                
            }
           
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

    if ([self.state isEqualToString:@"hide"]) {
        UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
        imageBack.image = [UIImage imageNamed:@"navbar_icon_back.png"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
        [imageBack addGestureRecognizer:tap];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageBack];

    }
    
}
- (void)createTableHeaderView:(NSDictionary *)dic
{
    UIView *mainHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    
    UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 70) / 2, 20, 70, 70)];
    [headerImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]]];
    headerImg.layer.borderWidth = 1;
    headerImg.layer.cornerRadius = 5;
    headerImg.layer.masksToBounds = YES;
    headerImg.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [mainHeaderView addSubview:headerImg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( (self.view.frame.size.width - 220 ) / 2, 100, 220, 20)];
    titleLabel.text = [dic objectForKey:@"title"];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor colorFromHexCode:@"333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [mainHeaderView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 220) / 2, 130, 220, 20)];
    detailLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[dic objectForKey:@"companyType"],[dic objectForKey:@"companyMoney"],[dic objectForKey:@"companySize"]];
    detailLabel.textColor = [UIColor colorFromHexCode:@"333"];
    detailLabel.textAlignment = 1;
    detailLabel.font = [UIFont systemFontOfSize:14];
    [mainHeaderView addSubview:detailLabel];
    
    UIButton *lookDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 240) / 3, 160, 120, 30)];
    [lookDetailBtn setTitle:@"点击查看" forState:UIControlStateNormal];
    [lookDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookDetailBtn addTarget:self action:@selector(lookDetail) forControlEvents:UIControlEventTouchUpInside];
    lookDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    lookDetailBtn.layer.cornerRadius = 5;
    lookDetailBtn.backgroundColor = [UIColor colorFromHexCode:@"38AB99"];
    [mainHeaderView addSubview:lookDetailBtn];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 240) * 2 / 3 + 120, 160, 120, 30)];
    [shareBtn setTitle:@"分享招人" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(sharedAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    shareBtn.layer.cornerRadius = 5;
    shareBtn.backgroundColor = [UIColor colorFromHexCode:@"38AB99"];
    [mainHeaderView addSubview:shareBtn];
     
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 20)];
    otherLabel.backgroundColor = [UIColor colorFromHexCode:@"eee"];
    otherLabel.text = @"  行业名企";
    otherLabel.font = [UIFont systemFontOfSize:12];
    otherLabel.textColor = [UIColor lightGrayColor];
    [mainHeaderView addSubview:otherLabel];
    self.companyTable.tableHeaderView = mainHeaderView;
    
    
}
- (void)lookDetail
{
    GoodCompanyDetailViewController *companyDetail = [[GoodCompanyDetailViewController alloc]init];
    if ([self.state isEqualToString:@"hide"]) {
        companyDetail.state = @"hide";
    }
    companyDetail.isSelf = YES;
    companyDetail.mainDic = self.dic;
    [self.navigationController pushViewController:companyDetail animated:YES];
}
#pragma mark -- 分享按钮
- (void)sharedAction:(UIButton*)button{
    
    // 解决循环引用
    //    __weak typeof(id) ws = self;
    //
    //    UIActionSheet *acSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈", nil];
    //    acSheet.tag =2;
    //    acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //    [acSheet showInView:[[UIApplication sharedApplication]keyWindow]];
    
    NSString *str =[NSString stringWithFormat: @"%@prise?priseId=%@", SHARE_URL, [self.dic objectForKey:@"id"]];
    //        // 设置标题
    NSString * title = [self.dic objectForKey:@"title"];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSArray* imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.dic objectForKey:@"icon"]]]]];
        
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\n求自荐、求转发",[self.dic objectForKey:@"address"]] images:imageArray  url:[NSURL URLWithString:str] title:title
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [MobClick event:@"GPShare"];
                                  [AVAnalytics event:@"GPShare"]; 
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];}
        
    }
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==2){
        if (buttonIndex == 0) {
            _scene = WXSceneSession;
            
        }
        else if (buttonIndex == 1) {
            _scene = WXSceneTimeline;
            
        }
    }
}


- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createCompanyTable
{
    self.companyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.companyTable.delegate = self;
    self.companyTable.dataSource = self;
    self.companyTable.rowHeight = 96;
    self.companyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.companyTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.mainArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    GoodCompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GoodCompanyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dic = [self.mainArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValueWithDic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodCompanyDetailViewController *companyDetail = [[GoodCompanyDetailViewController alloc]init];
    if ([self.state isEqualToString:@"hide"]) {
        companyDetail.state = @"hide";
    }
    companyDetail.mainDic = [self.mainArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:companyDetail animated:YES];
    
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
