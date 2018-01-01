//
//  JobDetailViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobDetailViewController.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
#import "CreateNewJobViewController.h"
#import "AFNetworking.h"
#import "CheatViewController.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "MBProgressHUD.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "WXApi.h" // 微信分享
#import "MyCAShapeLayer.h"
#import "UILableFitText.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZZDAlertView.h"
#import "CompanyDetailViewController.h"
#import "NewCompanyDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "MapShowViewController.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
#import "JobHelperViewController.h"
@interface JobDetailViewController ()<changeMainViewDelegate,MBProgressHUDDelegate, WXApiDelegate>

@property (nonatomic, strong)UIScrollView *mainScroll;

// 上面有个收藏按钮
@property (nonatomic, strong)UIButton *collectButton;

//first
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UILabel *headerLabel;
@property (nonatomic, strong)UIView *firstView;

//second
@property (nonatomic, strong)UILabel *tapLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *categoryLabel;
@property (nonatomic, strong)UILabel *salaryLabel;
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UIImageView *cityImage;
@property (nonatomic, strong)UIImageView *yearImage;
@property (nonatomic, strong)UILabel *yearLabel;
@property (nonatomic, strong)UIImageView *educationImage;
@property (nonatomic, strong)UILabel *educationLabel;
@property (nonatomic, strong)UILabel *tagArrLabel;
@property (nonatomic, strong)UILabel *companyNameLabel;

//third
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIView *thirdView;
@property (nonatomic, strong)UIView *lineView;


//forth
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *sizeLabel;
@property (nonatomic, strong)UILabel *subNameLabel;
@property (nonatomic, strong)UILabel *intrLabel;
@property (nonatomic, strong)UIView *forthView;
@property (nonatomic, strong)UIButton *showIntrButton;
@property(nonatomic, strong)NSArray *tagArr;
@property (nonatomic, strong)CAShapeLayer *layerOne;
@property (nonatomic, strong)CAShapeLayer *layerTwo;
@property (nonatomic, strong)CAShapeLayer *layerThree;

@property (nonatomic, strong)UIImageView *nameImage;
@property (nonatomic, strong)UIImageView *sizeImage;
@property (nonatomic, strong)UIImageView *subNameImage;
@property (nonatomic, strong)UILabel *distanceLabel;

@property (nonatomic, strong)UIView *fifthView;



@property (nonatomic, assign)CGFloat length;
@property (nonatomic, assign)CGFloat intrlLength;
@property (nonatomic, strong)UIButton *showAllButton;


@property (nonatomic, strong)NSString *buttonType;
@property (nonatomic, strong)MBProgressHUD *hud;

@property (nonatomic, strong) NSString *pinStr; // 拼接分享网址
@property (nonatomic, strong)UIImageView *collectImg;
// 设置微信分享弹出的view
@property (nonatomic, strong)UIView *wxShareView;

@property (nonatomic, strong)UIButton *connectButton;

@end

@implementation JobDetailViewController
{
    enum WXScene _scene; //请求发送场景
}

#pragma mark -------- 1
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dic = [NSMutableDictionary dictionary];
        _scene = WXSceneTimeline;
        
    }
    return self;
}

#pragma mark -------- 2
- (instancetype)initWithButton:(NSString *)buttonType
{
    self = [super init];
    if (self) {
        self.buttonType = buttonType;
    }
    return self;
}

#pragma mark --------- 3
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    //    self.navigationController.navigationBar.translucent = NO;
    
    /*
     // 微信分享的view
     self.wxShareView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 64)];
     [self.view addSubview:self.wxShareView];
     */
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width,650);
    self.mainScroll.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    self.mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScroll];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 标题
    self.title = [self.dic objectForKey:@"title"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    

    
    // 右边的分享按钮
    
//    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20, 0, 20, 20)];
//    rightImage.image = [UIImage imageNamed:@"icon_y.png"];
//    
//    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharedAction:)];
//    [rightImage addGestureRecognizer:rightTap];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightImage];
//
    
    
    UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 20)];
    shareImage.image = [UIImage imageNamed:@"fenxiang copy.png"];
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharedAction:)];
    shareImage.userInteractionEnabled = YES;
    [shareImage addGestureRecognizer:shareTap];
    
    
    // 右边的分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareImage];
    
    
    
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_y.png"] style:UIBarButtonItemStyleDone target:self action:@selector(sharedAction:)];
    
    
    [self createSecondView];
    [self createThirdView];
//    [self createForthView];
    [self createFifthView];
    [self setSecondValue];
    [self setThirdViewValue];
//    [self setForthViewValue];
    [self setFifthViewValue];
    [self createFirstView];
    [self setFirstViewValue];
    if ([self.buttonType isEqualToString:@"1"]) {
        [self createOtherBottonButton];
    }else if([self.buttonType isEqualToString:@"108"]){
        [self createOtherBottonButton];
    }else if([self.buttonType isEqualToString:@"123"]){
        
    }else{
        [self createBottomButton];
        
    }
//    [self showAll];
    if ([[self.dic objectForKey:@"state"]isEqualToString:@"0"]) {
        UIImageView *ycImage  = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 140, 100, 100, 70)];
        ycImage.image = [UIImage imageNamed:@"image.png"];
        [self.mainScroll addSubview:ycImage];
    }
    [self goToBrowser];
    [self judgeIsInvite];

}
- (void)judgeIsInvite
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/is_invite"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid" ] forKey:@"uid"];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [dic setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:[self.dic objectForKey:@"id"] forKey:@"jdId"];
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                if ([[[responseObject objectForKey:@"data"]objectForKey:@"is_invite"]integerValue] == 1) {
                    self.connectButton.backgroundColor = [UIColor colorFromHexCode:@"ccc"];
                    [self.connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self.connectButton setTitle:@"已请求约面试" forState:UIControlStateNormal];
                    [self.connectButton removeTarget:self action:@selector(goToConnect) forControlEvents:UIControlEventTouchUpInside];
                    [self.connectButton addTarget:self action:@selector(goToJobHelperDetail) forControlEvents:UIControlEventTouchUpInside];
                    self.connectButton.userInteractionEnabled = YES;
            
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [AVAnalytics beginLogPageView:@"JobDetailView"];
     self.navigationController.navigationBarHidden = NO;
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"JobDetailView"];
    self.navigationController.navigationBarHidden = NO;
}

