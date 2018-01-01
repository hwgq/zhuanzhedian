//
//  MyViewTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MyViewTableViewCell.h"

@interface MyViewTableViewCell ()
@property (nonatomic, strong)UIImageView *myImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
@implementation MyViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabel];
    }
    return self;
}

- (void)createLabel
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 100, 38)];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    self.titleLabel.textAlignment = 1;
//    self.titleLabel.backgroundColor = [UIColor grayColor];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 12, 24, 24)];
//    self.myImageView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.myImageView];
    
    UIImageView *nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15, 19, 10, 10)];
    nextImageView.image = [UIImage imageNamed:@"back_i.png"];
    [self.contentView addSubview:nextImageView];
}

- (void)setLabelValue:(NSString *)labelText imageView:(NSString *)imageName
{
    self.titleLabel.text = labelText;
    self.myImageView.image = [UIImage imageNamed:imageName];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
