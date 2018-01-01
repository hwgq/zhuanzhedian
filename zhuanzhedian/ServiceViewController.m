//
//  ServiceViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/24.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ServiceViewController.h"
#import "SecretaryTableViewCell.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "UserSaveTool.h"
#import "WebDetailViewController.h"
#import "UIColor+AddColor.h"
#import "UITextView+PrintField.h"
#import "FMDBMessages.h"
#import "BlankString.h"
#import "MyMessage.h"
#import "NewCheatTableViewCell.h"
#import "SortTextDate.h"
#import "MessageModel.h"
#import "CheakBubble.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
#import "JobHelperDetailViewController.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
@interface ServiceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *serviceTable;
@property (nonatomic, strong)NSMutableArray *serviceArr;
@property (nonatomic, strong)AVIMClient *client;
@property (nonatomic, strong)UIView *keyboardView;
@property (nonatomic, strong)UITextView *keyboardField;
@property (nonatomic, strong)NSString *sendStr;
@property (nonatomic, strong)NSMutableAttributedString *sendAttStr;
@property (nonatomic, strong)NSMutableArray *strArr;
@property (nonatomic, assign)CGFloat keyBoardHeight;
@property (nonatomic, assign)NSInteger length;
@property (nonatomic, strong)NSMutableDictionary *messageTextStrDic;
@property (nonatomic, strong)MessageModel *messageModel;
@end