- (void)goToBrowser
{
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/browser"];
    NSMutableDictionary  *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
    
    [parameters setObject:[self.dic objectForKey:@"id"] forKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [parameters setObject:time forKey:@"timestamp"];
        
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                
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

#pragma mark -- 分享按钮
- (void)sharedAction:(UIButton*)button{
    
    // 解决循环引用
//    __weak typeof(id) ws = self;
//    
//    UIActionSheet *acSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:ws cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈", nil];
//    acSheet.tag =2;
//    acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [acSheet showInView:[[UIApplication sharedApplication]keyWindow]];
    NSString *str = [NSString stringWithFormat:@"%@share/jd?id=%@", SHARE_URL, [self.dic objectForKey:@"id"]];
    //        // 设置标题
    NSString * title = [NSString stringWithFormat:@"%@ %@ 正在寻找 %@ 岗位",[[self.dic objectForKey:@"cp"] objectForKey:@"name"],[[self.dic objectForKey:@"user"] objectForKey:@"name"],[self.dic objectForKey:@"title"]];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                NSArray* imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dic objectForKey:@"user"]objectForKey:@"avatar"]]]]];
        
                if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"我是%@%@, 邀请你加入\n求自荐、求转发",[[self.dic objectForKey:@"cp"] objectForKey:@"name"],[[self.dic objectForKey:@"user"] objectForKey:@"name"]]
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
                               [AVAnalytics event:@"JDShare"]; 
                               [MobClick event:@"JDShare"];
                               
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
- (void)createOtherBottonButton
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height  - 36 - 64 - 15, self.view.frame.size.width * 2 / 3   - 30, 36)];
    //    bottomView.backgroundColor = [UIColor redColor];
    bottomView.backgroundColor = [UIColor whiteColor];
    //      returnView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    //      returnView.layer.shadowOffset = CGSizeMake(1,1);
    
    //      returnView.layer.shadowOpacity = 0.6;
    
    //        returnView.layer.shadowRadius = 1.0;
    bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(1, 1);
    bottomView.layer.shadowOpacity = 0.6;
    [self.view addSubview:bottomView];
    
    
    UIButton * loveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width  / 2 - 0.5,49)];
    loveButton.backgroundColor = [UIColor zzdColor];
//    loveButton.layer.cornerRadius = 3;
    loveButton.layer.masksToBounds = YES;
    
//    UIImageView *loveImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 15, 15)];
//    loveImage.image = [UIImage imageNamed:@"whiteXin.png"];
//    [loveButton addSubview:loveImage];
    
    if ([self.collectType isEqualToString:@"YES"]) {
        [loveButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        [loveButton addTarget:self action:@selector(notLoveThis:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [loveButton setTitle:@"收藏" forState:UIControlStateNormal];
        [loveButton addTarget:self action:@selector(loveThis:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [loveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    loveButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [bottomView addSubview:loveButton];
    
    UIButton *talkButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 2 / 3 - 30, 36)];
    talkButton.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
//    talkButton.layer.cornerRadius = 3;
//    talkButton.layer.borderWidth = 1;
    
    talkButton.layer.masksToBounds = YES;
    [talkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkButton setTitle:@"立刻沟通" forState:UIControlStateNormal];
    [talkButton addTarget:self action:@selector(takeConversation) forControlEvents:UIControlEventTouchUpInside];
    talkButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [bottomView addSubview:talkButton];
//    UIImageView *talkImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 16, 16)];
//    talkImage.image = [UIImage imageNamed:@"whiteTalk.png"];
//    //    talkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    //    talkButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
//    [talkButton addSubview:talkImage];

    
    
    UIView *bottomOtherView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 30) * 2 / 3 + 20, self.view.frame.size.height - 36 - 64 - 15, (self.view.frame.size.width - 30) / 3 - 5 , 36)];
    //    bottomView.backgroundColor = [UIColor redColor];
//    bottomOtherView.backgroundColor = [UIColor whiteColor];
    //      returnView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    //      returnView.layer.shadowOffset = CGSizeMake(1,1);
    
    //      returnView.layer.shadowOpacity = 0.6;
    
    //        returnView.layer.shadowRadius = 1.0;
    bottomOtherView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomOtherView.layer.shadowOffset = CGSizeMake(1, 1);
    bottomOtherView.layer.shadowOpacity = 0.6;
    [self.view addSubview:bottomOtherView];
//
    
    
    
    self.connectButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width - 30) / 3 - 5, 36)];
    self.connectButton.backgroundColor = [UIColor whiteColor];
    
    //    talkButton.layer.cornerRadius = 3;
    self.connectButton.layer.masksToBounds = YES;
    [self.connectButton setTitleColor:[UIColor colorFromHexCode:@"38ab99"] forState:UIControlStateNormal];
