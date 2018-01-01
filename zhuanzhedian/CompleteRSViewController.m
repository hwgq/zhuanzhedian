                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              //
//  CompleteRSViewController.m
//  CompleteRS
//
//  Created by Gaara on 16/6/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "CompleteRSViewController.h"
#import "WorkExperienceView.h"
#import "UILableFitText.h"
#import "SelectAsBtnView.h"  
#import "EditInforViewController.h"
#import "JobRequireViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "UIImageView+WebCache.h"
#import "WorkAndEduListController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "ScanViewController.h"
#import "AppDelegate.h"
#import "NSTimer+CLBlockSupport.h"
#import "ScanBeforeViewController.h"
#import <UMMobClick/MobClick.h>
@interface CompleteRSViewController  ()<JobRequireDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EditInforViewControllerDelegate,WorkAndEduListControllerDelegate,DeleteEduAndWorkDelegate>
@property (nonatomic, strong)NSMutableDictionary *mainDic;


@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)UIView *firstView;
@property (nonatomic, strong)UIView *secondView;
@property (nonatomic, strong)UIView *thirdView;
@property (nonatomic, assign)CGFloat currentHeight;

//first
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *userSexLabel;
@property (nonatomic, strong)UILabel *highestEduLabel;
@property (nonatomic, strong)UILabel *workYearLabel;
@property (nonatomic, strong)UILabel *workStateLabel;
@property (nonatomic, strong)UIImageView *headerImg;


//second
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *cityPriceLabel;
@property (nonatomic, strong)UILabel *jobTagLabel;
@property (nonatomic, strong)UILabel *cityDetailLabel;


@property (nonatomic, strong)UILabel *eduExLabel;
@property (nonatomic, strong)UILabel *myAdvantageLabel;
@property (nonatomic, strong)UILabel *selfSummaryLabel;
@property (nonatomic, strong)UIView *selfSummaryBackView;

@property (nonatomic, strong)UIView *mainUpView;

@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *styleSelectView;
@property (nonatomic, strong)UIView *currentView;


@property (nonatomic, strong)UIView *guideView;


@property (nonatomic, strong)UIView *percentView;

@property (nonatomic, strong)UIView *percentUnderView;
@property (nonatomic, strong)UIView *percentCurrentView;
@property (nonatomic, strong)UILabel *percentLabel;
@property (nonatomic, strong)NSTimer *mainTimer;
@end
@implementation CompleteRSViewController
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
    [MobClick beginLogPageView:@"CompleteRS"];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"CompleteRS"];
    [self removeGuide];
}
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.9 alpha:1];
    [super viewDidLoad];
    [self createSubView];
    [self createAlertView];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    if ([arr isKindOfClass:[NSArray class]]) {
        if (arr.count > 0) {
            
        }else{
            [self getConnection];
        }
    }else{
        [self getConnection];
        
    }
    
    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    imageBack.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [imageBack addGestureRecognizer:tap];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageBack];
    
    UIImageView*scanImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    scanImage.image = [UIImage imageNamed:@"macIcon.png"];
    UITapGestureRecognizer *scanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanAction:)];
    [scanImage addGestureRecognizer:scanTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scanImage];
    
    [self goToBrowser];
    [self guideUser];
    [self updateUserInfor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    
    titleLabel.text = @"我的简历";
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.navigationItem.titleView = titleLabel;
    
    
}
- (void)guideUser
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userGuide"]) {
        self.guideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.guideView.backgroundColor = [UIColor clearColor];
        [self.guideView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGuide)]];
        
        
        
        CGRect rect = self.view.bounds;
        
        CGRect holeRection = CGRectMake(self.view.frame.size.width - 48, 22, 40, 40);
        
        
        //背景
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
        //镂空
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:holeRection cornerRadius:5];
        
        [path appendPath:circlePath];
        [path setUsesEvenOddFillRule:YES];
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        [self.guideView.layer addSublayer:fillLayer];
        
        
        
        UIImageView *handImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 320) / 2 , 60, 300, 180)];
        handImage.image = [UIImage imageNamed:@"scanUser.png"];
        [self.guideView addSubview:handImage];
        
