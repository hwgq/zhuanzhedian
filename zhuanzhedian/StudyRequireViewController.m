//
//  StudyRequireViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "StudyRequireViewController.h"
#import "UIColor+AddColor.h"
#import "PriceRangeTableViewCell.h"
@interface StudyRequireViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *studyTableView;
@end

@implementation StudyRequireViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"学历要求";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createStudyRequireTableView];
}

- (void)createStudyRequireTableView
{
    self.studyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.studyTableView.delegate = self;
    self.studyTableView.dataSource = self;
    self.studyTableView.rowHeight = 48;
    [self.view addSubview:self.studyTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