//    self.connectButton.backgroundColor = [UIColor whiteColor];
    [self.connectButton setTitle:@"帮我约面试" forState:UIControlStateNormal];
    [self.connectButton addTarget:self action:@selector(showConnnectInfo) forControlEvents:UIControlEventTouchUpInside];
    self.connectButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [bottomOtherView addSubview:self.connectButton];
}
- (void)showConnnectInfo
{
    if ([[[self.dic objectForKey:@"user"]objectForKey:@"is_allow"]integerValue] == 0 && [[[self.dic objectForKey:@"user"]objectForKey:@"is_pay"]integerValue] == 0 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"面试通服务" message:@"该BOSS尚未开通转折点面试通服务，请您通过沟通按钮与该BOSS取得联系！" preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"该BOSS尚未开通转折点面试通服务，请您通过沟通按钮与该BOSS取得联系！"];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立刻沟通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            [self takeConversation];
        }];
        
        [alertController addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"查看进度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            [self goToJobHelperDetail];
        }];
          [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
        
    }else{
        
                         
    
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"count_invite"]integerValue] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"面试通服务" message:@"您已经预约了3个职位面试啦，在转折点团队为您确认BOSS意向之前，您将不能继续约面试" preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"您已经预约了3个职位面试啦，在转折点团队为您确认BOSS意向之前，您将不能继续约面试"];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"面试通服务" message:@"欢迎您使用转折点面试通服务，该服务能让人才更快、更精准的面试相关岗位，找到合适的工作；转折点专业团队收到您的面试请求后，将尽快为您确认该职位BOSS的意向情况，反馈给您，请您留意APP消息，及保持电话畅通，该服务免费！" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"欢迎您使用转折点面试通服务，该服务能让人才更快、更精准的面试相关岗位，找到合适的工作；转折点专业团队收到您的面试请求后，将尽快为您确认该职位BOSS的意向情况，反馈给您，请您留意APP消息，及保持电话畅通，该服务免费！"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self goToConnect];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    }
    }
}
- (void)goToConnect
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/invite"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid" ] forKey:@"uid"];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [dic setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:[self.dic objectForKey:@"id"] forKey:@"jdId"];
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                
                NSMutableDictionary *reloadDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]];
                [reloadDic setObject:[NSString stringWithFormat:@"%ld",[[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"count_invite"]integerValue] - 1] forKey:@"count_invite"];
                [[NSUserDefaults standardUserDefaults]setObject:reloadDic.copy forKey:@"user"];
                self.connectButton.backgroundColor = [UIColor colorFromHexCode:@"ccc"];
                [self.connectButton setTitle:@"已请求约面试" forState:UIControlStateNormal];
                [self.connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.connectButton removeTarget:self action:@selector(goToConnect) forControlEvents:UIControlEventTouchUpInside];
                [self.connectButton addTarget:self action:@selector(goToJobHelperDetail) forControlEvents:UIControlEventTouchUpInside];
                self.connectButton.userInteractionEnabled = YES;
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (void)goToJobHelperDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"转折点提示" message:@"你已预约过该Boss，点击按钮查看后台详细处理进度！" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"你已预约过该Boss，点击按钮查看后台详细处理进度！"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"333"] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertControllerMessageStr.string.length)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"查看进度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JobHelperViewController *jobHelperVC = [[JobHelperViewController alloc]init];
        [self.navigationController pushViewController:jobHelperVC animated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
- (void)takeConversation
{
    
//    NSString *url = @"http://api.zzd.hidna.cn/v1/jd/is_invite";
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
//        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
//        [dic setObject:time forKey:@"timestamp"];
//        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
//        [dic setObject:[self.dic objectForKey:@"id"] forKey:@"jdId"];
//        
//        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            
//            
//            if ([[responseObject objectForKey:@"ret"] isEqualToString:@"0"]) {
//                NSLog(@"收藏成功");
//                //                self.hud.labelText = @"收藏成功";
//                //                self.hud.mode = MBProgressHUDModeText;
//                //                [self.hud hide:YES afterDelay:1];
//                //                [self.hud removeFromSuperViewOnHide];
//               
//                
//                [self.dic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"]  forKey:@"favorite_id"];
//            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
//            {
//               
//                if ([AVUser currentUser].objectId != nil) {
//                    AVIMClient * client = [AVIMClient defaultClient];
//                    [client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
//                        
//                    }];
//                    if (client!=nil && client.status == AVIMClientStatusOpened) {
//                        [AVUser logOut];
//                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                            [self log];
//                        }];
//                    } else {
//                        [AVUser logOut];
//                        [client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                            [self log];
//                        }];
//                    }
//                    
//                }else{
//                    [self log];
//                }
//            }
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            
//        }];
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//    }];
//}




    if ([self.buttonType isEqualToString:@"108"] ){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        NSString *objectId = [[self.dic objectForKey:@"user"]objectForKey:@"im_id"];
        CheatViewController *cheat = [[CheatViewController alloc]init];
        cheat.objectId = objectId;
        cheat.jdDic = self.dic;
        cheat.rsDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"rs"];
   
        cheat.jdId = [self.dic objectForKey:@"id"];
        cheat.title = [[self.dic objectForKey:@"user"]objectForKey:@"name"];
        cheat.cheatHeader = [[self.dic objectForKey:@"user"]objectForKey:@"avatar"];
        
        
        [self.navigationController pushViewController:cheat animated:YES];
    }
}
- (void)notLoveThis:(UITapGestureRecognizer *)sender
{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
    
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"取消收藏中..." alert:ZZDAlertStateLoad];
    [self.view addSubview:alertView];
    
    UIImageView *loveButton = (UIImageView *)sender.view;
    if ([self.collectType isEqualToString:@"YES"]) {
        [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
        self.collectType = @"NO";
        self.collectImg.image = [UIImage imageNamed:@"Fill 1 Copy 6"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        
        
    }else{
        [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        self.collectType = @"YES";
        self.collectImg.image = [UIImage imageNamed:@"Group 10"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/my/favorite/%@/delete",[self.dic objectForKey:@"favorite_id"]];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:time forKey:@"timestamp"];
        [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
        [parameters setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSLog(@"取消成功");
//                self.hud.labelText = @"取消成功";
//                self.hud.mode = MBProgressHUDModeText;
//                [self.hud hide:YES afterDelay:1];
//                [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"取消成功"];
                
                // 给self.dic赋值
                [self.dic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"]  forKey:@"favorite_id"];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
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
}
- (void)loveThis:(UITapGestureRecognizer *)sender
{
    if ([[self.dic objectForKey:@"uid"]isEqualToString:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"]]) {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"不能收藏自己的职位" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [alert show];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"不能收藏自己的职位" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
    }else{
//    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//    self.hud.delegate = self;
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"收藏中...  " alert:ZZDAlertStateLoad];
        [self.view addSubview:alertView];
    
        UIImageView *loveButton = (UIImageView *)sender.view;
        if ([self.collectType isEqualToString:@"YES"]) {
            [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
            self.collectType = @"NO";
            self.collectImg.image = [UIImage imageNamed:@"Fill 1 Copy 6"];
            [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
            
            
        }else{
            [self.collectImg removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
            self.collectType = @"YES";
            self.collectImg.image = [UIImage imageNamed:@"Group 10"];
            [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
        }
    
    
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/my/favorite";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
    [dic setObject:[self.dic objectForKey:@"id"] forKey:@"origin_id"];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"] isEqualToString:@"0"]) {
                NSLog(@"收藏成功");
//                self.hud.labelText = @"收藏成功";
//                self.hud.mode = MBProgressHUDModeText;
//                [self.hud hide:YES afterDelay:1];
//                [self.hud removeFromSuperViewOnHide];
                [alertView loadDidSuccess:@"收藏成功"];
                
                [self.dic setObject:[[responseObject objectForKey:@"data"]objectForKey:@"id"]  forKey:@"favorite_id"];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                [alertView removeFromSuperview];
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



#pragma mark --------- 4
- (void)createFirstView
{
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, self.fifthView.frame.size.height + self.fifthView.frame.origin.y + 20, self.view.frame.size.width , 110)];
    self.firstView.backgroundColor = [UIColor whiteColor];
//    firstView.layer.borderWidth = 0.7;
//    firstView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor
    ;
    [self.mainScroll addSubview:self.firstView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#38AB99"];
    [self.firstView addSubview:lineView];
    
    UILabel *workLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 25)];
    //    workLabel.backgroundColor = [UIColor blackColor];
    workLabel.text = @"职位发布者";
    workLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    workLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    [self.firstView addSubview:workLabel];
    
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 50, 50)];
    self.headerImageView.backgroundColor = [UIColor blueColor];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    self.headerImageView.layer.borderWidth  = 0.7;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2;
    [self.firstView addSubview:self.headerImageView];
    
    
    self.headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.headerLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    //    self.headerLabel.backgroundColor = [UIColor belizeHoleColor];
    self.headerLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.firstView addSubview:self.headerLabel];
    
    
}

#pragma mark --------- 7
- (void)setFirstViewValue
{
    NSString *imageUrl = [[self.dic objectForKey:@"user"]objectForKey:@"avatar"];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    NSString *labelStr = [NSString stringWithFormat:@"%@ | %@ | %@",[[self.dic objectForKey:@"user"]objectForKey:@"name"],[[self.dic objectForKey:@"cp"]objectForKey:@"sub_name"],[[self.dic objectForKey:@"user"]objectForKey:@"title"]];
    self.headerLabel.text = labelStr ;
    
    CGSize headerLabelSize = [UILableFitText fitTextWithHeight:40 label:self.headerLabel];
    
    self.headerLabel.frame = CGRectMake(80, 50, headerLabelSize.width, 40);
    
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.firstView.frame.origin.y + self.firstView.frame.size.height + 120);
}



- (void)companyDetailTap
{
    NewCompanyDetailViewController *companyVC = [[NewCompanyDetailViewController alloc]init];
    companyVC.cpDic = [self.dic objectForKey:@"cp"];
    [self.navigationController pushViewController:companyVC animated:YES];
}
#pragma mark ---------- 5
- (void)createSecondView
{
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 160)];
    [secondView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyDetailTap)]];
    secondView.backgroundColor = [UIColor whiteColor];
    
//    secondView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    secondView.layer.borderWidth = 0.7;
    
    
    [self.mainScroll addSubview:secondView];
    
//    UIImageView *otherImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 25, 23, 20)];
//    otherImage.image = [UIImage imageNamed:@"pin1.png"];
//    [self.mainScroll addSubview:otherImage];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    
    [secondView addSubview:lineView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
//      self.titleLabel.backgroundColor = [UIColor blackColor];
    
    [secondView addSubview:self.titleLabel];
    
//    self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.categoryLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
//    self.categoryLabel.textColor = [UIColor grayColor];
////      self.categoryLabel.backgroundColor = [UIColor blackColor];
//    [secondView addSubview:self.categoryLabel];
    
    self.salaryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.salaryLabel.textAlignment = 0;
    self.salaryLabel.textColor = [UIColor colorFromHexCode:@"#ff5908"];
    self.salaryLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//      self.salaryLabel.backgroundColor = [UIColor redColor];
    
    [secondView addSubview:self.salaryLabel];
    
    self.tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 23, 16, 16)];
    self.tapLabel.text = @"聘";
    self.tapLabel.layer.borderWidth = 1;
    self.tapLabel.layer.borderColor = [UIColor colorFromHexCode:@"38ab99"].CGColor;
    self.tapLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
    self.tapLabel.textAlignment = 1;
    self.tapLabel.font = [UIFont systemFontOfSize:11];
    [secondView addSubview:self.tapLabel];
    
    if (self.buttonType == nil) {
        UILabel *hideLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 25, 70, 30)];
        hideLabel.textAlignment = 1;
        hideLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        hideLabel.userInteractionEnabled = YES;
        hideLabel.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        hideLabel.textColor = [UIColor whiteColor];
        hideLabel.layer.cornerRadius = 5;
        hideLabel.layer.masksToBounds = YES;
//        hideLabel.backgroundColor = [UIColor redColor];
        [secondView addSubview:hideLabel];
        if ([[self.dic objectForKey:@"state"]isEqualToString:@"1"]) {
            hideLabel.text = @"隐藏";
            [hideLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteJob)]];
            
                }else{
            hideLabel.text = @"取消隐藏";
                    [hideLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelHide)]];
                }
    }else{
    
    
    self.collectImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 29, 22, 21)];
