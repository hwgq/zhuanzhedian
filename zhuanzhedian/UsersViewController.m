//
//  UsersViewController.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/6.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "UsersViewController.h"
#import "AVOSCloud/AVOSCloud.h"
#import "CheatViewController.h"
#import "JudgeCreateCheatWindow.h"
#import "ConversationTableViewCell.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JudgeLocalUnreadMessage.h"
#import "ServiceViewController.h"
#import "MD5NSString.h"
#import "ZZDLoginViewController.h"
#import "FMDBMessages.h"
#import "MyMessage.h"
#import "MyConversation.h"
#import "FMDBMessages.h"
#import "MessageUtils.h"
#import "NotificationViewController.h"
#import "NotificationMessage.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface UsersViewController ()<UITableViewDataSource,UITableViewDelegate,AVIMClientDelegate>
@property (nonatomic, strong)UITableView *usersTable;
@property (nonatomic, strong)NSMutableArray *usersArr;
@property (nonatomic, strong)AVIMClient *receiveClient;
@property (nonatomic, strong)NSDictionary *jdDic;
@property (nonatomic, strong)NSMutableArray *otherMessageArr;
@property (nonatomic, strong)NSDictionary *userDic;
@property (nonatomic, strong)NSMutableArray *notifiArr;
@property (nonatomic, strong)UIView *backView;
@end

@implementation UsersViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.notifiArr = [NSMutableArray array];
        self.usersArr = [NSMutableArray array];
        
        self.otherMessageArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{

}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"UsersView"];
}
- (void)viewWillAppear:(BOOL)animated

{
    [AVAnalytics beginLogPageView:@"UsersView"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
    NSMutableArray *notifi = [FMDBMessages selectAllNotifiMessage];
    self.notifiArr = notifi;
    
    
    NSMutableArray *conver = [FMDBMessages selectAllConversation];
    
    self.usersArr = conver;
    [self judgeConversationArr:conver.copy];
    
    [self.usersTable reloadData];
    [JudgeLocalUnreadMessage tellNavHowMuchMessage];

}
- (void)getLocalConversation
{
    [self.usersArr removeAllObjects];
    //获取本地会话
    NSMutableArray *arr = [JudgeCreateCheatWindow getLocalConversationWindowArr];
    
    for (NSDictionary *dic in arr) {
        
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]]) {
            
            [self.usersArr addObject:dic];
        }
    }
   
    [self.usersTable reloadData];
    [self judgeConversationArr:arr];
}
- (void)judgeConversationArr:(NSArray *)arr
{
    if (arr.count > 0) {
        if (self.backView) {
            [self.backView removeFromSuperview];
            self.backView = nil;
        }
    }else{
        if (self.backView) {
            
        }else{
            self.backView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, self.view.frame.size.height / 3, 100, 100)];
            UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, 50, 50)];
            backImage.image = [UIImage imageNamed:@"duihuakuang.png"];
            
            UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50,100, 30)];
            backLabel.text = @"暂时没有新消息";
            backLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
            backLabel.textColor = [UIColor colorFromHexCode:@"#999999"];
            backLabel.textAlignment = 1;
            [self.backView addSubview:backLabel];
            [self.backView addSubview:backImage];
            [self.usersTable addSubview:self.backView];
        }
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    
    temporaryBarButtonItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    self.view.backgroundColor = [UIColor blackColor];
    
//    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
//    
//    titleLabel1.text = @"  最近联系的人";
//    
//    titleLabel1.font = [UIFont systemFontOfSize:12];
//    
//    titleLabel1.textColor = [UIColor grayColor];
//    
//    titleLabel1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
//    [self.view addSubview:titleLabel1];
    
    
    [self createUsersTable];
    
    
    
    
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    titleLabel.text = @"消息";
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMainMessage:) name:@"message" object:nil];

    
}


