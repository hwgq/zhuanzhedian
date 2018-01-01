//
//  ZZDAlertView.h
//  Alert
//
//  Created by Gaara on 16/6/20.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZZDAlertState) {
    ZZDAlertStateYes = 0,
    ZZDAlertStateNo,
    ZZDAlertStateLoad,
    ZZDAlertStateNormal,
    
};
@interface ZZDAlertView : UIView
- (instancetype)initWithView:(UIView *)view;
- (void)setTitle:(NSString *)title detail:(NSString *)detail alert:(ZZDAlertState)alert;
- (void)animationStart:(UIView *)view;
- (void)loadDidSuccess:(NSString *)str;
@end
