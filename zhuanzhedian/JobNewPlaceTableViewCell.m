//
//  JobNewPlaceTableViewCell.m
//  zhuanzhedian
//
//  Created by 李文涵 on 16/1/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "JobNewPlaceTableViewCell.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface JobNewPlaceTableViewCell ()
@property (nonatomic, strong)UILabel *provinceLabel;
@end

@implementation JobNewPlaceTableViewCell

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
    
    self.provinceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 4, 48)];
    self.provinceLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.provinceLabel.textColor = [UIColor colorFromHexCode:@"666666"];
    self.provinceLabel.textAlignment = 1;
    self.provinceLabel.numberOfLines = 0;
    [self.contentView addSubview:self.provinceLabel];
    
    
    
}
- (void)getProvinceLabelText:(NSString *)str
{
    self.provinceLabel.text = str;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
