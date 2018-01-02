
//
//  JobTagViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/12/7.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobTagViewController.h"
#import "UIColor+AddColor.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ZZDAlertView.h"
#import "FontTool.h"

@interface JobTagViewController ()
@property (nonatomic, strong)NSMutableArray *tagArr;
@property (nonatomic, strong)NSMutableArray *selectedArr;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation JobTagViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tagArr = [NSMutableArray array];
        self.selectedArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.dic objectForKey:@"tag_user"] != nil) {
        
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"1"]) {
        if ([[self.dic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
            self.selectedArr = [NSMutableArray arrayWithArray:[self.dic objectForKey:@"tag_user"]];
        }else{
            NSData *data = [[self.dic objectForKey:@"tag_user"] dataUsingEncoding:NSUTF8StringEncoding];
            self.selectedArr =
            [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]];
            
        }
    }else{
    if ([[self.dic objectForKey:@"tag_boss"]isKindOfClass:[NSArray class]]){
        self.selectedArr = [NSMutableArray arrayWithArray:[self.dic objectForKey:@"tag_boss"]];
    }else{
        NSData *data = [[self.dic objectForKey:@"tag_boss"] dataUsingEncoding:NSUTF8StringEncoding];
        self.selectedArr =
        [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]];
        
    }
    }
    }
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"从事行业";
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self getTagConnection];
    
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height - 60 - 64, self.view.frame.size.width - 60, 35)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [rightButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    [self.view addSubview:rightButton];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
- (void)confirm:(id)sender
{
    if (self.selectedArr.count == 0) {
        NSLog(@"没选择");
    }else{
        if ([self.state isEqualToString:@"work"]) {
            [self.delegate setBossTagArrToWork:self.selectedArr];
        }else{
    [self.delegate setBossTagArr:self.selectedArr];
        }
    [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getTagConnection
{
    NSArray *array = [[[NSUserDefaults standardUserDefaults]objectForKey:@"comm"]objectForKey:@"tag"];
    self.tagArr = [NSMutableArray arrayWithArray:array];
    [self createTagView];
}
- (void)createTagView
{
    double width = ([UIScreen mainScreen].bounds.size.width - 60) / 3.0 ;
    double height = width  / 3 ;
    
    
    
    
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0,  35, self.view.frame.size.width, 60 + self.tagArr.count / 3  * (12 + height) + 12)];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 25)];
    alertLabel.text = @"最多添加三个标签";
    alertLabel.textAlignment = 0;
    alertLabel.textColor = [UIColor lightGrayColor];
    alertLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:alertLabel];
    
    
    for (int i = 0; i < self.tagArr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i % 3 * (width + 12) + 12, i / 3 * (height + 12) + 12, width, height)];
        [button setTitle:[[self.tagArr objectAtIndex:i]objectForKey:@"name"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.tag = i + 1;
        button.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        [button addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSInteger a = 0;
        for (NSDictionary *dic in self.selectedArr) {
            if ([button.titleLabel.text isEqualToString:[dic objectForKey:@"name"]]) {
                a = 1;
            }
        }
        if (a == 1) {
//            button.backgroundColor = [UIColor zzdColor];
            button.layer.borderColor = [UIColor colorFromHexCode:@"38ab99"].CGColor;
            button.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else
        {
//            button.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
            [button setTitleColor:[UIColor colorFromHexCode:@"b0b0b0"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIColor colorFromHexCode:@"b0b0b0"].CGColor;
            
        }
        
        [mainView addSubview:button];
    }
    
    
}
- (void)selectTag:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger a = 0;
    for (NSDictionary *dic in self.selectedArr) {
        if ([button.titleLabel.text isEqualToString:[dic objectForKey:@"name"]]) {
            a = 1;
        }
    }
    if (a == 1) {
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor colorFromHexCode:@"b0b0b0"].CGColor;
        [button setTitleColor:[UIColor colorFromHexCode:@"b0b0b0"] forState:UIControlStateNormal];

        [self.selectedArr removeObject:[self.tagArr objectAtIndex:button.tag - 1]];
    }else{
        if (self.selectedArr.count >= 3) {
//            self.hud = [[MBProgressHUD alloc]initWithView:self.view];
//            self.hud.mode = MBProgressHUDModeText;
//            self.hud.labelText = @"最多添加3个标签";
//            [self.view addSubview:self.hud];
//            [self.hud show:YES];
//            [self.hud hide:YES afterDelay:1];
//            [self.hud removeFromSuperViewOnHide];
            
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"最多添加3个标签" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
        }else{
            button.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
            button.layer.borderColor = [UIColor colorFromHexCode:@"38ab99"].CGColor;
[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.selectedArr addObject:[self.tagArr objectAtIndex:button.tag - 1]];
        }
    }
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