//    self.collectImg.backgroundColor = [UIColor redColor];
    self.collectImg.userInteractionEnabled = YES;
    if ([self.collectType isEqualToString:@"YES"]) {
        self.collectImg.image = [UIImage imageNamed:@"Group 10"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notLoveThis:)]];
        
        
    }else{
       self.collectImg.image = [UIImage imageNamed:@"Fill 1 Copy 6"];
        [self.collectImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveThis:)]];
        
    }
    [secondView addSubview:self.collectImg];
    }
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//      self.cityLabel.backgroundColor = [UIColor redColor];
    self.cityLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.cityLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [secondView addSubview:self.cityLabel];
    
    
    self.cityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//        self.cityImage.backgroundColor = [UIColor redColor];
    [secondView addSubview:self.cityImage];
    
    self.yearImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//        self.yearImage.backgroundColor = [UIColor blueColor];
    [secondView addSubview:self.yearImage];
    
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.yearLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
//        self.yearLabel.backgroundColor = [UIColor redColor];
    self.yearLabel.font = [UIFont systemFontOfSize:16];
    [secondView addSubview:self.yearLabel];
    
    self.educationImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//        self.educationImage.backgroundColor = [UIColor blueColor];
    [secondView addSubview:self.educationImage];
    
    self.educationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.educationLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
//        self.educationLabel.backgroundColor = [UIColor redColor];
    self.educationLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [secondView addSubview:self.educationLabel];
    
//    self.tagArr = [self.dic objectForKey:@"tag_boss"];
//    double width = (self.view.frame.size.width - 60) / 5.0 + 10;
//    for (int i = 0; i < self.tagArr.count; i++) {
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * (width + 10) + 10, 115, width-8, 25)];
//        label.text = [[self.tagArr objectAtIndex:i]objectForKey:@"name"];
//        label.layer.cornerRadius = 5;
//        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
//        label.textAlignment = 1;
//        label.textColor = [UIColor zzdColor];
//        label.layer.masksToBounds = YES;
//        label.layer.borderColor = [UIColor zzdColor].CGColor;
//        label.layer.borderWidth = 0.5;
////        label.backgroundColor = [UIColor zzdColor];
//        [secondView addSubview:label];
//        
//    }
//    self.tagArrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, 0, 25)];
////    self.tagArrLabel.backgroundColor = [UIColor redColor];
//    self.tagArrLabel.font = [UIFont systemFontOfSize:16];
//    self.tagArrLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
//    [secondView addSubview:self.tagArrLabel];
    
    self.companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 0, 25)];
    self.companyNameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.companyNameLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    [secondView addSubview:self.companyNameLabel];
    
    UIImageView * nextBtn = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 35, 115, 8, 15)];
//    nextBtn.backgroundColor = [UIColor redColor];
    nextBtn.image = [UIImage imageNamed:@"Cell_Next.png"];
    [secondView addSubview:nextBtn];
    
}

#pragma mark ----------- 8
- (void)setSecondValue
{
    self.titleLabel.text = [self.dic objectForKey:@"title"];
    CGSize titleSize = [UILableFitText fitTextWithHeight:25 label:self.titleLabel];
    self.titleLabel.frame  = CGRectMake(10, 10, titleSize.width, 25);
    
    
    
   
    self.salaryLabel.text = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"salary"]];
    CGSize salarySize = [UILableFitText fitTextWithHeight:20 label:self.salaryLabel];
    self.salaryLabel.frame = CGRectMake(titleSize.width + 40, 10, salarySize.width, 25);
    
    self.tapLabel.frame = CGRectMake(titleSize.width + 40 + salarySize.width + 30, 14.5, 16, 16);
    
