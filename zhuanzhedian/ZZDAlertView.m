//
//  ZZDAlertView.m
//  Alert
//
//  Created by Gaara on 16/6/20.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDAlertView.h"
#import "UIColor+AddColor.h"
#import "YesLayer.h"
#import "CircleLayer.h"
#import "FontTool.h"
#import "UILableFitText.h"
@interface ZZDAlertView ()
@property (nonatomic, strong)NSString *zzdTitle;
@property (nonatomic, strong)NSString *zzdDetail;
@property (nonatomic, strong)UILabel *mainLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)YesLayer *alertImage;
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@end

@implementation ZZDAlertView
- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithFrame:view.frame];
    if (self) {
        [self createSubView];
    }
    return self;
}
- (void)createSubView
{
    self.userInteractionEnabled = YES;
    self.window.windowLevel = UIWindowLevelAlert;
    self.mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 250) / 2,([UIScreen mainScreen].bounds.size.height - 150) / 2 - 64, 250, 150)];
    self.mainLabel.backgroundColor = [UIColor zzdColor];
//    self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.mainLabel.userInteractionEnabled = YES;
//    self.mainLabel.backgroundColor = [UIColor whiteColor];
    self.mainLabel.layer.cornerRadius = 10;
    self.mainLabel.layer.masksToBounds = YES;
//    [self addSubview:self.mainLabel];
    
    
    
    
    UIView *underView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.mainLabel.frame.size.width, self.mainLabel.frame.size.height - 40)];
    underView.backgroundColor = [UIColor whiteColor];
//    [self.mainLabel addSubview:underView];
    
    UIImageView *cancelImage = [[UIImageView alloc]initWithFrame:CGRectMake(220, 12, 15, 15)];
    cancelImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction:)];
    [self.mainLabel addGestureRecognizer:cancelTap];
    cancelImage.image = [UIImage imageNamed:@"cancel.png"];
//    [self.mainLabel addSubview:cancelImage];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.mainLabel.frame.size.width - 20, 30)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = 1;
//    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:18]objectAtIndex:1];
//    [self.mainLabel addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.textAlignment = 1;
//    self.detailLabel.backgroundC tolor = [UIColor redColor];
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.layer.cornerRadius = 5;
    self.detailLabel.layer.masksToBounds = YES;
    self.detailLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    self.detailLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//    [self.mainLabel addSubview:self.detailLabel];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 115, 240, 30)];
    btn.backgroundColor = [UIColor zzdColor];
    [btn setTitle:@"返  回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
//    [self.mainLabel addSubview:btn];
    
    
   
}
- (void)cancelAction:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}
- (void)complete:(id)sender
{
    [self removeFromSuperview];
}
- (void)setTitle:(NSString *)title detail:(NSString *)detail alert:(ZZDAlertState)alert
{
//    if (alert == YES) {
//        self.alertImage.image = [UIImage imageNamed:@"成功.png"];
//    }else{
//        self.alertImage.image = [UIImage imageNamed:@"警告.png"];
//    }
    
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    if (alert == ZZDAlertStateYes) {
        self.alertImage = [[YesLayer alloc]initWithFrame:CGRectMake(40, 88, 15, 15)];
        [self.mainLabel addSubview:self.alertImage];
        
        UIView *circle = [[CircleLayer alloc]initWithFrame:CGRectMake(20, 44, 20, 20)];
        [self.mainLabel addSubview:circle];
        
        [self.alertImage show];
        
    }else if(alert == ZZDAlertStateNo){
        [self addSubview:self.detailLabel];
        [self.indicatorView removeFromSuperview];
        CGSize labelSize = [UILableFitText fitTextWithHeight:30 label:self.detailLabel];
        self.detailLabel.frame = CGRectMake((self.frame.size.width - labelSize.width) / 2, self.frame.size.height / 3 - 25 / 2, labelSize.width + 10, 30);
        [self animationStart:self.detailLabel];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(end) userInfo:nil repeats:YES];
        
    }else if(alert == ZZDAlertStateLoad){
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 35, [UIScreen mainScreen].bounds.size.height / 3 - 25, 70, 70)];
        self.indicatorView.color = [UIColor zzdColor];
        [self addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
        
    }else if(alert == ZZDAlertStateNormal)
    {
        [self addSubview:self.detailLabel];
        [self.indicatorView removeFromSuperview];
        CGSize labelSize = [UILableFitText fitTextWithHeight:30 label:self.detailLabel];
        self.detailLabel.frame = CGRectMake((self.frame.size.width - labelSize.width - 20) / 2, self.frame.size.height / 3 - 25 / 2, labelSize.width + 20, 30);
//        [self animationStart:self.detailLabel];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(end) userInfo:nil repeats:YES];
    }
    
}
- (void)end
{
    [self.indicatorView removeFromSuperview];
    [self removeFromSuperview];
    [self.detailLabel removeFromSuperview];

}
- (void)loadDidSuccess:(NSString *)str
{
    [self.indicatorView removeFromSuperview];
    self.detailLabel.text = str;
    self.alertImage = [[YesLayer alloc]initWithFrame:CGRectMake(40, 88, 15, 15)];
    [self.mainLabel addSubview:self.alertImage];
    
    UIView *circle = [[CircleLayer alloc]initWithFrame:CGRectMake(20, 44, 20, 20)];
    [self.mainLabel addSubview:circle];
    
    [self.alertImage show];
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(success:) userInfo:nil repeats:YES];
    [self removeFromSuperview];
    
}
- (void)success:(NSTimer *)timer
{
    [timer invalidate];
    [self.indicatorView removeFromSuperview];
    [self removeFromSuperview];
}
- (void)animationStart:(UIView *)view
{
    [self shakeAnimationForView:view];
}
- (void)shakeAnimationForView:(UIView *) view

{
    // 获取到当前的View
    
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    
    CGPoint x = CGPointMake(position.x + 10, position.y);
    
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    
    [animation setAutoreverses:YES];
    
    // 设置时间
    
    [animation setDuration:.05];
    
    // 设置次数
    
    [animation setRepeatCount:2];
    
    // 添加上动画
    
    [viewLayer addAnimation:animation forKey:nil];
    
    
    
}

@end
