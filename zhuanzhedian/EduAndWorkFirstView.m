//
//  EduAndWorkFirstView.m
//  zhuanzhedian
//
//  Created by Gaara on 17/4/6.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "EduAndWorkFirstView.h"
#import "CreateNewJobTableViewCell.h"
#import "HideCompanyTableViewCell.h"
#import "EditInforTableCell.h"
#import "BtnInforTableCell.h"
#import "BtnDateTableCell.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"

@interface EduAndWorkFirstView ()<UITableViewDelegate,UITableViewDataSource,EditInforTableCellDelegate,BtnInforTableCellDelegate,BtnDateTableCellDelegate,BtnInforTagDelegate,BtnInforCategoryDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, strong)NSMutableArray *editInforArr;


@end
@implementation EduAndWorkFirstView

- (instancetype)initWithFrame:(CGRect)frame state:(NSString *)state
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.state = state;
        self.titleArr = @[@"开始时间",@"结束时间",@"职位名称",@"公司名称"];
        self.mainDic = [NSMutableDictionary dictionary];
        if ([self.state isEqualToString:@"work"]) {
           self.editInforArr = @[@[@"开始时间",@"work_start_date",@""],@[@"结束时间",@"work_end_date",@""],@[@"职位类型",@"category",@""],@[@"公司名称",@"cp_name",@""]].mutableCopy;
        }else if([self.state isEqualToString:@"edu"])
        {
        self.editInforArr = @[@[@"开始时间",@"edu_start_date",@""],@[@"结束时间",@"edu_end_date",@""],@[@"学    校",@"edu_school",@""],@[@"专    业",@"edu_major",@""],@[@"学    历",@"edu_experience",@""]].mutableCopy;
        }
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    
    UILabel *titleImage = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 25)];
    
    titleImage.textAlignment = 1;
    titleImage.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    if ([self.state isEqualToString:@"work"]) {
        titleImage.text = @"\"你最新的工作经历\"";
    }else if ([self.state isEqualToString:@"edu"])
    {
      titleImage.text = @"\"你最高的教育经历\"";
    }
    
    titleImage.textColor = [UIColor colorFromHexCode:@"38ab99"];
    [self addSubview:titleImage];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 60 * self.editInforArr.count) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
//    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //    self.eduTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
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
- (void)setValue:(NSString *)value andKey:(NSString *)key
{
    [self.firstDelegate setEduAndWorkFirstValue:value key:key state:self.state];
}
- (void)setValue:(NSString *)value key:(NSString *)key
{
    [self.firstDelegate setEduAndWorkFirstValue:value key:key state:self.state];
}
- (void)setDate:(NSString *)date key:(NSString *)key
{
    [self.firstDelegate setEduAndWorkFirstValue:date key:key state:self.state];
}
- (void)jumpToTagVC
{
    [self.firstDelegate setTag];
}
- (void)jumpToCategory
{
    [self.firstDelegate setCategory];
}
- (void)setFirstLine:(NSString *)title
{
    self.editInforArr = @[@[@"开始时间",@"work_start_date",@""],@[@"结束时间",@"work_end_date",@""],@[@"职位类型",@"category",title],@[@"公司名称",@"cp_name",@""]].mutableCopy;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
@end
