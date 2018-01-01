//
//  FirstRegistGuideController.m
//  NewModelZZD
//
//  Created by Gaara on 16/6/23.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "FirstRegistGuideController.h"
#import "ZZDRegistGuideView.h"
#import "JobTagViewController.h"
#import "JobPlaceViewController.h"
#import "UIColor+AddColor.h"
#import "ZZDAlertView.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "FontTool.h"
#import "JobSelectTypeViewController.h"
#import "EduAndWorkFirstView.h"
#import "SelfSummaryFirstView.h"
#import <AVOSCloud/AVOSCloud.h>
#import <UMMobClick/MobClick.h>
#import "EditInforViewController.h"
@interface FirstRegistGuideController ()<ZZDRegistGuideViewDelegate,JobTagDelegate,JobPlaceViewDelegate,JobSelectTypeDelegate,EduAndWorkFirstDelegate,UIScrollViewDelegate,SelfSummaryFirstDelegate,EditInforViewControllerDelegate>
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)UILabel *numberOne;
@property (nonatomic, strong)UILabel *numberTwo;
@property (nonatomic, strong)UILabel *numberThree;
@property (nonatomic, strong)UIImageView *upperView;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, assign)BOOL pageOne;
@property (nonatomic, assign)BOOL pageTwo;
@property (nonatomic, assign)BOOL pageThree;
@property (nonatomic, assign)BOOL pageFour;
@property (nonatomic, assign)BOOL pageFive;
@property (nonatomic, assign)BOOL pageSix;

@property (nonatomic, strong)ZZDRegistGuideView *guideThree;
@property (nonatomic, strong)UILabel *navLabel;
@property (nonatomic, strong)NSMutableDictionary *eduDic;
@property (nonatomic, strong)NSMutableDictionary *workDic;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)SelfSummaryFirstView *selfView;

@property (nonatomic, strong)EduAndWorkFirstView *workView;
@property (nonatomic, strong)EduAndWorkFirstView *eduView;
@property (nonatomic, assign)NSInteger a;
@end
@implementation FirstRegistGuideController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPage = 1;
        self.mainDic = [NSMutableDictionary dictionary];
        self.eduDic = [NSMutableDictionary dictionary];
        self.workDic = [NSMutableDictionary dictionary];
    }
    return self;
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
                NSArray *cityArr = [dic objectForKey:@"data"];
                [[NSUserDefaults standardUserDefaults]setObject:cityArr forKey:@"city"];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
//                if ([AVUser currentUser].objectId != nil) {
//                    AVIMClient * client = [AVIMClient defaultClient];
//                    [client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
//                        
//                    }];
//                    if (client!=nil && client.status == AVIMClientStatusOpened) {
//                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                            [self log];
//                        }];
//                    } else {
//                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                            [self log];
//                        }];
//                    }
//                    
//                }else{
//                    [self log];
//                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)lastAction:(id)sender
{
    self.currentPage = self.currentPage - 1;
    if (self.currentPage == 1) {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
        self.upperView.image = [UIImage imageNamed:@"schedule1.png"];
        
    }else
    {
        UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        navLabel.textColor = [UIColor whiteColor];
        navLabel.text = @"下一步";
        navLabel.textAlignment = 2;
        navLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        navLabel.userInteractionEnabled = YES;
        [navLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextAction:)]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLabel];
        
        [self judge:navLabel];
    }
        [self.mainScroll setContentOffset:CGPointMake((self.currentPage - 1) * self.view.frame.size.width, 0) animated:YES];
        
