

//
//  CheatViewController.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/6.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CheatViewController.h"
#import <UIKit/UIKit.h>
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "CheatTableViewCell.h"
#import "UIColor+AddColor.h"
#import "NewCheatTableViewCell.h"
#import "MyRecorder.h"
#import "AudioBubble.h"
#import "AudioTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ImageTableViewCell.h"
#import "SortTextDate.h"
#import "UserSaveTool.h"
#import "CheatHeaderView.h"
#import "CheatHeaderTableViewCell.h"
#import "JudgeCreateCheatWindow.h"
#import "AFNetworking.h"
#import "JobDetailViewController.h"
#import "WorkResumeDetailViewController.h"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import <CoreText/CoreText.h>
#import "FMDBMessages.h"
#import "MyMessage.h"
#import "BlankString.h"
#import "MessageModel.h"
#import "CheakBubble.h"
#import "UITextView+PrintField.h"
#import "ZZDAlertView.h"
#import "BossCheatTitleCell.h"
#import "PersonCheatTitleCell.h"
#import "FontTool.h"
#import "NewZZDPeopleViewController.h"
#import "SendOrRequireTableViewCell.h"
#import "AFNetworking.h"
#import "SendResultTableViewCell.h"
#import <UMMobClick/MobClick.h>
#import "UILableFitText.h"
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
@interface CheatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AVIMClientDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSCoding,UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong)UITableView *cheatTableView;
@property (nonatomic, strong)NSMutableArray *messageArr;
@property (nonatomic, strong)NSMutableDictionary *userDic;
@property (nonatomic, strong)AVIMClient *client;
@property (nonatomic, strong)AVIMClient *receiveClient;
@property (nonatomic, strong)NSString *conversationId;
@property (nonatomic, strong)UIView *keyboardView;
@property (nonatomic, strong)UITextView *keyboardField;
@property (nonatomic, strong)NSMutableArray *emojiArr;
@property (nonatomic, strong)AVIMClient *mainClient;

//speak
@property (nonatomic, strong)UIButton *speakButton;
@property (nonatomic, strong)UIImageView *speakImage;
@property (nonatomic, strong)UIImageView *returnToTextImage;
@property (nonatomic, strong)NSTimer *speakTimer;
@property (nonatomic, strong)UIView *speakView;
@property (nonatomic, strong)UILabel *speakLabel;
@property (nonatomic, assign)CGFloat recordTime;
@property (nonatomic, strong)MyRecorder *myRecorder;
@property (nonatomic, strong)UIImageView *recordIm;
@property (nonatomic,strong)NSMutableArray * timeArr;


//album
@property (nonatomic, strong)UIView *albumView;


//look
@property (nonatomic, strong)UIPageControl *page;
@property (nonatomic, strong)UIView *mainView;
@property (nonatomic, strong)NSArray *lookArr;
@property (nonatomic, strong)UIScrollView *lookArrScroll;
@property (nonatomic, strong)UIScrollView *otherLookArrScroll;

@property (nonatomic, assign)NSInteger length;
@property (nonatomic, assign)NSInteger messageCount;


@property (nonatomic, strong)NSMutableArray *mesArr;
@property (nonatomic, assign)CGFloat lastScale;
@property (nonatomic, assign)CGFloat firstX;
@property (nonatomic, assign)CGFloat firstY;

//添加手势回收键盘
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;


@property (nonatomic, strong)MessageModel *messageModel;
@property (nonatomic, strong)NSCache *rowHeightDic;
@property (nonatomic, strong)NSCache *messageTextStrDic;

@property (nonatomic, assign)CGFloat keyBoardHeight;



@property (nonatomic, strong)NSString *sendStr;
@property (nonatomic, strong)NSMutableAttributedString *sendAttStr;
@property (nonatomic, strong)NSMutableArray *strArr;

@property (nonatomic, assign)NSInteger dbMesCount;


@property (nonatomic, strong)NSArray *otherLookArr;
@property (nonatomic, strong)UIWebView *lookDetailView;

@property (nonatomic, assign)BOOL isOut;


@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;


@property (nonatomic, strong)NSString *sendType;

@property (nonatomic, assign)BOOL hasDone;

@property (nonatomic, strong)UITextField *emailField;

@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong)UILabel *sendLabel;
@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIView *guideView;

@property (nonatomic, strong)UIButton *commonWordBtn;


@property (nonatomic, strong)NSArray *commonWordArr;
@property (nonatomic, strong)UIScrollView *commonWordScroll;
@property (nonatomic, strong)UIView * commonWordView;
@property (nonatomic, strong)UIImageView *addImage;

@property (nonatomic, strong)UIView *keyBoardBackView;
@end

@implementation CheatViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.strArr = [NSMutableArray array];
        self.sendAttStr = [[NSMutableAttributedString alloc]initWithString:@""];
        self.sendStr = [NSString string];
        self.keyBoardHeight = 216.0;
        self.rowHeightDic = [NSCache new];
        self.messageTextStrDic = [NSCache new];
        self.mesArr = [NSMutableArray array];
        self.messageArr = [NSMutableArray array];
        self.userDic = [NSMutableDictionary dictionary];
        self.emojiArr = [NSMutableArray array];
        self.messageCount = 10;
        self.lookArr = @[@":smile:",@":laughing:",@":blush:", @":smiley:",@":relaxed:",@":smirk:",@":heart_eyes:",@":kissing_heart:",@":kissing_closed_eyes:",@":flushed:",@":relieved:",@":satisfied:",@":grin:",@":wink:",@":stuck_out_tongue_winking_eye:",@":stuck_out_tongue_closed_eyes:",@":grinning:",@":kissing:",@":kissing_smiling_eyes:",@":stuck_out_tongue:",@":sleeping:",@":worried:",@":frowning:",@":anguished:",@":open_mouth:",@":grimacing:",@":confused:",@":hushed:",@":expressionless:",@":unamused:",@":sweat_smile:",@":sweat:",@":disappointed_relieved:",@":weary:",@":pensive:",@":disappointed:",@":confounded:",@":fearful:",@":cold_sweat:",@":persevere:",@":cry:",@":sob:",@":joy:",@":astonished:",@":scream:",@":tired_face:",@":angry:",@":rage:",@":triumph:",@":sleepy:",@":yum:",@":mask:",@":sunglasses:",@":dizzy_face:",@":neutral_face:",@":no_mouth:",@":innocent:",@":thumbsup:",@":thumbsdown:",@":clap:",@":point_right:",@":point_left:"];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    [AVAnalytics beginLogPageView:@"CheatView"];
    [MobClick beginLogPageView:@"CheatView"];
    
}

- (void)viewDidAppear:(BOOL)animated
{

    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"CheatView"];
    [AVAnalytics endLogPageView:@"CheatView"];
    //获取未读消息
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"]mutableCopy];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
    
    for (NSDictionary *dic in array1) {
        
        if ([[dic objectForKey:@"clientId"]isEqualToString:self.objectId]&&[[dic objectForKey:@"jdId"]isEqualToString:[NSString stringWithFormat:@"%@",self.jdId]]) {
            
            [array removeObject:dic];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"messageArr"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"object:self.keyboardField];
}
- (void)registerForKeyboardNotifications
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    if ([currentRole isEqualToString:@"1"]) {
        self.sendType = @"send";
    }else{
        self.sendType = @"require";
    }
    if ([self.rsId isKindOfClass: [NSString class]]) {
        self.rsId = [NSNumber numberWithInteger:self.rsId.integerValue];
    }
    
    if ([self.jdId isKindOfClass:[NSString class]]) {
        self.jdId = [NSNumber numberWithInteger:self.jdId.integerValue];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
    NSString *plistPath = [path stringByAppendingPathComponent:@"emoji.plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
    self.otherLookArr = arr;
    UIImage *um = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"001.png"]];
    
    
    
    if (self.rsId == nil && [[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
        self.rsId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"];
        self.rsId = [NSNumber numberWithInteger:self.rsId.integerValue];
    }

    // 手势用来回收键盘
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    
    self.tapGesture.numberOfTapsRequired = 1;
    
//    [self.view addGestureRecognizer:self.tapGesture];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    
    titleLabel.text = self.title;
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    self.navigationItem.titleView = titleLabel;
    
    NSLog(@"%@",[AVUser currentUser].objectId);
    NSArray * array = [FMDBMessages getMessageFromDB:self.objectId rid:[AVUser currentUser].objectId jd:[NSString stringWithFormat:@"%@", self.jdId] count:self.messageCount sendType:self.sendType];
    
    [self.mesArr removeAllObjects];
//    NSString *sendType =  ([self.sendType isEqualToString:@"send"]?@"require":@"send");
    for (MyMessage *message in array) {
        
        [self.mesArr insertObject:message atIndex:0];
        if ([message.sendType isEqualToString:@"send"]) {
            self.hasDone = YES;
        }
        if ([message.sendType isEqualToString:@"require"]) {
            self.hasDone = YES;
        }
        if (message.type == 5) {
            self.hasDone = YES;
        }
    }
    NSArray *jdArr = [FMDBMessages getHeaderJDMessagejd:[NSString stringWithFormat:@"%@",self.jdId] rsId:[NSString stringWithFormat:@"%@", self.rsId]];
    
    if (jdArr.count > 0) {
        
        [self.mesArr insertObject:[jdArr firstObject] atIndex:0];
    }
    
#pragma mark --------  刷新
    if (self.messageArr.count==0) {
        [self.cheatTableView reloadData];
    }else
    {
        [self.cheatTableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:self.messageArr.count  inSection:0] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMainMessage:) name:@"message" object:nil];
    
    if (self.jdDic != nil  && (jdArr.count == 0 || jdArr == nil)) {
        
        
        
        NSString *messageStr;
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
            
            messageStr = [NSString stringWithFormat:@"您好，我对您发布的%@很感兴趣，想和您聊聊，期待您的回复",[self.jdDic objectForKey:@"title"]];
        }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"])
        {
            messageStr = [NSString stringWithFormat:@"您好，我是%@的%@%@，看了您的信息，想和您聊聊，期待您的回复",[[self.jdDic objectForKey:@"cp"]objectForKey:@"name"],[[self.jdDic  objectForKey:@"user"]objectForKey:@"title"], [[self.jdDic objectForKey:@"user"]objectForKey:@"name"]];
        }
        self.client = [AVIMClient defaultClient];
        
        [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
            
            [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
                
                [attributes setObject:self.jdId forKey:@"jdId"];
                
                [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                    
                    [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                    
                    
                }else{
                    [attributes setObject:self.rsId forKey:@"rsId"];
                }
                [attributes setObject:@"1" forKey:@"type"];
                
                AVIMTextMessage *message = [AVIMTextMessage messageWithText:messageStr attributes:attributes];
                
                [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                        
                        [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                        self.length = 0;
                        //                        [self.cheatTableView reloadData];
                        
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
                        [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.cheatTableView endUpdates];
                        
                        
                        
                        NSDictionary *attributes = message.attributes;
                        NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                        //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                        [conDic setObject:self.objectId forKey:@"yourId"];
                        [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                        [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                        [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                        [conDic setObject:message.text forKey:@"lastText"];
                        [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                        [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
                        
                        
                        
                        AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
                        
                        [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                            if (error) {
                                
                                return ;
                            }
                            NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                            NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                            
                            
                            if (name == nil) {
                                [conDic setObject:@"" forKey:@"name"];
                            }else{
                                [conDic setObject:name forKey:@"name"];
                            }
                            if (header != nil) {
                                
                                [conDic setObject:header forKey:@"header"];
                            }
                            
                            [FMDBMessages judgeConversationExist:conDic];
                            
                            
                            
                        }];
                        
                        if (self.mesArr.count > 0) {
                            
                            
                            [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                }];
            }];
        }];
        [self doSomeThingJD];
        
    }
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    
    [AVOSCloud setAllLogsEnabled:YES];
    
    [self createCheatView];
    
    [self createKeyBoardView];
    [self.cheatTableView layoutIfNeeded];
    

//    self.cheatTableView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    if (self.cheatTableView.contentSize.height > self.view.frame.size.height) {
        self.cheatTableView.contentOffset = CGPointMake(0, self.cheatTableView.contentSize.height);
        
    }
    if ([self.jdId isEqualToNumber:self.rsId]) {
        UILabel *wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width - 40, 35)];
        wxLabel.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        wxLabel.text = @"微信用户,仅限沟通";
        wxLabel.textColor = [UIColor whiteColor];
        wxLabel.layer.cornerRadius = 7;
        wxLabel.layer.masksToBounds = YES;
        wxLabel.font = [UIFont systemFontOfSize:16];
        wxLabel.textAlignment = 1;
        [self.view addSubview:wxLabel];
        
    }else{
//    [self createBtn];
//    [self createGuideView];
    }
    
//    [self judgeEmail];
}
- (void)sendCommonWord:(NSString *)messageStr
{
    
        
        
        
    
        self.client = [AVIMClient defaultClient];
        
        [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
            
            [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
                
                [attributes setObject:self.jdId forKey:@"jdId"];
                
                [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                    
                    [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                    
                    
                }else{
                    [attributes setObject:self.rsId forKey:@"rsId"];
                }
                [attributes setObject:@"1" forKey:@"type"];
                
                AVIMTextMessage *message = [AVIMTextMessage messageWithText:messageStr attributes:attributes];
                
                [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                        
                        [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                        self.length = 0;
                        //                        [self.cheatTableView messageStrreloadData];
                        
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
                        [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.cheatTableView endUpdates];
                        
                        
                        
                        NSDictionary *attributes = message.attributes;
                        NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                        //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                        [conDic setObject:self.objectId forKey:@"yourId"];
                        [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                        [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                        [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                        [conDic setObject:message.text forKey:@"lastText"];
                        [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                        [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
                        
                        
                        
                        AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
                        
                        [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                            if (error) {
                                
                                return ;
                            }
                            NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                            NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                            
                            
                            if (name == nil) {
                                [conDic setObject:@"" forKey:@"name"];
                            }else{
                                [conDic setObject:name forKey:@"name"];
                            }
                            if (header != nil) {
                                
                                [conDic setObject:header forKey:@"header"];
                            }
                            
                            [FMDBMessages judgeConversationExist:conDic];
                            
                            
                            
                        }];
                        
                        if (self.mesArr.count > 0) {
                            
                            
                            [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                }];
            }];
        }];
    
        
    
}
- (void)removeGuide
{
    [self.guideView removeFromSuperview];
}
- (void)createGuideView
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"GuideUser"]) {
        self.guideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.guideView.backgroundColor = [UIColor clearColor];
        [self.guideView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGuide)]];
        
        
        CGRect rect = self.view.bounds;
        
        CGRect holeRection = CGRectMake(18, 60, 130, 40);
        
        
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
        
        
        
        UIImageView *handImage = [[UIImageView alloc]initWithFrame:CGRectMake(65, 110, 256, 170)];
    
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    if ([currentRole isEqualToString:@"2"]) {
        handImage.image = [UIImage imageNamed:@"guideBoss.png"];
    }else{
        handImage.image = [UIImage imageNamed:@"guideUser.png"];
    }
    [self.guideView addSubview:handImage];
        
        //        UILabel *strLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 75, self.view.frame.size.width - 160, 100)];
        //        NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc]initWithString:@"嫌手机发布职位麻烦?点击按钮扫码登录电脑端操作"];
        //        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, searchStr.length)];
        //        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(16, 4)];
        //        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(21, 4)];
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
        //        [self.backView addSubview:strLabel];
        
        
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:self.guideView];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"GuideUser"];
        
    }
}



