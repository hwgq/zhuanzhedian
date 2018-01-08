//
//  BaseViewController.m
//  zhuanzhedian
//
//  Created by GuoQing Huang on 2018/1/3.
//  Copyright © 2018年 Gaara. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self setBackButtonWithImageName:@"navbar_icon_back.png"];
}

// 设置 navigation 返回键
- (void)setBackButtonWithImageName:(NSString *)imageName {
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popController)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backImageView];
}

- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置 navigation title
- (void)setNavgationTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [[FontTool customFontArrayWithSize:16] objectAtIndex:1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg buttonTitle:(NSString *)btnTitle andAction:(AlertBlock)block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:block];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 弹窗UIAlertController
- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style andButtonTitle1:(NSString *)buttonTitle1 action1:(AlertBlock)block1 buttonTitle2:(NSString *)buttonTitle2 action2:(AlertBlock)block2 {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    if (buttonTitle1.length) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:buttonTitle1 style:UIAlertActionStyleDefault handler:block1];
        [alertController addAction:action1];
    } else if (buttonTitle2.length) {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:buttonTitle2 style:UIAlertActionStyleDefault handler:block2];
        [alertController addAction:action2];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

// 提示框，1秒后消失
- (void)showLabelTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    label.text = title;
    label.textColor = [UIColor colorFromHexCode:@"#39ab99"];
    [self.view addSubview:label];
    
    CATransition *transion = [CATransition animation];
    transion.type = @"reveal";
    [label.layer addAnimation:transion forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}


@end
