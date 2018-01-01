//
//  PeopleCheatWithMeController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/3/9.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "PeopleCheatWithMeController.h"
#import "FMDBMessages.h"
#import "MyConversation.h"
#import "ConversationTableViewCell.h"
#import "ServiceViewController.h"
#import "CheatViewController.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
@interface PeopleCheatWithMeController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *usersArr;
@property (nonatomic, strong)UITableView *usersTable;
@end

@implementation PeopleCheatWithMeController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.usersArr = [NSMutableArray array];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"PeopleCheatWithMe"];
    [AVAnalytics beginLogPageView:@"PeopleCheatWithMe"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"PeopleCheatWithMe"];
    [AVAnalytics endLogPageView:@"PeopleCheatWithMe"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"沟通过的";
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    NSMutableArray *conver = [FMDBMessages selectAllConversation];
    
    self.usersArr = conver;
    [self createUsersTable];
    
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUsersTable
{
    self.usersTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.usersTable.delegate = self;
    
    self.usersTable.dataSource = self;
    self.usersTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.usersTable.rowHeight = 80;
    
    self.usersTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.usersTable];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (section == 0) {
    //        return 1;
    //    }else if(section == 1)
    //    {
    return self.usersArr.count;
    
    //    }else{
    //        return 0;
    //    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *cellIdentify = @"cell";
    
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        
        cell = [[ConversationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    if (indexPath.section == 0) {
    //        MyConversation *dic = [[MyConversation alloc]init];
    //        dic.lastText = @"潘刘阳查看了你的微简历";
    //        dic.name = @"通知";
    //        dic.lastTime = 1289938423231;
    //        cell.a = 1;
    //        [cell getHeaderValue:dic];
    //    }else{
    MyConversation *dic =  [self.usersArr objectAtIndex:indexPath.row];
    cell.a = 0;
    
    [cell cellGetValue:dic];
    //    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    MyConversation *myCon = [self.usersArr objectAtIndex:indexPath.row];
   
    
   
    if (myCon.bossOrWorker == 3) {
        ServiceViewController *service = [[ServiceViewController alloc]init];
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
    //    }
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
