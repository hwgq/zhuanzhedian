//
//  KeyWordTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/26.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "KeyWordTableViewCell.h"
#import "UIColor+AddColor.h"
@interface KeyWordTableViewCell ()

@property (nonatomic, strong)UILabel *titleLabel;
@end
@implementation KeyWordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        
    }
    return self;
}

- (void)createView
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 28)];
    self.titleLabel.textAlignment = 1;
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    self.titleLabel.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    
    self.keyTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, 180, 28)];
    [self.keyTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventAllEditingEvents];
    self.keyTextField.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    self.keyTextField.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.keyTextField];
    
    
  
}

- (void)createButton
{
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 72, 0, 72, 41)];
    self.button.backgroundColor = [UIColor whiteColor];

    
    [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    [self.button setTitleColor:[UIColor colorFromHexCode:@"#f99029"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.button];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 72.5, 9, 0.5, 23)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#f99029"];
    [self.contentView addSubview:lineView];
    
    
}

- (void)textChange:(UITextField *)field
{
    [self.delegate getKey:field.text title:self.titleLabel.text];
}

- (void)setValueText:(NSString *)title placeHolder:(NSString *)str
{
    self.titleLabel.text = title;
    self.keyTextField.placeholder = str;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