// 回收键盘
- (void)handleTap
{
    [self.keyboardField resignFirstResponder];
}

- (void)receiveMainMessage:(NSNotification *)n
{
    AVIMTypedMessage *message = [n object];
    
    if ([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"jdId"]]isEqualToString:[NSString stringWithFormat:@"%@",self.jdId]] && ![[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"0"]) {
        
        if (message!= nil && self.objectId!= nil && [AVUser currentUser].objectId != nil) {
            
        
        [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:self.objectId rid:[AVUser currentUser].objectId]];
        
        self.length = 0;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
        
        [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.cheatTableView endUpdates];
        [self scrollViewToBottom:NO];
        }
    }
    
}

//pip:bug-fixed #5
- (void)scrollViewToBottom:(BOOL)animated {
    
    if ([self.mesArr count] > 0) {
        
        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.mesArr count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)cheatSomeThing:(NSInteger)b
{
    AVIMKeyedConversation *conver = [UserSaveTool getLocalConversation:[AVUser currentUser].objectId client:self.objectId] ;
    
    if (conver == nil) {
        [self connectConversation];
        
        
    }else{
        
        AVIMClient *client = [[AVIMClient alloc]initWithClientId:[AVUser currentUser].objectId tag:nil];
        
        AVIMConversation *conversation = [client conversationWithKeyedConversation:conver];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[conversation queryMessagesFromCacheWithLimit:b]];
        
        NSInteger a = 0;
        
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];
        
        NSMutableArray *headerArr = [NSMutableArray array];
        
        [headerArr removeAllObjects];
        
        for (AVIMTypedMessage*message in arr) {
            NSString *jdId = [NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"jdId"]];
            
            NSString *type = [NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]];
            
            if ([type isEqualToString:@"0"] && [jdId isEqualToString:[self.jdDic objectForKey:@"id"]]) {
                a = a + 1;
                
                [headerArr addObject:message];
            }
            if ([type isEqualToString:@"0"] && [jdId isEqualToString:[self.jdDic objectForKey:@"id"]] && a > 1) {
                
                [headerArr addObject:message];
            }
        }
        for (AVIMTypedMessage *message in headerArr) {
            
            [arr1 removeObject:message];
        }
        if (a == 0) {
            [self connectConversation];
        }else {
            if (headerArr.count!= 0) {
                
                
                [arr1 insertObject:[headerArr lastObject] atIndex:0];
            }
            
            AVIMTypedMessage *mes = [arr1 lastObject];
            
            self.messageArr =  [self sortMessages:(NSMutableArray *)arr1];
            
            self.length = 0;
            
#pragma mark ------- 刷新
            if (self.messageArr.count==0) {
                [self.cheatTableView reloadData];
            }else
            {
                [self.cheatTableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:self.messageArr.count  inSection:0] withRowAnimation:UITableViewRowAnimationNone];
            }
            
//            self.cheatTableView.contentSize = CGSizeMake(self.view.frame.size.width, [self judgeContentSize] + 49);
            if (self.messageCount == 10) {
                
                
//                self.cheatTableView.contentOffset = CGPointMake(0, [self judgeContentSize] + 49);
            }
//
        }
        
    }
}


- (void)startCheat:(NSInteger)a
{
    [self cheatSomeThing:a];
}
//对信息进行筛选
- (NSMutableArray *)sortMessages:(NSMutableArray *)arr
{
    NSMutableArray *messagesArr = [NSMutableArray array];
    for (AVIMTypedMessage *message in arr) {
        if ([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"jdId"]]isEqualToString:[self.jdDic objectForKey:@"id"]] ) {
            [messagesArr addObject:message];
        }
    }
    
    return messagesArr;
}
- (void)receiveMessages
{
    
    self.receiveClient = [[AVIMClient alloc]init];
    self.receiveClient.delegate = self;
    [self.receiveClient openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        
    }];
}
- (void)closeMessages
{
    [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
        
    }];
}
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message
{
    if ([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"jdId"]]isEqualToString:[self.jdDic objectForKey:@"id"]] && ![[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"0"]) {
        [self.messageArr addObject:message];
        self.length = 0;
        
#pragma mark ---------- 刷新
        if (self.messageArr.count==0) {
            [self.cheatTableView reloadData];
        }else
        {
            [self.cheatTableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:self.messageArr.count  inSection:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
//        self.cheatTableView.contentSize = CGSizeMake(self.view.frame.size.width, [self judgeContentSize] + 49);
//        self.cheatTableView.contentOffset = CGPointMake(0, [self judgeContentSize] + 49);
        
        AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
        
        [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (error) {
         
                return ;
            }
            
            [JudgeCreateCheatWindow judgeConversationExist:message objectId:self.objectId jdDic:self.jdDic userDic:[object objectForKey:@"localData"]state:[message.attributes objectForKey:@"bossOrWorker"]];
            
        }];
        
    }else{
        //???
    }
}
- (void)doSomeThingJD
{
    self.client = [[AVIMClient alloc]initWithClientId:[AVUser currentUser].objectId];
    
    [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            AVIMKeyedConversation *keyedConversation = [conversation keyedConversation];
            [UserSaveTool saveConversationToLocal:keyedConversation user:[AVUser currentUser].objectId client:self.objectId];

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([NSNumber numberWithInt:[[self.jdDic objectForKey:@"id"]intValue]]) {
                
                [dic setObject:[NSNumber numberWithInt:[[self.jdDic objectForKey:@"id"]intValue]] forKey:@"jdId"];
            }
            if ([self.jdDic objectForKey:@"sub_category"]) {
                
                [dic setObject:[self.jdDic objectForKey:@"sub_category"] forKey:@"category"];
            }
            
            if ([self.jdDic objectForKey:@"salary"]) {
                
                [dic setObject:[self.jdDic objectForKey:@"salary"] forKey:@"salary"];
            }
            if ([self.jdDic objectForKey:@"title"] ) {
                
                [dic setObject:[self.jdDic objectForKey:@"title"] forKey:@"title"];
            }
            if ([self.jdDic objectForKey:@"city"]) {
                
                [dic setObject:[self.jdDic objectForKey:@"city"] forKey:@"city"];
            }
            if ([self.jdDic objectForKey:@"work_year"]) {
                
                [dic setObject:[self.jdDic objectForKey:@"work_year"] forKey:@"workYear"];
            }
            if ([self.jdDic objectForKey:@"education"]) {
                
                [dic setObject:[self.jdDic objectForKey:@"education"] forKey:@"education"];
            }
            if ([[self.jdDic objectForKey:@"cp"]objectForKey:@"sub_name"]) {
                
                [dic setObject:[[self.jdDic objectForKey:@"cp"]objectForKey:@"sub_name"]forKey:@"subCpName"];
            }
            
            if ([[self.jdDic objectForKey:@"user"]objectForKey:@"title"]) {
                
                [dic setObject:[[self.jdDic objectForKey:@"user"]objectForKey:@"title"] forKey:@"bossTitle"];
            }
            if ([[self.jdDic objectForKey:@"user"]objectForKey:@"avatar"]) {
                
                [dic setObject:[[self.jdDic objectForKey:@"user"]objectForKey:@"avatar"] forKey:@"avatar"];
            }
         //New Update
         //rsName rsAvatar rsCity rsWork_year rsEdu rsSummary rsSex rsSalary
            
            
            if ([[self.rsDic objectForKey:@"user"]objectForKey:@"name"]) {
                
                [dic setObject:[[self.rsDic objectForKey:@"user"]objectForKey:@"name"] forKey:@"rsName"];
            }
            if ([[self.rsDic objectForKey:@"user"]objectForKey:@"avatar"]) {
                
                [dic setObject:[[self.rsDic objectForKey:@"user"]objectForKey:@"avatar"] forKey:@"rsAvatar"];
            }
            
            if ([self.rsDic objectForKey:@"city"]) {
                
                [dic setObject:[self.rsDic objectForKey:@"city"] forKey:@"rsCity"];
            }
            if ([self.rsDic objectForKey:@"work_year"] ) {
                
                [dic setObject:[self.rsDic objectForKey:@"work_year"] forKey:@"rsWork_year"];
            }
            if ([[self.rsDic objectForKey:@"user"] objectForKey:@"highest_edu"]) {
                [dic setObject:[[self.rsDic objectForKey:@"user"] objectForKey:@"highest_edu"] forKey:@"rsEdu"];
                
            }
            if ([self.rsDic objectForKey:@"self_summary"]) {
                [dic setObject:[self.rsDic objectForKey:@"self_summary"] forKey:@"rsSummary"];
                
            }
            if ([[self.rsDic objectForKey:@"user"] objectForKey:@"sex"]) {
                [dic setObject:[[self.rsDic objectForKey:@"user"] objectForKey:@"sex"] forKey:@"rsSex"];
                
            }
            if ([self.rsDic objectForKey:@"salary"]) {
                
                [dic setObject:[self.rsDic objectForKey:@"salary"] forKey:@"rsSalary"];
            }
            
            
            
            
            
            
            
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:[NSNumber numberWithInt:0] forKey:@"type"];
            [attributes setObject:[NSNumber numberWithInt:[[self.jdDic objectForKey:@"id"]intValue]] forKey:@"jdId"];
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                
                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
            }else{
                [attributes setObject:self.rsId forKey:@"rsId"];
            }
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:str attributes:attributes];
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
//                [FMDBMessages saveMessage:message];
                [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                MyMessage *jdMessage = [[MyMessage alloc]init];
                jdMessage.bossOrWorker = [[message.attributes objectForKey:@"bossOrWorker"]integerValue];
                jdMessage.jdId = [[message.attributes objectForKey:@"jdId"]integerValue];
                jdMessage.rsId = [[message.attributes objectForKey:@"rsId"]integerValue];
                jdMessage.type = [[message.attributes objectForKey:@"type"]integerValue];
                jdMessage.text = message.text;
                jdMessage.mediaType = message.mediaType;
                jdMessage.sendId = [AVUser currentUser].objectId;
                jdMessage.receiveId = message.clientId;
                jdMessage.timeStamp = message.sendTimestamp;
                jdMessage.status = message.status;
                if (jdMessage!=nil) {
                    
                    [self.mesArr insertObject:jdMessage atIndex:0];
                }
                
                [self.cheatTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.cheatTableView endUpdates];
            }];
        }];
    }];
    
}
//rsName rsAvatar rsCity rsWork_year rsEdu rsSummary rsSex rsSalary
- (void)connectConversation
{
    self.client = [[AVIMClient alloc]initWithClientId:[AVUser currentUser].objectId];
    [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            AVIMKeyedConversation *keyedConversation = [conversation keyedConversation];
            BOOL a =  [UserSaveTool saveConversationToLocal:keyedConversation user:[AVUser currentUser].objectId client:self.objectId];

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithInt:[[self.jdDic objectForKey:@"id"]intValue]] forKey:@"jdId"];
            [dic setObject:[self.jdDic objectForKey:@"sub_category"] forKey:@"category"];
            [dic setObject:[self.jdDic objectForKey:@"salary"] forKey:@"salary"];
            [dic setObject:[self.jdDic objectForKey:@"title"] forKey:@"title"];
            [dic setObject:[self.jdDic objectForKey:@"city"] forKey:@"city"];
            [dic setObject:[self.jdDic objectForKey:@"work_year"] forKey:@"workYear"];
            [dic setObject:[self.jdDic objectForKey:@"education"] forKey:@"education"];
            [dic setObject:[[self.jdDic objectForKey:@"cp"]objectForKey:@"sub_name"]forKey:@"subCpName"];
            [dic setObject:[[self.jdDic objectForKey:@"user"]objectForKey:@"title"] forKey:@"bossTitle"];
            [dic setObject:[[self.jdDic objectForKey:@"user"]objectForKey:@"avatar"] forKey:@"avatar"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:[NSNumber numberWithInt:0] forKey:@"type"];
            [attributes setObject:[NSNumber numberWithInt:[[self.jdDic objectForKey:@"id"]intValue]] forKey:@"jdId"];
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
            
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                
                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
            }else{
                [attributes setObject:self.rsId forKey:@"rsId"];
            }
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:str attributes:attributes];
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                [self.messageArr addObject:message];
                self.length = 0;
                