//        self.numberOne.textColor = [UIColor lightGrayColor];
//        self.numberTwo.textColor = [UIColor lightGrayColor];
//        self.numberThree.textColor = [UIColor lightGrayColor];
//        
//        UILabel *label = [self.view viewWithTag:self.currentPage];
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.upperView.frame = CGRectMake(self.view.frame.size.width / 4 * self.currentPage - 10, 480, 20, 20);
//        }completion:^(BOOL finished) {
//            label.textColor = [UIColor whiteColor];
//            
//        }];
    
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"RSEnd"];
    [AVAnalytics endLogPageView:@"RSEnd"];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [MobClick beginLogPageView:@"RSBegin"];
    [AVAnalytics beginLogPageView:@"RSBegin"];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    if (self.currentPage == 1) {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
        
    }
}
- (void)doSomeThing:(id)sender
{
    NSString *tagStr;
    if (sender != nil) {
        UIButton *btn = (UIButton *)sender;
        tagStr = [NSString stringWithFormat:@"%ld",btn.tag];
    }
    [self.backView removeFromSuperview];
    self.navLabel.userInteractionEnabled = NO;
    
        if (([[self.mainDic objectForKey:@"name"] isEqualToString:@""]) || ([[self.mainDic objectForKey:@"sex"] isEqualToString:@""])) {
            
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"请完善信息后保存" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
            return;
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = @"http://api.zzd.hidna.cn/v1/user";
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    if ([self.mainDic objectForKey:@"sex"]) {
        if ([[self.mainDic objectForKey:@"sex"]isEqualToString:@"男"]) {
            [self.mainDic setObject:@"http://old0l37qg.bkt.clouddn.com/v6.png" forKey:@"avatar"];
        }else if ([[self.mainDic objectForKey:@"sex"]isEqualToString:@"女"])
        {
            [self.mainDic setObject:@"http://7xnj9p.com1.z0.glb.clouddn.com/1_bd7934a5488b1ccf21d7.jpeg" forKey:@"avatar"];
        }
    }
        [manager GET:TIMESTAMP parameters:nil success:^ (AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           NSMutableDictionary *userDic =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
            [userDic setValuesForKeysWithDictionary:self.mainDic];
            self.mainDic = [[NSMutableDictionary alloc]initWithDictionary:userDic];
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[self.mainDic objectForKey:@"token"],time];
            [self.mainDic setObject:time forKey:@"timestamp"];
            [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [self.mainDic setObject:@"1" forKey:@"is_fill_user"];
          
            
            if ([[self.mainDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
                
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                [self.mainDic setObject:jsonString1 forKey:@"tag_user"];
            }else{
                
                
                
            }
            
            
            
            if ([[self.mainDic objectForKey:@"tag_boss"]isKindOfClass:[NSArray class]]){
                
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_boss"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                [self.mainDic setObject:jsonString1 forKey:@"tag_boss"];
            }else{
                
                
            }
            
            [manager POST:url parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSString *str = [responseObject objectForKey:@"ret"];
                if ([str isEqualToString:@"0"]) {
                    NSLog(@"修改成功");
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:(NSDictionary *)self.mainDic forKey:@"user"];
                    if ([tagStr isEqualToString:@"99"]) {
                        [self goToUpdateRs];
                        
                    }else{
                        [self goToUpdateRsWithOut];
                    }
//                    [self.navigationController popViewControllerAnimated:YES];
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
//                    if ([AVUser currentUser].objectId != nil) {
//                        AVIMClient * client = [AVIMClient defaultClient];
//                        [client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
//                            
//                        }];
//                        if (client!=nil && client.status == AVIMClientStatusOpened) {
//                            [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                                [self log];
//                            }];
//                        } else {
//                            [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                                [self log];
//                            }];
//                        }
//                    }else{
//                        [self log];
//                    }
                    if ([tagStr isEqualToString:@"99"]) {
                        
                    }else{
                        NSLog(@"--------1---------");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"--------2---------");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"--------3---------");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
    
}
- (void)nextAction:(UITapGestureRecognizer *)sender
{
    UILabel *lb = (UILabel *)sender.view;
    if (lb.textColor == [UIColor lightGrayColor]) {
        
    }else{
        if (self.currentPage == 4) {
//            [self saveEduOrWork:@"work"];
        }
        if (self.currentPage == 5) {
//            [self saveEduOrWork:@"edu"];
        }
    
//    if (self.currentPage == 3) {
//        NSLog(@"complete");
//        [self doSomeThing];
//        self.upperView.image = [UIImage imageNamed:@"schedule3.png"];
//    }else{
    self.currentPage = self.currentPage + 1;
        
        if (self.currentPage != 1) {
            UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
            navLabel.textColor = [UIColor lightGrayColor];
            navLabel.text = @"上一步";
            navLabel.textAlignment = 2;
            navLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
            navLabel.userInteractionEnabled = YES;
            [navLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lastAction:)]];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLabel];
            self.upperView.image = [UIImage imageNamed:@"schedule2.png"];
        }
        
//        if (self.currentPage == 3) {
//            self.navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
//            self.navLabel.textColor = [UIColor lightGrayColor];
//            self.navLabel.text = @"完成";
//            self.navLabel.textAlignment = 2;
//            self.navLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//            self.navLabel.userInteractionEnabled = YES;
//            [self.navLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextAction:)]];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.navLabel];
//            self.upperView.image = [UIImage imageNamed:@"schedule3.png"];
//        }
        if (self.currentPage == 6) {
                        self.navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
                        self.navLabel.textColor = [UIColor lightGrayColor];
                        self.navLabel.text = @"完成";
                        self.navLabel.textAlignment = 2;
                        self.navLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
                        self.navLabel.userInteractionEnabled = YES;
                        [self.navLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(complete:)]];
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.navLabel];
            
        }
    [self.mainScroll setContentOffset:CGPointMake((self.currentPage - 1) * self.view.frame.size.width, 0) animated:YES];
    
    self.numberOne.textColor = [UIColor lightGrayColor];
    self.numberTwo.textColor = [UIColor lightGrayColor];
    self.numberThree.textColor = [UIColor lightGrayColor];
    
    UILabel *label = [self.view viewWithTag:self.currentPage];
    
    [UIView animateWithDuration:0.5 animations:^{
//        self.upperView.frame = CGRectMake(self.view.frame.size.width / 4 * self.currentPage - 10, 480, 20, 20);
    }completion:^(BOOL finished) {
        label.textColor = [UIColor whiteColor];
        
    }];
        
        [self judge:(UILabel *)self.navigationItem.rightBarButtonItem.customView];
//    }
    }
    
}
- (void)complete:(id)sender
{
    [self saveEduOrWork:@"work"];
    [self saveEduOrWork:@"edu"];
    
    [self.mainDic setObject:self.selfView.myTextView.text forKey:@"self_summary"];
    [self doSomeThing:nil];
}
- (void)saveEduOrWork:(NSString *)state
{
    NSString *url = @"";
    NSMutableDictionary *mainDictionary = [NSMutableDictionary dictionary];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    [mainDictionary setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
           if ([state isEqualToString:@"work"]) {
            self.a = 2;
            url = @"http://api.zzd.hidna.cn/v1/rs/job";
               [mainDictionary setValuesForKeysWithDictionary:self.workDic];
            [mainDictionary setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] forKey:@"rs_id"];
            
        }else if ([state isEqualToString:@"edu"]){
            self.a = 2;
            url = @"http://api.zzd.hidna.cn/v1/rs/edu";
            [mainDictionary setValuesForKeysWithDictionary:self.eduDic];
            [mainDictionary setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] forKey:@"rs_id"];
            
        }
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[dic objectForKey:@"token"],time];
        [mainDictionary setObject:time forKey:@"timestamp"];
        
        [mainDictionary setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager POST:url parameters:mainDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                
                if ([state isEqualToString:@"edu"]) {
                    
                    //设置id
                    [self.eduDic setObject:[[responseObject objectForKey:@"data"] objectForKey:@"id"] forKey:@"id"];
//                    [self.saveDelegate saveNewEduAndWork:self.arrTitle dic:self.mainDic];
                    
                        NSMutableDictionary *user = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                        [user setObject:[[responseObject objectForKey:@"data"]objectForKey:@"highest_edu"] forKey:@"highest_edu"];
                    [user setObject:@[self.eduDic] forKey:@"job"];
                        [[NSUserDefaults standardUserDefaults]setObject:user forKey:@"user"];
                        
                }
                if ([state isEqualToString:@"work"]) {
                    //设置id
                    [self.workDic setObject:[[responseObject objectForKey:@"data"] objectForKey:@"id"] forKey:@"id"];
                    //                    [self.saveDelegate saveNewEduAndWork:self.arrTitle dic:self.mainDic];
                    
                    NSMutableDictionary *user = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                    [user setObject:@[self.workDic] forKey:@"job"];
                    [[NSUserDefaults standardUserDefaults]setObject:user forKey:@"user"];
                }
                
                NSLog(@"--------4---------");
                [self.navigationController popViewControllerAnimated:YES];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
               
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)judge:(UILabel *)label
{
    switch (self.currentPage) {
        case 1:
            if(self.pageOne){
                label.textColor = [UIColor whiteColor];
            }else{
                label.textColor = [UIColor lightGrayColor];
            }
            break;
        case 2:
            if (self.pageTwo) {
                label.textColor = [UIColor whiteColor];
            }else{
                label.textColor = [UIColor lightGrayColor];
            }
            break;
        case 3:
            if (self.pageThree) {
                label.textColor = [UIColor whiteColor];
            }else{
                label.textColor = [UIColor lightGrayColor];
            }
            break;
        case 4:
            if (self.pageFour) {
                label.textColor = [UIColor whiteColor];
            }else{
                label.textColor = [UIColor lightGrayColor];
            }
            break;
        case 5:
            if (self.pageFive) {
                label.textColor = [UIColor whiteColor];
            }else{
                label.textColor = [UIColor lightGrayColor];
            }
            break;
        case 6:
            if (self.pageSix) {
                label.textColor = [UIColor whiteColor];
            }else{
                label.textColor = [UIColor lightGrayColor];
            }
            break;
        default:
            break;
    }

}
- (void)backAction
{
    [self.mainScroll endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUnderNumber];
    [self getConnection];
    UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    navLabel.textColor = [UIColor lightGrayColor];
    navLabel.text = @"下一步";
    navLabel.textAlignment = 2;
    navLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    navLabel.userInteractionEnabled = YES;
    [navLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextAction:)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 400)];
    [self.view addSubview:self.mainScroll];
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width * 6, 0);
    self.mainScroll.userInteractionEnabled = YES;
    [self.mainScroll addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)]];
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.delegate = self;
    self.mainScroll.scrollEnabled = NO;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    
    NSString *url = @"{\"id\":\"2\",\"uid\":\"6\",\"category_id\":\"5\",\"sub_category_id\":\"25\",\"province_id\":\"861\",\"city_id\":\"862\",\"salary_id\":\"9\",\"work_year_id\":\"4\",\"category\":\"\u751f\u4ea7\u5236\u9020\",\"sub_category\":\"\u751f\u4ea7\u7c7b\",\"city\":\"\u4e0a\u6d77\u5e02\",\"salary\":\"\u9762\u8bae\",\"work_year\":\"3-5\u5e74\",\"title\":\"\u751f\u4ea7\u4e13\u5458\",\"work_state\":\"0\",\"work_address\":\"\",\"self_summary\":\"\u523b\u82e6\u94bb\u7814\",\"browser_num\":\"979\",\"favorite_num\":\"3\",\"tag_user\":[{\"id\":\"11\",\"name\":\"\u836f\u54c1\u6d41\u901a\"},{\"id\":\"15\",\"name\":\"\u751f\u7269\u6280\u672f\"},{\"id\":\"10\",\"name\":\"\u533b\u836f\u7535\u5546\"}],\"job\":[{\"id\":\"203\",\"category_id\":\"1\",\"sub_category_id\":\"8\",\"category\":\"\u6280\u672f\u7814\u53d1\",\"sub_category\":\"\u751f\u7269\u4fe1\u606f\u7c7b\",\"title\":\"\u804c\u4f4d\u540d\u79f0\",\"cp_name\":\"\u516c\u53f8\u540d\u79f0\",\"work_start_date\":\"2016.1\",\"work_end_date\":\"2016.4\",\"work_content\":\"\",\"is_invisible\":\"0\"}],\"edu\":[{\"id\":\"114\",\"edu_school\":\"\u5b66\u6821\u540d\u79f0\",\"edu_experience_id\":\"2\",\"edu_experience\":\"\u672c\u79d1\",\"edu_major\":\"\u4e13\u4e1a\u540d\u79f0\",\"edu_start_date\":\"2016.1\",\"edu_end_date\":\"2016.2\",\"edu_content\":\"\"},{\"id\":\"506\",\"edu_school\":\"\u4e0a\u6d77\u4e2d\u533b\u836f\u5927\u5b66\",\"edu_experience_id\":\"3\",\"edu_experience\":\"\u7855\u58eb\",\"edu_major\":\"\u4e2d\u533b\",\"edu_start_date\":\"2004.1\",\"edu_end_date\":\"2010.1\",\"edu_content\":\"\"}],\"user\":{\"im_id\":\"56556f7c60b2c00ce43e02b9\",\"name\":\"\u90ed\u4fca\u680b\",\"title\":\"\u804c\u4f4d\",\"avatar\":\"http:\/\/7xnj9p.com1.z0.glb.clouddn.com\/6_4f4a217ecbed02336038.png\",\"highest_edu\":\"\u7855\u58eb\",\"sex\":\"\u7537\"}}";
    NSData *jsonData = [url dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

    
    
    ZZDRegistGuideView *guideOne = [[ZZDRegistGuideView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,350) titleImgArr:@[@"名片.png",@"性别.png",@"手机号码.png"] titleArr:@[@"姓名",@"性别",@"手机号"] rowHeight:60 imgName:@"\"对你的初步了解\""keys:@[@"name",@"sex",@"mobilePhoneNumber"]];
    guideOne.delegate = self;
    [self.mainScroll addSubview:guideOne];
    
    ZZDRegistGuideView *guideTwo = [[ZZDRegistGuideView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 350) titleImgArr:@[@"XL.png",@"公文包.png",@"文档.png"] titleArr:@[@"最高学历",@"工作年限",@"求职状态"] rowHeight:60 imgName:@"\"你目前的情况\""keys:@[@"hightest_edu",@"work_year",@"work_state"]];
    guideTwo.delegate = self;
    [self.mainScroll addSubview:guideTwo];
    
    self.guideThree = [[ZZDRegistGuideView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, 350) titleImgArr:@[@"领带.png",@"类型同类.png",@"钱.png",@"地点.png"] titleArr:@[@"期望职业",@"期望行业",@"期望薪资",@"期望城市"] rowHeight:60 imgName:@"\"你期望的工作\""keys:@[@"title",@"sub_category",@"salary",@"city"]];
    self.guideThree.delegate = self;
    [self.mainScroll addSubview:self.guideThree];
    
    
    // category = "\U6280\U672f\U7814\U53d1";"category_id" = 1;"cp_name" = 123;title = 123;"work_end_date" = "2017-01";"work_start_date" = "2017-01";
    self.workView = [[EduAndWorkFirstView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 4, 0, self.view.frame.size.width, 315)state:@"work"];
    self.workView.firstDelegate = self;
    [self.mainScroll addSubview:self.workView];
    
    UIButton *addWorkBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 5 - 170, 295, 150, 50)];
    [addWorkBtn setTitle:@"添加更多工作经历" forState:UIControlStateNormal];
    [addWorkBtn setTitleColor:[UIColor colorFromHexCode:@"38ab99"] forState:UIControlStateNormal];
    [addWorkBtn addTarget:self action:@selector(addWork) forControlEvents:UIControlEventTouchUpInside];
    addWorkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.mainScroll addSubview:addWorkBtn];
    
    
    //{"edu_end_date" = "2017-01";"edu_experience" = "\U5927\U4e13";"edu_experience_id" = 1;"edu_major" = 1;"edu_school" = 12;"edu_start_date" = "2017-01";}
    self.eduView = [[EduAndWorkFirstView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 5, 0, self.view.frame.size.width, 375)state:@"edu"];
    self.eduView.firstDelegate = self;
    [self.mainScroll addSubview:self.eduView];
    
    
    UIButton *addEduBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 6 - 170, 355, 150, 50)];
    [addEduBtn setTitle:@"添加更多教育经历" forState:UIControlStateNormal];
    [addEduBtn setTitleColor:[UIColor colorFromHexCode:@"38ab99"] forState:UIControlStateNormal];
    [addEduBtn addTarget:self action:@selector(addEdu) forControlEvents:UIControlEventTouchUpInside];
    addEduBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.mainScroll addSubview:addEduBtn];
    
    
    
    self.selfView = [[SelfSummaryFirstView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 3, 0, self.view.frame.size.width, 350)];
    self.selfView.delegate = self;
    [self.mainScroll addSubview:self.selfView];
    
    
    
}
- (void)addWork
{
    EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
    editInforVC.delegate = self;
    editInforVC.key = @"work";
    //        NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
    //        editInforVC.keyId = [dic objectForKey:@"id"];
    
        [ editInforVC setArrValue:@[@[@"开始时间",@"work_start_date",@""],@[@"结束时间",@"work_end_date",@""],@[@"职位名称",@"category",@""],@[@"公司名称",@"cp_name",@""]]] ;
    
    [self.navigationController pushViewController:editInforVC animated:YES];

}
- (void)addEdu
{
    EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
    editInforVC.delegate = self;
    editInforVC.key = @"edu";
    //        NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
    //        editInforVC.keyId = [dic objectForKey:@"id"];
   
        [ editInforVC setArrValue:@[@[@"开始时间",@"edu_start_date",@""],@[@"结束时间",@"edu_end_date",@""],@[@"学    校",@"edu_school",@""],@[@"专    业",@"edu_major",@""],@[@"学    历",@"edu_experience",@""]]] ;
    
    [self.navigationController pushViewController:editInforVC animated:YES];

}
- (void)updateEduAndWorkDic:(NSDictionary *)dic keyId:(NSString *)keyId key:(NSString *)key
{
    [self saveEduAndWorkDic:[dic mutableCopy] keyId:keyId key:key self:self];
}
- (void)saveEduAndWorkDic:(NSMutableDictionary *)dic keyId:(NSString *)keyId key:(NSString *)key self:(id)selfVC
{
    NSDictionary *originDic = dic;
    NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    [dic setObject:[dicUser objectForKey:@"uid"] forKey:@"uid"];
    NSString *url = @"";
    if ([key isEqualToString:@"work"]) {
        url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/job/%@",keyId];
    }else if ([key isEqualToString:@"edu"]){
        url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/edu/%@",keyId];
    }
    if (keyId == nil) {
        if ([key isEqualToString:@"work"]) {
            url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/job"];
        }else if ([key isEqualToString:@"edu"]){
            url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/edu"];
        }
        [dic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rs"]objectForKey:@"id"] forKey:@"rs_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[dicUser objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            WorkAndEduListController *workVC = selfVC;
            NSMutableArray *arr = [NSMutableArray array];
            if ([key isEqualToString:@"work"]) {
                arr = [[self.mainDic objectForKey:@"job"]mutableCopy];
            }else if([key isEqualToString:@"edu"]){
                arr = [[self.mainDic objectForKey:@"edu"]mutableCopy];
            }
            
            [dic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"id"];
            NSMutableArray *otherArr = [NSMutableArray arrayWithArray:arr];
            if (keyId == nil) {
                [otherArr addObject:dic];
            }else{
                for (NSDictionary *workDic in arr) {
                    if ([[workDic objectForKey:@"id"]isEqualToString:keyId]) {
                        NSMutableDictionary *otherDic = [workDic mutableCopy];
                        [otherDic setValuesForKeysWithDictionary:originDic];
                        [otherArr removeObject:workDic];
                        [otherArr addObject:otherDic];
                    }
                    
                }
            }
            if ([key isEqualToString:@"work"]) {
                [self.mainDic setObject:otherArr forKey:@"job"];
            }else if([key isEqualToString:@"edu"]){
                [self.mainDic setObject:otherArr forKey:@"edu"];
            }
            //            [workVC setListArrWithArr:otherArr state:key];
            [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"rs"];
//            [self.mainUpView removeFromSuperview];
            
            
//            [workVC.navigationController popToViewController:self animated:YES];
            [self.navigationController popToViewController:selfVC animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
}
- (void)textDidChange:(NSString *)str
{
    if (str != nil) {
        
    
        [self.mainDic setObject:str forKey:@"self_summary"];
        if (str.length > 8) {
            self.pageFour = YES;
        }else{
            self.pageFour = NO;
        }
    }else{
        self.pageFour = NO;
    }
    [self judge:(UILabel *)self.navigationItem.rightBarButtonItem.customView];
}
- (void)setEduAndWorkFirstValue:(NSString *)value key:(NSString *)key state:(NSString *)state
{
    if ([state isEqualToString:@"edu"]) {
        [self.eduDic setObject:value forKey:key];
        [self judgePageCurrent:@"edu"];
        [self judge:(UILabel *)self.navigationItem.rightBarButtonItem.customView];
    }else if ([state isEqualToString:@"work"])
    {
        [self.workDic setObject:value forKey:key];
        [self judgePageCurrent:@"work"];
        [self judge:(UILabel *)self.navigationItem.rightBarButtonItem.customView];
    }
}
- (void)judgePageCurrent:(NSString *)state
{
    switch (self.currentPage) {
        case 6:
            self.pageSix = [self judgeAll:state];
            break;
        case 5:
            self.pageFive = [self judgeAll:state];
            break;
        default:
            break;
    }
}
- (BOOL)judgeAll:(NSString *)state
{
    
    // category = "\U6280\U672f\U7814\U53d1";"category_id" = 1;"cp_name" = 123;title = 123;"work_end_date" = "2017-01";"work_start_date" = "2017-01";
    if ([state isEqualToString:@"work"]) {
        
        if (![[self.workDic objectForKey:@"category"]isEqualToString:@""] && [self.workDic objectForKey:@"category"]!=nil && ![[self.workDic objectForKey:@"category_id"]isEqualToString:@""] && [self.workDic objectForKey:@"category_id"]!= nil && ![[self.workDic objectForKey:@"cp_name"]isEqualToString:@""] && [self.workDic objectForKey:@"cp_name"]!= nil && ![[self.workDic objectForKey:@"work_end_date"]isEqualToString:@""] && [self.workDic objectForKey:@"work_end_date"]!= nil && ![[self.workDic objectForKey:@"work_start_date"]isEqualToString:@""] && [self.workDic objectForKey:@"work_start_date"]!= nil  ) {
            return YES;
        }else{
            return NO;
        }
    }
    else if ([state isEqualToString:@"edu"])
    {
        //{"edu_end_date" = "2017-01";"edu_experience" = "\U5927\U4e13";"edu_experience_id" = 1;"edu_major" = 1;"edu_school" = 12;"edu_start_date" = "2017-01";}
        if (![[self.eduDic objectForKey:@"edu_end_date"]isEqualToString:@""] && [self.eduDic objectForKey:@"edu_end_date"]!=nil && ![[self.eduDic objectForKey:@"edu_experience"]isEqualToString:@""] && [self.eduDic objectForKey:@"edu_experience"]!= nil && ![[self.eduDic objectForKey:@"edu_experience_id"]isEqualToString:@""] && [self.eduDic objectForKey:@"edu_experience_id"]!= nil && ![[self.eduDic objectForKey:@"edu_major"]isEqualToString:@""] && [self.eduDic objectForKey:@"edu_major"]!= nil && ![[self.eduDic objectForKey:@"edu_school"]isEqualToString:@""] && [self.eduDic objectForKey:@"edu_school"]!= nil && ![[self.eduDic objectForKey:@"edu_start_date"]isEqualToString:@""] && [self.eduDic objectForKey:@"edu_start_date"]!= nil ) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
- (void)getTitleAndCategoryToWork:(NSDictionary *)dic
{
    if ([dic objectForKey:@"title"] != nil) {
        [self.workView setFirstLine:[dic objectForKey:@"title"]];
    }
    [self.workDic setValuesForKeysWithDictionary:dic];
    [self judgePageCurrent:@"work"];
    [self judge:(UILabel *)self.navigationItem.rightBarButtonItem.customView];
}
- (void)setBossTagArrToWork:(NSMutableArray *)arr
{
    [self.workDic setObject:arr forKey:@"tag_boss"];
    [self judgePageCurrent:@"work"];
    [self judge:(UILabel *)self.navigationItem.rightBarButtonItem.customView];
}
- (void)setCategory
{
    JobSelectTypeViewController *jobSelect = [[JobSelectTypeViewController alloc]init];
    jobSelect.dataArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"] objectForKey:@"category"];
    jobSelect.delegate = self;
    jobSelect.state = @"work";
    [self.navigationController pushViewController:jobSelect animated:YES];
}
- (void)setTag
{
    JobTagViewController *jobTagVC = [[JobTagViewController alloc]init];
    jobTagVC.dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"rs"];
    jobTagVC.delegate = self;
    [self.navigationController pushViewController:jobTagVC animated:YES];
}
- (void)createUnderNumber
{
    self.upperView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 310) / 2, self.view.frame.size.height - 200, 310, 100)];
    self.upperView.image = [UIImage imageNamed:@"schedule1.png"];
//    self.upperView.layer.cornerRadius = 10;
//    self.upperView.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:171 / 255.0 blue:125 / 255.0 alpha:1];
    [self.view addSubview:self.upperView];
    
//    self.numberOne = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 10, 480, 20, 20)];
//    self.numberOne.layer.cornerRadius = 10;
//    self.numberOne.text = @"1";
//    self.numberOne.tag = 1;
//    self.numberOne.textColor = [UIColor whiteColor];
//    self.numberOne.textAlignment = 1;
//    self.numberOne.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    [self.view addSubview:self.numberOne];
//    
//    self.numberTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 10, 480, 20, 20)];
//    self.numberTwo.layer.cornerRadius = 10;
//    self.numberTwo.text = @"2";
//    self.numberTwo.textColor = [UIColor lightGrayColor];
//    self.numberTwo.textAlignment = 1;
//    self.numberTwo.tag = 2;
//    self.numberTwo.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    [self.view addSubview:self.numberTwo];
//    
//    self.numberThree = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 * 3 - 10, 480, 20, 20)];
//    self.numberThree.layer.cornerRadius = 10;
//    self.numberThree.textAlignment = 1;
//    self.numberThree.text = @"3";
//    self.numberThree.tag = 3;
//    self.numberThree.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.numberThree.textColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.numberThree];
 }
- (void) getJobPlaceTextDic:(NSDictionary *)dic;
{
    [self.mainDic setValuesForKeysWithDictionary:dic];
}
- (void) getJobChangeTextDic:(NSDictionary *)dic
{
    [self.mainDic setValuesForKeysWithDictionary:dic];
    

    UILabel *label = [self.guideThree viewWithTag:115];
    label.text = [dic objectForKey:@"title"];
    label.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];

}

- (void)getTitleAndCategory:(NSDictionary *)dic
{
    [self.mainDic setValuesForKeysWithDictionary:dic];
    

    UILabel *label = [self.guideThree viewWithTag:115];
    label.text = [dic objectForKey:@"title"];
    label.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    NSLog(@"--------5---------");
    [self.navigationController popToViewController:self animated:YES];
}
- (void)jumpToCategory
{
//    JobPlaceViewController *jobPlace = [[JobPlaceViewController alloc]init];
//    jobPlace.dataArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"] objectForKey:@"category"];
//    jobPlace.delegate = self;
//    jobPlace.mainTitle = @"job";
//    jobPlace.word = @"职位类型";
    
    JobSelectTypeViewController *jobSelect = [[JobSelectTypeViewController alloc]init];
    jobSelect.dataArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"] objectForKey:@"category"];
    jobSelect.delegate = self;
    [self.navigationController pushViewController:jobSelect animated:YES];
    
//    [self.navigationController pushViewController:jobPlace animated:YES];
}
- (void)jumpToTagVC
{
    JobTagViewController *jobTagVC = [[JobTagViewController alloc]init];
    jobTagVC.dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"rs"];
    jobTagVC.delegate = self;
    [self.navigationController pushViewController:jobTagVC animated:YES];
}