//        UILabel *strLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 75, self.view.frame.size.width - 160, 100)];
//        NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc]initWithString:@"嫌手机编辑简历信息麻烦?点击按钮扫码登录电脑端操作"];
//        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, searchStr.length)];
////        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(14, 6)];
//        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//        paragraphStyle.paragraphSpacing = 15;  //段落高度
//        paragraphStyle.lineSpacing = 10;   //行高
//        
//        
//        [searchStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, searchStr.length)];
//        [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:18]objectAtIndex:1] range:NSMakeRange(0, searchStr.length)];
//        strLabel.attributedText = searchStr;
//        strLabel.numberOfLines = 0;
//        
//        [self.guideView addSubview:strLabel];
        
        
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:self.guideView];
        
    }
}
- (void)removeGuide
{
    [self.guideView removeFromSuperview];
    self.guideView = nil;
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userGuide"];
}
- (void)scanAction:(UITapGestureRecognizer *)tap
{
    ScanBeforeViewController *scanVC = [[ScanBeforeViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
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
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)updateUserInfor
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/user/%@",[self.mainDic objectForKey:@"uid"]];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"token"],time];
        NSMutableDictionary *dic= [NSMutableDictionary dictionary];
        
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:[self.mainDic objectForKey:@"uid"] forKey:@"uid"];
        
        
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"msg"]isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"data"] forKey:@"user"];
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)goToBrowser
{
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[self.mainDic objectForKey:@"id"]];
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    [parameters setObject:[self.mainDic objectForKey:@"id"] forKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"data"]forKey:@"rs"];
                
                
                NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                NSLog(@"%@",dic);
                [dic setValuesForKeysWithDictionary:[[responseObject objectForKey:@"data"]objectForKey:@"user"]];
                [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"user"];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)createSubView
{
    NSString *url = @"{\"id\":\"2\",\"uid\":\"6\",\"category_id\":\"5\",\"sub_category_id\":\"25\",\"province_id\":\"861\",\"city_id\":\"862\",\"salary_id\":\"9\",\"work_year_id\":\"4\",\"category\":\"\u751f\u4ea7\u5236\u9020\",\"sub_category\":\"\u751f\u4ea7\u7c7b\",\"city\":\"\u4e0a\u6d77\u5e02\",\"salary\":\"\u9762\u8bae\",\"work_year\":\"3-5\u5e74\",\"title\":\"\u751f\u4ea7\u4e13\u5458\",\"work_state\":\"0\",\"work_address\":\"\",\"self_summary\":\"\u523b\u82e6\u94bb\u7814\",\"browser_num\":\"979\",\"favorite_num\":\"3\",\"tag_user\":[{\"id\":\"11\",\"name\":\"\u836f\u54c1\u6d41\u901a\"},{\"id\":\"15\",\"name\":\"\u751f\u7269\u6280\u672f\"},{\"id\":\"10\",\"name\":\"\u533b\u836f\u7535\u5546\"}],\"job\":[{\"id\":\"203\",\"category_id\":\"1\",\"sub_category_id\":\"8\",\"category\":\"\u6280\u672f\u7814\u53d1\",\"sub_category\":\"\u751f\u7269\u4fe1\u606f\u7c7b\",\"title\":\"\u804c\u4f4d\u540d\u79f0\",\"cp_name\":\"\u516c\u53f8\u540d\u79f0\",\"work_start_date\":\"2016.1\",\"work_end_date\":\"2016.4\",\"work_content\":\"\",\"is_invisible\":\"0\"}],\"edu\":[{\"id\":\"114\",\"edu_school\":\"\u5b66\u6821\u540d\u79f0\",\"edu_experience_id\":\"2\",\"edu_experience\":\"\u672c\u79d1\",\"edu_major\":\"\u4e13\u4e1a\u540d\u79f0\",\"edu_start_date\":\"2016.1\",\"edu_end_date\":\"2016.2\",\"edu_content\":\"\"},{\"id\":\"506\",\"edu_school\":\"\u4e0a\u6d77\u4e2d\u533b\u836f\u5927\u5b66\",\"edu_experience_id\":\"3\",\"edu_experience\":\"\u7855\u58eb\",\"edu_major\":\"\u4e2d\u533b\",\"edu_start_date\":\"2004.1\",\"edu_end_date\":\"2010.1\",\"edu_content\":\"\"}],\"user\":{\"im_id\":\"56556f7c60b2c00ce43e02b9\",\"name\":\"\u90ed\u4fca\u680b\",\"title\":\"\u804c\u4f4d\",\"avatar\":\"http:\/\/7xnj9p.com1.z0.glb.clouddn.com\/6_4f4a217ecbed02336038.png\",\"highest_edu\":\"\u7855\u58eb\",\"sex\":\"\u7537\"}}";
    NSData *jsonData = [url dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

     NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]mutableCopy];