#pragma mark ------------ 刷新
                if (self.messageArr.count==0) {
                    [self.cheatTableView reloadData];
                }else
                {
                    [self.cheatTableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:self.messageArr.count  inSection:0] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                
//                self.cheatTableView.contentSize = CGSizeMake(self.view.frame.size.width, [self judgeContentSize] + 49);
//                self.cheatTableView.contentOffset = CGPointMake(0, [self judgeContentSize] + 49);
                [self startCheat:self.messageCount];
            }];
        }];
    }];
}
#pragma -------创建tableView
- (void)createCheatView
{
    
    self.cheatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)  style:UITableViewStylePlain];
    self.cheatTableView.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    self.cheatTableView.delegate = self;
    self.cheatTableView.dataSource = self;
    
    self.cheatTableView.delaysContentTouches = NO;
    self.cheatTableView.showsHorizontalScrollIndicator = NO;
    self.cheatTableView.showsVerticalScrollIndicator = NO;
    self.cheatTableView.estimatedRowHeight = 200;
    self.cheatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.cheatTableView.contentSize = CGSizeMake(self.view.frame.size.width, [self judgeContentSize] + 49);
//    self.cheatTableView.contentOffset = CGPointMake(0, [self judgeContentSize] + 49);

    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    normalHeader.stateLabel.textColor = [UIColor whiteColor];
    normalHeader.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
//    self.cheatTableView.header = normalHeader;
    
//    [self.cheatTableView.header endRefreshing];
    [self.view addSubview:self.cheatTableView];
    
    
   
    
    
}
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (BOOL)judgeEmail
{
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"] isEqualToString:@"2"]) {
        
    
    NSString *email;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"email"]) {
        email = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"email"];
    }
    

    if (email.length == 0 || email == nil) {
        [self createEnterEmailView];
        return NO;
    }else{
        return YES;
    }
    }else{
        return YES;
    }
}

- (void)removeView:(UITapGestureRecognizer *)tap
{
    [self.backView removeFromSuperview];

}
- (void)createEnterEmailView
{
    
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.backView.userInteractionEnabled = YES;
    [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)]];
    [self.view addSubview:self.backView];
    
    
    UIView *enterView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 280) / 2 , 120, 280, 180)];
    enterView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:enterView];
    
    
    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    titleImg.image = [UIImage imageNamed:@"email.png"];
    titleImg.center = CGPointMake(280 / 2, 0);
    [enterView addSubview:titleImg];
    
    
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(15, 40, 280 - 30, 30)];
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.placeholder = @"请填写您的企业邮箱";
    [self.emailField setValue:[UIColor colorFromHexCode:@"#bbb"] forKeyPath:@"_placeholderLabel.textColor"];
    self.emailField.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [enterView addSubview:self.emailField];
    
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 30.0f, self.emailField.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor colorFromHexCode:@"bbb"].CGColor;
    [self.emailField.layer addSublayer:TopBorder];
    
    NSString *textLabelStr;
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    if ([currentRole isEqualToString:@"2"]) {
       textLabelStr = @"对方同意后,简历会发到这个邮箱\n您可以在个人信息中修改简历";
    }else{
        textLabelStr = @"输入邮箱后,将会把简历发送到这个邮箱\n您可以在个人信息中修改邮箱";
    }
    
    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc]initWithString:textLabelStr];
    [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, searchStr.length)];
    //        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(14, 6)];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.lineSpacing = 5;   //行高
    
    
    [searchStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, searchStr.length)];
    [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:18]objectAtIndex:1] range:NSMakeRange(0, searchStr.length)];
    

    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, 280 - 30, 50)];
    textLabel.attributedText = searchStr;
    textLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
    textLabel.textColor = [UIColor colorFromHexCode:@"999"];
    textLabel.numberOfLines = 0;
    [enterView addSubview:textLabel];
    
    UIButton *saveEmailBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 135, 280 - 30 , 30)];
    [saveEmailBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveEmailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveEmailBtn.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [saveEmailBtn addTarget:self action:@selector(saveEmail) forControlEvents:UIControlEventTouchUpInside];
    saveEmailBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [enterView addSubview:saveEmailBtn];
    
}
- (void)saveEmail
{
    if (![self isValidateEmail:self.emailField.text]) {
        
    }else{
        self.manager = [AFHTTPRequestOperationManager manager];
    
        [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
    
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
    
                NSString *url = @"http://api.zzd.hidna.cn/v1/resume/saveEmail";
    
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
                [parameters setObject:time forKey:@"timestamp"];
    
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
    
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
    
                [parameters setObject:self.emailField.text forKey:@"email"];
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"bossId"];
                [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
    
                [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]];
                    [dic setObject:self.emailField.text forKey:@"email"];
                    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"user"];
                    [self removeView:nil];
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    [self removeView:nil];
                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }
}
- (void)refreshHeader
{
    NSInteger count = self.messageCount;
//    NSInteger len = [self judgeContentSize];
    self.messageCount = self.messageCount + 10;
    NSInteger dbCount = self.dbMesCount;
    NSArray *arr = [FMDBMessages getMessageFromDB:self.objectId rid:[AVUser currentUser].objectId jd:[NSString stringWithFormat:@"%@",self.jdId] count:self.messageCount sendType:self.sendType];
    self.dbMesCount = arr.count;
    [self.mesArr removeAllObjects];
    for (MyMessage *message in arr) {
        [self.mesArr insertObject:message atIndex:0];
    }
    
    NSArray *jdArr = [FMDBMessages getHeaderJDMessagejd:[NSString stringWithFormat:@"%@",self.jdId] rsId:[NSString stringWithFormat:@"%@", self.rsId]];
    if (jdArr.count > 0) {
        [self.mesArr insertObject:[jdArr firstObject] atIndex:0];
    }
    self.cheatTableView.scrollEnabled = NO;
#pragma mark ------- 刷新
    if (self.messageArr.count==0) {
        [self.cheatTableView reloadData];
    }else
    {
//        [self.cheatTableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:self.messageArr.count  inSection:0] withRowAnimation:UITableViewRowAnimationNone];
        
        NSMutableArray *indexArr = [NSMutableArray array];
        for (int i = 0 ; i< self.messageCount - count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArr addObject:indexPath];
        }
        [self.cheatTableView insertRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
        [self.cheatTableView endUpdates];
        
    }
    
    
    [self.cheatTableView.header endRefreshing];
    if (self.dbMesCount == dbCount) {
        
    }else{
    if (self.mesArr.count > 15) {
        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:15  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else if (self.mesArr.count > 10) {
        
        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    }
    self.cheatTableView.scrollEnabled = YES;
    

}
- (void)createKeyBoardView
{
    
    [self.albumView removeFromSuperview];
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49);
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    
    
    
    self.keyboardView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49)];
    self.keyboardView.backgroundColor = [UIColor colorFromHexCode:@"f7f7f7"];
    [self.view addSubview:self.keyboardView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#dddddd"];
    [self.keyboardView addSubview:lineView];
    self.keyBoardBackView = [[UIView alloc]initWithFrame:CGRectMake(70, 5, self.view.frame.size.width - 49 * 3 + 28, 49 - 5 * 2)];
    self.keyBoardBackView.layer.masksToBounds = YES;
    self.keyBoardBackView.layer.borderColor = [UIColor colorFromHexCode:@"#dddddd"].CGColor;
    self.keyBoardBackView.layer.borderWidth = 0.8;
    self.keyBoardBackView.layer.cornerRadius = 7;
    self.keyBoardBackView.backgroundColor = [UIColor whiteColor];
    [self.keyboardView addSubview:self.keyBoardBackView];
    
    self.keyboardField = [[UITextView_PrintField alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 49 * 3 + 18, 49 - 10 * 2)];
//    self.keyboardField.layer.masksToBounds = YES;
//    self.keyboardField.layer.borderColor = [UIColor colorFromHexCode:@"#dddddd"].CGColor;
//    self.keyboardField.layer.borderWidth = 0.8;
//    self.keyboardField.layer.cornerRadius = 7;
    self.keyboardField.delegate = self;
    self.keyboardField.bounces = NO;
    self.keyboardField.showsVerticalScrollIndicator = NO;
    self.keyboardField.showsHorizontalScrollIndicator = NO;
//    self.keyboardField.backgroundColor = [UIColor redColor];
    self.keyboardField.contentInset = UIEdgeInsetsMake(-4, 4, 0, 0);
    self.keyboardField.returnKeyType = UIReturnKeySend;
    self.keyboardField.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    [self.keyBoardBackView addSubview:self.keyboardField];
    
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextViewTextDidChangeNotification"object:self.keyboardField];
    
    
//    self.speakImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 49 - 10 * 2, 49 - 10 * 2)];
//    self.speakImage.image = [UIImage imageNamed:@"icon_yy.png"];
//
//    self.speakImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *speakTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(speak)];
//    if ([self.rsId isEqualToNumber:self.jdId]) {
//
//    }else{
//    [self.speakImage addGestureRecognizer:speakTap];
//    }
//    [self.keyboardView addSubview:self.speakImage];
    
    self.commonWordBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 11, 55, 49 - 11 * 2)];