//    self.categoryLabel.text = [self.dic objectForKey:@"sub_category"];
//    CGSize categorySize = [UILableFitText fitTextWithHeight:20 label:self.categoryLabel];
//    self.categoryLabel.frame = CGRectMake(20 + salarySize.width, 40, categorySize.width, 20);
    
    self.cityImage.image = [UIImage imageNamed:@"Group 6 Copy 6.png"];
    self.yearImage.image = [UIImage imageNamed:@"Group 4 Copy 5.png"];
    self.educationImage.image = [UIImage imageNamed:@"Group 5 Copy 5.png"];
    
    self.educationImage.frame = CGRectMake(10, 46, 13, 13);
    self.educationLabel.text = [self.dic objectForKey:@"education"];
    CGSize educationSize = [UILableFitText fitTextWithHeight:20 label:self.educationLabel];
    self.educationLabel.frame = CGRectMake(28, 43, educationSize.width, 20);
    
    self.cityImage.frame = CGRectMake(40 + educationSize.width, 46, 13, 13);
    self.cityLabel.text = [self.dic objectForKey:@"city"];
    CGSize citySize = [UILableFitText fitTextWithHeight:20 label:self.cityLabel];
    self.cityLabel.frame = CGRectMake(self.cityImage.frame.origin.x + 18, 43, citySize.width, 20);
    
    self.yearImage.frame = CGRectMake(self.cityLabel.frame.origin.x + citySize.width + 10, 46, 13, 13);
    
    self.yearLabel.text = [self.dic objectForKey:@"work_year"];
    
    CGSize yearSize = [UILableFitText fitTextWithHeight:20 label:self.yearLabel];
    self.yearLabel.frame = CGRectMake(self.yearImage.frame.origin.x + 18, 43, yearSize.width, 20);
    
    self.tagArr = [self.dic objectForKey:@"tag_boss"];
    NSMutableString *tagArrStr = [NSMutableString string];
//    for (NSDictionary *dic in self.tagArr) {
//        [tagArrStr appendString:[dic objectForKey:@"name"]];
//        [tagArrStr appendString:@" | "];
//        
//    }
    for (int i = 0; i < self.tagArr.count; i++) {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10 + i * 70, 125, 62, 23)];
        lb.layer.borderColor = [UIColor colorFromHexCode:@"#d7d7d7"].CGColor;
        lb.layer.borderWidth = 1;
        lb.textAlignment = 1;
        lb.text = [[self.tagArr objectAtIndex:i]objectForKey:@"name"];
        lb.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        lb.textColor = [UIColor colorFromHexCode:@"#d7d7d7"];
        [self.companyNameLabel.superview addSubview:lb];
    }
//    if (tagArrStr.length > 0) {
//        
//        [tagArrStr deleteCharactersInRange:NSMakeRange(tagArrStr.length - 3, 3)];
//    }
//    self.tagArrLabel.text = tagArrStr;
//    CGSize tagArrSize = [UILableFitText fitTextWithHeight:25 label:self.tagArrLabel];
//    self.tagArrLabel.frame = CGRectMake(10, 115, tagArrSize.width, 25);

    self.companyNameLabel.text = [[self.dic objectForKey:@"cp"]objectForKey:@"sub_name"];
    CGSize companyNameSize = [UILableFitText fitTextWithHeight:25 label:self.companyNameLabel];
    self.companyNameLabel.frame = CGRectMake(10, 90, companyNameSize.width, 25);
    
}

#pragma mark ----------- 6
- (void)createThirdView
{
    self.thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 170, self.view.frame.size.width , 115)];
    self.thirdView.backgroundColor = [UIColor whiteColor];
    
//    self.thirdView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    self.thirdView.layer.borderWidth = 0.7;
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#38AB99"];
    [self.thirdView addSubview:lineView];
    
    
    UILabel *workLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,  0, 150, 30)];
    //    workLabel.backgroundColor = [UIColor blackColor];
    workLabel.text = @"职位描述";
    workLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    workLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    [self.thirdView addSubview:workLabel];
    
    
//    UIImageView *mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.thirdView.frame.size.width - 30, 5, 20, 20)];
////    mainImage.backgroundColor = [UIColor blackColor];
//    mainImage.image = [UIImage imageNamed:@"xiaoxi.png"];
//    [self.thirdView addSubview:mainImage];
    
    
    
    
    
    
    
    [self.mainScroll addSubview:self.thirdView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = 0;
    //    [self.contentLabel sizeToFit];
    self.contentLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.contentLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    //    self.contentLabel.backgroundColor = [UIColor blackColor];
    [self.thirdView addSubview:self.contentLabel];
    
    
}

#pragma mark -------- 9
- (void)setThirdViewValue
{
    NSString *work_content = [self.dic objectForKey:@"work_content"];
//    self.contentLabel.text = [self.dic
//                              objectForKey:@"work_content"];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:work_content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [work_content length])];
    [self.contentLabel setAttributedText:attributedString1];
    
    CGSize contentSize = [UILableFitText fitTextWithWidth:self.thirdView.frame.size.width - 20 label:self.contentLabel];
    self.contentLabel.frame = CGRectMake(15, 35, self.thirdView.frame.size.width - 30, contentSize.height + 10);
    self.thirdView.frame = CGRectMake(0, 180, self.view.frame.size.width , 55 + contentSize.height);
    self.forthView.frame = CGRectMake(10, 180 + self.thirdView.frame.size.height + 10 , self.view.frame.size.width - 20, 180);
    
}

#pragma mark --------- 6.5
- (void)createForthView
{
    self.forthView = [[UIView alloc]initWithFrame:CGRectMake(10, 170 + self.thirdView.frame.size.height + 10 , self.view.frame.size.width - 20, 180)];
    
    self.forthView.backgroundColor = [UIColor whiteColor];
    self.forthView.layer.cornerRadius = 5;
    self.forthView.layer.masksToBounds = YES;
//    _forthView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    _forthView.layer.borderWidth = 0.7;
    [self.mainScroll addSubview:self.forthView];
    
    
    
    
    UIImageView *mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.thirdView.frame.size.width - 30, 7, 22, 19)];
    //    mainImage.backgroundColor = [UIColor blackColor];
    mainImage.image = [UIImage imageNamed:@"qi.png"];
    [self.forthView addSubview:mainImage];

    
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 25)];
    //    companyLabel.backgroundColor = [UIColor blackColor];
    companyLabel.text = @"公司介绍";
    companyLabel.textColor = [UIColor zzdColor];
    companyLabel.font = [UIFont systemFontOfSize:16];
    [_forthView addSubview:companyLabel];
    
    
    self.layerOne = [MyCAShapeLayer createLayerWithXx:0 xy:35 yx:self.forthView.frame.size.width yy:35];
    [self.forthView.layer addSublayer:self.layerOne];
    
    
    
//    self.showIntrButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5 + 180 * 4 / 5 , _forthView.frame.size.width - 20, 180 / 5 - 10)];
//    [self.showIntrButton setTitle:@"显示全部" forState:UIControlStateNormal];
//    [self.showIntrButton setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
//    self.showIntrButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
//    [self.showIntrButton addTarget:self action:@selector(showIntr:) forControlEvents:UIControlEventTouchUpInside];
    //    self.intrLabel.backgroundColor = [UIColor blackColor];
//    [_forthView addSubview:self.showIntrButton];
    
    
    self.intrLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.intrLabel.text  = [[self.dic objectForKey:@"cp"] objectForKey:@"intr"];
    self.intrLabel.font = [UIFont systemFontOfSize:16];
    self.intrLabel.textColor = [UIColor grayColor];
    self.intrLabel.numberOfLines = 0;
    [self.forthView addSubview:self.intrLabel];
    
