//
//  JobHelperViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/8/25.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "JobHelperViewController.h"
#import "AFNetworking.h"
#import "MD5NSString.h"
#import "JobHelperTableViewCell.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import "JobHelperDetailViewController.h"
@interface JobHelperViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray *mainArr;
@property (nonatomic, strong)UITableView *mainTable;
@property (nonatomic, strong)UIView *titleView;
@property (nonatomic, strong)UIView *selectedView;
@property (nonatomic, strong)NSArray *bigArr;
@end

@implementation JobHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self getConnect];
    [self createSubView];
    
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    
    titleLabel.text = @"我的面试通";
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = 1;
    
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    self.navigationItem.titleView = titleLabel;
    
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getConnect
{
     NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
            
            NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",@"http://api.zzd.hidna.cn/v1/invite_info",[dic objectForKey:@"token"],time];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:time forKey:@"timestamp"];
            [parameters setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
            [parameters setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
            
            [manager GET:@"http://api.zzd.hidna.cn/v1/invite_info" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                    self.bigArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
                    for (int i = 0; i < self.bigArr.count; i++) {
                        [self.mainArr addObjectsFromArray:[self.bigArr objectAtIndex:i]];
                    }
                    [self.mainTable reloadData];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)createSubView
{
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    self.titleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.titleView];
    NSArray *arr = @[@"全部",@"待处理",@"处理中",@"已结束"];
    for (int i = 0; i < 4; i++) {
        UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width / 4, 0, self.view.frame.size.width / 4, 40)];
        selectLabel.textAlignment = 1;
        selectLabel.font = [UIFont systemFontOfSize:16];
        selectLabel.textColor = [UIColor colorFromHexCode:@"bbb"];
        
        if (i == 0) {
            selectLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
            self.selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, self.view.frame.size.width / 4, 2)];
            self.selectedView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
            [selectLabel addSubview:self.selectedView];
        }
        selectLabel.tag = i + 1;
        selectLabel.userInteractionEnabled = YES;
        [selectLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectType:)]];
        selectLabel.text = [arr objectAtIndex:i];
        [self.titleView addSubview:selectLabel];
        
        
    }
    
    
    
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40 - 64) style:UITableViewStylePlain];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTable];
    
}

- (void)selectType:(UITapGestureRecognizer *)tap
{
    UILabel *selectedLabel = (UILabel *)tap.view;
    
    
    UILabel *lastLabel = [self.view viewWithTag:self.selectedView.superview.tag];
    if (lastLabel) {
        lastLabel.textColor = [UIColor colorFromHexCode:@"bbb"];
        [self.selectedView removeFromSuperview];
    }
    selectedLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
    [selectedLabel addSubview:self.selectedView];
    
    if (selectedLabel.tag != 1) {
        self.mainArr = [NSMutableArray arrayWithArray:[self.bigArr objectAtIndex:(selectedLabel.tag - 2)]];
        [self.mainTable reloadData];
    }else{
        self.mainArr = [NSMutableArray array];
        for (int i = 0; i < self.bigArr.count; i++) {
            [self.mainArr addObjectsFromArray:[self.bigArr objectAtIndex:i]];
        }
        [self.mainTable reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    JobHelperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[JobHelperTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setValueFromDic:[self.mainArr objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.mainArr objectAtIndex:indexPath.row];
    JobHelperDetailViewController *jobHelperDetailVC = [[JobHelperDetailViewController alloc]init];
    jobHelperDetailVC.dic = dic;
    [self.navigationController pushViewController:jobHelperDetailVC animated:YES];
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