//    self.commonWordBtn.layer.cornerRadius = 7;
//    [self.commonWordBtn setTitle:@"常用语" forState:UIControlStateNormal];
//    [self.commonWordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.commonWordBtn.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
//    self.commonWordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.commonWordBtn setImage:[UIImage imageNamed:@"常用语.png"] forState:UIControlStateNormal];
    [self.commonWordBtn addTarget:self action:@selector(commonWordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardView addSubview:self.commonWordBtn];
    
//    UIImageView *lookImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 * 2 + 16, 10, 49 - 10 * 2, 49 - 10 * 2)];
//    lookImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *lookTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(look)];
//    if ([self.rsId isEqualToNumber:self.jdId]) {
//
//    }else{
//    [lookImage addGestureRecognizer:lookTap];
//    }
//    lookImage.image = [UIImage imageNamed:@"icon_bq.png"];
//    //    lookImage.backgroundColor = [UIColor blackColor];
//    [self.keyboardView addSubview:lookImage];
    
    
    self.addImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 + 12, 12, 49 - 2 * 12, 49 - 12 * 2)];
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(add)];
    self.addImage.userInteractionEnabled = YES;
    if ([self.rsId isEqualToNumber:self.jdId]) {
        
    }else{
    [self.addImage addGestureRecognizer:addTap];
    }
    self.addImage.image = [UIImage imageNamed:@"+234.png"];
    //    addImage.backgroundColor = [UIColor blackColor];
    [self.keyboardView addSubview:self.addImage];
    
}
- (void)commonWordAction
{
    if (self.commonWordView.superview != nil) {
        [self.keyboardField becomeFirstResponder];
    }else{
    NSString *url = @"http://api.zzd.hidna.cn/v1/user/getComLang";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    
    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"] isEqualToString:@"0"]) {
                self.commonWordArr = [responseObject objectForKey:@"data"];
                
                [self.commonWordView removeFromSuperview];
                [self.commonWordScroll removeFromSuperview];
                [self.mainView removeFromSuperview];
                [self.speakButton removeFromSuperview];
                [self.returnToTextImage removeFromSuperview];
                [self.keyboardView removeFromSuperview];
                [self createKeyBoardView];
                
                
                [self.keyboardField resignFirstResponder];
                self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 2 / 7 - 49, self.view.frame.size.width, self.keyboardField.frame.size.height + 20);
                self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 50 - self.view.frame.size.width * 2 / 7 - 49);
                
                
                
                    self.commonWordView = [[UIView alloc]initWithFrame:CGRectMake(0, self.keyboardView.frame.origin.y + self.keyboardView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height * 2 / 7 )];
                    self.commonWordView.backgroundColor = [UIColor whiteColor];
                    [self.view addSubview:self.commonWordView];
                    self.commonWordScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 2 / 7 )];
                    self.commonWordScroll.backgroundColor = [UIColor whiteColor];
                    CGFloat scrollSizeHeight = 0;
                    for (int i = 0; i < self.commonWordArr.count; i++) {
                        UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 * i, self.view.frame.size.width - 40, 50)];
                        wordLabel.textAlignment = 1;
                        wordLabel.text = [[self.commonWordArr objectAtIndex:i]objectForKey:@"message"];
                        wordLabel.numberOfLines = 0;
                        wordLabel.textColor = [UIColor colorFromHexCode:@"666"];
                        wordLabel.userInteractionEnabled = YES;
                        [wordLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCommonStr:)]];
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:wordLabel.text];
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setLineSpacing:4];
                        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [wordLabel.text length])];
                        wordLabel.attributedText = attributedString;
                        wordLabel.font = [UIFont systemFontOfSize:14];
                        [self.commonWordScroll addSubview:wordLabel];
                        
                        CGSize labelSize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 40 label:wordLabel];
                        wordLabel.frame = CGRectMake(20, scrollSizeHeight, self.view.frame.size.width - 40, labelSize.height + 25);
                        scrollSizeHeight = scrollSizeHeight + labelSize.height + 25;
                        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, scrollSizeHeight - 1, self.view.frame.size.width - 40, 0.5)];
                        lineView.backgroundColor = [UIColor colorFromHexCode:@"ddd"];
                        [self.commonWordScroll addSubview:lineView];
                        
                        
                        
                    [self.commonWordView addSubview:self.commonWordScroll];
                }
                        self.commonWordScroll.contentSize = CGSizeMake(self.view.frame.size.width, scrollSizeHeight + 30);
                
                
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    }
}
- (void)sendCommonStr:(UITapGestureRecognizer *)tap
{
    UILabel *label = tap.view;
//    [self sendCommonWord:label.text];
    self.keyboardField.text = label.text;
    self.sendStr = label.text;
    [self.keyboardField becomeFirstResponder];
    
}
- (void)speak
{
    [self.mainView removeFromSuperview];
    [self.keyboardField resignFirstResponder];
    [self.albumView removeFromSuperview];
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    self.keyboardField.frame = CGRectMake(5, 5, self.view.frame.size.width - 49 * 3 + 18, 49 - 10 * 2);
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    
    
    self.speakButton = [[UIButton alloc]initWithFrame:self.keyBoardBackView.frame];
    //    self.speakButton.backgroundColor = [UIColor blackColor];
    self.speakButton.layer.masksToBounds = YES;
    self.speakButton.layer.cornerRadius = 7;
    self.speakButton.layer.borderColor = [UIColor colorFromHexCode:@"#cccccc"].CGColor;
    self.speakButton.layer.borderWidth = 0.8;
    self.speakButton.backgroundColor = [UIColor colorFromHexCode:@"#f7f7f7"];
    
    [self.speakButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.speakButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [self.speakButton addTarget:self action:@selector(recordBtnDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.speakButton addTarget:self action:@selector(recordBtnDidTouchDragExit) forControlEvents:UIControlEventTouchDragExit];
    [self.speakButton addTarget:self action:@selector(recordBtnDidTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.speakButton addTarget:self action:@selector(recordBtnDidTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.speakButton addTarget:self action:@selector(recordBtnDidTouchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    self.speakButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.speakButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.keyboardView addSubview:self.speakButton];
    
    
    
    self.returnToTextImage = [[UIImageView alloc]initWithFrame:self.speakImage.frame];
    self.returnToTextImage.image = [UIImage imageNamed:@"icon_jp.png"];
    self.returnToTextImage.userInteractionEnabled = YES;
    self.returnToTextImage.backgroundColor = [UIColor colorFromHexCode:@"#f7f7f7"];
    UITapGestureRecognizer *returnTextTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnText)];
    [self.returnToTextImage addGestureRecognizer:returnTextTap];
    [self.keyboardView addSubview:self.returnToTextImage];
    
    self.myRecorder = [[MyRecorder alloc]init];
    [self.myRecorder createAudioRecorder];
}
- (void)recordBtnDidTouchUpOutside
{
    self.speakButton.backgroundColor = [UIColor colorFromHexCode:@"#f7f7f7"];
    [self.myRecorder stopRecord];
    [self.speakTimer invalidate];
    [self.speakView removeFromSuperview];
    NSLog(@"TouchUpOutside");
    self.isOut = YES;
}
- (void)recordBtnDidTouchDragEnter
{
//    self.recordIm.image = [UIImage imageNamed:@"voice_0.png"];
    //    self.speakLabel.textColor = [UIColor whiteColor];
//    self.speakView.backgroundColor = [UIColor redColor];
    //    self.speakView.layer.borderWidth = 0;
    NSLog(@"TouchDragEnter");
    self.isOut = NO;
}
- (void)recordBtnDidTouchDragExit
{
    self.recordIm.image = [UIImage imageNamed:@"voice_cx.png"];
    
//    self.speakView.backgroundColor = [UIColor redColor];
    self.speakView.alpha = 1;
    
    NSLog(@"TouchDragExit");
    self.isOut = YES;
}
- (void)recordBtnDidTouchUpInside
{
    self.speakButton.backgroundColor = [UIColor colorFromHexCode:@"#f7f7f7"];
    [self.myRecorder stopRecord];
    
    [self.speakTimer invalidate];
    if (self.recordTime < 3.0) {
//        self.speakLabel.text = @"小于3秒无法发送";
//        self.speakLabel.font = [UIFont systemFontOfSize:15];
        self.recordIm.image = [UIImage imageNamed:@"voice_wrong.png"];
        [self performSelector:@selector(speakViewDisappear) withObject:nil afterDelay:1];
    }else{
        [self.speakView removeFromSuperview];
        
        [self sendAudioMessage];
    }
    
    NSLog(@"TouchUpInside");
}
- (void)speakViewDisappear
{
    [self.speakView removeFromSuperview];
}
- (void)sendAudioMessage
{
    self.client = [AVIMClient defaultClient];
    
    [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            
            
            NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *str = [array lastObject];
            NSString *path = [NSString stringWithFormat:@"%@/%@",str,@"record.wav"];
            AVFile *file = [AVFile fileWithName:@"record.wav" contentsAtPath:path];
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:self.jdId forKey:@"jdId"];
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                
                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
            }else{
                [attributes setObject:self.rsId forKey:@"rsId"];
            }
            
            AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:@"[语音]" file:file attributes:attributes];
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    
                    
                    [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                    
                    //                    [self.messageArr addObject:message];
                    [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                    self.length = 0;
                    //                        [self.cheatTableView reloadData];
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
                    [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.cheatTableView endUpdates];

                    if (self.mesArr.count > 0) {
                        
                    
                    [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                    
                    NSDictionary *attributes = message.attributes;
                    NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                    //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                    [conDic setObject:self.objectId forKey:@"yourId"];
                    [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                    [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                    [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                    [conDic setObject:message.text forKey:@"lastText"];
                    [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                    [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
                    
                    
                    
                    AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
                    
                    [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (error) {
                            return ;
                        }
                        
                        NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                        NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                        
                    
                        [conDic setObject:name forKey:@"name"];
                        [conDic setObject:header forKey:@"header"];
                        
                        [FMDBMessages judgeConversationExist:conDic];
                        
                        
                        
                    }];
                    
                }
            }];
        }];
    }];
}
- (void)recordBtnDidTouchDown
{
    [self.speakView removeFromSuperview];
    
    
    
    [self.myRecorder startRecord];
    self.recordTime = 0;
    self.isOut = NO;
    self.speakView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, self.view.frame.size.height / 2 - 75, 150, 150)];
//    self.speakView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    self.speakView.layer.masksToBounds = YES;
//    self.speakView.layer.cornerRadius = 100;
    self.speakLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.speakView.frame.size.width / 2 - 70, 130, 140, 40)];
    self.speakLabel.textColor = [UIColor whiteColor];
    self.speakLabel.textAlignment = 1;
    self.speakLabel.font = [UIFont systemFontOfSize:25];
    self.speakLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.speakView];
//    [self.speakView addSubview:self.speakLabel];
    
    self.recordIm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.recordIm.image = [UIImage imageNamed:@"voice_0.png"];
    [self.speakView addSubview:self.recordIm];
    

    NSError *setCategoryError = nil;
    
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayAndRecord error: &setCategoryError];
    
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordTimer) userInfo:nil repeats:YES];
    
    
    self.speakTimer = timer;
    
    self.speakButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    NSLog(@"TouchDown");
}
- (void)recordTimer
{
    self.recordTime = self.recordTime + 0.1;
    
    
    CGFloat value = 8.0 - (- [self.myRecorder.myRecorder peakPowerForChannel:0]) / 20.0;

    if (self.isOut) {
        self.recordIm.image = [UIImage imageNamed:@"voice_cx.png"];
    }else{
    if (value >= 0 && value <= 2 ) {
        self.recordIm.image = [UIImage imageNamed:@"voice_0.png"];
    }else if(value >= 2.1 && value <= 5.5)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_1.png"];
    }else if (value >= 5.6 && value <= 5.8)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_2.png"];
    }else if(value >= 5.9 && value <= 6.1)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_3.png"];
    }else if (value >= 6.2 && value <= 6.4)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_4.png"];
    }else if (value >= 6.5 && value <= 6.7)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_5.png"];
    }else if (value >= 6.8 && value <= 7.1)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_6.png"];
    }else if (value >= 7.2 && value <= 7.5)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_7.png"];
    }else if (value >= 7.6 && value <= 8.0)
    {
        self.recordIm.image = [UIImage imageNamed:@"voice_8.png"];
    }
    }
//    if (self.isOut) {
//        self.recordIm.image = [UIImage imageNamed:@"voice_cx.png"];
//    }else{
//    self.recordIm.image = [UIImage imageNamed:[NSString stringWithFormat:@"voice_%.0lf.png",value]];
//    }
    [self.myRecorder.myRecorder updateMeters];
    self.speakLabel.text = [NSString stringWithFormat:@"%lf秒",self.recordTime];
    
}
- (void)returnText
{
    [self.speakButton removeFromSuperview];
    [self.returnToTextImage removeFromSuperview];
    [self.speakView removeFromSuperview];
    [self.keyboardField becomeFirstResponder];
    //    [self.myRecorder destructionRecordingFile];
    NSLog(@"return");
    [self changeTextViewHeight:self.keyboardField];
}
- (void)look
{
    NSLog(@"look");
    [self changeTextViewHeight:self.keyboardField];
    [self createLookView];
}
- (void)add
{
    NSLog(@"add");
    if ([UIImagePNGRepresentation(self.addImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"+键盘.png"])]) {
        self.addImage.image = [UIImage imageNamed:@"+234.png"];
        [self.keyboardField becomeFirstResponder];
        [self.speakButton removeFromSuperview];
        [self.returnToTextImage removeFromSuperview];
        [self.speakView removeFromSuperview];
    }else{
    [self createAddView];
    self.addImage.image = [UIImage imageNamed:@"+键盘.png"];
    }
}
- (void)createLookView
{
    
    
//    if (self.lookArrScroll == nil) {
    
    
    
    self.sendAttStr = [self.keyboardField.attributedText mutableCopy];
//    NSString*ste = self.keyboardField.text;
    [self.speakButton removeFromSuperview];
    [self.returnToTextImage removeFromSuperview];
    [self.keyboardField resignFirstResponder];
    [self.lookArrScroll removeFromSuperview];
    [self.otherLookArrScroll removeFromSuperview];
    [self.mainView removeFromSuperview];
    [self.keyboardView removeFromSuperview];
    [self createKeyBoardView];
    
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 3 / 7 - 49, self.view.frame.size.width, self.keyboardField.frame.size.height + 20);
//    [self changeTextViewHeight:self.keyboardField];
    self.keyboardField.attributedText = self.sendAttStr;
    if (self.mainView.superview == self.view) {
        
    }else{
        self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 3 / 7, self.view.frame.size.width, 50 + self.view.frame.size.width * 3 / 7)];
        self.mainView.backgroundColor = [UIColor whiteColor];
        
        [self createEmojiScroll];
        
        self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width * 3 / 7, self.view.frame.size.width, 20)];
        self.page.currentPageIndicatorTintColor = [UIColor zzdColor];
        self.page.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.page.backgroundColor = [UIColor whiteColor];
        self.page.numberOfPages = self.lookArr.count / 22 + 1;
        [_mainView addSubview:self.page];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width * 3 / 7 + 20, self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_mainView addSubview:lineView];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.width * 3 / 7 + 20.5, 80, 30)];
        
        sendButton.backgroundColor = [UIColor zzdColor];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
        [_mainView addSubview:sendButton];
        
        
        [self.view addSubview:_mainView];
        
    }
