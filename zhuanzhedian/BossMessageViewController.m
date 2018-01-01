//
//  BossMessageViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/6/19.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "BossMessageViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "BossMessageTableViewCell.h"
#import "UILableFitText.h"
#import "UIColor+flat.h"
#import "FontTool.h"
#import <UMMobClick/MobClick.h>
@interface BossMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)NSMutableArray *mainArr;
@property (nonatomic, strong)NSMutableArray *bigArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UIPageControl *pageControl;

@end

@implementation BossMessageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"BossMessage"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"BossMessage"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.mainArr = [NSMutableArray array];
    [self getConnect];
    [self createTableView];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"lyArr"];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 111) {
        self.pageControl.currentPage = scrollView.contentOffset.x / self.view.frame.size.width ;
        self.mainArr = [[[ NSMutableArray arrayWithArray:self.bigArr]objectAtIndex:self.pageControl.currentPage]objectForKey:@"gtInfo"];
        [self.mainTableView reloadData];
    }
}
- (void)getConnect
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",@"http://api.zzd.hidna.cn/v1/jd/communicate",[dic objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [manager GET:@"http://api.zzd.hidna.cn/v1/jd/communicate" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    
//                    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
//                    mainView.backgroundColor = [UIColor colorWithHexCode:@"38AB99"];
                    self.bigArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
                    if (self.bigArr.count > 0) {
//                    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 170)];
//                    
//                    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, 170, 80, 20)];
//                    self.pageControl.numberOfPages = self.bigArr.count;
//                    [mainView addSubview:self.pageControl];
//                    
//                    
//                    mainScroll.contentSize = CGSizeMake(self.view.frame.size.width * self.bigArr.count, 0);
//                    mainScroll.tag = 111;
//                    mainScroll.delegate = self;
//                    mainScroll.bounces = NO;
//                    mainScroll.showsVerticalScrollIndicator = NO;
//                    mainScroll.showsHorizontalScrollIndicator = NO;
//                    mainScroll.backgroundColor = [UIColor colorWithHexCode:@"38AB99"];
//                    mainScroll.pagingEnabled = YES;
//                    [mainView addSubview:mainScroll];
//                    for (int i = 0; i < self.bigArr.count; i++) {
//                        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + self.view.frame.size.width * i, 10, self.view.frame.size.width - 20, 160)];
//                        view.backgroundColor = [UIColor whiteColor];
//                        [mainScroll addSubview:view];
//                        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width - 20, 50)];
//                        titleLabel.textAlignment = 1;
//                        titleLabel.textColor = [UIColor colorWithHexCode:@"38ab99"];
//                        titleLabel.font = [UIFont systemFontOfSize:18];
//                        titleLabel.text = [[[self.bigArr objectAtIndex:i]objectForKey:@"jdInfo"]objectForKey:@"title"];
//                        [view addSubview:titleLabel];
//                        
//                        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width - 20, 30)];
//                        detailLabel.textAlignment = 1;
//                        detailLabel.textColor = [UIColor colorWithHexCode:@"bbb"];
//                        detailLabel.font = [UIFont systemFontOfSize:16];
//                        detailLabel.text = [NSString stringWithFormat:@"%@ | %@",[[[self.bigArr objectAtIndex:i]objectForKey:@"jdInfo"]objectForKey:@"category"],[[[self.bigArr objectAtIndex:i]objectForKey:@"jdInfo"]objectForKey:@"city"]];
//                        [view addSubview:detailLabel];
//                        
//                        UILabel *salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width - 20, 30)];
//                        salaryLabel.textAlignment = 1;
//                        salaryLabel.textColor = [UIColor orangeColor];
//                        salaryLabel.font = [UIFont systemFontOfSize:16];
//                        salaryLabel.text = [NSString stringWithFormat:@"¥ %@",[[[self.bigArr objectAtIndex:i]objectForKey:@"jdInfo"]objectForKey:@"salary"]];
//                        [view addSubview:salaryLabel];
//                        
//                        
//                    }
//                    self.mainTableView.tableHeaderView = mainView;
                    
                        
                    
                    self.mainArr = [ NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
                    [self.mainTableView reloadData];
                    }else{
                        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 -  25  , self.view.frame.size.height / 2 - 25 , 50, 50)];
                        backImage.image = [UIImage imageNamed:@"duihuakuang.png"];
                        
                        UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 -  50, self.view.frame.size.height / 2 + 25 ,100, 30)];
                        backLabel.text = @"暂时没有留言";
                        backLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
                        backLabel.textColor = [UIColor colorWithHexCode:@"#999999"];
                        backLabel.textAlignment = 1;
                        [self.view addSubview:backLabel];
                        [self.view addSubview:backImage];
                    }
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 30)];
    titleLabel.textAlignment = 0;
    titleLabel.textColor = [UIColor colorWithHexCode:@"38ab99"];
    titleLabel.font = [UIFont systemFontOfSize:18];
     titleLabel.text = [[[self.mainArr objectAtIndex:section]objectForKey:@"jdInfo"]objectForKey:@"title"];
     [view addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 30)];
       detailLabel.textAlignment = 0;
        detailLabel.textColor = [UIColor colorWithHexCode:@"bbb"];
  detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.text = [NSString stringWithFormat:@"%@ | %@",[[[self.mainArr objectAtIndex:section]objectForKey:@"jdInfo"]objectForKey:@"category"],[[[self.mainArr objectAtIndex:section]objectForKey:@"jdInfo"]objectForKey:@"city"]];
                            [view addSubview:detailLabel];
    
    UILabel *salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 20, 100, 30)];
      salaryLabel.textAlignment = 2;
     salaryLabel.textColor = [UIColor orangeColor];
        salaryLabel.font = [UIFont systemFontOfSize:16];
    salaryLabel.text = [NSString stringWithFormat:@"¥ %@",[[[self.mainArr objectAtIndex:section]objectForKey:@"jdInfo"]objectForKey:@"salary"]];
     [view addSubview:salaryLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 99, self.view.frame.size.width - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithHexCode:@"eee"];
    [view addSubview:lineView];
    return view;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    lineView.backgroundColor = [UIColor colorWithHexCode:@"eee"];

    return lineView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[[self.mainArr objectAtIndex:indexPath.section]objectForKey:@"gtInfo"]objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手机号码:%@\n个人简介:%@",[dic objectForKey:@"mobile "],[dic objectForKey:@"intro"]]];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1.string length])];
    [label setAttributedText:attributedString1];
    

    CGSize size = [UILableFitText fitTextWithWidth:[UIScreen mainScreen].bounds.size.width - 40 label:label];
    [label removeFromSuperview];
   NSLog(@"%@  预估高度:%lf",[dic objectForKey:@"created_at"],size.height + 130);
    return 130 + size.height;
}
- (void)createTableView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [[self.mainArr objectAtIndex:section]objectForKey:@"gtInfo"];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    BossMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BossMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValueWithDic:[[[self.mainArr objectAtIndex:indexPath.section]objectForKey:@"gtInfo"] objectAtIndex:indexPath.row]];
    return cell;
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