@implementation ServiceViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.serviceArr = [NSMutableArray array];
        self.sendAttStr = [[NSMutableAttributedString alloc]initWithString:@""];
        self.strArr = [NSMutableArray array];
        self.messageTextStrDic = [NSMutableDictionary dictionary];
        self.objectId = @"56555c9000b0acaad44a89fc";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"ServiceView"];
    [MobClick beginLogPageView:@"ServiceView"];
    [self.serviceArr removeAllObjects];
    
    NSMutableArray *serviceArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceArr"];
    
    for (NSDictionary*dic in serviceArr) {
        if ([[dic objectForKey:@"state"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]]) {
            
            [self.serviceArr addObject:dic];
            
        }else
            
        if ([[dic objectForKey:@"state"]isEqualToString:@"3"]) {
            
            [self.serviceArr addObject:dic];
        }
    }
    [self.serviceTable reloadData];
    
    [self registerForKeyboardNotifications];
    
    
}
- (void)registerForKeyboardNotifications
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
//    [self.albumView removeFromSuperview];
//    [self.mainView removeFromSuperview];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    self.keyBoardHeight = height;
    
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - height - 49, self.view.frame.size.width, 49);
    self.keyboardField.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    self.serviceTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - height - 49);
    //    [UIView animateWithDuration:[[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue] animations:^{
    ////        self.cheatTableView.contentOffset = CGPointMake(0, [self judgeContentSize] - height);
    //        if (self.mesArr.count > 0) {
    //
    //
    //        }
    //    }];
    if (self.serviceArr.count > 0) {
        
        
        [self.serviceTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.serviceArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [self changeTextViewHeight:self.keyboardField];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue] animations:^{
        
        self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        self.serviceTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
        self.keyboardField.frame = CGRectMake(9, 10, self.view.frame.size.width - 49 * 2 + 10, 49 - 10 * 2);
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
//        [self.mainView removeFromSuperview];
        [self.keyboardField resignFirstResponder];
//        [self.albumView removeFromSuperview];
        self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        
        self.keyboardField.frame = CGRectMake(9, 10, self.view.frame.size.width - 49 * 2 + 10, 49 - 10 * 2);
        self.serviceTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"ServiceView"];
    [MobClick endLogPageView:@"ServiceView"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"object:self.keyboardField];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.serviceArr.count > 0) {
        
        [self.serviceTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.serviceArr.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    titleLabel.text = @"系统小秘书";
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    
    
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    [self createServiceTable];
    
    [self createKeyBoardView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMainMessage:) name:@"message" object:nil];
}
- (void)receiveMainMessage:(NSNotification *)n
{
    AVIMTypedMessage *message = [n object];
    
    if ([[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"-1"]) {
        
        
        NSMutableDictionary *serviceDic = [NSMutableDictionary dictionary];
        [serviceDic setObject:message.text forKey:@"text"];
        [serviceDic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
        [serviceDic setObject:[message.attributes objectForKey:@"bossOrWorker"] forKey:@"bossOrWorker"];
        if ([message.attributes objectForKey:@"yms"]) {
            [serviceDic setObject:[message.attributes objectForKey:@"yms"] forKey:@"yms"];
        }
        [serviceDic setObject:[message.attributes objectForKey:@"type"]  forKey:@"type"];
        [serviceDic setObject:message.clientId forKey:@"sendId"];
        
        [serviceDic setObject:[AVUser currentUser].objectId forKey:@"receiveId"];
        
        [serviceDic setObject:[NSString stringWithFormat:@"%d", message.status] forKey:@"status"];
        [serviceDic setObject:[NSString stringWithFormat:@"%d",message.mediaType] forKey:@"mediaType"];
        [serviceDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"state"];
        [self.serviceArr addObject:serviceDic];
        
        self.length = 0;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.serviceArr count]-1 inSection:0];
        
        [self.serviceTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.serviceTable endUpdates];
        [self scrollViewToBottom:NO];
    }
    
}
- (void)scrollViewToBottom:(BOOL)animated {
    
    if ([self.serviceArr count] > 0) {
        
        [self.serviceTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.serviceArr count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getLocalConversation
{
    AVIMKeyedConversation *conver = [UserSaveTool getLocalConversation:[AVUser currentUser].objectId client:self.objectId] ;
    
    if (conver == nil) {
        
        [self connectConversation];
        
    }else{
        
        AVIMClient *client = [[AVIMClient alloc]initWithClientId:[AVUser currentUser].objectId tag:nil];
        
        AVIMConversation *conversation = [client conversationWithKeyedConversation:conver];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[conversation queryMessagesFromCacheWithLimit:1000]];
        
        NSMutableArray *messageArr = [NSMutableArray array];
        
        for (AVIMTypedMessage *message in arr) {
            
            if ([[message.attributes objectForKey:@"bossOrWorker"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]] || [[message.attributes objectForKey:@"bossOrWorker"]isEqualToString:@"3"]) {
                
                [messageArr addObject:message];
            }
        }
        self.serviceArr = [NSMutableArray arrayWithArray:messageArr];
        
        [self.serviceTable reloadData];
        
    }
}
- (void)connectConversation
{
    self.client = [[AVIMClient alloc]init];
    [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        
        [self.client createConversationWithName:[AVUser currentUser].objectId clientIds:@[self.objectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            
            AVIMKeyedConversation *keyedConversation = [conversation keyedConversation];
            
            BOOL a =  [UserSaveTool saveConversationToLocal:keyedConversation user:[AVUser currentUser].objectId client:self.objectId];
            
            if (a) {
                NSLog(@"存储成功");
            }
        }];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *serviceDic = [self.serviceArr objectAtIndex:indexPath.row];
    if (![[serviceDic objectForKey:@"text"]isKindOfClass:[NSDictionary class]]) {
    
        MessageModel * messageModel = [CheakBubble bubbleView:[serviceDic objectForKey:@"text"] from:NO withPosition:20 attributedStr:[self.messageTextStrDic objectForKey:[NSNumber numberWithDouble: [[serviceDic objectForKey:@"time"]doubleValue]]]];
        return messageModel.rowHeight;
    }else{
        return 350;
    }
}
- (void)createServiceTable
{
    self.serviceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 64) style:UITableViewStylePlain];
    self.serviceTable.delegate = self;
    self.serviceTable.dataSource = self;
    self.serviceTable.delaysContentTouches = NO;
    self.serviceTable.showsHorizontalScrollIndicator = NO;
    self.serviceTable.showsVerticalScrollIndicator = NO;
    
    self.serviceTable.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    self.serviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.serviceTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *serviceDic = [self.serviceArr objectAtIndex:indexPath.row];
    
    if (![[serviceDic objectForKey:@"text"]isKindOfClass:[NSDictionary class]]) {
        static NSString *cellIdentify = @"cell1";
        NewCheatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[NewCheatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        cell.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MyMessage *message = [[MyMessage alloc]init];
        message.text = [serviceDic objectForKey:@"text"];
        
        message.type = [[serviceDic objectForKey:@"type"]integerValue];
        message.bossOrWorker = [[serviceDic objectForKey:@"bossOrWorker"]integerValue];
        message.receiveId = [serviceDic objectForKey:@"receiveId"];
        message.sendId = [serviceDic objectForKey:@"sendId"];
        message.timeStamp = [[serviceDic objectForKey:@"time"]doubleValue];
        message.mediaType = [[serviceDic objectForKey:@"mediaType"]integerValue];
        message.status = [[serviceDic objectForKey:@"status"]integerValue];
        if ([serviceDic objectForKey:@"yms"]) {
            message.yms = [serviceDic objectForKey:@"yms"];
            message.text = [NSString stringWithFormat:@"%@ \n\n点击查看详情",[serviceDic objectForKey:@"text"]];
        }
        
        
        
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
            
//            [self.rowHeightDic setObject:[NSNumber numberWithDouble:self.messageModel.rowHeight] forKey:[NSNumber numberWithDouble:messages.timeStamp]];
            
            [cell getRightImage:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"avatar"]];
            
            
        }
        if ([message.receiveId isEqualToString:[AVUser currentUser].objectId]) {
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
//            [self.rowHeightDic setObject:[NSNumber numberWithDouble:self.messageModel.rowHeight] forKey:[NSNumber numberWithDouble:messages.timeStamp]];
            [cell getLeftImage:self.header];
            
            
            cell.rightHeader.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
//            cell.userInteractionEnabled = YES;
//            [cell.rightHeader addGestureRecognizer:tap];
            if (message.yms.integerValue > 0) {
                cell.rightView.userInteractionEnabled = YES;
                cell.rightView.tag = message.yms.integerValue;
                [cell.rightView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToJobHelperDetail:)] ];
                
            }else{
                cell.leftView.userInteractionEnabled = NO;
                [cell.leftView removeGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToJobHelperDetail:)]];
            }
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
//                self.rsId = [NSNumber numberWithInteger:message.rsId];
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
        
        
        