//    [UIView animateWithDuration:0.25 animations:^{
        self.cheatTableView.frame = CGRectMake(0,  0, self.view.frame.size.width, self.view.frame.size.height - self.mainView.frame.size.height - 49 );
    if (self.mesArr.count > 0) {
        
    
        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
//    }];
//    [self changeTextViewHeight:self.keyboardField];
    
    
    UIButton *changeEmojiBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.mainView.frame.size.height - 30, 30, 30)];
    changeEmojiBtn.tag = 774;
//    changeEmojiBtn.backgroundColor = [UIColor redColor];
    [changeEmojiBtn setImage:[UIImage imageNamed:@"bqax.png"] forState:UIControlStateNormal];
    changeEmojiBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [changeEmojiBtn addTarget:self action:@selector(changeEmojiScroll:) forControlEvents:UIControlEventTouchUpInside];
    changeEmojiBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.mainView addSubview:changeEmojiBtn];
    
    UIButton *changeOtherEmojiBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, self.mainView.frame.size.height - 30, 30, 30)];
//    changeOtherEmojiBtn.backgroundColor = [UIColor purpleColor];
    changeOtherEmojiBtn.tag = 775;
    [changeOtherEmojiBtn setImage:[UIImage imageNamed:@"bqbq.png"] forState:UIControlStateNormal];
    changeOtherEmojiBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [changeOtherEmojiBtn addTarget:self action:@selector(changeEmojiScroll:) forControlEvents:UIControlEventTouchUpInside];
    changeOtherEmojiBtn.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:changeOtherEmojiBtn];
//    }
}
- (void)changeEmojiScroll:(id)sender
{
    [self.otherLookArrScroll removeFromSuperview];
    [self.lookArrScroll removeFromSuperview];
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 774) {
        btn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        UIButton *btn2 = [self.view viewWithTag:775];
        btn2.backgroundColor = [UIColor clearColor];
        [self createEmojiScroll];
        self.page.numberOfPages = self.lookArr.count / 22 + 1;
    }else if(btn.tag == 775){
        btn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        UIButton *btn2 = [self.view viewWithTag:774];
        btn2.backgroundColor = [UIColor clearColor];
        [self createOtherEmojiScroll];
        self.page.numberOfPages = self.otherLookArr.count / 22 + 1;
    }
    self.page.currentPage = 0;
}
- (void)createEmojiScroll
{
    self.lookArrScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 3 / 7)];
    self.lookArrScroll.showsHorizontalScrollIndicator = NO;
    self.lookArrScroll.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.width * 3 / 7);
    self.lookArrScroll.pagingEnabled = YES;
    self.lookArrScroll.delegate = self;
    self.lookArrScroll.tag = 145;
    self.lookArrScroll.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:self.lookArrScroll];
    NSInteger a = 0;
    NSInteger b = 0;
    for (int i = 0 ; i < self.lookArr.count / 22 + 1; i++) {
        UIImageView *deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width + self.view.frame.size.width - self.view.frame.size.width /6 * 2 + 80, self.view.frame.size.width /6 * 2  - 20, self.view.frame.size.width /8 * 2 - 55, self.view.frame.size.width / 8 - 20)];
        deleteImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookDelete)];
        [deleteImage addGestureRecognizer:deleteTap];
        deleteImage.image = [UIImage imageNamed:@"delete.png"];
        //        deleteImage.backgroundColor = [UIColor orangeColor];
        [self.lookArrScroll addSubview:deleteImage];
    }
    for (int i = 0; i < self.lookArr.count; i++) {
        if (i + b == self.lookArr.count) {
            break;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i % 8  * self.view.frame.size.width /8 + a + 5 + 10, i / 8  * self.view.frame.size.width / 8 + 10, self.view.frame.size.width / 8 - 20, self.view.frame.size.width / 8 - 20)];
        NSString *str = [self.lookArr objectAtIndex:i + b];
        NSString *imageStr = [str substringWithRange:NSMakeRange(1, str.length - 2)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_%@.png",imageStr]] forState:UIControlStateNormal];
        
        button.tag = i + b + 1;
        [button addTarget:self action:@selector(selectedLook:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self.lookArrScroll addSubview:button];
        if (a == self.view.frame.size.width * 3 && i == 15) {
            break;
        }
        if (i % 22 == 0 && i != 0) {
            a = a + self.view.frame.size.width;
            i =  -1;
            b = b + 23;
        }
        
    }
}
- (void)createOtherEmojiScroll
{
    self.otherLookArrScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 3 / 7)];
    self.otherLookArrScroll.showsHorizontalScrollIndicator = NO;
    self.otherLookArrScroll.contentSize = CGSizeMake(self.view.frame.size.width * 7, self.view.frame.size.width * 3 / 7);
    self.otherLookArrScroll.pagingEnabled = YES;
    self.otherLookArrScroll.delegate = self;
    self.otherLookArrScroll.tag = 245;
    self.otherLookArrScroll.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:self.otherLookArrScroll];
    NSInteger a = 0;
    NSInteger b = 0;
    for (int i = 0 ; i < self.otherLookArr.count / 22 + 1; i++) {
        UIImageView *deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width + self.view.frame.size.width - self.view.frame.size.width /6 * 2 + 80, self.view.frame.size.width /6 * 2  - 20, self.view.frame.size.width /8 * 2 - 55, self.view.frame.size.width / 8 - 20)];
        deleteImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookDelete)];
        [deleteImage addGestureRecognizer:deleteTap];
        deleteImage.image = [UIImage imageNamed:@"delete.png"];
        //        deleteImage.backgroundColor = [UIColor orangeColor];
        [self.otherLookArrScroll addSubview:deleteImage];
    }
    for (int i = 0; i < self.otherLookArr.count; i++) {
        if (i + b == self.otherLookArr.count) {
            break;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i % 8  * self.view.frame.size.width /8 + a + 5 + 10, i / 8  * self.view.frame.size.width / 8 + 10, self.view.frame.size.width / 8 - 20, self.view.frame.size.width / 8 - 20)];
        NSDictionary *str = [self.otherLookArr objectAtIndex:i + b];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
        
        UIImage *um = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:[[str allValues]firstObject]]];
        [button setImage:um forState:UIControlStateNormal];
        
        button.tag = i + b + 1 + 100;
        
        
        [button addTarget:self action:@selector(selectedLook:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [button addGestureRecognizer:longPress];
        
        [button addTarget:self action:@selector(leaveBtnFrame:) forControlEvents:UIControlEventTouchCancel];
        
        
        button.backgroundColor = [UIColor whiteColor];
        [self.otherLookArrScroll addSubview:button];
        if (a == self.view.frame.size.width * 7 && i == 15) {
            break;
        }
        if (i % 22 == 0 && i != 0) {
            a = a + self.view.frame.size.width;
            i =  -1;
            b = b + 23;
        }
        
    }
}
- (void)leaveBtnFrame:(id)sender
{
//    [self.lookDetailView removeFromSuperview];
}
- (void)btnLong:(UILongPressGestureRecognizer *)press
{
//[self.lookDetailView removeFromSuperview];
//    self.lookDetailView = nil;
    if (self.lookDetailView == nil) {
        
    
    
    UIButton *btn = (UIButton *)press.view;
    self.lookDetailView = [[UIWebView alloc]initWithFrame:CGRectMake(btn.frame.origin.x - 7.5 - self.page.currentPage * self.view.frame.size.width, btn.frame.origin.y - 50 + self.view.frame.size.height - 50 - self.view.frame.size.width * 3 / 7, 45, 45)];
    self.lookDetailView.layer.cornerRadius = 5;
    self.lookDetailView.layer.masksToBounds = YES;

    self.lookDetailView.layer.borderColor = [UIColor colorWithWhite:0.806 alpha:1.000].CGColor;
    self.lookDetailView.layer.borderWidth = 1;
    [self.view addSubview:self.lookDetailView];
    
        NSDictionary *dic = [self.otherLookArr objectAtIndex:btn.tag - 101];
        NSString *fileName = [NSString stringWithFormat:@"%@@2x",[[dic allValues]firstObject]];
      
       NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:fileName ofType:@"gif"]];
 
        self.lookDetailView.scalesPageToFit = YES;
        self.lookDetailView.delegate = self;
        
        [self.lookDetailView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }
    if (press.state == UIGestureRecognizerStateEnded){
        [self.lookDetailView removeFromSuperview];
        self.lookDetailView = nil;
    }
    if (press.state == UIGestureRecognizerStateCancelled) {
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F5F5F5'"];
}
- (void)sendMessage
{
    [self textFieldShouldReturn:self.keyboardField];
    
}
- (void)lookDelete
{
    if (self.sendStr.length == 0) {
        if (self.strArr.count > 0) {
            if ([[[NSString stringWithFormat:@"%@",[self.strArr lastObject]] substringWithRange:NSMakeRange(0, 1)]isEqualToString:@":"]) {
                [self.strArr removeLastObject];
            }else if([[[NSString stringWithFormat:@"%@",[self.strArr lastObject]] substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"["]){
                [self.strArr removeLastObject];
                
            }else{
                NSString *str = [self.strArr lastObject];
                if (str.length > 1) {
                    str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
                    [self.strArr removeLastObject];
                    [self.strArr addObject:str];
                    
                }else{
                    [self.strArr removeLastObject];
                    
                }
            }
        }else{
            
        }
    }
    if (self.keyboardField.attributedText.length > 0) {
        
        
        NSMutableAttributedString *mutableStr = [self.keyboardField.attributedText mutableCopy];
        
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length - 1, 1)];
        
        self.keyboardField.attributedText = mutableStr;
        [self changeTextViewHeight:self.keyboardField];
        self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 3 / 7 - self.keyboardField.frame.size.height - 20, self.view.frame.size.width, self.keyboardField.frame.size.height + 20);
    }
    self.sendAttStr = [self.keyboardField.attributedText mutableCopy];

}
- (void)selectedLook:(id)sender
{
    

    UIButton *button = (UIButton *)sender;
    if (button.tag > 100) {
        NSDictionary *str = [self.otherLookArr objectAtIndex:button.tag - 100 - 1];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
        
        UIImage *um = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:[[str allValues]firstObject]]];
        NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:UIImagePNGRepresentation(um) ofType:nil] ;
        textAttachment.image = um ;
        textAttachment.bounds = CGRectMake(2, -2, 18, 18);
        NSAttributedString * textAttachmentString = [ NSAttributedString attributedStringWithAttachment:textAttachment] ;
        [self.sendAttStr appendAttributedString:textAttachmentString];
        //    self.keyboardField.text = self.sendStr;
        self.keyboardField.attributedText = self.sendAttStr;
        if (self.sendStr.length != 0 && self.sendStr != nil) {
            [self.strArr addObject:self.sendStr];
            
        }
        [self.strArr addObject:[[str allKeys]firstObject]];
        self.sendStr = [NSString string];
    }else{
    NSString *str =  [self.lookArr objectAtIndex:button.tag - 1];
    NSString *str1 = [str substringWithRange:NSMakeRange(1, str.length - 2)];
    
//    NSString *imageName = [NSString stringWithFormat:@"emoji_%@.png",str1];
    

//    self.keyboardField.text = [self.keyboardField.text stringByAppendingString:str];
//    self.sendStr = [self.sendStr stringByAppendingString:str];
    UIImage * smileImage = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_%@.png",str1]];
    
    NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:UIImagePNGRepresentation(smileImage) ofType:nil] ;
    textAttachment.image = smileImage ;
    textAttachment.bounds = CGRectMake(2, -2, 18, 18);
    NSAttributedString * textAttachmentString = [ NSAttributedString attributedStringWithAttachment:textAttachment] ;
    [self.sendAttStr appendAttributedString:textAttachmentString];
//    self.keyboardField.text = self.sendStr;
    self.keyboardField.attributedText = self.sendAttStr;
    if (self.sendStr.length != 0 && self.sendStr != nil) {
        [self.strArr addObject:self.sendStr];
        
    }
    [self.strArr addObject:str];
    self.sendStr = [NSString string];
    
    
    [self changeTextViewHeight:self.keyboardField];
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 3 / 7 - self.keyboardField.frame.size.height - 20, self.view.frame.size.width, self.keyboardField.frame.size.height + 20);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.class == [UITableView class]) {
        if (scrollView.contentOffset.y < -140) {
            [self refreshHeader];
        }
    }else{
    if (scrollView.tag == 145) {
        
        NSInteger a = scrollView.contentOffset.x / self.view.frame.size.width;
        self.page.currentPage = a;
    }else if(scrollView.tag == 245){
        NSInteger a = scrollView.contentOffset.x / self.view.frame.size.width;
        self.page.currentPage = a;
    }
    }
    
}
- (void)createAddView
{
    [self.commonWordView removeFromSuperview];
    [self.commonWordScroll removeFromSuperview];
    [self.mainView removeFromSuperview];
    [self.speakButton removeFromSuperview];
    [self.returnToTextImage removeFromSuperview];
    [self.keyboardView removeFromSuperview];
    [self createKeyBoardView];
    
    
    [self.keyboardField resignFirstResponder];
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 1 / 7 - 49, self.view.frame.size.width, self.keyboardField.frame.size.height + 20);
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 50 - self.view.frame.size.width * 1 / 7 - 49 );
    [self createAlbumView];

    
    
}
- (void)createBtn
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    btnView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    btnView.layer.shadowColor=[[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
    
    btnView.layer.shadowOffset=CGSizeMake(1,1);
    
    btnView.layer.shadowOpacity=0.8;
    
     btnView.layer.shadowRadius=3;
    [self.view addSubview:btnView];
    
    self.sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 35)];
