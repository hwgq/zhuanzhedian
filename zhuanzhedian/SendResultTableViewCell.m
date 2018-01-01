//
//  SendResultTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 17/3/14.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "SendResultTableViewCell.h"
#import "UIColor+AddColor.h"
@interface SendResultTableViewCell ()
@property (nonatomic, strong)UIImageView *resultImg;
@end
@implementation SendResultTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews
{
    self.resultImg = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 94) / 2, 10, 94, 30)];
    [self.contentView addSubview:self.resultImg];
}
- (void)setResultImage:(NSString *)sendType
{
    if ([sendType isEqualToString:@"send"]) {
        self.resultImg.image = [UIImage imageNamed:@"requireemail.png"];
    }else{
        self.resultImg.image = [UIImage imageNamed:@"sendemail.png"];
    }
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
