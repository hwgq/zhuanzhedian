//
//  GoodCompanyDetailViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 17/1/14.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "GoodCompanyDetailViewController.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "UILableFitText.h"
#import "NewZZDBossCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "JobDetailViewController.h"
#import "GoodCompanyJobsViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "WXApi.h"
#import "AppDelegate.h"
#import <UMMobClick/MobClick.h>
@interface GoodCompanyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)UIScrollView *headerScroll;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UIImageView *companyImg;
@property (nonatomic, strong)UILabel *companyTitle;
@property (nonatomic, strong)UILabel *companyDetail;

@property (nonatomic, strong)UIScrollView *detailScroll;
@property (nonatomic, strong)UIButton *infoBtn;
@property (nonatomic, strong)UIButton *listBtn;
@property (nonatomic, strong)UIView *personView;
@property (nonatomic, strong)UIView *selectView;
@property (nonatomic, strong)UITableView *jobListTable;

@property (nonatomic, strong)NSArray *imageArr;
@property (nonatomic, strong)NSMutableArray *jobArr;
@property (nonatomic, strong)NSArray *membersArr;

@property (nonatomic, strong)UIView *guideView;
@end


@implementation GoodCompanyDetailViewController
{
    enum WXScene _scene; //请求发送场景
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self infoAction];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.jobArr = [NSMutableArray array];
    
    
    [AVAnalytics beginLogPageView:@"GoodCompany"];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    [self.view addSubview:self.mainScroll];
    
    
    [self createSubViews];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(18, 18, 29, 29)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    backView.layer.cornerRadius = 14.5;
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8, 16, 13)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    backImageView.userInteractionEnabled = YES;
    
    [backView addSubview:backImageView];
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 47, 18, 29, 29)];
    backView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    backView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    backView1.layer.cornerRadius = 14.5;
    [backView1 addGestureRecognizer:tap1];
    [self.view addSubview:backView1];
    
    
    
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 21, 20)];
    shareImage.image = [UIImage imageNamed:@"112分享.png"];
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharedAction:)];
    shareImage.userInteractionEnabled = YES;
    
    [shareImage addGestureRecognizer:shareTap];
    [backView1 addSubview:shareImage];
    
    [self getAllJob];
    
    if (self.isSelf == YES) {
        
        [self guideUser];
    }
}
- (void)guideUser
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userGuide1"]) {
        self.guideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.guideView.backgroundColor = [UIColor clearColor];
        [self.guideView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGuide)]];
        
        
        
        CGRect rect = self.view.bounds;
        
        CGRect holeRection = CGRectMake(self.view.frame.size.width - 50, 15, 35, 35);
        
        
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
        handImage.image = [UIImage imageNamed:@"shareUser.png"];
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
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userGuide1"];
}
#pragma mark -- 分享按钮
- (void)sharedAction:(UITapGestureRecognizer *)tap{
    
    // 解决循环引用
    //    __weak typeof(id) ws = self;
    //
    //    UIActionSheet *acSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈", nil];
    //    acSheet.tag =2;
    //    acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //    [acSheet showInView:[[UIApplication sharedApplication]keyWindow]];
    
    NSString *str =[NSString stringWithFormat: @"%@share/prise?priseId=%@", SHARE_URL, [self.mainDic objectForKey:@"id"]];
    //        // 设置标题
    NSString * title = [self.mainDic objectForKey:@"title"];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSArray* imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.mainDic objectForKey:@"icon"]]]]];
        
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\n求自荐、求转发",[self.mainDic objectForKey:@"address"]]
                                             images:imageArray
                                                url:[NSURL URLWithString:str]
                                              title:title
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