//    sendBtn.layer.borderColor = [UIColor colorFromHexCode:@"#38ab99"].CGColor;
//    sendBtn.layer.borderWidth = 1;
    
    self.sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 25, 5, 70, 25)];
    self.sendLabel.textColor = [UIColor colorFromHexCode:@"#666"];
    self.sendLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.sendBtn addSubview:self.sendLabel];
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    if ([currentRole isEqualToString:@"1"]) {
//        [sendBtn setTitle:@"发送简历" forState:UIControlStateNormal];
        self.sendLabel.text = @"发送简历";
    }else{
//        [sendBtn setTitle:@"求简历" forState:UIControlStateNormal];
        self.sendLabel.text = @"求简历";
    }
    if (self.hasDone == YES) {
        self.sendLabel.text = @"已请求";
        self.sendLabel.textColor = [UIColor colorFromHexCode:@"9a9a9a"];
//        sendBtn.backgroundColor = [UIColor colorFromHexCode:@"#B9B9B9"];
        self.sendBtn.userInteractionEnabled = NO;
    }
    UIImageView *sendImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 50, 8, 19, 19)];
    sendImage.image = [UIImage imageNamed:@"sendOrRequire.png"];
    [self.sendBtn addSubview:sendImage];
    [self.sendBtn addTarget:self action:@selector(sendOrRequire:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:self.sendBtn];
    
    UIButton *loveBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 35)];
    [loveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loveSomeThing)]];
    UILabel *loveLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 25, 5, 70, 25)];
    loveLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    loveLabel.textColor = [UIColor colorFromHexCode:@"#666"];
    if ([currentRole isEqualToString:@"1"]) {
//        [loveBtn setTitle:@"收藏职位" forState:UIControlStateNormal];
        loveLabel.text = @"收藏职位";
    }else{
//        [loveBtn setTitle:@"收藏简历" forState:UIControlStateNormal];
        loveLabel.text = @"收藏简历";
    }
    [loveBtn addSubview:loveLabel];
    
    UIImageView *loveImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 50, 8, 19, 19)];
    loveImage.image = [UIImage imageNamed:@"personal_icon_collect.png"];
    [loveBtn addSubview:loveImage];
    
    [btnView addSubview:loveBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 0.25, 8, 0.5, 19)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    [btnView addSubview:lineView];
    
}
- (void)loveSomeThing
{
    NSString *url = @"http://api.zzd.hidna.cn/v1/my/favorite";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    if ([currentRole isEqualToString:@"1"]) {
        [dic setObject:self.jdId forKey:@"origin_id"];
    }else{
        [dic setObject:self.rsId forKey:@"origin_id"];
    }
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"type"];
    
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
                
                
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
               
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];


}
- (void)sendOrRequire:(UITapGestureRecognizer*)tap
{
    
    
//    self.manager = [AFHTTPRequestOperationManager manager];
//    
//    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//            
//            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
//            
//            NSString *url = @"http://api.zzd.hidna.cn/v1/resume/upload";
//            
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            
//            [parameters setObject:time forKey:@"timestamp"];
//            
//            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
//            
//            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
//            
//            [parameters setObject:[NSString stringWithFormat:@"%@",self.rsId] forKey:@"rsId"];
//            [parameters setObject:[NSString stringWithFormat:@"%@",self.jdId] forKey:@"jdId"];
//            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
//            
//            
//            
//            //            [parameters setObject:self.userState forKey:@"userStatus"];
//            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]);
//            [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                
//                
//                
//                
//            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                
//            }];
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//    }];
//
    
    if ([self judgeEmail]) {
        UIImageView *image  = tap.view;
        image.userInteractionEnabled = NO;
        image.image = [UIImage imageNamed:@"发送简历-已发送123.png"];
    
        self.sendLabel.text = @"已请求";
        self.sendLabel.textColor = [UIColor colorFromHexCode:@"9a9a9a"];
        //        sendBtn.backgroundColor = [UIColor colorFromHexCode:@"#B9B9B9"];
        self.sendBtn.userInteractionEnabled = NO;
        self.hasDone = YES;
        
    self.client = [AVIMClient defaultClient];
    
    [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
            
            [attributes setObject:self.jdId forKey:@"jdId"];
            
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                
                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                
                
            }else{
                [attributes setObject:self.rsId forKey:@"rsId"];
            }
            [attributes setObject:@"1" forKey:@"type"];
            NSString *sendOrRequireStr;
            NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
            if ([currentRole isEqualToString:@"1"]) {
                sendOrRequireStr = @"我想发送我的简历给您,是否同意?";
                [attributes setObject:@"send" forKey:@"sendType"];
            }else{
                sendOrRequireStr = @"我想要一份您的简历,是否同意?";
                [attributes setObject:@"require" forKey:@"sendType"];
            }
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:sendOrRequireStr attributes:attributes];
            
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                    
                    
                    NSMutableDictionary *otherAttributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
                    
                    [otherAttributes setObject:self.jdId forKey:@"jdId"];
                    
                    [otherAttributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                        
                        [otherAttributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                        
                        
                    }else{
                        [otherAttributes setObject:self.rsId forKey:@"rsId"];
                    }
                    [otherAttributes setObject:@"5" forKey:@"type"];
                     
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
                    
                    NSString *timeString = [NSString stringWithFormat:@"%.0f", (double)a ];
                    NSString *sendResult;
                    if ([self.sendType isEqualToString:@"send"]) {
                    sendResult = @"简历已发送";
                    }else
                    {
                    sendResult = @"请求已发送";
                    }
                    AVIMTextMessage *otherMessage = [AVIMTextMessage messageWithText:sendResult attributes:otherAttributes];
                    otherMessage.sendTimestamp = [timeString doubleValue];
                    [FMDBMessages saveMessageWhenSend:otherMessage Rid:self.objectId];
                    
                    [self.mesArr addObject:[FMDBMessages messageTranToModel:otherMessage WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                    self.length = 0;
                                            [self.cheatTableView reloadData];
                    
//                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
//                    [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.cheatTableView endUpdates];
//                    [self.cheatTableView reloadData];
                    
                    
                    NSDictionary *attributes = message.attributes;
                    NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                    //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                    [conDic setObject:self.objectId forKey:@"yourId"];
                    [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                    [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                    [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                    [conDic setObject:sendOrRequireStr forKey:@"lastText"];
                    [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                    [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
                    
                    
                    
                    AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
                    
                    [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (error) {
                            
                            return ;
                        }
                        NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                        NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                        
                        
                        if (name == nil) {
                            [conDic setObject:@"" forKey:@"name"];
                        }else{
                            [conDic setObject:name forKey:@"name"];
                        }
                        if (header != nil) {
                            
                            [conDic setObject:header forKey:@"header"];
                        }
                        
                        [FMDBMessages judgeConversationExist:conDic];
                        
                        
                        
                    }];
                    
                    if (self.mesArr.count > 0) {
                        
                        
                        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        
                        
                        
                        
                    }
                    
                    
                    
                }
            }];
        }];
    }];
    }

}
- (void)createAlbumView
{
    
    self.albumView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 -  self.view.frame.size.width * 1 / 7, self.view.frame.size.width, 50 +  self.view.frame.size.width * 1 / 7)];
    self.albumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.albumView];
    NSString *firstImg;
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    if ([currentRole isEqualToString:@"1"]) {
        //        [sendBtn setTitle:@"发送简历" forState:UIControlStateNormal];
        firstImg = @"发送简历123.png";
    }else{
        //        [sendBtn setTitle:@"求简历" forState:UIControlStateNormal];
        firstImg = @"求简历123.png";
    }
    if (self.hasDone == YES) {
        firstImg = @"发送简历-已发送123.png";
    }
    NSArray *arr = @[firstImg,@"表情123.png",@"语音123.png",@"拍摄123.png",@"照片123.png"];
    for (int i = 0; i < 5; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width / 5 + 15, 20, self.view.frame.size.width / 5 - 30, (self.view.frame.size.width / 5 - 30) * 64 / 45)];
        image.userInteractionEnabled = YES;
                UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)];
        UITapGestureRecognizer *sendOrRequireTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendOrRequire:)];
        switch (i) {
                
            case 0:
                [image addGestureRecognizer:sendOrRequireTap];
                if ([firstImg isEqualToString:@"发送简历-已发送123.png"]) {
                    image.userInteractionEnabled = NO;
                }
                break;
            case 1:
                
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(look)]];
                
                break;
            case 2:
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(speak)]];
                break;
                
            case 3:
                image.tag = 56;
                [image addGestureRecognizer:photoTap];
                break;
            case 4:
                image.tag = 55;
                [image addGestureRecognizer:photoTap];
                break;
            default:
                break;
        }
        image.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        [self.albumView addSubview:image];
        
    }
//    UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(30  , 20, 66, 66)];
//    //    photo.backgroundColor = [UIColor blackColor];
//    photo.layer.masksToBounds = YES;
//    photo.layer.cornerRadius = 33;
//    photo.userInteractionEnabled = YES;
//    photo.tag = 56;
//    photo.image = [UIImage imageNamed:@"icon_zx.png"];
//    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)];
//    [photo addGestureRecognizer:photoTap];
//    [self.albumView addSubview:photo];
//
//    UIImageView *album = [[UIImageView alloc]initWithFrame:CGRectMake(130 , 20, 66, 66)];
//    //    album.backgroundColor = [UIColor blackColor];
//    album.tag = 55;
//    album.layer.masksToBounds = YES;
//    album.layer.cornerRadius = 33;
//    album.userInteractionEnabled = YES;
//    UITapGestureRecognizer *albumTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)];
//    [album addGestureRecognizer:albumTap];
//
//    album.image = [UIImage imageNamed:@"icon_xc.png"];
//
//    [self.albumView addSubview:album];
//
//    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 , 90, 66, 20)];
//    photoLabel.text = @"拍照";
//    photoLabel.textAlignment = 1;
//    photoLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    photoLabel.textColor = [UIColor colorFromHexCode:@"#cccccc"];
//    [self.albumView addSubview:photoLabel];
//
//    UILabel *albumLabel =[[UILabel alloc]initWithFrame:CGRectMake(130, 90, 66, 20)];
//    albumLabel.text = @"相册";
//    albumLabel.textAlignment = 1;
//    albumLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    albumLabel.textColor = [UIColor colorFromHexCode:@"#cccccc"];
//    [self.albumView addSubview:albumLabel];
    if (self.mesArr.count > 0) {
        
        
        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)photoTap:(UITapGestureRecognizer *)sender
{
    UIImageView *image = (UIImageView *)sender.view;

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    picker.allowsEditing = NO;
    switch (image.tag) {
        case 55:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 56:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        default:
            break;
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self sendImageMessage:selectedImage];
}
- (void)sendImageMessage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(600, 600 * image.size.height / image.size.width));
    [image drawInRect:CGRectMake(0, 0, 600, 600 * image.size.height / image.size.width)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.client = [AVIMClient defaultClient];
    [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            
            
            NSData *imageData = UIImagePNGRepresentation(scaledImage);
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:self.jdId forKey:@"jdId"];
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                
                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
            }else{
                [attributes setObject:self.rsId forKey:@"rsId"];
            }
            AVIMImageMessage *message = [AVIMImageMessage messageWithText:@"[图片]" file:[AVFile fileWithData:imageData] attributes:attributes];
            
            
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                    
                    //                    [self.messageArr addObject:message];
                    [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                    self.length = 0;
                    //                        [self.cheatTableView reloadData];
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
                    [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.cheatTableView endUpdates];

                    if (self.mesArr.count > 0) {
                        
                    
                    [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    
                    }
                    NSDictionary *attributes = message.attributes;
                    NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                    //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                    [conDic setObject:self.objectId forKey:@"yourId"];
                    [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                    [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                    [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                    [conDic setObject:message.text forKey:@"lastText"];
                    [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                    [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
        
                    AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
                    
                    [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (error) {
                    
                            return ;
                        }
                        
                        NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                        NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                        
            
                        [conDic setObject:name forKey:@"name"];
                        [conDic setObject:header forKey:@"header"];
                        
                        [FMDBMessages judgeConversationExist:conDic];
                        
                    }];
                }
            }];
        }];
    }];
}
//键盘输入栏的点击事件
- (void)keyboardFieldAction
{
    if ([self.keyboardField isFirstResponder]) {
        
    }else{
        
    }
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self.albumView removeFromSuperview];
    [self.mainView removeFromSuperview];
    [self.commonWordView removeFromSuperview];
    [self.commonWordScroll removeFromSuperview];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    self.keyBoardHeight = height;

    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - height - 49, self.view.frame.size.width, 49);
    self.keyboardField.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - height - 49 );