- (void)receiveMainMessage:(NSNotification *)n
{
    AVIMTypedMessage *message = [n object];
    
    NSDictionary *attributes = message.attributes;
    
    NSMutableDictionary *conDic = [NSMutableDictionary dictionary];

    [conDic setObject:message.clientId forKey:@"yourId"];
    
    [conDic setObject:[AVUser currentUser].objectId forKey:@"myId"];

    
    if ([attributes objectForKey:@"jdId"]!= nil) {
    [conDic setObject:[attributes objectForKey:@"jdId"] forKey:@"jdId"];
    }
    if ([attributes objectForKey:@"rsId"]!= nil) {
    [conDic setObject:[attributes objectForKey:@"rsId"] forKey:@"rsId"];
    }
    //pip:bug #1:不同的消息类型未判断，怎么确定message.text有值？
    //pip:bug-fixed bug#1
    if ([[NSString stringWithFormat:@"%@",[attributes objectForKey:@"type"] ]isEqualToString:@"-1"]) {
   //之后修改
//        NSData *data = [NSJSONSerialization dataWithJSONObject:message.text options:NSJSONWritingPrettyPrinted error:nil];
//        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        [conDic setObject:[jsonDic objectForKey:@"title"] forKey:@"lastText"];
    }else{
    NSString* brief = [MessageUtils getMessageBrief:message];
    [conDic setObject:brief forKey:@"lastText"];
    }
    [conDic setObject:[NSNumber numberWithDouble:message.sendTimestamp] forKey:@"lastTime"];
    
    [conDic setObject:[attributes objectForKey:@"bossOrWorker"] forKey:@"bossOrWorker"];
    
    AVObject *User = [AVObject objectWithoutDataWithClassName:@"_User" objectId:message.clientId];
    
    [User fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSString *name = [[object objectForKey:@"localData"]objectForKey:@"name"];
        
        NSString *header = [[object objectForKey:@"localData"]objectForKey:@"avatar"];
        
//bug
        if (name) {
        [conDic setObject:name forKey:@"name"];
        }
        [conDic setObject:header forKey:@"header"];
        if([message.attributes objectForKey:@"sub_type"]== nil){
        if (![[NSString stringWithFormat:@"%@",[message.attributes objectForKey:@"type"]]isEqualToString:@"-1"] ) {
            [FMDBMessages judgeConversationExist:conDic];
        }else{
            [FMDBMessages judgeServiceConversationExist:conDic];
        }
        }
        NSMutableArray *notifi = [FMDBMessages selectAllNotifiMessage];
        self.notifiArr = notifi;

        
        NSMutableArray *conver = [FMDBMessages selectAllConversation];
        
        self.usersArr = conver;
        [self judgeConversationArr:self.usersArr];

        [self.usersTable reloadData];
    }];
    
}
//- (void)receiveMessages
//{
//    self.receiveClient = [[AVIMClient alloc]init];
//    
//    self.receiveClient.delegate = self;
//    
//    [self.receiveClient openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
//        
//    }];
//}

