//
//  WorkAndEduListController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/7/6.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "WorkAndEduListController.h"
#import "WorkAndEduListCell.h"
#import "EditInforViewController.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface WorkAndEduListController ()<UITableViewDelegate,UITableViewDataSource,EditInforViewControllerDelegate,DeleteEduAndWorkDelegate>
@property (nonatomic, strong)UITableView *workEduListTable;
@property (nonatomic, strong)NSMutableArray *listArr;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)UIButton *addBtn;
@end
@implementation WorkAndEduListController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listArr = [NSMutableArray array];
    }
    return self;
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWorkAndEduTable];
    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    imageBack.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [imageBack addGestureRecognizer:tap];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageBack];
    
}

- (void)createWorkAndEduTable;
{
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.mainScroll];
    
    self.workEduListTable = [[UITableView alloc]initWithFrame:CGRectMake(20,  20, self.view.frame.size.width - 40, 105 * self.listArr.count) style:UITableViewStylePlain];
    self.workEduListTable.delegate = self;
    self.workEduListTable.dataSource = self;
    self.workEduListTable.rowHeight = 105;
    self.workEduListTable.scrollEnabled = NO;
    self.workEduListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScroll addSubview:self.workEduListTable];
    
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20 + self.listArr.count * 105 + 20, self.view.frame.size.width - 40, 44)];
    self.addBtn.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.addBtn setTitle:@"添加更多工作经历" forState:UIControlStateNormal];
    if ([self.state isEqualToString:@"edu"]) {
         [self.addBtn setTitle:@"添加更多教育经历" forState:UIControlStateNormal];
    }
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addNewWorkAndEdu:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.mainScroll addSubview:self.addBtn];
    
    self.mainScroll.contentSize = CGSizeMake(0, 20 + self.listArr.count * 105 + 20 + 70);
    
}
- (void)setListArrWithArr:(NSArray *)arr state:(NSString *)state
{
    self.state = state;
    self.listArr = [arr mutableCopy];
    if (self.workEduListTable) {
        [self.workEduListTable reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    WorkAndEduListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WorkAndEduListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([self.state isEqualToString:@"edu"]) {
        NSDictionary *jobDic = [self.listArr objectAtIndex:indexPath.row];
        NSString *dateStr = [NSString stringWithFormat:@"%@ - %@",[jobDic objectForKey:@"edu_start_date"],[jobDic objectForKey:@"edu_end_date"]];
        NSString *detailStr = [NSString stringWithFormat:@"%@ · %@",[jobDic objectForKey:@"edu_experience"],[jobDic objectForKey:@"edu_major"]];
        [cell setLabelText:dateStr title:[jobDic objectForKey:@"edu_school"] detail:detailStr count:indexPath.row];
    }else if ([self.state isEqualToString:@"work"])
    {
        NSDictionary *jobDic = [self.listArr objectAtIndex:indexPath.row];
        NSString *dateStr = [NSString stringWithFormat:@"%@ - %@",[jobDic objectForKey:@"work_start_date"],[jobDic objectForKey:@"work_end_date"]];
        NSString *detailStr = [NSString stringWithFormat:@"%@ · %@",[jobDic objectForKey:@"title"],[jobDic objectForKey:@"sub_category"]];
        [cell setLabelText:dateStr title:[jobDic objectForKey:@"cp_name"] detail:detailStr count:indexPath.row];
    }
    tableView.contentOffset = CGPointMake(0, 0);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
            editInforVC.delegate = self;
         editInforVC.key = self.state;
    editInforVC.count = self.listArr.count;
            NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
    editInforVC.keyId = [dic objectForKey:@"id"];
            if ([self.state isEqualToString:@"work"]) {
                [ editInforVC setArrValue:@[@[@"开始时间",@"work_start_date",[dic objectForKey:@"work_start_date"]],@[@"结束时间",@"work_end_date",[dic objectForKey:@"work_end_date"]],@[@"职位类型",@"category",[dic objectForKey:@"title"]],@[@"公司名称",@"cp_name",[dic objectForKey:@"cp_name"]]]];
            }else if([self.state isEqualToString:@"edu"]){
                [ editInforVC setArrValue:@[@[@"开始时间",@"edu_start_date",[dic objectForKey:@"edu_start_date"]],@[@"结束时间",@"edu_end_date",[dic objectForKey:@"edu_end_date"]],@[@"学    校",@"edu_school",[dic objectForKey:@"edu_school"]],@[@"专    业",@"edu_major",[dic objectForKey:@"edu_major"]],@[@"学    历",@"edu_experience",[dic objectForKey:@"edu_experience"]]]] ;
            }
            [self.navigationController pushViewController:editInforVC animated:YES];

}
- (void)deleteDic:(NSString *)keyId key:(NSString *)key
{
    [self.delegate deleteDicc:keyId key:key];
}
- (void)addNewWorkAndEdu:(id)sender
{
    EditInforViewController *editInforVC = [[EditInforViewController alloc]init];
                editInforVC.delegate = self;
    editInforVC.key = self.state;
    editInforVC.delegate = self;
    if ([self.state isEqualToString:@"work"]) {
        [ editInforVC setArrValue:@[@[@"开始时间",@"work_start_date",@""],@[@"结束时间",@"work_end_date",@""],@[@"职位类型",@"category",@""],@[@"公司名称",@"cp_name",@""]]] ;
    }else if([self.state isEqualToString:@"edu"]){
        [ editInforVC setArrValue:@[@[@"开始时间",@"edu_start_date",@""],@[@"结束时间",@"edu_end_date",@""],@[@"学    校",@"edu_school",@""],@[@"专    业",@"edu_major",@""],@[@"学    历",@"edu_experience",@""]]] ;
    }
    [self.navigationController pushViewController:editInforVC animated:YES];
}
- (void)updateEduAndWorkDic:(NSDictionary *)dic keyId:(NSString *)keyId key:(NSString *)key
{
    [self.delegate saveEduAndWorkDic:[dic mutableCopy] keyId:keyId key:key self:self];
    
}
- (void)updateDic:(NSDictionary *)dic
{
    
}
@end
