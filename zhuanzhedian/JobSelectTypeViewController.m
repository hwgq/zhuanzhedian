//
//  JobSelectTypeViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/2.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "JobSelectTypeViewController.h"
#import "JobSelectTypeCell.h"
#import "UILableFitText.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "EnterTitleViewController.h"
@interface JobSelectTypeViewController ()<UITableViewDelegate,UITableViewDataSource,EnterTitleDelegate>
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, strong)NSArray *titleImgArr;
@end
@implementation JobSelectTypeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainDic = [NSMutableDictionary dictionary];
        self.titleImgArr = @[@"针对市场.png",@"针对市场 copy.png",@"针对市场 copy 2.png",@"针对市场 copy 3.png",@"针对市场 copy 4.png",@"针对市场 copy 5.png",@"针对市场 copy 6.png"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createMainTable];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];

}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createMainTable
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
//    self.mainTableView.rowHeight = 60;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *str = @"".mutableCopy;
    UILabel *label = [[UILabel alloc]init];

    label.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    label.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    NSArray *arr = [[self.dataArr objectAtIndex:indexPath.row]objectForKey:@"sub_category"];
    for (int i = 0; i < arr.count ; i++) {
        if (i == 0) {
            [str appendString:[[arr objectAtIndex:i]objectForKey:@"name"]];
        }else{
             [str appendString:[NSString stringWithFormat:@" | %@",[[arr objectAtIndex:i]objectForKey:@"name"]]];
        }
    }
    label.text = str;
    CGSize subSize = [UILableFitText fitTextWithWidth:[UIScreen mainScreen].bounds.size.width - 160 label:label];
    [label removeFromSuperview];
    label = nil;
    return subSize.height + 40 + 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    JobSelectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[JobSelectTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setTitles:[self.dataArr objectAtIndex:indexPath.row]imgName:[self.titleImgArr objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    EnterTitleViewController *enterTitle = [[EnterTitleViewController alloc]init];
    enterTitle.delegate = self;
    enterTitle.currentStr = self.currentStr;
    enterTitle.currentType = [dic objectForKey:@"name"];
    [self.mainDic setObject:[dic objectForKey:@"name"] forKey:@"category"];
    [self.mainDic setObject:[dic objectForKey:@"id"] forKey:@"category_id"];
    [self.navigationController pushViewController:enterTitle animated:YES];
}
- (void)getTitleFromDic:(NSDictionary *)dic
{
    if ([self.state isEqualToString:@"work"]) {
        [self.mainDic addEntriesFromDictionary:dic];
        [self.delegate getTitleAndCategoryToWork:self.mainDic];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self.mainDic addEntriesFromDictionary:dic];
    [self.delegate getTitleAndCategory:self.mainDic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
