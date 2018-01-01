//
//  JobNewCityTableViewCell.m
//  zhuanzhedian
//
//  Created by 李文涵 on 16/1/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "JobNewCityTableViewCell.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface JobNewCityTableViewCell ()
@property (nonatomic, strong)UILabel *cityLabel;
@end


@implementation JobNewCityTableViewCell

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
    self.cityLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.cityLabel.textColor = [UIColor colorFromHexCode:@"666666"];
    [self.contentView addSubview:self.cityLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, 47, [UIScreen mainScreen].bounds.size.width * 3 / 4 - 30, 1)];
    view.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
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