- (void)getAllJob
{
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"http://api.zzd.hidna.cn/v1/jd/getJdsFromUser/new";
    
    NSArray *jobsArr = [self.mainDic objectForKey:@"users"];

    for (int i = 0; i <jobsArr.count ; i++) {
        
    

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:[jobsArr objectAtIndex:i] forKey:@"userId"];
        
        
        
        [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
        
        
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [parameters setObject:time forKey:@"timestamp"];
            
            [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                    [self.jobArr addObjectsFromArray:[(NSDictionary *)responseObject objectForKey:@"data"]];
                    
                    [self.jobListTable reloadData];
                    
                    
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];

            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];

        
        
        
    }
}
- (void)createSubViews
{
    self.imageArr = [self.mainDic objectForKey:@"pics"];
    
    self.headerScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.headerScroll.contentSize = CGSizeMake(self.view.frame.size.width * self.imageArr.count, 200);
    self.headerScroll.tag = 5;
    self.headerScroll.delegate = self;
    self.headerScroll.pagingEnabled = YES;
    self.headerScroll.bounces = NO;
    for (int i = 0; i < self.imageArr.count; i++) {
        UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, 200)];
//        headerImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d%d.jpg",i+1,i+1,i+1,i+1]];
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[self.imageArr objectAtIndex:i]]placeholderImage:[UIImage imageNamed:@"banner1750.png"]];
        [self.headerScroll addSubview:headerImg];
    }
    [self.mainScroll addSubview:self.headerScroll];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, 175, 80, 20)];
    self.pageControl.numberOfPages = self.imageArr.count;
    [self.mainScroll addSubview:self.pageControl];
    
    self.companyImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 215, 60, 60)];
//    self.companyImg.image = [UIImage imageNamed:@"xxccvv.jpg"];
    [self.companyImg sd_setImageWithURL:[NSURL URLWithString:[self.mainDic objectForKey:@"icon"]]placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    self.companyImg.layer.cornerRadius = 8;
    self.companyImg.layer.masksToBounds = YES;
    self.companyImg.layer.borderWidth = 1;
    self.companyImg.layer.borderColor = [UIColor colorFromHexCode:@"#bbb"].CGColor;
    [self.mainScroll addSubview:self.companyImg];
    
    
    self.companyTitle = [[UILabel alloc]initWithFrame:CGRectMake(85, 215, self.view.frame.size.width - 90, 30)];
    self.companyTitle.text = [self.mainDic objectForKey:@"title"];
    self.companyTitle.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.companyTitle.textColor = [UIColor colorFromHexCode:@""];
    [self.mainScroll addSubview:self.companyTitle];
    
    self.companyDetail = [[UILabel alloc]initWithFrame:CGRectMake(85, 250, self.view.frame.size.width - 90, 20)];
    self.companyDetail.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.mainDic objectForKey:@"companyType"],[self.mainDic objectForKey:@"companyMoney"],[self.mainDic objectForKey:@"companySize"]];
    self.companyDetail.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.companyDetail.textColor = [UIColor colorFromHexCode:@"#666"];
    [self.mainScroll addSubview:self.companyDetail];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 284, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#eee"];
    [self.mainScroll addSubview:lineView];
    
    
    
    self.infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 285, self.view.frame.size.width / 2, 40)];
    [self.infoBtn setTitle:@"公司概况" forState:UIControlStateNormal];
    [self.infoBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.infoBtn setTitleColor:[UIColor colorFromHexCode:@"#333"] forState:UIControlStateNormal];
    self.infoBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.mainScroll addSubview:self.infoBtn];
    
    self.listBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 285, self.view.frame.size.width / 2, 40)];
    [self.listBtn setTitle:@"热招职位" forState:UIControlStateNormal];
    [self.listBtn addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    [self.listBtn setTitleColor:[UIColor colorFromHexCode:@"#333"] forState:UIControlStateNormal];
    self.listBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    [self.mainScroll addSubview:self.listBtn];
    
    self.detailScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 325, self.view.frame.size.width, self.view.frame.size.height - 325 + 20)];
    self.detailScroll.backgroundColor = [UIColor colorFromHexCode:@"eee"];
    self.detailScroll.tag = 7;
    self.detailScroll.delegate = self;