//    self.tagArr = [self.dic objectForKey:@"tag_boss"];
//    if (self.tagArr.count > 0) {
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 5+180, self.forthView.frame.size.width - 20, 0.5)];
//        lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
//        [self.forthView addSubview:lineView];
//        
//        self.forthView.frame = CGRectMake(10, 355, self.view.frame.size.width - 20, 216);
//        self.showIntrButton.frame = CGRectMake(10, 5 + 180, self.forthView.frame.size.width - 20, 180 / 5 - 10);
//        
//        double width = (self.forthView.frame.size.width - 60) / 4.0;
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180 * 4 / 5 + 8, width + 20, 180 / 5 - 10)];
//        titleLabel.text = @"公司行业:";
//        titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
//        titleLabel.textColor = [UIColor grayColor];
//        [self.forthView addSubview:titleLabel];
//        
//        for (int i = 0; i < self.tagArr.count; i++) {
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * (width + 10) + 25 + width,    180 * 4 / 5 + 12, width-8, 180 / 5 - 18)];
//            label.text = [[self.tagArr objectAtIndex:i]objectForKey:@"name"];
//            label.layer.cornerRadius = 5;
//            label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
//            label.textAlignment = 1;
//            label.textColor = [UIColor whiteColor];
//            label.layer.masksToBounds = YES;
//            label.backgroundColor = [UIColor zzdColor];
//            [self.forthView addSubview:label];
//            
//        }
//    }else{
//        self.forthView.frame = CGRectMake(10, 355, self.view.frame.size.width - 20, 180);
//        self.showIntrButton.frame = CGRectMake(10, 150, self.forthView.frame.size.width - 20, 180 / 5 - 10);
//    }
    
}
#pragma mark ----------- 10
- (void)setForthViewValue
{
    [self.layerTwo removeFromSuperlayer];
    [self.layerThree removeFromSuperlayer];
    
    
    
    NSDictionary *cpDic = [self.dic objectForKey:@"cp"];
    self.intrLabel.text = [cpDic objectForKey:@"intr"];
    CGSize intrSize = [UILableFitText fitTextWithWidth:self.forthView.frame.size.width - 20  label:self.intrLabel];
    self.intrLabel.frame = CGRectMake(10, 40, self.forthView.frame.size.width - 20, intrSize.height);
    
    
    
    self.forthView.frame = CGRectMake(10, 170 + self.thirdView.frame.size.height + 10 , self.view.frame.size.width - 20, self.intrLabel.frame.origin.y + intrSize.height + 10);
    
    
    
    
}
- (void)addressTap:(UITapGestureRecognizer *)tap
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lat"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"] && [[self.dic objectForKey:@"cp"]objectForKey:@"lat"] && [[self.dic objectForKey:@"cp"]objectForKey:@"lon"]) {
        if (([[[self.dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue] != 0) && ([[[self.dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue] != 0)) {
            
//            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"]doubleValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"lon"]doubleValue]));
//            
//            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[self.dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue],[[[self.dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue]));
            MapShowViewController *mapVC = [[MapShowViewController alloc]init];
            mapVC.addressStr = [[self.dic objectForKey:@"cp"]objectForKey:@"address"];
            mapVC.lat = [[[self.dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue];
            mapVC.lon = [[[self.dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue];
            [self.navigationController pushViewController:mapVC animated:YES];
            
        }
    }

}
- (void)createFifthView
{
    self.fifthView = [[UIView alloc]initWithFrame:CGRectMake(0, self.thirdView.frame.origin.y + self.thirdView.frame.size.height + 10, self.view.frame.size.width , 180)];
    self.fifthView.backgroundColor = [UIColor whiteColor];
//    self.fifthView.layer.cornerRadius = 5;
    self.fifthView.userInteractionEnabled = YES;
    [self.fifthView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressTap:)]];
//    self.fifthView.layer.masksToBounds = YES;
    [self.mainScroll addSubview:self.fifthView];

    UILabel *workLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,  0, 150, 30)];
    //    workLabel.backgroundColor = [UIColor blackColor];
    workLabel.text = @"工作地点";
    workLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    workLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    [self.fifthView addSubview:workLabel];
    
//    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
//    self.nameLabel.textColor = [UIColor grayColor];
//    //    self.nameLabel.backgroundColor = [UIColor blackColor];
//    [self.fifthView addSubview:self.nameLabel];
    
    
//    self.sizeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.sizeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
//    self.sizeLabel.textColor = [UIColor grayColor];
//    //    self.sizeLabel.backgroundColor = [UIColor blackColor];
//    [self.fifthView addSubview:self.sizeLabel];
    
    self.subNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.subNameLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.subNameLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
//        self.subNameLabel.backgroundColor = [UIColor blueColor];
    [self.fifthView addSubview:self.subNameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 30)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    [self.fifthView addSubview:lineView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.sizeLabel.frame.origin.y + 35, 13, 16)];
//    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"Group 6 Copy 10.png"];
    [self.fifthView addSubview:imageView];
    
    
//    self.nameImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.nameImage.image = [UIImage imageNamed:@"copt_1.png"];
//    [self.fifthView addSubview:self.nameImage];
//    
//    self.sizeImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.sizeImage.image = [UIImage imageNamed:@"copt_2.png"];
//    [self.fifthView addSubview:self.sizeImage];
//    
//    self.subNameImage = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.subNameImage.image = [UIImage imageNamed:@"ico-01.png"];
//    [self.fifthView addSubview:self.subNameImage];

    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 102, self.sizeLabel.frame.origin.y + 20, 80, 20)];
//    self.distanceLabel.backgroundColor = [UIColor redColor];
    self.distanceLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
//    self.distanceLabel.text = @"距我1008.08km";
    self.distanceLabel.textAlignment = 1;
    self.distanceLabel.textColor = [UIColor colorFromHexCode:@"#dadada"];
    [self.fifthView addSubview:self.distanceLabel];

}
- (void)setFifthViewValue
{
    
    
    NSDictionary *cpDic = [self.dic objectForKey:@"cp"];
//    self.nameLabel.text = [cpDic objectForKey:@"name"];
//    CGSize nameSize = [UILableFitText fitTextWithHeight:20 label:self.nameLabel];
//    self.nameLabel.frame = CGRectMake(30, 5, nameSize.width, 20);
//    self.nameImage.frame = CGRectMake(5,  5, 18, 18);
//    
//    
//    self.layerThree = [MyCAShapeLayer createLayerWithXx:0 xy:60  yx:self.forthView.frame.size.width yy:60 ];
//    [self.fifthView.layer addSublayer:self.layerThree];
//    
//    self.sizeLabel.text = [cpDic objectForKey:@"size"];
//    CGSize sizeSize = [UILableFitText fitTextWithHeight:20 label:self.sizeLabel];
//    self.sizeLabel.frame = CGRectMake(30, self.nameLabel.frame.origin.y + 30, sizeSize.width, 20);
//    self.sizeImage.frame = CGRectMake(7, self.nameImage.frame.origin.y + 32, 14, 14);
    
    
    
    self.subNameLabel.text = [cpDic objectForKey:@"address"];
//    CGSize subNameSize = [UILableFitText fitTextWithHeight:20 label:self.subNameLabel];
//    self.subNameLabel.frame = CGRectMake(10, self.sizeLabel.frame.origin.y + 35, self.view.frame.size.width - 120, 30);
    self.subNameLabel.numberOfLines = 2;
//    self.subNameImage.frame = CGRectMake(6, self.sizeLabel.frame.origin.y + 32, 15, 15);
    
    CGSize subNameSize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 120 label:self.subNameLabel];
    self.subNameLabel.frame = CGRectMake(35, self.sizeLabel.frame.origin.y + 35, self.view.frame.size.width - 120, subNameSize.height + 5);
    self.fifthView.frame = CGRectMake(0, self.thirdView.frame.origin.y + self.thirdView.frame.size.height + 20, self.view.frame.size.width , self.subNameLabel.frame.origin.y + self.subNameLabel.frame.size.height + 5);