- (void)createUsersTable
{
    self.usersTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    self.usersTable.delegate = self;
    
    self.usersTable.dataSource = self;
    self.usersTable.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    self.usersTable.rowHeight = 80;
   
    self.usersTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.usersTable];
    
   
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1)
    {
        return self.usersArr.count;
        
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *cellIdentify = @"cell";
    
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        
        cell = [[ConversationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *messageArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"];
    if (indexPath.section == 0) {
        
        NSInteger a = 0 ;
        for (NSDictionary *dic in messageArr) {
            if ([[dic objectForKey:@"jdId"]isEqualToString:@"0" ]) {
                a = a + 1;
            }
        }
        MyConversation *dic = [[MyConversation alloc]init];
        dic.lastText = @"暂无通知";
        dic.name = @"通知";
        dic.lastTime = 0;
        cell.a = a;
        if (self.notifiArr.count > 0) {
            NotificationMessage *message = [self.notifiArr firstObject];
            dic.lastText = message.text;
            dic.lastTime = message.timestamps;
            
        }
        [cell getHeaderValue:dic];
    }else{
    MyConversation *dic =  [self.usersArr objectAtIndex:indexPath.row];
    NSInteger a = 0;
    NSInteger b = 0;
   
    for (NSMutableDictionary *messageDic in messageArr) {
      
        if ([[messageDic objectForKey:@"clientId"] isEqualToString:dic.yourId] && [[messageDic objectForKey:@"jdId"] isEqualToString:[NSString stringWithFormat:@"%ld",dic.jdId]]) {
            
            a = a + 1;
        }else
        if ([[messageDic objectForKey:@"state"]isEqualToString:@"3"]) {
            b = b + 1;
        }
    }
        
        if (dic.bossOrWorker == 3) {
            cell.a = b;
        }else{
            
            cell.a = a;
        }

    
    [cell cellGetValue:dic];
    }

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NotificationViewController *notiVC = [[NotificationViewController alloc]init];
        notiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notiVC animated:YES];
        //此处是bug
        NSMutableArray * array = [NSMutableArray arrayWithArray:[[[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"]mutableCopy]];
        if (array.count > 0 && array != nil) {
            
            NSMutableArray *arrTwo = [NSMutableArray arrayWithArray:array];
        for (NSDictionary *dic in array) {
            if ([[dic objectForKey:@"jdId"]isEqualToString:@"0"]) {
                [arrTwo removeObject:dic];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:arrTwo forKey:@"messageArr"];
        }
    }else{
    ConversationTableViewCell * cell = [self tableView:self.usersTable cellForRowAtIndexPath:indexPath];
    
    cell.alertLabel.text = @"";
    
    cell.alertLabel.backgroundColor = [UIColor clearColor];
    
    MyConversation *myCon = [self.usersArr objectAtIndex:indexPath.row];
    
    //消除缓存中存的未读消息所对应的字典
    [self deleteTheMessages:indexPath];
    
    [JudgeLocalUnreadMessage tellNavHowMuchMessage];
        if (myCon.bossOrWorker == 3) {
            ServiceViewController *service = [[ServiceViewController alloc]init];
            service.myId =myCon.myId;
            service.yourId = myCon.yourId;
            service.header = myCon.header;
                    service.hidesBottomBarWhenPushed = YES;
//                    service.objectId = [[self.usersArr objectAtIndex:indexPath.row]objectForKey:@"objectId"];
                    [self.navigationController pushViewController:service animated:YES];
        }else{
    CheatViewController *cheat = [[CheatViewController alloc]init];
    
    cheat.objectId = myCon.yourId;
    
    cheat.title = myCon.name;
    
    cheat.jdDic = nil;
    
    cheat.title = myCon.name;
    
    cheat.rsId = [NSNumber numberWithInteger:myCon.rsId];
    
    cheat.jdId = [NSNumber numberWithInteger:myCon.jdId];
    
    cheat.cheatHeader = myCon.header;
    
    cheat.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:cheat animated:YES];
        }
    }
}
- (void)deleteTheMessages:(NSIndexPath *)indexPath
{
    
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"]mutableCopy];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
    
   MyConversation *dic =  [self.usersArr objectAtIndex:indexPath.row];
    if (dic.bossOrWorker == 3) {
        for (NSMutableDictionary *dic1 in array1) {
            
            if ([[dic1 objectForKey:@"state"]isEqualToString:@"3"]) {
                
                [array removeObject:dic1];
            }
            
        }
    }else{
    for (NSMutableDictionary *dic1 in array1) {
        
        if ([[dic1 objectForKey:@"clientId"] isEqualToString:dic.yourId] && [[dic1 objectForKey:@"jdId"] isEqualToString:[ NSString stringWithFormat:@"%ld",dic.jdId] ]) {
            
            [array removeObject:dic1];
        }

    }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"messageArr"];
    
    

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if(section == 1){
        UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        
        titleLabel1.text = @"    最近联系的人";
        
        titleLabel1.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
        
        titleLabel1.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
        
        titleLabel1.backgroundColor = [UIColor colorFromHexCode:@"#f9f9f9"];
        return titleLabel1;
    }else{
        return nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone ;
    }else{
    MyConversation *dic =  [self.usersArr objectAtIndex:indexPath.row];
    if (dic.bossOrWorker == 3) {
        return UITableViewCellEditingStyleNone;
    }else{
    return UITableViewCellEditingStyleDelete;
    }
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        MyConversation *dic = [self.usersArr objectAtIndex:indexPath.row];
        
        [FMDBMessages deleteOneConversation:dic.jdId rsId:dic.rsId];

        NSMutableDictionary *conDic = [NSMutableDictionary dictionary];
       
        [conDic setObject:dic.yourId forKey:@"yourId"];
        
        [conDic setObject:dic.myId forKey:@"myId"];


        
        [conDic setObject:[NSNumber numberWithInteger: dic.jdId] forKey:@"jdId"];
        
        [conDic setObject:[NSNumber numberWithInteger:dic.rsId] forKey:@"rsId"];
        
        [conDic setObject:dic.lastText forKey:@"lastText"];
        
        [conDic setObject:[NSNumber numberWithDouble:dic.lastTime ]forKey:@"lastTime"];
        
        [conDic setObject:[NSNumber numberWithInteger: dic.bossOrWorker] forKey:@"bossOrWorker"];

            [conDic setObject:dic.name forKey:@"name"];
        
            [conDic setObject:dic.header forKey:@"header"];
            
            [FMDBMessages judgeConversationExist:conDic];
        
        NSMutableArray *conver = [FMDBMessages selectAllConversation];
        
        self.usersArr = conver;
         [self judgeConversationArr:self.usersArr];
        [self.usersTable reloadData];
    
        }];
    editAction.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];;

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        MyConversation *dic = [self.usersArr objectAtIndex:indexPath.row];
        
        [FMDBMessages deleteOneConversation:dic.jdId rsId:dic.rsId];
        [self deleteTheMessages:indexPath];
        
    
        [JudgeLocalUnreadMessage tellNavHowMuchMessage];
        
        [self.usersArr removeObject:dic];
          [self judgeConversationArr:self.usersArr];
        [self.usersTable reloadData];
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction,editAction];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0001;
    }else{
        return 30;
    }
}

@end
