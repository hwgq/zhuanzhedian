//
//  SearchResultCell.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/18.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "SearchResultCell.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface SearchResultCell ()
@property (nonatomic, strong)UILabel *searchResultLabel;
@end
@implementation SearchResultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.searchResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    self.searchResultLabel.backgroundColor = [UIColor whiteColor];
    self.searchResultLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    self.searchResultLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.searchResultLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    [self.contentView addSubview:lineView];
}
- (void)setTitleText:(NSString *)str key:(NSString *)key
{
    self.searchResultLabel.text = str;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