- (void)setBossTagArr:(NSMutableArray *)arr
{
    if (arr.count > 0) {
        [self.mainDic setObject:arr forKey:@"tag_user"];
        UILabel *label = [self.guideThree viewWithTag:102];
        label.text = @"已选择";
        label.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    }
}
- (void)valueChangeWith:(NSString *)value key:(NSString *)key
{
    UILabel *label = (UILabel *)self.navigationItem.rightBarButtonItem.customView;
 
    [self.mainDic setObject:value forKey:key];
    if ([self.mainDic objectForKey:@"name"] != nil && [self.mainDic objectForKey:@"sex"] != nil  && ![[self.mainDic objectForKey:@"name"] isEqualToString:@""] && ![[self.mainDic objectForKey:@"sex"]isEqualToString:@""] ) {
        self.pageOne = YES;
        if (self.currentPage == 1) {
            label.textColor = [UIColor whiteColor];
        }
    }else{
        self.pageOne = NO;
        if (self.currentPage == 1) {
            label.textColor = [UIColor lightGrayColor];
        }
    }
    
    if ([self.mainDic objectForKey:@"hightest_edu"] != nil &&[self.mainDic objectForKey:@"work_year"] != nil &&[self.mainDic objectForKey:@"work_state"] != nil && ![[self.mainDic objectForKey:@"hightest_edu"] isEqualToString:@""] && ![[self.mainDic objectForKey:@"work_year"]isEqualToString:@""] && ![[self.mainDic objectForKey:@"work_state"] isEqualToString:@""]) {
        self.pageTwo = YES;
        if (self.currentPage == 2) {
            label.textColor = [UIColor whiteColor];
        }
    }else{
        self.pageTwo = NO;
        if (self.currentPage == 2) {
            label.textColor = [UIColor lightGrayColor];
        }
    }
    
    if ([self.mainDic objectForKey:@"title"] != nil &&[self.mainDic objectForKey:@"category"] != nil &&[self.mainDic objectForKey:@"salary"] != nil &&[self.mainDic objectForKey:@"city"] != nil &&![[self.mainDic objectForKey:@"title"] isEqualToString:@""] && ![[self.mainDic objectForKey:@"category"]isEqualToString:@""] && ![[self.mainDic objectForKey:@"salary"] isEqualToString:@""]&& ![[self.mainDic objectForKey:@"city"] isEqualToString:@""]) {
        self.pageThree = YES;
        if (self.currentPage == 3) {
            label.textColor = [UIColor whiteColor];
        }
    }else{
        self.pageThree = NO;
        if (self.currentPage == 3) {
            label.textColor = [UIColor lightGrayColor];
        }
    }
    
}
-(void)goToUpdateRsWithOut
{
    
    
    
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSString *url = @"";
    
    url = @"http://api.zzd.hidna.cn/v1/rs";
    if ([self.mainDic objectForKey:@"id"]!= nil || [[self.mainDic objectForKey:@"id"]integerValue]>0) {
        url = [NSString stringWithFormat:@"%@/%@",@"http://api.zzd.hidna.cn/v1/rs",[self.mainDic objectForKey:@"id"]];
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
                [self.mainDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"resume_id"];
                [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"rs"];
                
                
                if ([self.mainDic objectForKey:@"tag_user"]!= nil) {
                    
                    
                    NSMutableDictionary *dic  =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                    [dic setObject:[self.mainDic objectForKey:@"tag_user"] forKey:@"tag_user"];
                    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"user"];
                    
                }
                
                
                if ([[dic objectForKey:@"resume_id"] isEqualToString: @"0"]|| [dic objectForKey:@"resume_id"] == nil) {
                    NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                    [userDic setObject:[self.mainDic objectForKey:@"name"]  forKey:@"name"];
                    [userDic setObject:[self.mainDic objectForKey:@"title"]  forKey:@"title"];
                    [userDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"] forKey:@"resume_id"];
                    //                            NSDictionary *dic = @{}
                    [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:@"user"];
                }
                
                NSLog(@"--------6---------");
                                        [self.navigationController popViewControllerAnimated:YES];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    //        }
    
}
- (void)goToUpdateRs
{


    
  
            AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
            NSString *url = @"";
    if ([self.mainDic objectForKey:@"id"]) {
        url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[self.mainDic objectForKey:@"id"]];
    }else{
                url = @"http://api.zzd.hidna.cn/v1/rs";
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
                        if (![self.mainDic objectForKey:@"id"]) {
                            [self.mainDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"id"];
                            [self.mainDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"resume_id"];
                            
                        }
                        [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"rs"];
                        [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"user"];
                        
                        if ([self.mainDic objectForKey:@"tag_user"]!= nil) {
                            
                            
                            NSMutableDictionary *dic  =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                            [dic setObject:[self.mainDic objectForKey:@"tag_user"] forKey:@"tag_user"];
                            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"user"];
                            
                        }
                        
                        
                        if ([[dic objectForKey:@"resume_id"] isEqualToString: @"0"] || [dic objectForKey:@"resume_id"] == nil) {
                            NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                            [userDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"] forKey:@"resume_id"];
//                            NSDictionary *dic = @{}
                            [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:@"user"];
                        }
                        NSLog(@"--------7---------");
//                        [self.navigationController popViewControllerAnimated:YES];

                    }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                    {

                    }
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
//        }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.view.frame.size.width + 1;
    
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"schedule%ld.png",page]];
    if (img != nil) {
        self.upperView.image = img;
    }
    if (self.currentPage == 5) {
        if (!self.backView) {
        [self createAlert];
        }
    }

}
- (void)createAlert
{
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.backView.userInteractionEnabled = YES;
    [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)]];
    [self.view addSubview:self.backView];
    
    
    UIView *enterView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 280) / 2 , 120, 280, 180)];
    enterView.layer.cornerRadius = 2;
    enterView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:enterView];
    
    
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    titleImg.image = [UIImage imageNamed:@"pinAlert.png"];
    titleImg.center = CGPointMake(280 / 2, 0);
    [enterView addSubview:titleImg];
    
    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 280 - 30, 60)];
    textLabel.text = @"继续完善你的教育经历和职业经历,会让更多Boss看到你!";
    textLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:2];
    textLabel.textColor = [UIColor colorFromHexCode:@"333"];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = 1;
    [enterView addSubview:textLabel];
    
    UIButton *saveEmailBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 135, 140 - 15 - 15 / 2 , 30)];
    [saveEmailBtn setTitle:@"返回" forState:UIControlStateNormal];
    [saveEmailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveEmailBtn.backgroundColor = [UIColor colorFromHexCode:@"bbb"];
    [saveEmailBtn addTarget:self action:@selector(doSomeThing:) forControlEvents:UIControlEventTouchUpInside];
    saveEmailBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    saveEmailBtn.tag = 98;
    [enterView addSubview:saveEmailBtn];
    
    UIButton *goOnBtn = [[UIButton alloc]initWithFrame:CGRectMake(140 + 15 / 2, 135, 140 - 15 - 15 / 2, 30)];
    [goOnBtn setTitle:@"继续" forState:UIControlStateNormal];
    [goOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goOnBtn.tag = 99;
    goOnBtn.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [goOnBtn addTarget:self action:@selector(doSomeThing:) forControlEvents:UIControlEventTouchUpInside];
    goOnBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [enterView addSubview:goOnBtn];
    
}
- (void)removeView:(id)sender
{
    [self.backView removeFromSuperview];

}
@end
