//
//  GoodCompanyJobsViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 17/2/12.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "GoodCompanyJobsViewController.h"
#import "NewZZDBossCell.h"
#import "AFNetworking.h"
#import "JobDetailViewController.h"
@interface GoodCompanyJobsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *jobsTable;
@property (nonatomic, strong)NSArray *jobsArr;
@end

@implementation GoodCompanyJobsViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
     self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllJob];
    
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TabBar_bg"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.image = [UIImage imageNamed:@"StatusBar_bg"];
    [self.navigationController.navigationBar addSubview:statusBarView];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    self.jobsTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.jobsTable.delegate = self;
    self.jobsTable.dataSource = self;
    self.jobsTable.rowHeight = 125;
    self.jobsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.jobsTable];
    // Do any additional setup after loading the view.
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
     self.navigationController.navigationBar.hidden = YES;
    
}

- (void)getAllJob
{
   
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"http://api.zzd.hidna.cn/v1/jd/getJdsFromUser";
    
   
        
        
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:self.jobId forKey:@"uid"];
        
        
        
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"] ) {
                self.jobsArr = [(NSDictionary *)responseObject objectForKey:@"data"];
                
                [self.jobsTable reloadData];
                
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jobsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    NewZZDBossCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NewZZDBossCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    [cell setSubViewTextFromDic:[self.jobsArr objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithButton:@"1"];
    
    jobDetail.dic = [NSMutableDictionary dictionaryWithDictionary:[self.jobsArr objectAtIndex:indexPath.row]];
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
