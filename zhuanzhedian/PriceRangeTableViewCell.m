//
//  PriceRangeTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "PriceRangeTableViewCell.h"
#import "FontTool.h"
@interface PriceRangeTableViewCell ()
@property (nonatomic, strong)UILabel *priceLabel;
@end
@implementation PriceRangeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createPriceLabel];
    }
    return self;
}

- (void)createPriceLabel
{
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 75, 0, 150, 48)];
    self.priceLabel.textColor = [UIColor grayColor];
    self.priceLabel.textAlignment = 1;
    self.priceLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.contentView addSubview:self.priceLabel];
}

- (void)getPriceLabelText:(NSString *)priceRange
{
    self.priceLabel.text = priceRange;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
