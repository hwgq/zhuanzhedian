//
//  JobSelectTypeCell.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/2.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "JobSelectTypeCell.h"
#import "UILableFitText.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface JobSelectTypeCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIImageView *arrowsImg;
@property (nonatomic, strong)UIImageView *titleImg;
@end
@implementation JobSelectTypeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithFrame];
    }
    return self;
}
- (void)initWithFrame
{
    self.titleImg = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.titleImg.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.titleImg];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.contentView addSubview:self.titleLabel];
    
    self.subLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.subLabel.numberOfLines = 0;
    self.subLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.subLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.subLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
    self.lineView.backgroundColor = [UIColor colorFromHexCode:@"#EEEEEE"];
    [self.contentView addSubview:self.lineView];
    
    self.arrowsImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.arrowsImg.image = [UIImage imageNamed:@"icon_arrows.png"];
    [self.contentView addSubview:self.arrowsImg];
}
- (void)setTitles:(NSDictionary *)dic imgName:(NSString *)name
{
    NSArray *arr = [dic objectForKey:@"sub_category"];
    NSMutableString *str = @"".mutableCopy;
    
    for (int i = 0; i < arr.count ; i++) {
        if (i == 0) {
            [str appendString:[[arr objectAtIndex:i]objectForKey:@"name"]];
        }else{
            [str appendString:[NSString stringWithFormat:@" | %@",[[arr objectAtIndex:i]objectForKey:@"name"]]];
        }
    }
    self.subLabel.text = str;
    CGSize subSize = [UILableFitText fitTextWithWidth:[UIScreen mainScreen].bounds.size.width - 160 label:self.subLabel];
    self.subLabel.frame = CGRectMake(110, 60, [UIScreen mainScreen].bounds.size.width - 160, subSize.height);
    
    self.titleLabel.frame = CGRectMake(110, 10, 70, 40);
    
    self.titleLabel.text = [dic objectForKey:@"name"];
    
    self.lineView.frame = CGRectMake(0, subSize.height + 39 + 50, [UIScreen mainScreen].bounds.size.width, 1);
    self.titleImg.frame = CGRectMake(30, (40 + subSize.height - 40 + 50) / 2, 40, 40);
    self.titleImg.image = [UIImage imageNamed:name];
    self.arrowsImg.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 17, (40 + subSize.height - 12 + 45) / 2, 7, 12);
}
@end