//        cell.timeLabel.text = [SortTextDate retrunTimeLabelText:indexPath.row arr:self.serviceArr];
        return cell;
    
}else{
    static NSString *cellIdentify = @"cell";
    
    SecretaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[SecretaryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
//    NSData *data = [NSJSONSerialization dataWithJSONObject:[serviceDic objectForKey:@"text"] options:NSJSONWritingPrettyPrinted error:nil];
    
    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookDetail:)];
    
    cell.mainView.tag = indexPath.row + 1;
    
    [cell.mainView addGestureRecognizer:tap];
    
    [cell getCellValue:serviceDic];
    
    
    
    return cell;
    }
}
- (void)goToJobHelperDetail:(UITapGestureRecognizer *)tap
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",@"http://api.zzd.hidna.cn/v1/invite_item_info",[dic objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [parameters setObject:[NSString stringWithFormat:@"%ld",tap.view.tag] forKey:@"inviteId"];
            [manager GET:@"http://api.zzd.hidna.cn/v1/invite_item_info" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    NSDictionary *dic = [[responseObject objectForKey:@"data"]objectAtIndex:0];
                    JobHelperDetailViewController *jobHelperDetailVC = [[JobHelperDetailViewController alloc]init];
                    jobHelperDetailVC.dic = dic;
                    [self.navigationController pushViewController:jobHelperDetailVC animated:YES];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)createKeyBoardView
{
    
    self.keyboardView.frame = CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49);
    self.serviceTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -  49 -64);
    
    
    
    self.keyboardView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 64, self.view.frame.size.width, 49)];
    self.keyboardView.backgroundColor = [UIColor colorFromHexCode:@"f7f7f7"];
    [self.view addSubview:self.keyboardView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#dddddd"];
    [self.keyboardView addSubview:lineView];
    
    self.keyboardField = [[UITextView_PrintField alloc]initWithFrame:CGRectMake(9, 10, self.view.frame.size.width - 49 * 2 + 10, 49 - 10 * 2)];
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
    
    
//    self.speakImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 49 - 10 * 2, 49 - 10 * 2)];
//    self.speakImage.image = [UIImage imageNamed:@"icon_yy.png"];
//    
//    self.speakImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *speakTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(speak)];
//    [self.speakImage addGestureRecognizer:speakTap];
//    [self.keyboardView addSubview:self.speakImage];
//    
//    UIImageView *lookImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 * 2 + 16, 10, 49 - 10 * 2, 49 - 10 * 2)];
//    lookImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *lookTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(look)];
//    [lookImage addGestureRecognizer:lookTap];
//    lookImage.image = [UIImage imageNamed:@"icon_bq.png"];
//    //    lookImage.backgroundColor = [UIColor blackColor];
//    [self.keyboardView addSubview:lookImage];
//    
//    
//    UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 + 10, 10, 49 - 2 * 10, 49 - 10 * 2)];
//    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(add)];
//    addImage.userInteractionEnabled = YES;
//    [addImage addGestureRecognizer:addTap];
//    addImage.image = [UIImage imageNamed:@"icon_qt.png"];
//    //    addImage.backgroundColor = [UIColor blackColor];
//    [self.keyboardView addSubview:addImage];
    
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 49 * 2 + 25, 10, 67, 49 - 20)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    sendBtn.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 7;
    [self.keyboardView addSubview:sendBtn];
    
}
- (void)sendMessage
{
    [self textFieldShouldReturn:self.keyboardField];
}
- (void)lookDetail:(UITapGestureRecognizer *)tap
{
    NSDictionary *serviceDic = [self.serviceArr objectAtIndex:tap.view.tag - 1];
    
    NSString *str = [[serviceDic objectForKey:@"text"]objectForKey:@"url"];
    
    WebDetailViewController *web = [[WebDetailViewController alloc]init];
    
    web.urlStr = str;
    
    [self.navigationController pushViewController:web animated:YES];
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
- (void)changeTextViewHeight:(UITextView *)textView
{
    
    [self.keyboardField sizeToFit];
    
    self.keyboardField.frame = CGRectMake(9, 10, self.view.frame.size.width - 49 * 2 + 10, self.keyboardField.frame.size.height);
    self.keyboardView.frame = CGRectMake(self.keyboardView.frame.origin.x, self.view.frame.size.height - self.keyBoardHeight - self.keyboardField.frame.size.height  - 20, self.keyboardView.frame.size.width, self.keyboardField.frame.size.height + 20);
    
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
            
            [self.client createConversationWithName:self.myId clientIds:@[self.yourId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
#pragma mark 修改的
                
//                [attributes setObject:self.jdId forKey:@"jdId"];
                
                [attributes setObject:@"3" forKey:@"bossOrWorker"];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
                    
                    [attributes setObject:[NSNumber numberWithInteger:[[[[NSUserDefaults standardUserDefaults]objectForKey:@"rs"]objectForKey:@"id"]integerValue]] forKey:@"rsId"];
                    
                    
                }else{
//                    [attributes setObject:self.rsId forKey:@"rsId"];
                }
                [attributes setObject:@"-1" forKey:@"type"];
               
                AVIMTextMessage *message = [AVIMTextMessage messageWithText:messageStr attributes:attributes];
                
                [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
//                        [FMDBMessages saveMessageWhenSend:message Rid:self.objectId];
                        
//                        [self.serviceArr addObject:[FMDBMessages messageTranToModel:message WithSid:[AVUser currentUser].objectId rid:self.objectId]];
                        self.length = 0;
                        //                        [self.cheatTableView reloadData];
                        
                       
                        NSMutableArray *serviceArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"serviceArr"]mutableCopy];
                        NSMutableDictionary *serviceDic = [NSMutableDictionary dictionary];
                        [serviceDic setObject:message.text forKey:@"text"];
                        [serviceDic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
                        [serviceDic setObject:[message.attributes objectForKey:@"bossOrWorker"] forKey:@"bossOrWorker"];
                        [serviceDic setObject:[message.attributes objectForKey:@"type"]  forKey:@"type"];
                        [serviceDic setObject:[AVUser currentUser].objectId forKey:@"sendId"];
                        
                        [serviceDic setObject:self.yourId forKey:@"receiveId"];
                        
                        [serviceDic setObject:[NSString stringWithFormat:@"%d", message.status] forKey:@"status"];
                        [serviceDic setObject:[NSString stringWithFormat:@"%d",message.mediaType] forKey:@"mediaType"];
                        [serviceDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"] forKey:@"state"];
                        [serviceArr addObject:serviceDic];
                        
                        [self.serviceArr addObject:serviceDic];
                        [[NSUserDefaults standardUserDefaults]setObject:serviceArr forKey:@"serviceArr"];
                        
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.serviceArr count]-1 inSection:0];
                        [self.serviceTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.serviceTable endUpdates];
                        
                        if (self.serviceArr.count > 0) {
                            
                            
                            [self.serviceTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.serviceArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                            
                            
                            
                            
                        }
                        
                        
                        
                        NSDictionary *attributes = message.attributes;
                        NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
                        //@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
                        [conDic setObject:self.objectId forKey:@"yourId"];
                        [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];
//                        [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
//                        [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
                        [conDic setObject:message.text forKey:@"lastText"];
                        [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
                        [conDic setObject:@"3" forKey:@"bossOrWorker"];
                        
                        
                        
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
                            
//                            [FMDBMessages judgeConversationExist:conDic];
                            [FMDBMessages judgeServiceConversationExist:conDic];


                            
                           
                            
                            
                        }];
                        
                        
                        
                        
                    }
                }];
            }];
        }];
    }
    
    
    
    
    
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
