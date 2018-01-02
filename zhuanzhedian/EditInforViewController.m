//
//  EditInforViewController.m
//  EditInforVC
//
//  Created by Gaara on 16/6/28.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "EditInforViewController.h"
#import "EditInforTableCell.h"
#import "BtnInforTableCell.h"
#import "BtnDateTableCell.h"
#import "JobTagViewController.h"
#import "JobPlaceViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "FontTool.h"
#import "JobSelectTypeViewController.h"
#import "EnterTitleViewController.h"
@interface EditInforViewController ()<UITableViewDelegate,UITableViewDataSource,BtnInforTableCellDelegate,BtnInforTagDelegate,JobTagDelegate,BtnInforCategoryDelegate,JobPlaceViewDelegate,EditInforTableCellDelegate,BtnDateTableCellDelegate,JobSelectTypeDelegate,EnterTitleDelegate>
@property (nonatomic, strong)UITableView *editInforTable;
@property (nonatomic, strong)NSMutableArray *editInforArr;
@property (nonatomic, strong)NSMutableDictionary *smallDic;

@end
@implementation EditInforViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.editInforArr = [NSMutableArray array];
//        self.editInforArr = [@[@"公司名称",@"担任职位",@"起止时间"]mutableCopy];
        self.smallDic = [NSMutableDictionary dictionary];
        self.mainDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)saveInfor:(id)sender
{
    for (NSArray *arr in self.editInforArr) {
        NSMutableDictionary *dic = [self.smallDic mutableCopy];
        
        if ([arr objectAtIndex:2]!= nil && [arr objectAtIndex:1]!= nil) {
            if ([NSString stringWithFormat:@"%@",[arr objectAtIndex:2]].length > 0 && [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]].length > 0) {
        [self.smallDic setObject:[arr objectAtIndex:2] forKey:[arr objectAtIndex:1]];
                
            }
        }
             [self.smallDic addEntriesFromDictionary:dic];
    }
    if (self.smallDic.allKeys.count >= self.editInforArr.count) {
        
    
        
    if ([self.key isEqualToString:@"work"] || [self.key isEqualToString:@"edu"]) {
        [self.delegate updateEduAndWorkDic:self.smallDic keyId:self.keyId key:self.key];
    }else{
    [self.delegate updateDic:self.smallDic];
    }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];

    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveInfor:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    saveBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    [self createEditTable];
    
    if (([self.key isEqualToString:@"edu"] || [self.key isEqualToString:@"work"]) && (self.count > 1))
    {
        [self createDeleteBtn];
    }
    
}
- (void)createDeleteBtn
{
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake( 20, self.editInforArr.count * 60 + 80, self.view.frame.size.width - 40, 40)];
    deleteBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1];
    [deleteBtn setTitle:@"删  除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    deleteBtn.layer.cornerRadius = 20;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteThisEduAndWork) forControlEvents:UIControlEventTouchUpInside];
    [self.editInforTable addSubview:deleteBtn];

}
- (void)deleteThisEduAndWork
{
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    NSString *key = @"";
    if ([self.key isEqualToString:@"work"]) {
        key = @"job";
    }else{
        key = self.key;
    }
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/rs/%@/%@/delete",key,self.keyId];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"uid"] forKey:@"uid"];
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
//                    [self.deleteDelegate deleteEduAndWork:self.arrTitle dic:self.mainDic];
                    [self.delegate deleteDic:self.keyId key:key];
                    
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
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (void)setArrValue:(NSArray *)arr
{
    self.editInforArr = [arr mutableCopy];
}
- (void)createEditTable
{
    self.editInforTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.editInforTable.delegate = self;
    self.editInforTable.backgroundColor = [UIColor whiteColor];
    self.editInforTable.dataSource = self;
    self.editInforTable.rowHeight = 60;
    self.editInforTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.editInforTable];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editInforArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:1];
    if ([title isEqualToString:@"name"]||[title isEqualToString:@"edu_major"]||[title isEqualToString:@"edu_school"]||[title isEqualToString:@"cp_name"]) {
        static NSString *cellId = @"cell";
        EditInforTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[EditInforTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.delegate = self;
        [cell setPlaceHolder:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:0] key:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:1] state:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:2]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if([title isEqualToString:@"edu_start_date"]||[title isEqualToString:@"edu_end_date"]||[title isEqualToString:@"work_start_date"]||[title isEqualToString:@"work_end_date"]){
    
        static NSString *cellD = @"cellD";
        BtnDateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellD];
        if (!cell) {
            cell = [[BtnDateTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellD];
            
        }
        cell.delegate = self;
        [cell setPlaceHolder:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:0] key:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:1] state:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:2]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    
    }else{
        static NSString *cellI = @"cellI";
        BtnInforTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellI];
        if (!cell) {
            cell = [[BtnInforTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellI];
        }
        cell.delegate = self;
        cell.mainDic = self.mainDic;
        [cell setPlaceHolder:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:0] key:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:1] state:[[self.editInforArr objectAtIndex:indexPath.row]objectAtIndex:2]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)setBossTagArr:(NSMutableArray *)arr
{
    
    [self.smallDic setObject:arr forKey:@"tag_user"];
    [self.delegate setTagArr:arr];
}
- (void)jumpToCategory
{
    if ([self.state isEqualToString:@"1"]) {
        
    
//    JobPlaceViewController *jobPlace = [[JobPlaceViewController alloc]init];
//    jobPlace.dataArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"] objectForKey:@"category"];
//    jobPlace.delegate = self;
//    jobPlace.mainTitle = @"job";
//    jobPlace.word = @"职位类型";
// 
//    
//    [self.navigationController pushViewController:jobPlace animated:YES];
    
    
    
    JobSelectTypeViewController *jobSelect = [[JobSelectTypeViewController alloc]init];
    jobSelect.dataArr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"] objectForKey:@"category"];
    jobSelect.delegate = self;
    if (self.editInforArr.count > 0) {
        if ([[self.editInforArr objectAtIndex:0]objectAtIndex:2]) {
            jobSelect.currentStr = (NSString *)[[self.editInforArr objectAtIndex:0]objectAtIndex:2];
        }
    }
    [self.navigationController pushViewController:jobSelect animated:YES];
    
    
//    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    }else{
    EnterTitleViewController *enterTitle = [[EnterTitleViewController alloc]init];
    enterTitle.delegate = self;
//    enterTitle.currentStr = self.currentStr;
        if (self.editInforArr.count > 0) {
            if ([[self.editInforArr objectAtIndex:0]objectAtIndex:2]) {
                enterTitle.currentStr = (NSString *)[[self.editInforArr objectAtIndex:2]objectAtIndex:2];
            }
        }
//    enterTitle.currentType = [dic objectForKey:@"name"];
//    [self.mainDic setObject:[dic objectForKey:@"name"] forKey:@"category"];
//    [self.mainDic setObject:[dic objectForKey:@"id"] forKey:@"category_id"];
    [self.navigationController pushViewController:enterTitle animated:YES];
    }
}
- (void)getTitleFromDic:(NSDictionary *)dic
{
    [self.smallDic setValuesForKeysWithDictionary:dic];
    
    NSMutableArray *arr = [[self.editInforArr objectAtIndex:2]mutableCopy];
    [arr removeObjectAtIndex:2];
    if ([dic objectForKey:@"title"] == nil) {
        [arr insertObject:@"  " atIndex:2];
    }else{
        [arr insertObject:[dic objectForKey:@"title"] atIndex:2];
    }
    [self.editInforArr replaceObjectAtIndex:2 withObject:arr];
    [self.editInforTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)jumpToTagVC
{
    JobTagViewController *jobTagVC = [[JobTagViewController alloc]init];
    jobTagVC.dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"rs"];
    jobTagVC.delegate = self;
    [self.navigationController pushViewController:jobTagVC animated:YES];
}
- (void)setValue:(NSString *)value key:(NSString *)key
{
    [self.smallDic setObject:value forKey:key];
}
- (void)getJobPlaceTextDic:(NSDictionary *)dic
{
    [self.smallDic addEntriesFromDictionary:dic];
}
- (void)getTitleAndCategory:(NSDictionary *)dic
{
    NSMutableArray *arr = [[self.editInforArr objectAtIndex:0]mutableCopy];
    [arr removeObjectAtIndex:2];
    if ([dic objectForKey:@"title"] == nil) {
    [arr insertObject:@"  " atIndex:2];
    }else{
    [arr insertObject:[dic objectForKey:@"title"] atIndex:2];
    }
    [self.editInforArr replaceObjectAtIndex:0 withObject:arr];
    [self.editInforTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.smallDic addEntriesFromDictionary:dic];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getJobChangeTextDic:(NSDictionary *)dic
{
    NSMutableArray *arr = [[self.editInforArr objectAtIndex:0]mutableCopy];
    [arr removeObjectAtIndex:2];
    if ([dic objectForKey:@"title"] == nil) {
        [arr insertObject:@"  " atIndex:2];
    }else{
        [arr insertObject:[dic objectForKey:@"title"] atIndex:2];
    }
    [self.editInforArr replaceObjectAtIndex:0 withObject:arr];
    [self.editInforTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.smallDic addEntriesFromDictionary:dic];
}
- (void)setValue:(NSString *)value andKey:(NSString *)key
{
    [self.smallDic setObject:value forKey:key];
    
}
- (void)setDate:(NSString *)date key:(NSString *)key
{
    [self.smallDic setObject:date forKey:key];
    
}
@end