//    [UIView animateWithDuration:[[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue] animations:^{
////        self.cheatTableView.contentOffset = CGPointMake(0, [self judgeContentSize] - height);
//        if (self.mesArr.count > 0) {
//            
//        
//        }
//    }];
    
    self.addImage.image = [UIImage imageNamed:@"+234.png"];
    if (self.mesArr.count > 0) {
        
    
    [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [self changeTextViewHeight:self.keyboardField];
    self.keyboardField.contentOffset = CGPointMake(0, -5);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
     NSDictionary *userInfo = [aNotification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue] animations:^{
     self.addImage.image = [UIImage imageNamed:@"+234.png"];
        self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 );
        self.keyboardField.frame = CGRectMake(5, 5, self.view.frame.size.width - 49 * 3 + 18, 49 - 10 * 2);
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        self.addImage.image = [UIImage imageNamed:@"+234.png"];
        [self.mainView removeFromSuperview];
        [self.keyboardField resignFirstResponder];
        [self.albumView removeFromSuperview];
        [self.commonWordView removeFromSuperview];
        [self.commonWordScroll removeFromSuperview];
        self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        
        self.keyboardField.frame = CGRectMake(5, 5, self.view.frame.size.width - 49 * 3 + 18, 49 - 10 * 2);
        self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mesArr.count;
}
- (NSInteger)judgeContentSize
{
    self.length = 0;
    for (MyMessage *message in self.mesArr) {
        if (message.mediaType == -1) {
            
            if (message.type == 0) {
                self.length = self.length + 150;
                
            }else{
                UIFont *font = [UIFont systemFontOfSize:18];
                CGSize size = [message.text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
                
                self.length = self.length + size.height+70;
                
            }
        }
        if (message.mediaType == -3) {
            
            self.length = self.length + 100;
            
        }
        if (message.mediaType == -2) {
            
            
            
            self.length = self.length + 230;
            
            
            
            
        }
        
    }
    if (self.mesArr.count == 1) {
        return self.view.frame.size.height - 150 + 37;
    }else{
        return self.length ;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyMessage *message = [self.mesArr objectAtIndex:indexPath.row];

    if([self.rowHeightDic objectForKey:[NSNumber numberWithDouble:message.timeStamp]]!= nil)
    {
        return [[self.rowHeightDic objectForKey:[NSNumber numberWithDouble:message.timeStamp]]doubleValue];
    }else{
    if (message.mediaType == -1) {
        if (message.type == 0) {
            return 85;
        }else if (message.type == 5)
        {
            return 50;
        }else{
            if ([message.sendType isEqualToString:@"send"]||[message.sendType isEqualToString:@"require"]) {
                return 160;
            }else{
            MessageModel * messageModel = [CheakBubble bubbleView:message.text from:NO withPosition:20 attributedStr:[self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: message.timeStamp]]];
            return messageModel.rowHeight;
            
            }
            return 0;
        }
    }else if(message.mediaType == -3){
        return 74;
    }else if(message.mediaType == -2){
        return 170;
    }else{
        return 60;
    }
    }
    
    
}
- (void)changeTextViewHeight:(UITextView *)textView
{

    [self.keyboardField sizeToFit];
    
     self.keyboardView.frame = CGRectMake(self.keyboardView.frame.origin.x, self.view.frame.size.height - self.keyBoardHeight - self.keyboardField.frame.size.height  - 20, self.keyboardView.frame.size.width, self.keyboardField.frame.size.height + 20);
    
    
    
    self.keyBoardBackView.frame = CGRectMake(70, 5, self.view.frame.size.width - 49 * 3 + 18, self.keyboardField.frame.size.height + 10);
}
//- (CGFloat)judgeContentSizeOne
//{
//    CGFloat rows = 0;
//    for (NSNumber *rowHeight in [self.rowHeightDic allValues]) {
//        rows = [rowHeight floatValue] + rows;
//    }
//    return rows;
//}

-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {

            [self doSomeThingWithStr:textView];
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self doSomeThingWithStr:textView];
        
        
    }
}
- (void)doSomeThingWithStr:(UITextView *)textView
{
    
        NSInteger a = 0;
        for (NSString *str  in self.strArr) {
            if ([[str substringToIndex:1]isEqualToString:@":"]) {
            
               a = a + 1;
            }else if([[str substringToIndex:1]isEqualToString:@"["]){
                a = a + 1;
            }else{
                a = a + str.length;
            }
        }
    
    if (textView.text.length < a) {
        
    }else{
        self.sendStr = [textView.text substringWithRange:NSMakeRange(a , textView.text.length - a )];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    [textView sizeToFit];
    
//    textView.attributedText = self.sendAttStr;
    if ([text isEqualToString:
         @"\n"]){
        

        [self textFieldShouldReturn:textView];
        return NO;
    }
    
    if (text.length == 0) {

  
        if (self.sendStr.length == 0) {
            if (self.strArr.count > 0) {
                if ([[[NSString stringWithFormat:@"%@",[self.strArr lastObject]] substringWithRange:NSMakeRange(0, 1)]isEqualToString:@":"]) {
                    [self.strArr removeLastObject];
                }else if([[[NSString stringWithFormat:@"%@",[self.strArr lastObject]] substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"["]){
                    [self.strArr removeLastObject];
                    
                }else{
                    NSString *str = [self.strArr lastObject];
                    if (str.length > 1) {
                        str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
                        [self.strArr removeLastObject];
                        [self.strArr addObject:str];
                        
                    }else{
                        [self.strArr removeLastObject];
                        
                    }
                }
            }else{
                
            }
        }
    
        return YES;
    }else{
        self.sendAttStr = [textView.attributedText mutableCopy];


        
    [self changeTextViewHeight:textView];
    
    }
    
    return YES;
}

- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    BOOL isString = [BlankString isBlankString:textField.text];
//    NSString *messageStr = textField.text;
    NSString *messageStr = @"";
    for (NSString *str in self.strArr) {
        messageStr = [messageStr stringByAppendingString:str];

    };
    if (self.sendStr.length!= 0) {
        messageStr = [messageStr stringByAppendingString:self.sendStr];
    }
    //防止空白信息
    
    
    textField.text = @"";
    
    textField.attributedText = [[NSMutableAttributedString alloc]initWithString:@""];
    self.sendStr = @"";
    self.sendAttStr = [[NSMutableAttributedString alloc]initWithString:@""];
    self.strArr = [NSMutableArray array];
    if (messageStr.length != 0 && isString == NO) {
        self.client = [AVIMClient defaultClient];
        
        [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
            
            [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
                
                [attributes setObject:self.jdId forKey:@"jdId"];

                [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"bossOrWorker"];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                    
                    [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                    
                    
                }else{
                    [attributes setObject:self.rsId forKey:@"rsId"];
                }
                [attributes setObject:@"1" forKey:@"type"];
                
                AVIMTextMessage *message = [AVIMTextMessage messageWithText:messageStr attributes:attributes];
                
                [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                       
                        [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                        
                        [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                        self.length = 0;
                        //                        [self.cheatTableView reloadData];
                        
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
                        [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.cheatTableView endUpdates];

                        
                        
                        NSDictionary *attributes = message.attributes;
                        NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                        //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                        [conDic setObject:self.objectId forKey:@"yourId"];
                        [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
                        [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
                        [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                        [conDic setObject:message.text forKey:@"lastText"];
                        [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                        [conDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"bossOrWorker"];
                        
                        
                        
                        AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:self.objectId];
                        
                        [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                            if (error) {
                     
                                return ;
                            }
                            NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
                            NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
                            
                    
                            if (name == nil) {
                            [conDic setObject:@"" forKey:@"name"];
                            }else{
                            [conDic setObject:name forKey:@"name"];
                            }
                            if (header != nil) {
                                
                                [conDic setObject:header forKey:@"header"];
                            }
                            
                            [FMDBMessages judgeConversationExist:conDic];
                            
                            
                            
                        }];

                        if (self.mesArr.count > 0) {
                            

                            [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

                
                            
                          
                        }

                        
                        
                    }
                }];
            }];
        }];
    }
    
    
    
    
    
    
    return NO;
}

//获取系统表情

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    tableView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    
    if (indexPath.row <self.mesArr.count) {
        
        
        MyMessage *messages = [self.mesArr objectAtIndex:indexPath.row];
        if (indexPath.row == self.messageArr.count - 1) {
            
        }
        if (messages.mediaType == -1) {
            
            if (messages.type == 0)
            {
                NSString *userState = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
                if ([userState isEqualToString:@"1"]) {
                    static NSString *personTitle = @"personTitle";
                    BossCheatTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:personTitle];
                    if (!cell) {
                        cell = [[BossCheatTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personTitle];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setValuesFromText:messages.text];
                    [self.rowHeightDic setObject:@85 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                    return cell;
                }else if([userState isEqualToString:@"2"])
                {
                    static NSString *bossTitle = @"bossTitle";
                    PersonCheatTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:bossTitle];
                    if (!cell) {
                        cell = [[PersonCheatTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bossTitle];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                     [cell setValuesFromText:messages.text];
                    [self.rowHeightDic setObject:@85 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                    return cell;
                }else{
                    return nil;
                }

//                static NSString *cellIdentifyHeader = @"header";
//                CheatHeaderTableViewCell * header = [tableView dequeueReusableCellWithIdentifier:cellIdentifyHeader];
//                if (!header) {
//                    header = [[CheatHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyHeader];
//                }
//                header.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [header getNameFromCell:self.title];
//                NSString *jdName = @"";
//                if ([[self.jdDic objectForKey:@"user"]objectForKey:@"name"]!= nil) {
//                    jdName = [[self.jdDic objectForKey:@"user"]objectForKey:@"name"];
//                }else{
//                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
//                        jdName = self.title;
//                    }else{
//                    jdName = @"";
//                    }
//                }
//                [header.headerView setLabelValue:nil text:messages.text name:jdName];
////                self.messageModel = [[MessageModel alloc]init];
////                self.messageModel.rowHeight = 150;
//                [self.rowHeightDic setObject:@175 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
//                
//                
//                
//                return header;
                
                
                
                
            }else if(messages.type == 5){
                static NSString *sendResultIdentify = @"resultCell";
                SendResultTableViewCell *sendResultCell = [tableView dequeueReusableCellWithIdentifier:sendResultIdentify];
                if (!sendResultCell) {
                    sendResultCell = [[SendResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendResultIdentify];
                }
                sendResultCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [sendResultCell setResultImage:self.sendType];
                return sendResultCell;
            
            }else{
                if ([messages.sendType isEqualToString:@"send"]||[messages.sendType isEqualToString:@"require"]) {
                    static NSString *sendCellIdentify = @"sendCell";
                    SendOrRequireTableViewCell *sendCell = [tableView dequeueReusableCellWithIdentifier:sendCellIdentify];
                    if (!sendCell) {
                        sendCell = [[SendOrRequireTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendCellIdentify];
                    }
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [sendCell setHeaderImage:self.cheatHeader];
                    __weak SendOrRequireTableViewCell *sendOrRequireCell = sendCell;
                    sendCell.resultBlock = ^(NSString *str)
                    {
                        if ([str isEqualToString:@"confirm"]) {
                            if ([self judgeEmail]) {
                                [self sendEmailRequest:messages];
                                
                            }else{
                                
                            }
                            
                        }
                        if ([str isEqualToString:@"cancel"]) {
                            
                        }
                        [sendOrRequireCell hadDone:str];
                    };
                    if ([messages.url isEqualToString:@"1"]) {
                        [sendOrRequireCell hadDone:@""];
                    }
//                    sendCell.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
//                    sendCell.contentView.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return sendCell;
                }else{
                static NSString *cellIdentify = @"cell";
                NewCheatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
                if (!cell) {
                    cell = [[NewCheatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
                }
                cell.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                MyMessage *message= [self.mesArr objectAtIndex:indexPath.row];
                
                [cell.statusImage removeFromSuperview];
                if ([message.sendId isEqualToString:[AVUser currentUser].objectId]) {
                    //        cell.rightCheatLabel.text = message.text;
                    //         cell.rightCheatLabel.backgroundColor = [UIColor colorFromHexCode:@"#00abea"];
                    //
                    //
                    //        cell.left.image = nil;
                    //        cell.leftCheatLabel.text = nil;
                    //        cell.leftCheatLabel.backgroundColor = [UIColor clearColor];
                    //        cell.leftCheatLabel.layer.borderColor = [UIColor clearColor].CGColor;
                    [cell.timeLabel removeFromSuperview];
                    [cell.rightView removeFromSuperview];
                    [cell.leftView removeFromSuperview];
                    [cell.rightHeader removeFromSuperview];
                    [cell.leftHeader removeFromSuperview];
                    if ([self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: message.timeStamp]] == nil) {
                        
                        self.messageModel = [cell createCheatBubble:YES text:message.text attributedStr:nil];
                        
                        [self.messageTextStrDic setObject:self.messageModel.attStr forKey:[NSNumber numberWithDouble: message.timeStamp]];
                    }else{
                        self.messageModel = [cell createCheatBubble:YES text:message.text attributedStr:[self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: message.timeStamp]]];
                    }
                    
                    [self.rowHeightDic setObject:[NSNumber numberWithDouble:self.messageModel.rowHeight] forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                    
                    [cell getRightImage:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"avatar"]];
                    
                    
                }
                if ([message.sendId isEqualToString:self.objectId]) {
                    //        cell.leftCheatLabel.text = message.text;
                    //        cell.leftCheatLabel.backgroundColor = [UIColor whiteColor];
                    //
                    //        cell.right.image = nil;
                    //        cell.rightCheatLabel.text = nil;
                    //        cell.rightCheatLabel.backgroundColor = [UIColor clearColor];
                    [cell.timeLabel removeFromSuperview];
                    [cell.rightView removeFromSuperview];
                    [cell.leftView removeFromSuperview];
                    [cell.rightHeader removeFromSuperview];
                  
                    [cell.leftHeader removeFromSuperview];
  
                    
                    if ([self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: message.timeStamp]] == nil) {
                        
                        self.messageModel = [cell createCheatBubble:NO text:message.text attributedStr:nil];
                        [self.messageTextStrDic setObject:self.messageModel.attStr forKey:[NSNumber numberWithDouble: message.timeStamp]];
                    }else{
                        self.messageModel = [cell createCheatBubble:NO text:message.text attributedStr:[self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: message.timeStamp]]];
                    }
                    [self.rowHeightDic setObject:[NSNumber numberWithDouble:self.messageModel.rowHeight] forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                    [cell getLeftImage:self.cheatHeader];
                    
                    
                    cell.rightHeader.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
                    cell.userInteractionEnabled = YES;
                    if ([self.rsId isEqualToNumber:self.jdId]) {
                        
                    }else{
                    [cell.rightHeader addGestureRecognizer:tap];
                    }
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
                        self.rsId = [NSNumber numberWithInteger:message.rsId];
                    }
                }
//                if (message.status == 2) {
//                    cell.statusImage.image = [UIImage imageNamed:@"sending.png"];
//                    if (message.status == 4) {
//                        cell.statusImage.image = [UIImage imageNamed:@"sendFail.png"];
//                    }
//                    else{
//                        [cell.statusImage removeFromSuperview];
//                    }
//                }
                //            }else if(message.status == 4){
                //                cell.statusImage.image = [UIImage imageNamed:@"sendFail.png"];
                //            }else{
                //                [cell.statusImage removeFromSuperview];
                //            }
                //[_cheatTableView reloadData];
                
                
                
                            cell.timeLabel.text = [SortTextDate retrunTimeLabelText:indexPath.row arr:self.mesArr];
                return cell;
            }
            }
        }else if (messages.mediaType == -3)  {
            
            
            static NSString *cellIdentify1 = @"cell1";
            AudioTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
            if (!cell1) {
                cell1 = [[AudioTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify1];
            }
            
            [cell1.view removeFromSuperview];
            cell1.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
            
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            MyMessage *audioMessage = [self.mesArr objectAtIndex:indexPath.row];
            
            
            if ([audioMessage.sendId isEqualToString:[AVUser currentUser].objectId]) {
                [cell1.timeLabel removeFromSuperview];
                [cell1.rightHeader removeFromSuperview];
                [cell1.leftHeader removeFromSuperview];
                [cell1 createAudioView:YES url:audioMessage.url duration:[audioMessage.text doubleValue]];
                
//                self.messageModel = [[MessageModel alloc]init];
//                self.messageModel.rowHeight = 100;
                [self.rowHeightDic setObject:@74 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                
                
                
                
                [cell1 setLeftHeaderImage:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"avatar"]];
                
            }else{
                [cell1.timeLabel removeFromSuperview];
                [cell1.rightHeader removeFromSuperview];
                [cell1.leftHeader removeFromSuperview];
                [cell1 createAudioView:NO url:audioMessage.url duration:[audioMessage.text doubleValue]];
//                self.messageModel = [[MessageModel alloc]init];
//                self.messageModel.rowHeight = 100;
                   [self.rowHeightDic setObject:@74 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                
                [cell1 setRightHeaderImage:self.cheatHeader];
                cell1.rightHeader.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
                cell1.userInteractionEnabled = YES;
                if ([self.rsId isEqualToNumber:self.jdId]) {
                    
                }else{
                [cell1.rightHeader addGestureRecognizer:tap];
                }
            }
            //        cell1.timeLabel.text = [SortTextDate retrunTimeLabelText:indexPath.row arr:self.messageArr];
            return cell1;
            
        }else if(messages.mediaType == -2){
            static NSString *cellIdentify3 = @"cell3";
            ImageTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentify3];
            if (!cell3) {
                cell3 = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify3];
            }
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
            
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            cell3.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
            MyMessage *message= [self.mesArr objectAtIndex:indexPath.row];
            //        cell3.size = CGSizeMake(message.width, message.height);
            //        cell3.size = CGSizeMake(150, 150);
            [cell3.timeLabel removeFromSuperview];
            [cell3.leftHeader removeFromSuperview];
            [cell3.rightHeader removeFromSuperview];
            if ([message.sendId isEqualToString:[AVUser currentUser].objectId]) {
                //            [cell3.timeLabel removeFromSuperview];
                //            [cell3.leftHeader removeFromSuperview];
                //            [cell3.rightHeader removeFromSuperview];
                self.messageModel = [cell3 createImage:YES image:message.url];
                
                   [self.rowHeightDic setObject:@170 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
                
                [cell3 setLeftHeaderImage:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"avatar"]];
                cell3.imageImage.userInteractionEnabled = YES;
                if ([self.rsId isEqualToNumber:self.jdId]) {
                    
                }else{
                [cell3.imageImage addGestureRecognizer:imageTap];
                }
                
            }else{
                //            [cell3.timeLabel removeFromSuperview];
                //            [cell3.leftHeader removeFromSuperview];
                //            [cell3.rightHeader removeFromSuperview];
                self.messageModel = [cell3 createImage:NO image:message.url];
                [self.rowHeightDic setObject:@170 forKey:[NSNumber numberWithDouble:messages.timeStamp]];
 
                
                [cell3 setRightHeaderImage:self.cheatHeader];
                cell3.rightHeader.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
                cell3.userInteractionEnabled = YES;
                if ([self.rsId isEqualToNumber:self.jdId]) {
                    
                }else{
                [cell3.rightHeader addGestureRecognizer:tap];
                }
                cell3.imageImage.userInteractionEnabled = YES;
                [cell3.imageImage addGestureRecognizer:imageTap];
            }
            //        cell3.timeLabel.text = [SortTextDate retrunTimeLabelText:indexPath.row arr:self.messageArr];
            return cell3;
        }
        return nil;
    }else{
        static NSString *cellId11   = @"cell111";
        UITableViewCell *cell111 = [tableView dequeueReusableCellWithIdentifier:cellId11];
        if (!cell111) {
            cell111 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId11];
        }
        cell111.selectionStyle = UITableViewCellSelectionStyleNone;
        cell111.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
        
        self.messageModel = [[MessageModel alloc]init];
        self.messageModel.rowHeight = 60;
        
        
        return cell111;
    }
}
- (void)sendEmailRequest:(MyMessage *)message
{
    [FMDBMessages updateEmailMessageState:message];
    self.manager = [AFHTTPRequestOperationManager manager];
    
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *url = @"http://api.zzd.hidna.cn/v1/resume/upload";
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:time forKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
            
            [parameters setObject:[NSString stringWithFormat:@"%@",self.rsId] forKey:@"rsId"];
            [parameters setObject:[NSString stringWithFormat:@"%@",self.jdId] forKey:@"jdId"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            
            
            //            [parameters setObject:self.userState forKey:@"userStatus"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]);
            [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                
                
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)imageTap:(UITapGestureRecognizer *)tap
{
    
    
    UIView*backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backView.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = (UIImageView *)tap.view;
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - self.view.frame.size.width * imageView.image.size.height / imageView.image.size.width) / 2, self.view.frame.size.width, self.view.frame.size.width * imageView.image.size.height / imageView.image.size.width)];
    view.image = imageView.image;
    UITapGestureRecognizer *tapRemove  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRemove:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapRemove];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] ;
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    
    [view addGestureRecognizer:panRecognizer];
    
    
    UIPinchGestureRecognizer *pinchTap = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImage:)];
    [view addGestureRecognizer:pinchTap];
    
    
    [backView addSubview:view];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:backView];
    
}
- (void)pinchImage:(UIPinchGestureRecognizer *)tap
{
    
    
    UIView *view = tap.view;
    if (tap.state == UIGestureRecognizerStateBegan || tap.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, tap.scale, tap.scale);
        tap.scale = 1;
    }
    
}

