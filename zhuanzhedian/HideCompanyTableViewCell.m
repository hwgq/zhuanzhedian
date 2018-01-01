//
//  HideCompanyTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/12/8.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "HideCompanyTableViewCell.h"
#import "UIColor+AddColor.h"
@implementation HideCompanyTableViewCell
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
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2f2f2f"];
    //    self.titleLabel.textColor = [UIColor lightGrayColor];
    

    [self.contentView addSubview:self.titleLabel];
    
    self.setting = [[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 7, 50, 38)];
    self.setting.onTintColor = [UIColor zzdColor];
    [self.contentView addSubview:self.setting];
}
- (void)getTitleLabelText:(NSString *)str
{
    self.titleLabel.text = str;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