//    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.fifthView.frame.origin.y + self.fifthView.frame.size.height + 60);
    
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lat"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"] && [[self.dic objectForKey:@"cp"]objectForKey:@"lat"] && [[self.dic objectForKey:@"cp"]objectForKey:@"lon"]) {
        if (([[[self.dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue] != 0) && ([[[self.dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue] != 0)) {
            
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"]doubleValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"lon"]doubleValue]));
            
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[self.dic objectForKey:@"cp"]objectForKey:@"lat"]doubleValue],[[[self.dic objectForKey:@"cp"]objectForKey:@"lon"]doubleValue]));
            
            
            
            //2.计算距离
            
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            self.distanceLabel.text = [NSString stringWithFormat:@"距离%.1fkm",distance / 1000.0];
//            CGSize distanceSize = [UILableFitText fitTextWithHeight:25 label:self.distanceLabel];
//            self.distanceLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - distanceSize.width - 20, 60, distanceSize.width + 10, 15);
//            self.distanceLabel.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
        }else{
//            self.distanceLabel.backgroundColor = [UIColor whiteColor];
            self.distanceLabel.text = @"位置未知";
        }
    }else{
//        self.distanceLabel.backgroundColor = [UIColor whiteColor];
        self.distanceLabel.text = @"位置未知";
        
    }

}
- (void)showIntr:(id)sender
{
    
    CGFloat labelHeight = [self.intrLabel sizeThatFits:CGSizeMake(self.intrLabel.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.intrLabel.font.lineHeight);

    self.intrlLength = [count integerValue];
    
    
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"显示全部"]) {
        [button setTitle:@"收起" forState:UIControlStateNormal];
        self.intrLabel.frame = CGRectMake(10, self.forthView.frame.size.height - 180 / 5, self.forthView.frame.size.width - 20, self.intrlLength * (180 / 5 - 10));
        [self.forthView addSubview:self.intrLabel];
        self.forthView.frame = CGRectMake(10, self.forthView.frame.origin.y, self.view.frame.size.width - 20, 216 + self.intrlLength * (180 / 5 - 10));
        self.showIntrButton.frame = CGRectMake(10, 185 + self.intrlLength * (180 / 5 - 10), _forthView.frame.size.width - 20, 180 / 5  );
        if ([self.showAllButton.titleLabel.text isEqualToString:@"显示全部"]) {
            self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 650 + self.intrlLength * (180 / 5 - 10));
        }else{
            self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 650 + self.intrlLength * (180 / 5 - 10) + self.length * 20 - 35);
        }
        if (self.tagArr.count == 0) {
            self.forthView.frame = CGRectMake(10, self.forthView.frame.origin.y, self.view.frame.size.width - 20, 180 + self.intrlLength * (180 / 5 - 10));
            self.showIntrButton.frame = CGRectMake(10, 150 + self.intrlLength * (180 / 5 - 10), _forthView.frame.size.width - 20, 180 / 5  -10);
        }
        
    }else{
        [button setTitle:@"显示全部" forState:UIControlStateNormal];
        [self.intrLabel removeFromSuperview];
        
        //        self.intrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.forthView.frame.size.width - 20, 180/ 5 - 10)];
        self.showIntrButton.frame = CGRectMake(10, 5 + 180, self.forthView.frame.size.width - 20, 180 / 5 - 10);
        self.forthView.frame = CGRectMake(10, self.forthView.frame.origin.y, self.view.frame.size.width - 20, 216);
        self.intrlLength = 0;
        if ([self.showAllButton.titleLabel.text isEqualToString:@"显示全部"]) {
            self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 650 );
        }else{
            self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 650 + self.length * 20);
        }
        if (self.tagArr.count == 0) {
            self.forthView.frame = CGRectMake(10, self.forthView.frame.origin.y, self.view.frame.size.width - 20, 180);
            self.showIntrButton.frame = CGRectMake(10, 150 , _forthView.frame.size.width - 20, 180 / 5  -10);
        }
        
        
    }
}

#pragma mark ---------- 11
- (void)createBottomButton
{
//    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49)];
//    //    bottomView.backgroundColor = [UIColor redColor];
//    bottomView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
//    bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    bottomView.layer.shadowOffset = CGSizeMake(1, 1);
//    bottomView.layer.shadowOpacity = 0.6;
//    [self.view addSubview:bottomView];
    
    
    UIButton * editJobButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 49 - 64 + 2.5, self.view.frame.size.width - 30, 49 - 15)];
    //    editJobButton.backgroundColor = [UIColor blackColor];
    //    editJobButton.layer.shadowOpacity = 0.8;
    //    editJobButton.layer.shadowColor = [UIColor redColor].CGColor;
    //    editJobButton.layer.shadowOffset = CGSizeMake(1, 1);
    [editJobButton setTitle:@"编辑职位" forState:UIControlStateNormal];
    [editJobButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editJobButton.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [editJobButton addTarget:self action:@selector(editJob) forControlEvents:UIControlEventTouchUpInside];
    editJobButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    
    [self.view addSubview:editJobButton];
    
//    UIButton *deleteJobButton  = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width / 2 + 5, 5, bottomView.frame.size.width  / 2 - 10,49  - 10)];
//    //    deleteJobButton.backgroundColor = [UIColor blackColor];
//    [deleteJobButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    if ([[self.dic objectForKey:@"state"]isEqualToString:@"1"]) {
//        
//        [deleteJobButton addTarget:self action:@selector(deleteJob) forControlEvents:UIControlEventTouchUpInside];
//        [deleteJobButton setTitle:@"隐藏职位" forState:UIControlStateNormal];
//    }else{
//        [deleteJobButton addTarget:self action:@selector(cancelHide) forControlEvents:UIControlEventTouchUpInside];
//        [deleteJobButton setTitle:@"开放职位" forState:UIControlStateNormal];
//    }
//    deleteJobButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    [bottomView addSubview:deleteJobButton];
//    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(bottomView.frame.size.width / 2 - 0.5 / 2, 5, 0.5, bottomView.frame.size.height - 10)];
//    lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
//    [bottomView addSubview:lineView];
//    
//    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
//    lineView1.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
//    [bottomView addSubview:lineView1];
}
- (void)cancelHide
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@/update",[self.dic objectForKey:@"id"]];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:@"1" forKey:@"state"];
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    NSLog(@"开放职位");
                    [self.navigationController popViewControllerAnimated:YES];
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    
                    
                    if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
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
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark --------- 编辑职位
- (void)editJob
{

    if ([[self.dic objectForKey:@"state"]isEqualToString:@"0"]) {

        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请先开放职位" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
    }else{
    CreateNewJobViewController *createNewJob = [[CreateNewJobViewController alloc]init];
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    [dic setObject:[self.dic objectForKey:@"title"]  forKey:@"职位名称"];
    //    [dic setObject:[self.dic objectForKey:@"salary"] forKey:@"薪资范围"];
    //    [dic setObject:[self.dic objectForKey:@"work_year"] forKey:@"经验要求"];
    //    [dic setObject:[self.dic objectForKey:@"education"] forKey:@"学历要求"];
    //    [dic setObject:[NSString stringWithFormat:@"%@|%@",[self.dic objectForKey:@"category"],[self.dic objectForKey:@"sub_category"]] forKey:@"职位类型"];
    //    [dic setObject:[self.dic objectForKey:@"city"] forKey:@"工作地点"];
    [createNewJob.mainDic addEntriesFromDictionary:self.dic];
    createNewJob.state = 10;
    createNewJob.delegate = self;
    [self.navigationController pushViewController:createNewJob animated:YES];
    }
    
}