//    if ([dic objectForKey:@"user"] == nil) {
//        
//        NSDictionary *userDic = @{@"avatar":[dic objectForKey:@"avatar"],@"highest_edu":[dic objectForKey:@"highest_edu"],@"im_id":[dic objectForKey:@"im_id"],@"name":[dic objectForKey:@"name"],@"sex":[dic objectForKey:@"sex"],@"title":[dic objectForKey:@"title"]};
//        [dic setObject:userDic forKey:@"user"];
//         [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"rs"];
//    }
    self.mainDic = [dic mutableCopy];
    
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mainScroll.bounces = NO;
    [self.view addSubview:self.mainScroll];
    
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    titleView.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:171 / 255.0 blue:125 / 255.0 alpha:1];
//    [self.mainScroll addSubview:titleView];
//    
//    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 25)];
//    titleImg.image = [UIImage imageNamed:@"tim.png"];
//
//    [titleView addSubview:titleImg];
//    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, self.view.frame.size.width - 50, 40)];
//    titleLabel.textAlignment = 1;
//    titleLabel.text = @"完善简历  ,  吸引更多的BOSS注意你";
//    titleLabel.textColor = [UIColor whiteColor];
//    [titleView addSubview:titleLabel];
    
    
    
    //percent
    self.percentView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 80)];
    self.percentView.backgroundColor = [UIColor whiteColor];                                                                                                                    
    [self.mainScroll addSubview:self.percentView];
    
    UILabel *percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, self.view.frame.size.width - 30, 30)];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"   简历完整度  完善简历可提高求职成功率"];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[[FontTool customFontArrayWithSize:16]objectAtIndex:1]
     
                          range:NSMakeRange(0, AttributedStr.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorFromHexCode:@"2b2b2b"]
     
                          range:NSMakeRange(0, AttributedStr.length)];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:14.0]
     
                          range:NSMakeRange(10, 12)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorFromHexCode:@"bbb"]
     
                          range:NSMakeRange(10, 12)];
    percentLabel.attributedText = AttributedStr;
    [self.percentView addSubview:percentLabel];
    
    UIView *percentLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    percentLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.percentView addSubview:percentLineView];
    
    
    self.percentUnderView = [[UIView alloc]initWithFrame:CGRectMake(30, 56, self.view.frame.size.width - 60, 12)];
    self.percentUnderView.backgroundColor = [UIColor colorFromHexCode:@"eee"];
    [self.percentView addSubview:self.percentUnderView];
    
    
    __block NSInteger percent = 60;
    if ([self.mainDic objectForKey:@"job"] != nil) {
        if ([[self.mainDic objectForKey:@"job"]isKindOfClass:[NSArray class]]) {
            NSArray *jobArr = [self.mainDic objectForKey:@"job"];
            if (jobArr.count > 0) {
                percent  = percent + 15;
                
            }
        }
    }
    if ([self.mainDic objectForKey:@"edu"] != nil) {
        if ([[self.mainDic objectForKey:@"edu"]isKindOfClass:[NSArray class]]) {
            NSArray *eduArr = [self.mainDic objectForKey:@"edu"];
            if (eduArr.count > 0) {
                
                percent  = percent + 15;
            }
        }
    }
    NSString *selfSummaryStr = [self.mainDic objectForKey:@"self_summary"];
    if (selfSummaryStr.length > 0) {
        percent  = percent + 10;
    }
    self.percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 41, 40, 13)];
    __block NSInteger animationPercent = 0;
    self.percentLabel.text = [NSString stringWithFormat:@"%ld%%",animationPercent];
    self.percentLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
    self.percentLabel.textAlignment = 1;
    self.percentLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.percentView addSubview:self.percentLabel];
    
    
    self.percentCurrentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 12)];
    self.percentCurrentView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.percentUnderView addSubview:self.percentCurrentView];
    
    __weak typeof(self) weakSelf = self;
    self.mainTimer = [NSTimer clscheduledTimerWithTimeInterval:0.05 block:^{
        animationPercent = animationPercent + 5;
        weakSelf.percentLabel.text = [NSString stringWithFormat:@"%ld%%",animationPercent];
        if (animationPercent == percent) {
            [weakSelf.mainTimer invalidate];
        }
    } repeats:YES];
    
    [UIView animateWithDuration:1.2 animations:^{
        weakSelf.percentCurrentView.frame = CGRectMake(0, 0, (weakSelf.view.frame.size.width - 60) * percent / 100, 12);
        weakSelf.percentLabel.frame = CGRectMake((weakSelf.view.frame.size.width - 60) * percent / 100, 41, 40, 13);
    }];
    
    
    
    
    //first
    
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 115 , self.view.frame.size.width, 180)];
    self.firstView.userInteractionEnabled = YES;
    [self.firstView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstTap:)]];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.firstView];
    
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, self.view.frame.size.width - 30, 30)];
    firstLabel.text = @"   我的头像";
    firstLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    firstLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.firstView addSubview:firstLabel];
    
    UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    firstLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.firstView addSubview:firstLineView];
    
    
    
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.firstView.frame.size.width - 80) / 2, 50, 80, 80)];
    if ([[dic objectForKey:@"user"]objectForKey:@"avatar"] == nil) {
    self.headerImg.image = [UIImage imageNamed:@"tx.png"];
        
    }else{
    [self.headerImg sd_setImageWithURL:[[dic objectForKey:@"user"]objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"v2.png"]];
    
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 40;
    }
    [self.firstView addSubview:self.headerImg];
    
    UIButton *editHeaderBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.firstView.frame.size.width - 80) / 2, 138, 80, 30)];
    [editHeaderBtn setTitle:@"点击更换" forState:UIControlStateNormal];
    [editHeaderBtn setTitleColor:[UIColor colorFromHexCode:@"b0b0b0"] forState:UIControlStateNormal];
    [editHeaderBtn addTarget:self action:@selector(doSomeThing) forControlEvents:UIControlEventTouchUpInside];
    editHeaderBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.firstView addSubview:editHeaderBtn];
    
    
    
    
    //测试按钮
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 130, 30, 30)];
//    btn.backgroundColor = [UIColor cyanColor];
//    [btn addTarget:self action:@selector(previewRS) forControlEvents:UIControlEventTouchUpInside];
//    [self.firstView addSubview:btn];
    //second
   
    
    self.secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 320, self.view.frame.size.width , 180)];
    self.secondView.userInteractionEnabled = YES;
    [self.secondView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondTap:)]];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.secondView];
    
    UILabel *secLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    secLabel.text = @"   基本信息";
    secLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.secondView addSubview:secLabel];
    
    UIView *secLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    secLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [secLabel addSubview:secLineView];
    
    UIImageView *pencilIconTwo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25, 10, 15, 15)];
    pencilIconTwo.image = [UIImage imageNamed:@"bi.png"];
    [self.secondView addSubview:pencilIconTwo];
    
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, self.secondView.frame.size.width - 15,25)];
    self.userNameLabel.text = [NSString stringWithFormat:@" 姓        名 : %@",[[dic objectForKey:@"user"]objectForKey:@"name"]];
    self.userNameLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userNameLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    [self.secondView addSubview:self.userNameLabel];
    
    self.userSexLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, self.secondView.frame.size.width - 15, 25)];
    self.userSexLabel.text = [NSString stringWithFormat:@" 性        别 : %@",[[dic objectForKey:@"user"]objectForKey:@"sex"]];
    self.userSexLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.userSexLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    [self.secondView addSubview:self.userSexLabel];
    
    self.highestEduLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, self.secondView.frame.size.width - 15, 25)];
    self.highestEduLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.highestEduLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.highestEduLabel.text = [NSString stringWithFormat:@" 最高学历 : %@",[[dic objectForKey:@"user"]objectForKey:@"highest_edu"]];
    [self.secondView addSubview:self.highestEduLabel];

    self.workYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 115, self.secondView.frame.size.width - 15, 25)];
    self.workYearLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.workYearLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.workYearLabel.text = [NSString stringWithFormat:@" 工作年限 : %@",[dic objectForKey:@"work_year"]];
    [self.secondView addSubview:self.workYearLabel];
    
    self.workStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 140, self.secondView.frame.size.width - 15, 25)];
    self.workStateLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.workStateLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    NSInteger workState = [[dic objectForKey:@"work_state"]integerValue];
    NSString *workStr;
    switch (workState) {
        case 0:
            workStr = @"在职";
            break;
        case 1:
            workStr = @"离职";
            break;
        case 2:
            workStr = @"应届";
        default:
            break;
    }
    self.workStateLabel.text = [NSString stringWithFormat:@" 工作状态 : %@", workStr];
    [self.secondView addSubview:self.workStateLabel];
    
    
    
    
    //third
    
   
    
    
    
    self.thirdView = [[UIView alloc]initWithFrame:CGRectMake(0,525, self.view.frame.size.width, 165)];
    self.thirdView.userInteractionEnabled = YES;
    [self.thirdView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdTap:)]];
    self.thirdView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.thirdView];
    
    UIView *thirdLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    thirdLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.thirdView addSubview: thirdLineView];
    
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, self.view.frame.size.width - 4, 30)];
    thirdLabel.text = @"   期望工作";
    thirdLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    thirdLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    [self.thirdView addSubview:thirdLabel];
    
    
    UIImageView *pencilIconThree = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25, 10, 15, 15)];
    pencilIconThree.image = [UIImage imageNamed:@"bi.png"];
    [self.thirdView addSubview:pencilIconThree];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, self.thirdView.frame.size.width - 15, 25)];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.titleLabel.text = [NSString stringWithFormat:@" 期望职位 : %@",[dic objectForKey:@"title"]];
    [self.thirdView addSubview:self.titleLabel];
    
    self.cityPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, self.thirdView.frame.size.width - 15 , 25)];
    self.cityPriceLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.cityPriceLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.cityPriceLabel.text = [NSString stringWithFormat:@" 期望薪资 : %@",[dic objectForKey:@"salary"]];
    [self.thirdView addSubview:self.cityPriceLabel];
    
    self.cityDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 95, self.thirdView.frame.size.width - 15, 25)];
    self.cityDetailLabel.text = [NSString stringWithFormat:@" 期望城市 : %@",[dic objectForKey:@"city"]];
    self.cityDetailLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.cityDetailLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.thirdView addSubview:self.cityDetailLabel];
    
    NSMutableString *tagStr = [NSMutableString string];
    id tagArr = [dic objectForKey:@"tag_user"];
    if ([tagArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *tagDic in tagArr) {
            if (tagStr.length == 0) {
                
                [tagStr appendString:[tagDic objectForKey:@"name"]];
                
            }else{
                [tagStr appendString:[NSString stringWithFormat:@" | %@",[tagDic objectForKey:@"name"]]];
            }
        }
    }else{
        if ([tagArr isKindOfClass:[NSString class]]) {
            NSArray *tagArray = [NSJSONSerialization JSONObjectWithData:[tagArr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *tagDic in tagArray) {
                if (tagStr.length == 0) {
                    
                    [tagStr appendString:[tagDic objectForKey:@"name"]];
                    
                }else{
                    [tagStr appendString:[NSString stringWithFormat:@" | %@",[tagDic objectForKey:@"name"]]];
                }
            }
        }
    }
    self.jobTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, self.thirdView.frame.size.width - 15, 25)];
    self.jobTagLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.jobTagLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    self.jobTagLabel.text = [NSString stringWithFormat:@" 期望行业 : %@",tagStr];
    [self.thirdView addSubview:self.jobTagLabel];
    
    UILabel *forthLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 715, self.view.frame.size.width - 4 , 30)];
    forthLabel.backgroundColor = [UIColor whiteColor];
    forthLabel.text = @"   工作经历";
    forthLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    forthLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.mainScroll addSubview:forthLabel];
    
    UIView *workLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 715, 4, 30)];
    workLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.mainScroll addSubview:workLineView];
    
    
    [self rebuildUpView];
    
}
- (void)previewRS
{
    NSString *url = @"http://api.zzd.hidna.cn/v1/resume/preview";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    //测试字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:[self.mainDic objectForKey:@"id"] forKey:@"rsId"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?rsId=%@&sign=%@&timestamp=%@&uid=%@",url,[dic objectForKey:@"rsId" ],[dic objectForKey:@"sign"],[dic objectForKey:@"timestamp"],[dic objectForKey:@"uid"]]]];
//        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            
//        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (void)secondTap:(UITapGestureRecognizer *)tap
{
    EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
    editInforVC.delegate = self;
    editInforVC.mainDic = self.mainDic;
    NSInteger workState = [[self.mainDic objectForKey:@"work_state"]integerValue];
    
    NSString *workStr;
    switch (workState) {
        case 0:
            workStr = @"在职";
            break;
        case 1:
            workStr = @"离职";
            break;
        case 2:
            workStr = @"应届";
        default:
            break;
    }
    
    
    [editInforVC setArrValue:@[@[@"姓    名",@"name",[[self.mainDic objectForKey:@"user"]objectForKey:@"name"]],@[@"性    别",@"sex",[[self.mainDic objectForKey:@"user"]objectForKey:@"sex"]],@[@"最高学历",@"highest_edu",[[self.mainDic objectForKey:@"user"]objectForKey:@"highest_edu"]],@[@"工作年限",@"work_year",[self.mainDic objectForKey:@"work_year"]],@[@"求职状态",@"work_state",workStr]]];
    [self.navigationController pushViewController:editInforVC animated:YES];
    
}
- (void)rebuildUpView
{
    [self.mainUpView removeFromSuperview];
    self.currentHeight = 100;
    
    self.mainUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 745, self.view.frame.size.width, MAXFLOAT)];
    //    self.mainUpView.backgroundColor = [UIColor redColor];
    [self.mainScroll addSubview:self.mainUpView];
    
    
    id jobArr = [self.mainDic objectForKey:@"job"];
    
    if ([jobArr isKindOfClass:[NSArray class]]) {
        
        NSArray *jobArray = [self.mainDic objectForKey:@"job"];
        if (jobArray.count  == 0) {
            SelectAsBtnView *btnView = [[SelectAsBtnView alloc]initWithFrame:CGRectMake(15, self.currentHeight + 10, self.view.frame.size.width - 30, 105)];
            [btnView setText:@"添加工作经历" detail:@"请从最近一份工作填写" key:@"job"];
            btnView.state = @"work";
            [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workAndEduTap:)]];
            [self.mainUpView addSubview:btnView];
            self.currentHeight = self.currentHeight + 120;
        }else{

            for (int i = 0 ; i < jobArray.count; i++ ) {
                NSDictionary *jobDic = [jobArray objectAtIndex:i];
                WorkExperienceView *workView = [[WorkExperienceView alloc]initWithFrame:CGRectMake(0, self.currentHeight, self.view.frame.size.width , 95)];
                NSString *dateStr = [NSString stringWithFormat:@"%@ - %@",[jobDic objectForKey:@"work_start_date"],[jobDic objectForKey:@"work_end_date"]];
                NSString *detailStr = [NSString stringWithFormat:@"%@ · %@",[jobDic objectForKey:@"title"],[jobDic objectForKey:@"category"]];
                [workView setLabelText:dateStr title:[jobDic objectForKey:@"cp_name"] detail:detailStr count:i];
      
                workView.userInteractionEnabled = YES;
                workView.dic = jobDic;
                workView.state = @"work";
                [workView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workExTap:)]];
                [self.mainUpView addSubview:workView];
                
                if (i == 0) {
                    UIImageView *pencilIconOne = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25, self.currentHeight + 15, 15, 15)];
                    pencilIconOne.image = [UIImage imageNamed:@"bi.png"];
                    [self.mainUpView addSubview:pencilIconOne];
                }
                self.currentHeight = self.currentHeight + 95;
            }
        }
    }else{
        SelectAsBtnView *btnView = [[SelectAsBtnView alloc]initWithFrame:CGRectMake(15, self.currentHeight + 10, self.view.frame.size.width - 30, 105)];
        btnView.state = @"work";
        [btnView setText:@"添加工作经历" detail:@"请从最近一份工作填写" key:@"job"];
        [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workAndEduTap:)]];
        [self.mainUpView addSubview:btnView];
        self.currentHeight = self.currentHeight + 120;
    }
    
    self.eduExLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, self.currentHeight + 30, self.view.frame.size.width - 4, 30)];
    self.eduExLabel.text = @"   教育经历";
    self.eduExLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    self.eduExLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.eduExLabel.backgroundColor = [UIColor whiteColor];
    [self.mainUpView addSubview:self.eduExLabel];
    
    UIView *eduLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.currentHeight + 30, 4, 30)];
    eduLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.mainUpView addSubview:eduLineView];
    self.currentHeight = self.currentHeight + 60;
    
    
    id eduArr = [self.mainDic objectForKey:@"edu"];
    if ([eduArr isKindOfClass:[NSArray class]]) {
        NSArray *eduArray = [self.mainDic objectForKey:@"edu"];
        if (eduArray.count == 0) {
            SelectAsBtnView *btnView = [[SelectAsBtnView alloc]initWithFrame:CGRectMake(15, self.currentHeight + 10, self.view.frame.size.width - 30, 105)];
            btnView.state = @"edu";
            [btnView setText:@"添加教育经历" detail:@"请从最高学历填写" key:@"edu"];
            [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workAndEduTap:)]];
            [self.mainUpView addSubview:btnView];
            self.currentHeight = self.currentHeight + 120;
        }else{
 
            for (int i = 0 ; i < eduArray.count; i++ ) {
                NSDictionary *jobDic = [eduArray objectAtIndex:i];
                WorkExperienceView *eduView = [[WorkExperienceView alloc]initWithFrame:CGRectMake(0, self.currentHeight, self.view.frame.size.width, 95)];
                NSString *dateStr = [NSString stringWithFormat:@"%@ - %@",[jobDic objectForKey:@"edu_start_date"],[jobDic objectForKey:@"edu_end_date"]];
                NSString *detailStr = [NSString stringWithFormat:@"%@ · %@",[jobDic objectForKey:@"edu_experience"],[jobDic objectForKey:@"edu_major"]];
                [eduView setLabelText:dateStr title:[jobDic objectForKey:@"edu_school"] detail:detailStr count:i];
                [self.mainUpView addSubview:eduView];

                eduView.userInteractionEnabled = YES;
                eduView.dic = jobDic;
                eduView.state = @"edu";
                [eduView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workExTap:)]];
                if (i == 0) {
                    UIImageView *pencilIconOne = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25, self.currentHeight + 15, 15, 15)];
                    pencilIconOne.image = [UIImage imageNamed:@"bi.png"];
                    [self.mainUpView addSubview:pencilIconOne];
                }
                self.currentHeight = self.currentHeight + 95;
            }
        }
    }else{
        SelectAsBtnView *btnView = [[SelectAsBtnView alloc]initWithFrame:CGRectMake(15, self.currentHeight + 10, self.view.frame.size.width - 30, 105)];
        btnView.state = @"edu";
        [btnView setText:@"添加教育经历" detail:@"请从最高学历填写" key:@"edu"];
        [self.mainUpView addSubview:btnView];
        [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(workAndEduTap:)]];
        self.currentHeight = self.currentHeight + 120;
        
    }
    
    self.myAdvantageLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, self.currentHeight + 30, self.view.frame.size.width - 4, 30)];
    self.myAdvantageLabel.text = @"   我的优势";
    self.myAdvantageLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.myAdvantageLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    self.myAdvantageLabel.backgroundColor = [UIColor whiteColor];
    [self.mainUpView addSubview:self.myAdvantageLabel];
    
    UIView *advantageLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.currentHeight + 30, 4, 30)];
    advantageLineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.mainUpView addSubview:advantageLineView];
  
    
    self.currentHeight = self.currentHeight + 60;
    
    
    
    self.selfSummaryBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.selfSummaryBackView.backgroundColor = [UIColor whiteColor];
    [self.mainUpView addSubview:self.selfSummaryBackView];
    
    
    
    
    NSString *selfSummary = [self.mainDic objectForKey:@"self_summary"];
    self.selfSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 0)];
    self.selfSummaryLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.selfSummaryLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
    
    if (selfSummary == nil) {
        selfSummary = @"";
    }
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:selfSummary];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [selfSummary length])];
    [self.selfSummaryLabel setAttributedText:attributedString1];
    
    
    
