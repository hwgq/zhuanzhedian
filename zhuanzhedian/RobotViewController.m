//
//  RobotViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 17/3/8.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "RobotViewController.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MJRefresh.h"
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
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "UITextView+PrintField.h"
#import "MyMessage.h"
#import "MessageModel.h"
#import "CheakBubble.h"
#import "UITextView+PrintField.h"
#import "ZZDAlertView.h"
#import "BossCheatTitleCell.h"
#import "PersonCheatTitleCell.h"
#import "NewZZDPeopleViewController.h"
#import "FMDBMessages.h"
#import "TRRTuringAPI.h"
#import "TRRTuringAPIConfig.h"
#import "TRRTuringRequestManager.h"
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
@interface RobotViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic, strong)UITableView *cheatTableView;
@property (nonatomic, strong)NSArray *otherLookArr;
@property (nonatomic, strong)NSMutableArray *messageArr;
@property (nonatomic, strong)NSMutableAttributedString *sendAttStr;
@property (nonatomic, strong)NSString *sendStr;
@property (nonatomic, strong)NSMutableArray *strArr;
//添加手势回收键盘
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;

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


@property (nonatomic, strong)AVIMClient *client;
@property (nonatomic, strong)AVIMClient *receiveClient;
@property (nonatomic, strong)NSString *conversationId;
@property (nonatomic, strong)UIView *keyboardView;
@property (nonatomic, strong)UITextView *keyboardField;
@property (nonatomic, strong)NSMutableArray *emojiArr;
@property (nonatomic, strong)AVIMClient *mainClient;
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




@property (nonatomic, strong)MessageModel *messageModel;
@property (nonatomic, strong)NSCache *rowHeightDic;
@property (nonatomic, strong)NSCache *messageTextStrDic;

@property (nonatomic, assign)CGFloat keyBoardHeight;

@property (nonatomic, assign)BOOL isOut;
@property (nonatomic, strong)TRRTuringAPIConfig *apiConfig;
@property (nonatomic, strong)TRRTuringRequestManager *apiRequest;
@end

@implementation RobotViewController
- (void)initRobot
{
    NSString *currentStr = self.keyboardField.text;
    self.keyboardField.text = @"";
    //如userID==nil,需要调用request_UserIDwithSuccessBlock:failBlock:接口获取UserID
    if (self.apiConfig.userID == nil) {
        [self.apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {
            //获取UserID成功，继续调用OpenAPI接口
            [self.apiRequest request_OpenAPIWithInfo:currentStr successBlock:^(NSDictionary *dict) {
                //处理语义分析接口的返回结果
//                _outputTextView.text = [dict objectForKey:@"text"];
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
                [attributes setObject:@"1" forKey:@"robot"];
                AVIMTextMessage *message = [AVIMTextMessage messageWithText:[dict objectForKey:@"text"] attributes:attributes];
                
              [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:@"robot" rid:[AVUser currentUser].objectId]];
                self.length = 0;
                
                
                
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
                [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.cheatTableView endUpdates];
                
                if (self.mesArr.count > 0) {
                    
                    
                    [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    
                    
                    
                    
                }
            } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
                //处理语义分析失败结果
//                _outputTextView.text = infoStr;
            }];
        }
                                        failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
                                            //处理获取UserID失败的场景
//                                            _outputTextView.text = infoStr;
                                            NSLog(@"erroresult = %@", infoStr);
                                        }];
    } else {
        //如本地缓存了UserID，则直接调用OpenAPI接口
        [self.apiRequest request_OpenAPIWithInfo:currentStr successBlock:^(NSDictionary *dict) {
            NSLog(@"apiResult =%@",dict);
            
            
            
            
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
            
            [attributes setObject:@"0" forKey:@"jdId"];
            
            [attributes setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"1":@"2" forKey:@"bossOrWorker"];
//            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
//                
//                [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
//                
//                
//            }else{
//                [attributes setObject:self.rsId forKey:@"rsId"];
//            }
            [attributes setObject:@"1" forKey:@"type"];
            [attributes setObject:@"1" forKey:@"robot"];
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:[dict objectForKey:@"text"] attributes:attributes];
            
            [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:@"robot" rid:[AVUser currentUser].objectId]];
            self.length = 0;
            
            
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
            [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.cheatTableView endUpdates];
            
            
            
//            MyMessage *myMessage = [[MyMessage alloc]init];
//            myMessage.bossOrWorker = [[attributes objectForKey:@"bossOrWorker"]integerValue];
//            myMessage.jdId = [[attributes objectForKey:@"jdId"]integerValue];
//            myMessage.rsId = [[attributes objectForKey:@"rsId"]integerValue];
//            myMessage.type = [[attributes objectForKey:@"type"]integerValue];
//            //如果是音频，文字数据字段用于保存时间
//            myMessage.text = [FMDBMessages getMessageContnet:message];
//            myMessage.url = message.file.url;
//            myMessage.mediaType = message.mediaType;
//            myMessage.sendId = sid;
//            myMessage.receiveId = rid;
//            myMessage.timeStamp = message.sendTimestamp;
//            myMessage.status = message.status;
//            
//            [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:self.objectId rid:[AVUser currentUser].objectId]];
//            _outputTextView.text = [dict objectForKey:@"text"];
            
            if (self.mesArr.count > 0) {
                
                
                [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
                
                
                
            }
        } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
//            _outputTextView.text = infoStr;
            NSLog(@"errorinfo = %@", infoStr);
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化TRRTuringAPIConfig对象
    self.mesArr = [NSMutableArray array];
    self.apiConfig = [[TRRTuringAPIConfig alloc]initWithAPIKey:@"073d554edad44f67b87a3a985ddc049a"];
    self.apiRequest = [[TRRTuringRequestManager alloc] initWithConfig:self.apiConfig];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
    NSString *plistPath = [path stringByAppendingPathComponent:@"info.plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
    self.otherLookArr = arr;
    UIImage *um = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"001.png"]];
    
    
    
