//
//  ZZDEditFieldView.h
//  LoginAndRegist
//
//  Created by Gaara on 16/6/29.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZDEditFieldView : UIView
- (instancetype)initWithFrame:(CGRect)frame key:(NSString *)key placeHolder:(NSString *)placeHolder;
@property (nonatomic, strong)UITextField *loginField;
@end
