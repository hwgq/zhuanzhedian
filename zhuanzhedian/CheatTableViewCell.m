//
//  CheatTableViewCell.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/9.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CheatTableViewCell.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
@interface CheatTableViewCell ()


@end
@implementation CheatTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCheatLabel];
    }
    return self;
}
- (void)createCheatLabel
{
    self.leftCheatLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, [UIScreen mainScreen].bounds.size.width  - 30 - 150, 60)];
    self.leftCheatLabel.backgroundColor = [UIColor whiteColor];
    self.leftCheatLabel.layer.cornerRadius = 7;

    self.leftCheatLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor
    ;
    self.leftCheatLabel.layer.masksToBounds = YES;
    self.leftCheatLabel.layer.borderWidth = 1;
    [self.contentView addSubview:self.leftCheatLabel];
    
    self.rightCheatLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, [UIScreen mainScreen].bounds.size.width - 30 - 150, 60)];
    self.rightCheatLabel.backgroundColor = [UIColor colorFromHexCode:@"#00abea"];
    self.rightCheatLabel.textColor = [UIColor whiteColor];

    [self.contentView addSubview:self.rightCheatLabel];
    
    self.left = [[UIImageView alloc]initWithFrame:CGRectMake(14, 27, 20, 20)];
//    right.backgroundColor = [UIColor blackColor];

    self.rightCheatLabel.layer.cornerRadius = 7;
    
    ;
    self.rightCheatLabel.layer.masksToBounds = YES;
    _left.image = [UIImage imageNamed:@"icon_j.png"];
    [self.contentView addSubview:_left];
    
    self.right = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 34, 27, 20, 20)];
    _right.image = [UIImage imageNamed:@"icon_i.png"];
    [self.contentView addSubview:_right];
    
}
- (void)getLeftImage:(NSString *)leftImage rightImage:(NSString *)rightImage
{
    [_left sd_setImageWithURL:[NSURL URLWithString:leftImage] placeholderImage:[UIImage imageNamed:@"v2.png"]];
    [_right sd_setImageWithURL:[NSURL URLWithString:rightImage] placeholderImage:[UIImage imageNamed:@"v2.png"]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
