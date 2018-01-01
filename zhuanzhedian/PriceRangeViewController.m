//
//  PriceRangeViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "PriceRangeViewController.h"
#import "UIColor+AddColor.h"
#import "PriceRangeTableViewCell.h"
#import "FontTool.h"
@interface PriceRangeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *priceTableView;

@end

@implementation PriceRangeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = self.word;
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createPriceTableView];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createPriceTableView
{
    self.priceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.priceTableView.delegate = self;
    self.priceTableView.dataSource = self;
    self.priceTableView.rowHeight = 48;
    self.priceTableView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self.view addSubview:self.priceTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    PriceRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[PriceRangeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    if (self.array.count > 0) {
        [cell getPriceLabelText:[[self.array objectAtIndex:indexPath.row]objectForKey:@"name"]];
        
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([self.mainTitle isEqualToString:@"sex"]) {
        [dic setObject:[[self.array objectAtIndex:indexPath.row]objectForKey:@"name" ] forKey:self.mainTitle];
    }else if([self.mainTitle isEqualToString:@"work_state"]){
        if ([[[self.array objectAtIndex:indexPath.row]objectForKey:@"name" ] isEqualToString:@"在职"]) {
            [dic setObject:@"0" forKey:self.mainTitle];
        }else{
            [dic setObject:@"1" forKey:self.mainTitle];
        }
    }
    else{
    [dic setObject:[[self.array objectAtIndex:indexPath.row]objectForKey:@"name" ] forKey:self.mainTitle];
    [dic setObject:[[self.array objectAtIndex:indexPath.row]objectForKey:@"id" ]  forKey:[NSString stringWithFormat:@"%@_id",self.mainTitle]];
    
    
}

    [self.delegate getMyValue:dic];

    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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
