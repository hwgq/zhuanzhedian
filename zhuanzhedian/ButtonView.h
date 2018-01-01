//
//  ButtonView.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/28.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ButtonViewDelegate <NSObject>

- (void)toDoSomeThingWithTitle:(NSString *)title image:(UIImageView *)image;

@end
@interface ButtonView : UIView
@property (nonatomic, strong)UILabel *titleLabel;
- (void)changeLabelText:(NSString *)str;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)id<ButtonViewDelegate>delegate;
@end
