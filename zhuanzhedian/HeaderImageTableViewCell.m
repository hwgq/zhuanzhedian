//
//  HeaderImageTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "HeaderImageTableViewCell.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface HeaderImageTableViewCell ()
@property (nonatomic, strong)UILabel *titleLabel;


@end
@implementation HeaderImageTableViewCell
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
//    UIImageView *nextImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20, 27.5, 15, 15)];
//    nextImage.image = [UIImage imageNamed:@"back_i.png"];
//    [self.contentView addSubview:nextImage];
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10, 50, 50)];
//    self.headerImageView.backgroundColor = [UIColor blueColor];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 200, 38)];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
//    self.titleLabel.backgroundColor = [UIColor blackColor];
    
    self.titleLabel.textAlignment = 0;
    self.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.titleLabel];
}
- (void)setTitleLabelText:(NSString *)str
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
