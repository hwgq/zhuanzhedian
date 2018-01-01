//
//  MainSearchViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/19.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "MainSearchViewController.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "NewZZDPeopleCell.h"
#import "NewZZDBossCell.h"
#import "JobDetailViewController.h"
#import "NewZZDPeopleViewController.h"
@interface MainSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITextField *searchField;
@property (nonatomic, strong)UITableView *resultTable;
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)NSArray *resultArr;
@end

@implementation MainSearchViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.searchField becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    self.tabBarController.tabBar.hidden = YES;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, 30)];
    
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 75, 30)];
    backGroundView.layer.cornerRadius = 15;
    backGroundView.layer.masksToBounds = YES;
    backGroundView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:backGroundView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backView];
    
    self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(35, 5, self.view.frame.size.width - 120, 20)];
    self.searchField.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.searchField.textColor = [UIColor colorFromHexCode:@"#666666"];
    [self.searchField setValue:[UIColor colorFromHexCode:@"#dfdfdf"] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
    if ([role isEqualToString:@"2"]) {
        self.searchField.placeholder = @"职位/公司/姓名";
        
    }else{
        self.searchField.placeholder = @"职位/姓名";
    }
    self.searchField.returnKeyType = UIReturnKeySearch;
    [self.searchField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.searchField.delegate = self;
    [backGroundView addSubview:self.searchField];
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 16, 14)];
    searchIcon.image = [UIImage imageNamed:@"Group 2 Search.png"];
    [backGroundView addSubview:searchIcon];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 5, 60, 20)];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorFromHexCode:@"#b0b0b0"] forState:UIControlStateNormal];
    backBtn.titleLabel.textAlignment = 2;
    [backBtn addTarget:self action:@selector(backLastPage) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [backView addSubview:backBtn];
    
    
}
- (void)backLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)valueChanged:(UITextField *)field
{
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self startToSearch];
    }
    return YES;
}
- (void)startToSearch
{
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager.operationQueue cancelAllOperations];
    [self.manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            NSString *url = @"";
            if ([role isEqualToString:@"2"]) {
                
                url = @"http://api.zzd.hidna.cn/v1/rs/search";
            }else if ([role isEqualToString:@"1"])
            {
                url = @"http://api.zzd.hidna.cn/v1/jd/search";
            }
            
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:time forKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"token"],time];
            
            [parameters setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"] objectForKey:@"uid"] forKey:@"uid"];
            
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [parameters setObject:self.searchField.text forKey:@"key"];
            
            [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    self.resultArr = [responseObject objectForKey:@"data"];
                    [self createResultTable];
                    [self judgeConversationArr:self.resultArr];
                    [self.resultTable reloadData];
                    
                }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
                {
                    
                    
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

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
            backLabel.text = @"查无搜索结果";
            backLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
            backLabel.textColor = [UIColor colorFromHexCode:@"#999999"];
            backLabel.textAlignment = 1;
            [self.backView addSubview:backLabel];
            [self.backView addSubview:backImage];
            [self.resultTable addSubview:self.backView];
        }
    }
}

- (void)createResultTable
{
    if (!self.resultTable) {
    self.resultTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.resultTable.delegate = self;
    self.resultTable.dataSource = self;
    self.resultTable.rowHeight = 125;
        self.resultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.resultTable.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    [self.view addSubview:self.resultTable];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];

    if ([role isEqualToString:@"2"]) {
        static NSString *cellId = @"cell";
        NewZZDPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NewZZDPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSubViewTextFromDic:[self.resultArr objectAtIndex:indexPath.row]];
        
        return cell;
    }else if ([role isEqualToString:@"1"])
    {
        static NSString *cellId = @"cell1";
        NewZZDBossCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NewZZDBossCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setSubViewTextFromDic:[self.resultArr objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    

    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *role = [[NSUserDefaults standardUserDefaults]objectForKey:@"state"];
    if ([role isEqualToString:@"1"]) {
        
        JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
        
        jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.resultArr objectAtIndex:indexPath.row]];
        
        jobDetail.hidesBottomBarWhenPushed = YES;
//        if ([self judgeWhatILike:indexPath]) {
//            
//            jobDetail.collectType = @"YES";
//            
//        }else{
//            
//            jobDetail.collectType = @"NO";
//            
//        }
        
        [self.navigationController pushViewController:jobDetail animated:YES];
        
    }else if([role isEqualToString:@"2"]){
   
        NewZZDPeopleViewController *workDetail = [[NewZZDPeopleViewController alloc]init];
        
        
//        if ([self judgeWhatILike:indexPath]) {
//            
//            workDetail.collectType = @"YES";
//            
//        }else{
//            
//            workDetail.collectType = @"NO";
//        }
        workDetail.jdId = self.jdId;
        workDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.resultArr objectAtIndex:indexPath.row]];
        
        workDetail.hidesBottomBarWhenPushed = YES;
  
        [self.navigationController pushViewController:workDetail animated:YES];
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
