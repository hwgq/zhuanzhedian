//
//  BaseViewController.h
//  zhuanzhedian
//
//  Created by GuoQing Huang on 2018/1/3.
//  Copyright © 2018年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertBlock) (id block);

@interface BaseViewController : UIViewController

// navigation设置
- (void)setBackButtonWithImageName:(NSString *)imageName;
- (void)setNavgationTitle:(NSString *)title;

// 弹框
- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)style andButtonTitle1:(NSString *)buttonTitle1 action1:(AlertBlock)block1 buttonTitle2:(NSString *)buttonTitle2 action2:(AlertBlock)block2;
- (void)showLabelTitle:(NSString *)title;

@end
