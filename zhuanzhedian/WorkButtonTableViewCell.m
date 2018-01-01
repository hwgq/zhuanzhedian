//
//  WorkButtonTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/27.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "WorkButtonTableViewCell.h"
#import "UIColor+AddColor.h"
@implementation WorkButtonTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createButton];
    }
    return self;
}

- (void)createButton
{   
    self.addButton = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 0, 200, 48)];
    self.addButton.textColor = [UIColor zzdColor];
    self.addButton.font = [UIFont systemFontOfSize:16];
    self.addButton.textAlignment = 1;
    [self.contentView addSubview:self.addButton];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
