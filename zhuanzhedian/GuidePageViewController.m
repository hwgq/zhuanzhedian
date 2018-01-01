//
//  GuidePageViewController.m
//  GuidePage
//
//  Created by Gaara on 15/12/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "GuidePageViewController.h"
#import "AppDelegate.h"
#import "UIColor+AddColor.h"
@interface GuidePageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl *pageControl;
@end

@implementation GuidePageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark 设置启屏界面
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [[UIScrollView alloc]
                            initWithFrame:self.view.frame];
    scroll.pagingEnabled = YES;
    
    scroll.showsVerticalScrollIndicator = NO;
    
    scroll.showsHorizontalScrollIndicator = NO;
    
    scroll.delegate = self;
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    NSArray *titleArr = @[@"即时沟通,主动勾搭BOSS",@"先了解再面试,增加成功率",@"试试用聊天的方式找工作"];
    NSArray *detailArr = @[@"不只有投简历,还可以换一种",@"地铁坐了一小时,到了才知不合适",@"转折点专注生物医药职业机会"];
    for (int i = 0; i < 3; i++) {
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
       
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png",@"引导页",i + 1]];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, self.view.frame.size.height - 240, self.view.frame.size.width, 30)];
        titleLabel.textAlignment = 1;
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
//        titleLabel.backgroundColor = [UIColor redColor];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, self.view.frame.size.height - 200, self.view.frame.size.width, 30)];
        detailLabel.textAlignment = 1;
        detailLabel.text = [detailArr objectAtIndex:i];
        detailLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        
        
        
        [scroll addSubview:image];
        
        if (i == 2)
        {
            UIButton *goBtn = [[UIButton alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width  + (self.view.frame.size.width - 100) / 2, self.view.frame.size.height - 150, 100, 30)];
            goBtn.layer.cornerRadius = 5;
            goBtn.layer.borderColor = [UIColor zzdColor].CGColor;
            goBtn.layer.borderWidth = 1;
            [goBtn addTarget:self action:@selector(goInTo) forControlEvents:UIControlEventTouchUpInside];
            goBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [goBtn setTitle:@"进入" forState:UIControlStateNormal];
            [goBtn setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
            [scroll addSubview:goBtn];
            
        }
//        detailLabel.backgroundColor = [UIColor blueColor];
        
        [scroll addSubview:titleLabel];
        [scroll addSubview:detailLabel];
        
    }
    [self.view addSubview:scroll];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 60, self.view.frame.size.width - 40, 30)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:self.pageControl];
}
#pragma mark 设置滑动界面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger count = scrollView.contentOffset.x / self.view.frame.size.width;
    self.pageControl.currentPage = count;
  
    if (scrollView.contentOffset.x > self.view.frame.size.width * 2 + 50)
    {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app doBigThing];
    }
}
- (void)goInTo
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app doBigThing];
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