-(void)move:(UIPanGestureRecognizer *)tap {
    UIView *view = tap.view;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)tap translationInView:view];
    
    if(tap.state == UIGestureRecognizerStateBegan) {
        _firstX = [view center].x;
        _firstY = [view center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [view setCenter:translatedPoint];
    if (tap.state == UIGestureRecognizerStateEnded) {
        view.center = self.view.center;
    }
    
    
}
- (void)tapRemove:(UITapGestureRecognizer *)tap
{
    
    [tap.view.superview removeFromSuperview];
    [tap.view removeFromSuperview];
    
}
- (void)headerTap:(UITapGestureRecognizer *)tap
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
        JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"108"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                
                
                
                NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
                
                NSString *str  = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@",self.jdId];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                [dic setObject:uid forKey:@"uid"];
                [dic setObject:time forKey:@"timestamp"];
                [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                [manager GET:str parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                        self.jdDic = [responseObject objectForKey:@"data"];
                        jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:self.jdDic];
                        [self.navigationController pushViewController:jobDetail animated:YES];
                        
                        
                        
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
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }else{

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",self.rsId];
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:time forKey:@"timestamp"];
                [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
                
                [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                        NewZZDPeopleViewController *detail = [[NewZZDPeopleViewController alloc]init];
                        detail.buttonCount = 10;
                        detail.dic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                        [self.navigationController pushViewController:detail animated:YES];
                    }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                    {
                        
                        if (self.receiveClient!=nil && self.receiveClient.status == AVIMClientStatusOpened) {
                            [AVUser logOut];
                            [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                                [self log];
                            }];
                        } else {
                            [AVUser logOut];
                            [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                                [self log];
                            }];
                        }
                        
                    }
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            }
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



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MyMessage *mes = [self.mesArr objectAtIndex:indexPath.row];
//    
//    if (indexPath.row == 0 && mes.type == 0) {
//        JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"108"];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        
//        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
//                
//                
//                
//                NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
//                
//                NSString *str  = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@",self.jdId];
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                
//                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
//                [dic setObject:uid forKey:@"uid"];
//                [dic setObject:time forKey:@"timestamp"];
//                [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
//                [manager GET:str parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                        self.jdDic = [responseObject objectForKey:@"data"];
//                        jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:self.jdDic];
//                        [self.navigationController pushViewController:jobDetail animated:YES];
//                        
//                        
//                        
//                    }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
//                    {
//                        
//                        if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened) {
//                            [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
//                                
//                                [self log];
//                            }];
//                        } else {
//                            [self log];
//                        }
//                        
//                        
//                    }
//                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//                    
//                }];
//            }
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            
//        }];
//        
//    }
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MyMessage *mes = [self.mesArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0 && mes.type == 0) {
        
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
        JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"108"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                
                
                
                NSString *uid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"];
                
                NSString *str  = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/%@",self.jdId];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",str,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                [dic setObject:uid forKey:@"uid"];
                [dic setObject:time forKey:@"timestamp"];
                [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                [manager GET:str parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                        self.jdDic = [responseObject objectForKey:@"data"];
                        jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:self.jdDic];
                        [self.navigationController pushViewController:jobDetail animated:YES];
                        
                        
                        
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
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }else{

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@",self.rsId];
                NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
                NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:time forKey:@"timestamp"];
                [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
                [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
                
                [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                        NewZZDPeopleViewController *detail = [[NewZZDPeopleViewController alloc]init];
                        detail.buttonCount = 10;
                        detail.jdId = [NSString stringWithFormat:@"%@",self.jdId];
                        detail.dic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                        [self.navigationController pushViewController:detail animated:YES];
                    }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                    {
                        
                        if (self.receiveClient!=nil && self.receiveClient.status == AVIMClientStatusOpened) {
                            [AVUser logOut];
                            [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                                [self log];
                            }];
                        } else {
                            [AVUser logOut];
                            [self.receiveClient closeWithCallback:^(BOOL succeeded, NSError *error) {
                                [self log];
                            }];
                        }
                        
                    }
                } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }
    }
}
/*
 QQ1293205720
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
