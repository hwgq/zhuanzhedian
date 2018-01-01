//
//  ConversationViewController.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/6.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ConversationViewController.h"
//#import <AVOSCloudIM/AVOSCloudIM.h>
#import "AVOSCloud/AVOSCloud.h"
#import "UserSaveTool.h"
#import "CheatViewController.h"
@interface ConversationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *conversationTable;
@property (nonatomic, strong)NSMutableArray *conversationArr;
@property (nonatomic, strong)UIView *backView;
@end

@implementation ConversationViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.conversationArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createConversationTable];
    
    [self getLocalConversationsAndMessages];
}
- (void)getLocalConversationsAndMessages
{
    //加载服务器数据，获取聊天记录
    NSArray *array = [UserSaveTool getAllDocumentsName:[AVUser currentUser].username];
   
    [self.conversationArr addObjectsFromArray:array];
    [self.conversationTable reloadData];
    [self judgeConversationArr:array];
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
            self.backView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 200, 200, 200)];
            UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 100, 100)];
            backImage.image = [UIImage imageNamed:@"对话框.png"];
            [self.backView addSubview:backImage];
            [self.conversationTable addSubview:self.backView];
        }
    }
}
- (void)createConversationTable
{
    self.conversationTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.conversationTable.delegate = self;
    
    self.conversationTable.dataSource = self;
    
    self.conversationTable.rowHeight = 100;
    
    [self.view addSubview:self.conversationTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.textLabel.text = [self.conversationArr objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheatViewController *cheat = [[CheatViewController alloc]init];
    
    AVUser *user = [AVUser user];
    
    user.username = [self.conversationArr objectAtIndex:indexPath.row];
    
    cheat.cheatUser = user;
    
    cheat.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:cheat animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
