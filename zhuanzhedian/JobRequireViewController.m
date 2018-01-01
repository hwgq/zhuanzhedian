//
//  JobRequireViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobRequireViewController.h"
#import "UIColor+AddColor.h"
#import "CountHowMuchStr.h"
#import "ZZDAlertView.h"
#import "FontTool.h"
#import "ScanViewController.h"
@interface JobRequireViewController ()<UITextViewDelegate,ScanViewControllerDelegate>
@property (nonatomic, strong)UITextView *myTextView;
@property (nonatomic, strong)UILabel *backLabel;
@property (nonatomic, strong)UILabel *numLabel;

@end

@implementation JobRequireViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
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
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self createTextView];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 18)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [rightButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.textAlignment = 2;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    

}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)complete
{
//    if ([CountHowMuchStr convertToInt:self.myTextView.text] > 180) {
////        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你输入的内容超过了180字" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
////        [alert show];
//        
//        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
//        [alertView setTitle:@"转折点提示" detail:@"你输入的内容超过了180字" alert:ZZDAlertStateNo];
//        [self.view addSubview:alertView];
//    }else{
    [self.delegate getChangedText:self.myTextView.text];
    [self.navigationController popViewControllerAnimated:YES];
//    }
}
- (void)createTextView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.backLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, 200, 24)];
    self.backLabel.text = [NSString stringWithFormat:@"请填写%@",self.word];
    self.backLabel.textColor = [UIColor lightGrayColor];
    self.backLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    if (self.currentStr.length != 0) {
        self.backLabel.frame = CGRectMake(5, 4, 0, 24);
    }
//    self.backLabel.backgroundColor = [UIColor yellowColor];
    [backView addSubview:self.backLabel];
    
    self.myTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 200)];
    self.myTextView.delegate = self;
    self.myTextView.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.myTextView.textAlignment = 0;
//    self.myTextView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
//    self.myTextView.text = @"请填写职位要求";
//    self.myTextView.textColor = [UIColor grayColor];
    self.myTextView.text = self.currentStr;
    self.myTextView.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    self.myTextView.backgroundColor = [UIColor clearColor];
    self.myTextView.showsVerticalScrollIndicator = NO;
    
   
    
    [self.view addSubview:self.myTextView];
    
//    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 228, 195, 20)];
//    self.numLabel.textAlignment = 2;
//    self.numLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.numLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
////    self.numLabel.backgroundColor = [UIColor whiteColor];
//    self.numLabel.text = [NSString stringWithFormat:@"%ld/180",[CountHowMuchStr convertToInt:self.currentStr]];
//    [self.view addSubview:self.numLabel];
    
    
    UIView *scanView = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 50 - 79, self.view.frame.size.width - 40, 40)];
    scanView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    UIImageView *scanImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 23, 23)];
    scanImg.image = [UIImage imageNamed:@"macIcon.png"];
    scanView.layer.cornerRadius = 5;
    [scanView addSubview:scanImg];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString:@"2"]) {
        
    
    UILabel *scanTitle = [[UILabel alloc]initWithFrame:CGRectMake(75, 5,250 - 55, 30)];
    scanTitle.textColor = [UIColor whiteColor];
    scanTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    scanTitle.text = @"扫码登录电脑编辑信息";
    [scanTitle addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterScan)]];
    scanTitle.userInteractionEnabled = YES;
    scanTitle.textAlignment = 1;
    [scanView addSubview:scanTitle];
    [self.view addSubview:scanView];
    }
}
- (void)enterScan
{

    ScanViewController *scanVC = [[ScanViewController alloc]init];
    scanVC.state = @"jd";
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)saveBossInfor
{
    [self.delegate scanSuccess];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL )textViewShouldBeginEditing:(UITextView *)textView
//{
////    self.myTextView.text=@"";
//    self.backLabel.frame = CGRectMake(5, 4, 0, 30);
//    self.myTextView.textColor = [UIColor blackColor];
//    
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView
{
   
    if (textView.text.length == 0) {
        self.backLabel.frame = CGRectMake(5, 4, 200, 24);
        self.numLabel.text = @"0/180";
    }else{
        self.backLabel.frame = CGRectMake(5, 4, 0, 24);
        if ([CountHowMuchStr convertToInt:textView.text] > 180) {
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/180",[CountHowMuchStr convertToInt:textView.text]]];
            NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"/"].location);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
            [self.numLabel setAttributedText:noteStr] ;
            
        }else{
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/180",[CountHowMuchStr convertToInt:textView.text]]];
            [self.numLabel setAttributedText:noteStr] ;
        }

    }
}

@end