//    self.detailScroll.pagingEnabled = YES;
    self.detailScroll.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.width - 325 + 20);
    [self.mainScroll addSubview:self.detailScroll];
    
    [self createDetailScrollSubviews];

    self.selectView = [[UIView alloc]initWithFrame:CGRectMake(30, 322, self.view.frame.size.width / 2 - 60, 3)];
    self.selectView.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    [self.mainScroll addSubview:self.selectView];
    
    self.jobListTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 325 ) style:UITableViewStylePlain];
    self.jobListTable.delegate = self;
    self.jobListTable.dataSource = self;
    self.jobListTable.rowHeight = 125;
    self.jobListTable.tag = 117;
    self.jobListTable.bounces = NO;
    self.jobListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.detailScroll addSubview:self.jobListTable];
    self.detailScroll.alwaysBounceHorizontal = NO;
    
}
- (void)listAction
{
    self.detailScroll.scrollEnabled = NO;
  
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(30 + self.view.frame.size.width / 2, 322, self.view.frame.size.width / 2 - 60, 3);
    }];
    [self.detailScroll setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    
}
- (void)infoAction
{
    self.detailScroll.scrollEnabled = YES;
    [UIView animateWithDuration:0.4 animations:^{
        self.selectView.frame = CGRectMake(30, 322, self.view.frame.size.width / 2 - 60, 3);
    }];
    [self.detailScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)createDetailScrollSubviews
{
    NSString *introStr = [self.mainDic objectForKey:@"intro"];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, self.view.frame.size.width - 30, 0)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.detailScroll addSubview:backView];
    UITextView *introLabel = [[UITextView alloc]initWithFrame:CGRectZero];
//    introLabel.numberOfLines = 0;
    introLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    introLabel.editable = NO;
    introLabel.selectable = NO;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.paragraphSpacing = 10;  //段落高度
    paragraphStyle.lineSpacing = 10;   //行高
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName: [[FontTool customFontArrayWithSize:14]objectAtIndex:1]};
    
    //设置值
    
    //创建富文本
    NSAttributedString *atStr  = [[NSAttributedString alloc]initWithString:introStr attributes:attributes];
    introLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    introLabel.attributedText = atStr;
    introLabel.textColor = [UIColor colorFromHexCode:@"#666"];
    [backView addSubview:introLabel];
    
//    introLabel.text = introStr;
    CGFloat introS = [UILableFitText getSpaceLabelHeightwithSpeace:10 withFont:[[FontTool customFontArrayWithSize:14]objectAtIndex:1] withWidth:self.view.frame.size.width - 50 string:introStr];
//    CGSize introSize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 50 label:introLabel];
    introLabel.frame = CGRectMake(10, 10, self.view.frame.size.width - 50, introS);