#pragma mark ------- 协议方法
- (void)changeMainValue:(NSDictionary *)dic
{
    
    self.dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self setFirstViewValue];
    [self setSecondValue];
    [self setThirdViewValue];
    [self setForthViewValue];
    [self setFifthViewValue];
    
}

#pragma mark ---------- 隐藏职位
- (void)deleteJob
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@/update",[self.dic objectForKey:@"id"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid" ] forKey:@"uid"];
    
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        [dic setObject:time forKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [dic setObject:@"0" forKey:@"state"];
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSLog(@"隐藏成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
                    [AVUser logOut];
                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                } else{
                    [AVUser logOut];
                    [self log];
                }
                
                
               
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}



#pragma mark ---------- 12
- (void)showAll
{

    self.contentLabel.numberOfLines = 0;
    CGFloat labelHeight = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.contentLabel.font.lineHeight);

    self.length = [count integerValue];
    self.contentLabel.numberOfLines = 2;
    
    
    if (self.length > 2) {
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 85.5, self.thirdView.frame.size.width, 0.5)];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        [self.thirdView addSubview:self.lineView];
        
        
        self.showAllButton = [[ UIButton alloc]initWithFrame:CGRectMake(self.thirdView.frame.size.width / 2 - 80, 90, 160, 25)];
        [self.showAllButton setTitle:@"显示全部" forState:UIControlStateNormal];
        [self.showAllButton setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
        [self.showAllButton addTarget:self action:@selector(showAllView) forControlEvents:UIControlEventTouchUpInside];
        self.showAllButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        //        button.backgroundColor = [UIColor blackColor];
        [self.thirdView addSubview:self.showAllButton];
    }
    
}

- (void)showAllView
{
    //self.length = (NSInteger)(self.length + 1);
    if ([self.showAllButton.titleLabel.text isEqualToString:@"显示全部"]) {
        [self.showAllButton setTitle:@"收起" forState:UIControlStateNormal];
        self.thirdView.frame = CGRectMake(10, 230, self.view.frame.size.width - 20, 115 + self.length * 20 - 35);
        
        self.contentLabel.frame = CGRectMake(10, 40, self.thirdView.frame.size.width - 20, self.length  * 20);
        self.contentLabel.textAlignment = 3;
        self.contentLabel.numberOfLines = 0;
        self.lineView.frame = CGRectMake(0, 85.5 + self.length * 20 - 35, self.thirdView.frame.size.width, 0.5);
        
        
        self.forthView.frame = CGRectMake(10, 355 - 35 + self.length * 20, self.view.frame.size.width - 20, self.forthView.frame.size.height);
        
        self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 650 + self.length * 20 - 35 + self.intrlLength * (180 / 5 - 10));
        self.showAllButton.frame = CGRectMake(self.thirdView.frame.size.width / 2 - 80, 90 + self.length * 20 - 35, 160, 25);
        
        
    }else{
        [self.showAllButton setTitle:@"显示全部" forState:UIControlStateNormal];
        self.thirdView.frame = CGRectMake(10, 230, self.view.frame.size.width - 20, 115);
        self.contentLabel.frame = CGRectMake(10, 35, self.thirdView.frame.size.width - 20, 50);
        self.contentLabel.numberOfLines = 2;
        self.contentLabel.textAlignment = 3;
        self.lineView.frame = CGRectMake(0, 85.5, self.thirdView.frame.size.width, 0.5);
        self.forthView.frame = CGRectMake(10, 355, self.view.frame.size.width - 20, self.forthView.frame.size.height);
        self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 650 + self.intrlLength * (180 / 5 - 10));
        self.showAllButton.frame = CGRectMake(self.thirdView.frame.size.width / 2 - 80, 90, 160, 25);
        
    }
    
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.forthView.frame.size.height + self.forthView.frame.origin.y);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   ==============截屏方法==============
- (void)CaptureScreen{
    
    UIImage* image = nil;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(self.mainScroll.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = self.mainScroll.contentOffset;
    CGRect savedFrame = self.mainScroll.frame;
    self.mainScroll.contentOffset = CGPointZero;
    self.mainScroll.frame = CGRectMake(0, 0, self.mainScroll.contentSize.width, self.mainScroll.contentSize.height);
    [self.mainScroll.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    self.mainScroll.contentOffset = savedContentOffset;
    self.mainScroll.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    image = [self scaleToSize:image size:CGSizeMake(600, image.size.height * 600 / image.size.width)];
    NSMutableData* outputData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputData);
    CFMutableDictionaryRef attrDictionary = NULL;
    attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, @"My Awesome Document");
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attrDictionary);
    CFRelease(dataConsumer);
    CFRelease(attrDictionary);
    UIImage* myUIImage = image;
    CGImageRef pageImage = [myUIImage CGImage];
    CGPDFContextBeginPage(pdfContext, NULL);
    CGContextDrawImage(pdfContext, CGRectMake(0, 0, [myUIImage size].width, [myUIImage size].height /1.45), pageImage);
    CGPDFContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    CGContextRelease(pdfContext);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* appFile = [documentsDirectory stringByAppendingPathComponent:@"tmp.pdf"];
    [outputData writeToFile:appFile atomically:YES];

    NSLog(@"%@",appFile);

}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
        // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
       // 从当前context中创建一个改变大小后的图片
       UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return scaledImage;
}
void WQDrawContent(CGContextRef myContext,
                   CFDataRef data,
                   CGRect rect)
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(data);
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider,
                                                         NULL,
                                                         NO,
                                                         kCGRenderingIntentDefault);
    CGContextDrawImage(myContext, rect, image);
    
    CGDataProviderRelease(dataProvider);
    CGImageRelease(image);
}

//指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功，可到相册查看" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}

@end
