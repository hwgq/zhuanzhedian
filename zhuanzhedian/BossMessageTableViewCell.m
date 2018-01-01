//
//  BossMessageTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/6/19.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "BossMessageTableViewCell.h"
#import "UILableFitText.h"
#import "UIColor+flat.h"
@interface BossMessageTableViewCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UILabel *kanLabel;
@end
@implementation BossMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubVew];
    }
    return self;
}
- (void)createSubVew
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width / 2 - 20, 30)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexCode:@"aaa"];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 30, 10, [UIScreen mainScreen].bounds.size.width / 2 - 50, 30)];
    self.timeLabel.textAlignment = 2;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithHexCode:@"aaa"];
    [self.contentView addSubview:self.timeLabel];
    
    
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    [self.contentView addSubview:self.backView];
    
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 0)];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.detailLabel.textColor = [UIColor colorWithHexCode:@"aaa"];
    [self.contentView addSubview:self.detailLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
    self.lineView.backgroundColor = [UIColor colorWithHexCode:@"eee"];
    [self.contentView addSubview:self.lineView];
    
    self.kanLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 , 10, 45, 30)];
    self.kanLabel.font = [UIFont systemFontOfSize:12];
    self.kanLabel.textColor = [UIColor redColor];
    self.kanLabel.text = @"New!";
    self.kanLabel.hidden = YES;
    [self.contentView addSubview:self.kanLabel];
    
    
}
- (void)setValueWithDic:(NSDictionary *)dic
{
    NSString *name = [dic objectForKey:@"name"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 给您发送了名片",name]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexCode:@"38ab99"] range:NSMakeRange(0,name.length)]; //设置字体颜色
    self.titleLabel.attributedText = str;
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_kan"]]isEqualToString:@"1"]) {
        self.kanLabel.hidden = YES;
    }else{
        self.kanLabel.hidden = NO;
    }
    CGSize titleSize = [UILableFitText fitTextWithHeight:30 label:self.titleLabel];
    self.titleLabel.frame = CGRectMake(20, 10, titleSize.width, 30);
    self.kanLabel.frame = CGRectMake(20 + titleSize.width + 5, 10, 50, 30);
    
    self.timeLabel.text = [dic objectForKey:@"created_at"];
    
//    self.detailLabel.text = [NSString stringWithFormat:@"手机号码:%@\n个人简介:%@",[dic objectForKey:@"mobile"],[dic objectForKey:@"intro"]];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手机号码:%@\n个人简介:%@",[dic objectForKey:@"mobile"],[dic objectForKey:@"intro"]]];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1.string length])];
    [self.detailLabel setAttributedText:attributedString1];
    
    
    CGSize size = [UILableFitText fitTextWithWidth:[UIScreen mainScreen].bounds.size.width - 40 label:self.detailLabel];
    self.detailLabel.frame = CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40, size.height + 40);
    
    self.backView.frame = CGRectMake(10, 50, [UIScreen mainScreen].bounds.size.width - 20, size.height + 60);
    self.lineView.frame = CGRectMake(0, 130 + size.height - 1, [UIScreen mainScreen].bounds.size.width, 1);
    
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
