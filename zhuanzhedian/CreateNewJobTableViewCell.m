//
//  CreateNewJobTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CreateNewJobTableViewCell.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface CreateNewJobTableViewCell ()<UITextFieldDelegate>


@end
@implementation CreateNewJobTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTitleLabel];
    }
    return self;
}
- (void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 38)];
//    self.titleLabel.backgroundColor = [UIColor grayColor];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
//    self.titleLabel.textColor = [UIColor lightGrayColor];
    
   
    [self.contentView addSubview:self.titleLabel];
    
    
//    UIImageView *nextImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15, 17, 7, 14)];
//    nextImage.image = [UIImage imageNamed:@"Back Chevron Copy 16.png"];
//    [self.contentView addSubview:nextImage];
    
    self.returnField = [[UITextField alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200 , 5, 200 - 10, 38)];
    self.returnField.textAlignment = 2;
    self.returnField.hidden = YES;
    self.returnField.textColor = [UIColor colorFromHexCode:@"38ab99"];
    self.returnField.font = [UIFont systemFontOfSize:14];
    [self.returnField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.returnField setValue:[UIColor colorFromHexCode:@"#b0b0b0"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.returnField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.returnField.delegate = self;
    [self.contentView addSubview:self.returnField];
    
    self.returnLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 5, 200 - 10, 38)];
    self.returnLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
//    self.returnLabel.backgroundColor = [UIColor blueColor];
    self.returnLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.returnLabel.textAlignment = 2;
    [self.contentView addSubview:self.returnLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 47, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    [self.contentView addSubview:lineView];
}
- (void)getTitleLabelText:(NSString *)str
{
    if ([str isEqualToString:@"公司邮箱"]||[str isEqualToString:@"公司简称"]||[str isEqualToString:@"公司全称"]||[str isEqualToString:@"你的职位"]||[str isEqualToString:@"姓名"]) {
        self.returnLabel.hidden = YES;
        self.returnField.hidden = NO;
        self.returnField.placeholder = [NSString stringWithFormat:@"请填写%@",str];
        
    }else{
        self.returnLabel.hidden = NO;
        self.returnField.hidden = YES;
    }
    self.titleLabel.text = str;
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    [self.delegate setTitle:self.returnStr andStr:theTextField.text];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