//    if (self.rsId == nil && [[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
//        self.rsId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"];
//        
//    }
    
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
    
    
//    NSArray * array = [FMDBMessages getMessageFromDB:self.objectId rid:[AVUser currentUser].objectId jd:[NSString stringWithFormat:@"%@", self.jdId] count:self.messageCount];
//    
//    [self.mesArr removeAllObjects];
//    
//    for (MyMessage *message in array) {
//        
//        [self.mesArr insertObject:message atIndex:0];
//    }
//    NSArray *jdArr = [FMDBMessages getHeaderJDMessagejd:[NSString stringWithFormat:@"%@",self.jdId] rsId:[NSString stringWithFormat:@"%@", self.rsId]];
//    
//    if (jdArr.count > 0) {
//        
//        [self.mesArr insertObject:[jdArr firstObject] atIndex:0];
//    }
//    
//#pragma mark --------  刷新
//    if (self.messageArr.count==0) {
//        [self.cheatTableView reloadData];
//    }else
//    {
//        [self.cheatTableView reloadRowsAtIndexPaths:[NSIndexPath indexPathForRow:self.messageArr.count  inSection:0] withRowAnimation:UITableViewRowAnimationNone];
//        
//        
//    }
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMainMessage:) name:@"message" object:nil];
    
//    if (self.jdDic != nil && jdArr.count == 0) {
//        
//        [self doSomeThingJD];
//    }
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    
    [AVOSCloud setAllLogsEnabled:YES];
    
    [self createCheatView];
    
    [self createKeyBoardView];
    [self.cheatTableView layoutIfNeeded];
    
    
    //    self.cheatTableView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    if (self.cheatTableView.contentSize.height > self.view.frame.size.height) {
        self.cheatTableView.contentOffset = CGPointMake(0, self.cheatTableView.contentSize.height);
        
    }
    
}
- (void)handleTap
{
    [self.keyboardField resignFirstResponder];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.keyboardField = [[UITextView_PrintField alloc]initWithFrame:CGRectMake(49, 10, self.view.frame.size.width - 49 * 3 + 10, 49 - 10 * 2)];
    self.keyboardField.layer.masksToBounds = YES;
    self.keyboardField.layer.borderColor = [UIColor colorFromHexCode:@"#eeeeee"].CGColor;
    self.keyboardField.layer.borderWidth = 0.8;
    self.keyboardField.layer.cornerRadius = 7;
    self.keyboardField.delegate = self;
    //    self.keyboardField.backgroundColor = [UIColor redColor];
    self.keyboardField.contentInset = UIEdgeInsetsMake(-4, 4, 0, 0);
    self.keyboardField.returnKeyType = UIReturnKeySend;
    self.keyboardField.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    [self.keyboardView addSubview:self.keyboardField];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextViewTextDidChangeNotification"object:self.keyboardField];
    
    
    self.speakImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 49 - 10 * 2, 49 - 10 * 2)];
    self.speakImage.image = [UIImage imageNamed:@"icon_yy.png"];
    
    self.speakImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *speakTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(speak)];
    [self.speakImage addGestureRecognizer:speakTap];
    [self.keyboardView addSubview:self.speakImage];
    
    UIImageView *lookImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 * 2 + 16, 10, 49 - 10 * 2, 49 - 10 * 2)];
    lookImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *lookTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(look)];
    [lookImage addGestureRecognizer:lookTap];
    lookImage.image = [UIImage imageNamed:@"icon_bq.png"];
    //    lookImage.backgroundColor = [UIColor blackColor];
    [self.keyboardView addSubview:lookImage];
    
    
    UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 + 10, 10, 49 - 2 * 10, 49 - 10 * 2)];
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(add)];
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:addTap];
    addImage.image = [UIImage imageNamed:@"icon_qt.png"];
    //    addImage.backgroundColor = [UIColor blackColor];
    [self.keyboardView addSubview:addImage];
    
}
- (void)changeTextViewHeight:(UITextView *)textView
{
    
    [self.keyboardField sizeToFit];
    
    self.keyboardField.frame = CGRectMake(9, 10, self.view.frame.size.width - 49 * 2 + 10, self.keyboardField.frame.size.height);
    self.keyboardView.frame = CGRectMake(self.keyboardView.frame.origin.x, self.view.frame.size.height - self.keyBoardHeight - self.keyboardField.frame.size.height  - 20, self.keyboardView.frame.size.width, self.keyboardField.frame.size.height + 20);
    
}
- (void)look
{
    NSLog(@"look");
    [self changeTextViewHeight:self.keyboardField];
    [self createLookView];
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
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.mainView.frame.size.height - 49);
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
- (void)add
{
    NSLog(@"add");
    [self createAddView];
}
- (void)createAddView
{
    [self.mainView removeFromSuperview];
    [self.speakButton removeFromSuperview];
    [self.returnToTextImage removeFromSuperview];
    [self.keyboardView removeFromSuperview];
    [self createKeyBoardView];
    
    
    [self.keyboardField resignFirstResponder];
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 50 - self.view.frame.size.width * 3 / 7 - 49, self.view.frame.size.width, self.keyboardField.frame.size.height + 20);
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 50 - self.view.frame.size.width * 3 / 7 - 49);
    [self createAlbumView];
}
- (void)createAlbumView
{
    
    self.albumView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 -  self.view.frame.size.width * 3 / 7, self.view.frame.size.width, 50 +  self.view.frame.size.width * 3 / 7)];
    self.albumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.albumView];
    
    UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(30  , 20, 66, 66)];
    //    photo.backgroundColor = [UIColor blackColor];
    photo.layer.masksToBounds = YES;
    photo.layer.cornerRadius = 33;
    photo.userInteractionEnabled = YES;
    photo.tag = 56;
    photo.image = [UIImage imageNamed:@"icon_zx.png"];
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)];
    [photo addGestureRecognizer:photoTap];
    [self.albumView addSubview:photo];
    
    UIImageView *album = [[UIImageView alloc]initWithFrame:CGRectMake(130 , 20, 66, 66)];
    //    album.backgroundColor = [UIColor blackColor];
    album.tag = 55;
    album.layer.masksToBounds = YES;
    album.layer.cornerRadius = 33;
    album.userInteractionEnabled = YES;
    UITapGestureRecognizer *albumTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)];
    [album addGestureRecognizer:albumTap];
    
    album.image = [UIImage imageNamed:@"icon_xc.png"];
    
    [self.albumView addSubview:album];
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 , 90, 66, 20)];
    photoLabel.text = @"拍照";
    photoLabel.textAlignment = 1;
    photoLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    photoLabel.textColor = [UIColor colorFromHexCode:@"#cccccc"];
    [self.albumView addSubview:photoLabel];
    
    UILabel *albumLabel =[[UILabel alloc]initWithFrame:CGRectMake(130, 90, 66, 20)];
    albumLabel.text = @"相册";
    albumLabel.textAlignment = 1;
    albumLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    albumLabel.textColor = [UIColor colorFromHexCode:@"#cccccc"];
    [self.albumView addSubview:albumLabel];
    if (self.mesArr.count > 0) {
        
        
        [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mesArr.count;
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
            }else{
                
                MessageModel * messageModel = [CheakBubble bubbleView:message.text from:NO withPosition:20 attributedStr:[self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: message.timeStamp]]];
                return messageModel.rowHeight;
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //    [textView sizeToFit];
    
    //    textView.attributedText = self.sendAttStr;
    if ([text isEqualToString:
         @"\n"]){
        if (textView.text.length > 0) {
            
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
            [attributes setObject:@"1" forKey:@"robot"];
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:textView.text attributes:attributes];
            
            [self.mesArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
        self.length = 0;
        
            
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.mesArr count]-1 inSection:0];
        [self.cheatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.cheatTableView endUpdates];
            
            
            if (self.mesArr.count > 0) {
                
                
                [self.cheatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mesArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
                
                
                
            }
       
            [self initRobot];
        }
        return NO;
    }
    return YES;
}

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
            
//            [self doSomeThingWithStr:textView];
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
//        [self doSomeThingWithStr:textView];
        
        
    }
}
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
                    [cell.rightHeader addGestureRecognizer:tap];
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
                [cell1.rightHeader addGestureRecognizer:tap];
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
                [cell3.imageImage addGestureRecognizer:imageTap];
                
                
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
                [cell3.rightHeader addGestureRecognizer:tap];
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

- (void)speak
{
    [self.mainView removeFromSuperview];
    [self.keyboardField resignFirstResponder];
    [self.albumView removeFromSuperview];
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    self.keyboardField.frame = CGRectMake(49, 10, self.view.frame.size.width - 49 * 3 + 10, 49 - 10 * 2);
    self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    
    
    self.speakButton = [[UIButton alloc]initWithFrame:self.keyboardField.frame];
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
                    
                    
                    
//                    [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                    
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        [self.mainView removeFromSuperview];
        [self.keyboardField resignFirstResponder];
        [self.albumView removeFromSuperview];
        self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        
        self.keyboardField.frame = CGRectMake(49, 10, self.view.frame.size.width - 49 * 3 + 10, 49 - 10 * 2);
        self.cheatTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 );
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
