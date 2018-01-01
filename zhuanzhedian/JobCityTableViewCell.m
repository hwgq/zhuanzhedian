//
//  JobCityTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobCityTableViewCell.h"

@interface JobCityTableViewCell ()
@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic,strong)UIButton *button;
@end
@implementation JobCityTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCityLabel];

    }
    return self;
}

- (void)createCityLabel
{
    
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width * 3 / 4 - 30, 48)];
    self.cityLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    
    [self.contentView addSubview:self.cityLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, 47, [UIScreen mainScreen].bounds.size.width * 3 / 4 - 30, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:view];
}
- (void)getCityLabelText:(NSString *)str
{
    self.cityLabel.text = str;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
