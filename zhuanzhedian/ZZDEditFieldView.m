//
//  ZZDEditFieldView.m
//  LoginAndRegist
//
//  Created by Gaara on 16/6/29.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDEditFieldView.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface ZZDEditFieldView ()<UITextFieldDelegate>
@property (nonatomic, strong)NSString *myPlaceHolder;
@property (nonatomic, strong)NSString *key;

@end
@implementation ZZDEditFieldView
- (instancetype)initWithFrame:(CGRect)frame key:(NSString *)key placeHolder:(NSString *)placeHolder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.key = key;
        self.myPlaceHolder = placeHolder;
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews
{
//    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
//    self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = 20;
    
    
    self.loginField = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width , self.frame.size.height - 10)];
    self.loginField.placeholder = self.myPlaceHolder;
    self.loginField.delegate = self;
    self.loginField.textColor = [UIColor colorFromHexCode:@"#333333"];
    self.loginField.font = [[FontTool customFontArrayWithSize:18]objectAtIndex:1];
        [self.loginField setValue:[[FontTool customFontArrayWithSize:14]objectAtIndex:1] forKeyPath:@"_placeholderLabel.font"];
    [self.loginField setValue:[UIColor colorFromHexCode:@"#eeeeee"] forKeyPath:@"_placeholderLabel.textColor"];
    
    if ([self.key isEqualToString:@"newKey"] || [self.key isEqualToString:@"confirmKey"]) {
        self.loginField.secureTextEntry = YES;
    }
    [self addSubview:self.loginField];
    
    UIView *layer = [[UIView alloc]initWithFrame:CGRectMake(0, 5+ self.frame.size.height - 10 + 1, self.frame.size.width , 1)];
    layer.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    [self addSubview:layer];
    
}

@end
