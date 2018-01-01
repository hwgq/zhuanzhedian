//
//  CheatHeaderTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/18.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CheatHeaderTableViewCell.h"
#import "CheatHeaderView.h"
#import "UILableFitText.h"
@interface CheatHeaderTableViewCell ()
@property (nonatomic, strong)UIImageView *line1;
@property (nonatomic, strong)UIImageView *line2;
@end
@implementation CheatHeaderTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createHeaderView];
    }
    return self;
}
- (void)createHeaderView
{
    self.headerView = [[CheatHeaderView alloc]initWithFrame:CGRectMake(10, 35, [UIScreen mainScreen].bounds.size.width - 20, 130)];
    self.headerView.layer.cornerRadius = 7;
    self.headerView.layer.masksToBounds = YES;
    self.headerView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    self.headerView.layer.borderWidth = 0.7;
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.contentView addSubview:self.headerView];
    
    UIImageView *otherImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 58, 25, 23 )];
//    otherImage.backgroundColor = [UIColor blackColor];
    otherImage.image = [UIImage imageNamed:@"pin1.png"];
    [self.contentView addSubview:otherImage];
    
    self.nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameTitleLabel.textAlignment = 1;
//    self.nameTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.nameTitleLabel.font = [UIFont systemFontOfSize:12];
    self.nameTitleLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.nameTitleLabel];
    
    self.line1 = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.line1.image = [UIImage imageNamed:@"line2.png"];
    [self.contentView addSubview:self.line1];
    
    self.line2 = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.line2.image = [UIImage imageNamed:@"line1.png"];
    [self.contentView addSubview:self.line2];


}
- (void)getNameFromCell:(NSString *)name
{
    NSString *titleStr = [NSString stringWithFormat:@"您正在和%@沟通以下职位",name];
    self.nameTitleLabel.text = titleStr;
    CGSize nameSize = [UILableFitText fitTextWithHeight:19 label:self.nameTitleLabel];
    self.nameTitleLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - nameSize.width) / 2, 12, nameSize.width, 19);
    
    self.line1.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - nameSize.width) / 2 - 50, 21, 40, 1);
    self.line2.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width + nameSize.width) / 2 + 10, 21, 40, 1);
    
}
- (void)awakeFromNib {
    // Initialization code
    }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