//    self.selfSummaryLabel.text = selfSummary;
    self.selfSummaryLabel.numberOfLines = 0;
    self.selfSummaryLabel.userInteractionEnabled = YES;
    [self.selfSummaryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(summaryTap:)]];
    self.selfSummaryLabel.backgroundColor = [UIColor whiteColor];
    [self.mainUpView addSubview:self.selfSummaryLabel];
    CGSize selfSummarySize = CGSizeZero;
    if (selfSummary.length == 0) {
        [self.selfSummaryBackView removeFromSuperview];
        SelectAsBtnView *btnView = [[SelectAsBtnView alloc]initWithFrame:CGRectMake(15, self.currentHeight + 10, self.view.frame.size.width - 30, 105)];
        [btnView setText:@"添加自我评价" detail:@"展示真实的自己" key:@"self_summary"];
        [self.mainUpView addSubview:btnView];
        [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(summaryTap:)]];
        self.currentHeight = self.currentHeight + 120;
    }else{
        selfSummarySize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 50 label:self.selfSummaryLabel];
        self.selfSummaryLabel.frame = CGRectMake(20, self.currentHeight + 10, self.view.frame.size.width - 40 , selfSummarySize.height + 60);
        self.selfSummaryBackView.frame = CGRectMake(0, self.currentHeight, self.view.frame.size.width , selfSummarySize.height + 80);
        UIImageView *pencilIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25,  self.currentHeight   - 20, 15, 15)];
        pencilIcon.userInteractionEnabled = YES;
        [pencilIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(summaryTap:)]];
        pencilIcon.image = [UIImage imageNamed:@"bi.png"];
        [self.mainUpView addSubview:pencilIcon];
    }
    
    
    
    self.mainScroll.contentSize = CGSizeMake(0, self.currentHeight + selfSummarySize.height + 150 + 720);
    self.mainUpView.frame = CGRectMake(0, 645, self.view.frame.size.width, self.currentHeight + selfSummarySize.height + 150);
}
- (void)firstTap:(UITapGestureRecognizer *)tap
{
    [self doSomeThing];
}
- (void)workAndEduTap:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[SelectAsBtnView class]]) {
        SelectAsBtnView *workExView = (SelectAsBtnView *)tap.view;
        EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
        editInforVC.delegate = self;
        editInforVC.key = workExView.state;
//        NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
//        editInforVC.keyId = [dic objectForKey:@"id"];
        if ([workExView.state isEqualToString:@"work"]) {
            [ editInforVC setArrValue:@[@[@"开始时间",@"work_start_date",@""],@[@"结束时间",@"work_end_date",@""],@[@"职位类型",@"category",@""],@[@"公司名称",@"cp_name",@""]] ] ;
        }else if([workExView.state isEqualToString:@"edu"]){
            [ editInforVC setArrValue:@[@[@"开始时间",@"edu_start_date",@""],@[@"结束时间",@"edu_end_date",@""],@[@"学    校",@"edu_school",@""],@[@"专    业",@"edu_major",@""],@[@"学    历",@"edu_experience",@""]]] ;
        }
        [self.navigationController pushViewController:editInforVC animated:YES];
    }
}
- (void)updateEduAndWorkDic:(NSDictionary *)dic keyId:(NSString *)keyId key:(NSString *)key
{
    [self saveEduAndWorkDic:[dic mutableCopy] keyId:keyId key:key self:self];
}
- (void)workExTap:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[WorkExperienceView class]]) {
        WorkExperienceView *workExView = (WorkExperienceView *)tap.view;
        NSArray *arr = @[];
        if ([workExView.state isEqualToString:@"work"]) {
            arr = [self.mainDic objectForKey:@"job"];
        }else if([workExView.state isEqualToString:@"edu"]){
            arr = [self.mainDic objectForKey:@"edu"];
        }
        
//        EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
//        editInforVC.delegate = self;
//        NSDictionary *dic = workExView.dic;
//        if ([workExView.state isEqualToString:@"work"]) {
//            [ editInforVC setArrValue:@[@[@"职位类型",@"category",[dic objectForKey:@"category"]],@[@"公司名称",@"cp_name",[dic objectForKey:@"cp_name"]],@[@"开始时间",@"work_start_date",[dic objectForKey:@"work_start_date"]],@[@"结束时间",@"work_end_date",[dic objectForKey:@"work_end_date"]]]] ;
//        }else if([workExView.state isEqualToString:@"edu"]){
//            [ editInforVC setArrValue:@[@[@"学    校",@"edu_school",[dic objectForKey:@"edu_school"]],@[@"专    业",@"edu_major",[dic objectForKey:@"edu_major"]],@[@"学    历",@"edu_experience",[dic objectForKey:@"edu_experience"]],@[@"开始时间",@"edu_start_date",[dic objectForKey:@"edu_start_date"]],@[@"结束时间",@"edu_end_date",[dic objectForKey:@"edu_end_date"]]]] ;
//        }
//        [self.navigationController pushViewController:editInforVC animated:YES];
//    }
    WorkAndEduListController *workListVC = [[WorkAndEduListController alloc]init];
        [workListVC setListArrWithArr:arr state:workExView.state];
        workListVC.delegate = self;
        [self.navigationController pushViewController:workListVC animated:YES];
    }
    
}
- (void)summaryTap:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[SelectAsBtnView class]]) {
        JobRequireViewController *jobRequire = [[JobRequireViewController alloc]init];
        jobRequire.word = @"你的优势";
        jobRequire.currentStr = @"";
        jobRequire.delegate = self;
        [self.navigationController pushViewController:jobRequire animated:YES];
    }else if([tap.view isKindOfClass:[UILabel class]])
    {
        
    
    UILabel *label = (UILabel *)tap.view;
    JobRequireViewController *jobRequire = [[JobRequireViewController alloc]init];
    jobRequire.word = @"你的优势";
    jobRequire.currentStr = label.text;
    jobRequire.delegate = self;
    [self.navigationController pushViewController:jobRequire animated:YES];
    }else if ([tap.view isKindOfClass:[UIImageView class]])
    {
        UILabel *label = (UILabel *)tap.view;
        JobRequireViewController *jobRequire = [[JobRequireViewController alloc]init];
        jobRequire.word = @"你的优势";
        jobRequire.currentStr = self.selfSummaryLabel.attributedText.string;
        jobRequire.delegate = self;
        [self.navigationController pushViewController:jobRequire animated:YES];
    }
}
- (void)getChangedText:(NSString *)str
{
    [self.mainDic setObject:str forKey:@"self_summary"];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [self.selfSummaryLabel setAttributedText:attributedString1];
    self.selfSummaryLabel.attributedText = attributedString1;
    [self updateDic:@{}];
    [self rebuildUpView];
}
- (void)doSomeThing
{
    
    
       self.backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
        
        self.styleSelectView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    }];
}
- (void)createAlertView
{
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMain)];
    [self.backView addGestureRecognizer:backTap];
    [self.view addSubview:self.backView];
    
    
    
    self.alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