//    introSize = CGSizeMake(self.view.frame.size.width - 50, introS);
//    introLabel.frame = CGRectMake(10, 10, self.view.frame.size.width - 50, introS);
    backView.frame = CGRectMake(15, 15, self.view.frame.size.width - 30, introS + 20 );
    introLabel.scrollEnabled = NO;
    
  
    
    
    
    self.personView = [[UIView alloc]initWithFrame:CGRectMake(15, 50 + introS, self.view.frame.size.width - 30, 100)];
    UILabel *jobTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    jobTitleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    jobTitleLabel.text = @"高管介绍";
    [self.personView addSubview:jobTitleLabel];
    self.personView.backgroundColor = [UIColor whiteColor];
    
    self.membersArr = [self.mainDic objectForKey:@"members"];
    for (int i = 0; i < self.membersArr.count; i++) {
        NSDictionary *memberDic = [self.membersArr objectAtIndex:i];
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 30 + i * 70, self.view.frame.size.width - 30, 70)];
        sectionView.userInteractionEnabled = YES;
        UIImageView *personHeader = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [personHeader sd_setImageWithURL:[NSURL URLWithString:[memberDic objectForKey:@"header"]]placeholderImage:[UIImage imageNamed:@"head1200.png"]];
        sectionView.tag = 200 + i;
        personHeader.userInteractionEnabled = YES;
        if (![self.state isEqualToString:@"hide"]) {
            
        
        [sectionView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)]];
        }
        [sectionView addSubview:personHeader];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, self.view.frame.size.width - 90, 25)];
        nameLabel.text = [memberDic objectForKey:@"name"];
        nameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        [sectionView addSubview:nameLabel];
        
        UILabel *jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, self.view.frame.size.width - 90, 20)];
        jobLabel.text = [memberDic objectForKey:@"job"];
        jobLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        jobLabel.textColor = [UIColor colorFromHexCode:@"#333"];
        [sectionView addSubview:jobLabel];
        
        
        UILabel *cheatLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 105, 13, 65, 24)];
        cheatLabel.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        cheatLabel.text = @"进行沟通";
        cheatLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
        cheatLabel.textColor = [UIColor whiteColor];
        cheatLabel.textAlignment = 1;
        cheatLabel.layer.cornerRadius = 7;
        cheatLabel.layer.masksToBounds = YES; 
        [sectionView addSubview:cheatLabel];
        [self.personView addSubview:sectionView];
    }
    
    self.personView.frame = CGRectMake(15, 50 + introS, self.view.frame.size.width - 30, 100 + (self.membersArr.count - 1) * 70);
    [self.detailScroll addSubview:self.personView];
    self.detailScroll.contentSize = CGSizeMake(self.view.frame.size.width,50 + introS  + 150 + (self.membersArr.count - 1) * 70 );
    
}
- (void)headerTap:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSDictionary *dic = [self.membersArr objectAtIndex:(imageView.tag - 200)];
    if ([dic objectForKey:@"id"] == nil) {
        
    }else{
        GoodCompanyJobsViewController *jobsVC = [[GoodCompanyJobsViewController alloc]init];
        jobsVC.jobId = [dic objectForKey:@"id"];
        [self.navigationController pushViewController:jobsVC animated:YES];
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 117) {
        return  self.jobArr.count;
    }else{
        return 0;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    NewZZDBossCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NewZZDBossCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    [cell setSubViewTextFromDic:[self.jobArr objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 5) {
        self.pageControl.currentPage = scrollView.contentOffset.x / self.view.frame.size.width ;
    }
    if (scrollView.tag == 7) {
        NSLog(@"%lf------%lf",scrollView.contentOffset.x,scrollView.contentOffset.y);
    }
//    if (scrollView.tag == 7) {
//        if ((scrollView.contentOffset.x / self.view.frame.size.width) == 0) {
//            [UIView animateWithDuration:0.4 animations:^{
//                self.selectView.frame = CGRectMake(30, 322, self.view.frame.size.width / 2 - 60, 3);
//            }];
//            [self.detailScroll setContentOffset:CGPointMake(0, 0) animated:YES];
//        }else if ((scrollView.contentOffset.x / self.view.frame.size.width) == 1)
//        {
//            [UIView animateWithDuration:0.4 animations:^{
//                self.selectView.frame = CGRectMake(30 + self.view.frame.size.width / 2, 322, self.view.frame.size.width / 2 - 60, 3);
//            }];
//            [self.detailScroll setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
//        }
//    }
//    
}
- (void)goToLastPage
{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.state isEqualToString:@"hide"]) {
        
    }else{
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
    
    jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.jobArr objectAtIndex:indexPath.row]];
    self.navigationController.navigationBar.hidden = NO;
    jobDetail.hidesBottomBarWhenPushed = YES;
//    if ([self judgeWhatILike:indexPath]) {
//        
//        jobDetail.collectType = @"YES";
    
//    }else{
        
        jobDetail.collectType = @"NO";
        
//    }
    
    [self.navigationController pushViewController:jobDetail animated:YES];
    }
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
