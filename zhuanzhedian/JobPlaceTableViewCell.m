//
//  JobPlaceTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JobPlaceTableViewCell.h"

@interface JobPlaceTableViewCell ()
@property (nonatomic, strong)UILabel *provinceLabel;
@property (nonatomic,strong)UIImageView * provinceImageView;
@end
@implementation JobPlaceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTitleLable];
    }
    return self;
}

- (void)createTitleLable
{
    
    self.provinceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 15)];
    [self.contentView addSubview:self.provinceImageView];
    
    self.provinceLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, [UIScreen mainScreen].bounds.size.width / 3, 48)];
    self.provinceLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    self.provinceLabel.textAlignment = 0;
    self.provinceLabel.numberOfLines = 0;
    [self.contentView addSubview:self.provinceLabel];
    
}
- (void)getProvinceLabelText:(NSString *)str getImage:(UIImage *)image
{
    self.provinceLabel.text = str;
    self.provinceImageView.image = image;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