//    self.alertView.layer.borderWidth = 0.5;
    self.alertView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self.view addSubview:self.alertView];
    
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 150, self.view.frame.size.width - 30, 40)];
    [backButton addTarget:self action:@selector(backToWindow) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor colorFromHexCode:@"eeeeee"].CGColor;
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [backButton setTitleColor:[UIColor colorFromHexCode:@"666666"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor whiteColor];
    [self.alertView addSubview:backButton];
    
    self.styleSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    //    self.styleSelectView.backgroundColor = [UIColor clearColor];
    [self.alertView addSubview:self.styleSelectView];
    //标题名的数组
    NSArray *titleArr = @[@"拍摄照片",@"相册照片"];
    for (int i = 0; i < 2; i++) {
//        UIImageView *styleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 5 * (2 * i + 1) , 30, self.view.frame.size.width / 5, self.view.frame.size.width / 5)];
//        styleImage.tag = i + 1;
//        styleImage.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectStyle:)];
//        [styleImage addGestureRecognizer:tapImage];
//        styleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico-%d.png",19 + i]];
//        //        styleImage.backgroundColor = [UIColor blackColor];
//        [self.styleSelectView addSubview:styleImage];
        
        
        UILabel *styleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 ,25 + i * 43, self.view.frame.size.width  - 30, 40)];
        styleNameLabel.text = [titleArr objectAtIndex:i];
        styleNameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        styleNameLabel.tag = i + 1;
        styleNameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectStyle:)];
                [styleNameLabel addGestureRecognizer:tapImage];
        styleNameLabel.textAlignment = 1;
        styleNameLabel.backgroundColor = [UIColor whiteColor];
        styleNameLabel.textColor = [UIColor colorFromHexCode:@"666666"];
        styleNameLabel.layer.borderColor = [UIColor colorFromHexCode:@"eeeeee"].CGColor;
        styleNameLabel.layer.borderWidth = 1;
        [self.styleSelectView addSubview:styleNameLabel];
    }
    
    

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * photoImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    

    [self uploadHeaderImage:photoImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self backToWindow];
}
- (void)backToWindow
{
    
    self.currentView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 160);
    self.backView.frame = CGRectZero;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alertView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
    }];
}
- (void)uploadHeaderImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSString *imagePath = [NSString stringWithFormat:@"%@/image.png",documentPath];
    [[NSFileManager defaultManager]createFileAtPath:imagePath contents:imageData attributes:nil];
    
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/image/upload";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    //测试字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            //         上传filename
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //         设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSURL *url = [NSURL fileURLWithPath:imagePath isDirectory:YES];
            [formData appendPartWithFileURL:url name:@"body" fileName:fileName mimeType:@"image/png" error:nil];
            
            
            
            
            
            
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
             
                [self.mainDic setObject:url forKey:@"avatar"];

                [self updateDic:nil];
                [self.headerImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"v2.png"]];
                self.headerImg.layer.masksToBounds = YES;
                self.headerImg.layer.cornerRadius = self.headerImg.frame.size.width / 2;
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
//                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
//                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
//                        [self log];
//                    }];
//                } else
//                {
//                    [self log];
//                }
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
           
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
    
    
    
}
- (void)tapSelectStyle:(UITapGestureRecognizer *)sender
{
    
    UIImageView *image = (UIImageView *)sender.view;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    switch (image.tag) {
        case 1:
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 2:
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];//进入相册
            break;
        default:
            break;
    }
}
- (void)backToMain
{
    [self backToWindow];
}
- (void)thirdTap:(UITapGestureRecognizer *)tap
{
    
    EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
    editInforVC.delegate = self;
    editInforVC.state = @"1";
    [editInforVC setArrValue:@[@[@"工作职位",@"title",[self.mainDic objectForKey:@"title"]],@[@"工作城市",@"city",[self.mainDic objectForKey:@"city"]],@[@"工作待遇",@"salary",[self.mainDic objectForKey:@"salary"]],@[@"期望行业",@"tag_user",[self.mainDic objectForKey:@"tag_user"]]]];
    [self.navigationController pushViewController:editInforVC animated:YES];
    
}
- (void)updateDic:(NSDictionary *)dic
{
   
    [self.mainDic setValuesForKeysWithDictionary:dic];
//    user =     {
//        avatar = "http://7xnj9p.com1.z0.glb.clouddn.com/6_4f4a217ecbed02336038.png";
//        "highest_edu" = "\U7855\U58eb";
//        "im_id" = 56556f7c60b2c00ce43e02b9;
//        name = "\U90ed\U4fca\U680b";
//        sex = "\U7537";
//        title = "\U804c\U4f4d";
//    };
    NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] mutableCopy];

   
    [self resetEveryThing];
    if ([self.mainDic objectForKey:@"avatar"]) {
        [userDic setObject:[self.mainDic objectForKey:@"avatar"] forKey:@"avatar"];
    }
    if ([self.mainDic objectForKey:@"name"]) {
         [userDic setObject:[self.mainDic objectForKey:@"name"] forKey:@"name"];
    }
    if ([self.mainDic objectForKey:@"title"]) {
         [userDic setObject:[self.mainDic objectForKey:@"title"] forKey:@"title"];
    }
    if ([self.mainDic objectForKey:@"sex"]) {
         [userDic setObject:[self.mainDic objectForKey:@"sex"] forKey:@"sex"];
    }
    if ([self.mainDic objectForKey:@"highest_edu"]) {
        [userDic setObject:[self.mainDic objectForKey:@"highest_edu"] forKey:@"highest_edu"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //用户信息
    NSString *url = @"http://api.zzd.hidna.cn/v1/user";
    [manager GET:TIMESTAMP parameters:nil success:^ (AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
        [userDic setObject:time forKey:@"timestamp"];
        [userDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [userDic setObject:@"1" forKey:@"is_fill_user"];
        
        
        if ([[self.mainDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
            
            NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            [userDic setObject:jsonString1 forKey:@"tag_user"];
        }else{
            
            
            
        }
        
        
        
        if ([[self.mainDic objectForKey:@"tag_boss"]isKindOfClass:[NSArray class]]){
            
            NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_boss"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            [userDic setObject:jsonString1 forKey:@"tag_boss"];
        }else{
            
            
        }
        
        [manager POST:url parameters:userDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSString *str = [responseObject objectForKey:@"ret"];
            if ([str isEqualToString:@"0"]) {

                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:(NSDictionary *)userDic forKey:@"user"];
                
                if (dic.allKeys.count == 0) {
                    
                }else{
                [self.navigationController popViewControllerAnimated:YES];
                }
                [self.mainDic setValuesForKeysWithDictionary:dic];
                NSString *urlRS = @"";
                
                //简历上传
                if ([[dic objectForKey:@"resume_id"] isEqualToString: @"0"]) {
                    urlRS = @"http://api.zzd.hidna.cn/v1/rs";
                }else
                {
                    urlRS = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",[userDic objectForKey:@"resume_id"]];
                }
                [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                    NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",urlRS,[userDic objectForKey:@"token"],time];
                    [self.mainDic setObject:time forKey:@"timestamp"];
                    [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                    [self.mainDic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
                    
                    if ([self.mainDic objectForKey:@"tag_user"]!= nil){
                        if ([[self.mainDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
                            NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
                            NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                            [self.mainDic setObject:jsonString1 forKey:@"tag_user"];
                            
                        }else{
                            [self.mainDic setObject:[self.mainDic objectForKey:@"tag_user"] forKey:@"tag_user"];
                        }
                    }
                    [manager POST:urlRS  parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                          
                            if ([self.mainDic objectForKey:@"tag_user"]!= nil) {
                                
                                
//                                NSMutableDictionary *dic  =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]mutableCopy];
                                [userDic setObject:[self.mainDic objectForKey:@"tag_user"] forKey:@"tag_user"];
                                [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:@"user"];
                                
                            }
                            
                            
                            if ([[dic objectForKey:@"resume_id"] isEqualToString: @"0"]) {

                                [userDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"] forKey:@"resume_id"];
                                [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:@"user"];
                            }
                            [self.mainDic setObject:userDic forKey:@"user"];
                            [self resetEveryThing];
                            [self.mainDic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id" ] forKey:@"id"];
                            [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"rs"];
                                                    }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                        {
                                                    }
                    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                        
                    }];
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];

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
//                }else{
//                    [self log];
//                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)setTagArr:(NSArray *)arr
{
    
    [self.mainDic setObject:arr forKey:@"tag_user"];
}

- (void)createNewTap:(UITapGestureRecognizer *)tap
{
    
}
- (void)deleteFromKeyId:(NSString *)keyId key:(NSString *)key
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([key isEqualToString:@"job"]) {
        arr = [[self.mainDic objectForKey:@"job"]mutableCopy];
    }else if([key isEqualToString:@"edu"]){
        arr = [[self.mainDic objectForKey:@"edu"]mutableCopy];
    }

    NSMutableArray *otherArr = [NSMutableArray arrayWithArray:arr];
    for (NSDictionary *workDic in arr) {
        if ([[workDic objectForKey:@"id"]isEqualToString:keyId]) {
            [otherArr removeObject:workDic];
            [self.mainDic setObject:otherArr forKey:key];
            [[NSUserDefaults standardUserDefaults]setObject:self.mainDic forKey:@"rs"];
            [self.navigationController popToViewController:self animated:YES];
            [self rebuildUpView];
        }
        
    }
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
            WorkAndEduListController *workVC = selfVC;
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
            [self.mainUpView removeFromSuperview];
            [self rebuildUpView];
            
            [workVC.navigationController popToViewController:self animated:YES];
            
            
                
                   } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    
}
- (void)saveEduAndWorkDic:(NSDictionary *)dic
{
    //save origin
}
- (void)resetEveryThing
{
    [self.headerImg sd_setImageWithURL:[[self.mainDic objectForKey:@"user"]objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"v2.png"]];
     self.userNameLabel.text = [NSString stringWithFormat:@" 姓        名 : %@",[[self.mainDic objectForKey:@"user"]objectForKey:@"name"]];
     self.userSexLabel.text = [NSString stringWithFormat:@" 性        别 : %@",[[self.mainDic objectForKey:@"user"]objectForKey:@"sex"]];
     self.highestEduLabel.text = [NSString stringWithFormat:@" 最高学历 : %@",[[self.mainDic objectForKey:@"user"]objectForKey:@"highest_edu"]];

     self.workYearLabel.text = [NSString stringWithFormat:@" 工作年限 : %@",[self.mainDic objectForKey:@"work_year"]];
        NSInteger workState = [[self.mainDic objectForKey:@"work_state"]integerValue];
    
    NSString *workStr;
    switch (workState) {
        case 0:
            workStr = @"在职";
            break;
        case 1:
            workStr = @"离职";
            break;
        case 2:
            workStr = @"应届";
        default:
            break;
    }
     self.workStateLabel.text = [NSString stringWithFormat:@" 求职状态 : %@",workStr];
    self.titleLabel.text = [NSString stringWithFormat:@" %@",[self.mainDic objectForKey:@"title"]];

    self.cityPriceLabel.text = [NSString stringWithFormat:@" %@ | %@",[self.mainDic objectForKey:@"city"],[self.mainDic objectForKey:@"salary"]];

}
- (void)deleteDic:(NSString *)keyId key:(NSString *)key
{
    [self deleteFromKeyId:keyId key:key];
}

- (void)deleteDicc:(NSString *)keyId key:(NSString *)key
{
    [self deleteFromKeyId:keyId key:key];
}
@end
