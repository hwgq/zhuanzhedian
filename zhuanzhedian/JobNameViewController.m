//
//  JobNameViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobNameViewController.h"
#import "UIColor+AddColor.h"
#import "CountHowMuchStr.h"
#import "JobPlaceViewController.h"
#import "ZZDAlertView.h"
#import "AFNetworking.h"
#import "FontTool.h"
@interface JobNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *myJobNameField;
@property (nonatomic, strong)UILabel *textLengthLabel;

@end

@implementation JobNameViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)getConnectRecommend
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *url = [NSString stringWithFormat:@"http://139.196.7.234/v1/jd/recommend/%@",self.word];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getConnectRecommend];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = self.word;
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    
    UIButton *rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBarButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    rightBarButton.titleLabel.textAlignment = 2;
    [rightBarButton addTarget:self action:@selector(saveMyJobName:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    
    
    [self createTextField];
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveMyJobName:(id)sender
{
    if ([CountHowMuchStr convertToInt:self.myJobNameField.text] > self.len) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您输入的内容超过%d字",self.len] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
//        [alert show];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:[NSString stringWithFormat:@"您输入的内容超过%ld字",self.len] alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        
    } else if([CountHowMuchStr convertToInt:self.myJobNameField.text] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
//        [alert show];
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请输入内容" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];

    } else {
        
        
        
        // 协议步骤三
        [self.delegate getNameTextDic:[NSDictionary dictionaryWithObject:self.myJobNameField.text forKey:self.mainTitle]];
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"back"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"backmain" forKey:@"back"];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
            }
    
    
}
- (void)createTextField
{
    UIView *jobNameView = [[UIView alloc]initWithFrame:CGRectMake(0,  20, self.view.frame.size.width, 48)];
    jobNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:jobNameView];
    self.myJobNameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 12, self.view.frame.size.width - 30, 30)];
    self.myJobNameField.delegate = self;
    self.myJobNameField.text = self.currentStr;
    self.myJobNameField.backgroundColor = [UIColor whiteColor];
    self.myJobNameField.placeholder = self.placeHolderStr;
    [self.myJobNameField setValue:[[FontTool customFontArrayWithSize:16]objectAtIndex:1] forKeyPath:@"_placeholderLabel.font"];
    [self.myJobNameField addTarget:self  action:@selector(valueChanged:)  forControlEvents:
     UIControlEventAllEditingEvents];
    self.myJobNameField.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [jobNameView addSubview:self.myJobNameField];
    
    self.textLengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 110, 68, 100, 40)];
    self.textLengthLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",[CountHowMuchStr convertToInt:self.currentStr],self.len]];
    self.textLengthLabel.textColor =  [UIColor zzdColor];;
    [self.textLengthLabel setAttributedText:noteStr] ;
    self.textLengthLabel.textAlignment = 2;
    [self.view addSubview:self.textLengthLabel];
}
- (void)valueChanged:(id)sender
{
    if ([CountHowMuchStr convertToInt:self.myJobNameField.text] > self.len) {
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",[CountHowMuchStr convertToInt:self.myJobNameField.text],self.len]];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"/"].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        [self.textLengthLabel setAttributedText:noteStr] ;
        
    }else{
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",[CountHowMuchStr convertToInt:self.myJobNameField.text],self.len]];
        [self.textLengthLabel setAttributedText:noteStr] ;
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
