//
//  GoodCompanyTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 17/1/14.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "GoodCompanyTableViewCell.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
@interface GoodCompanyTableViewCell()
@property (nonatomic, strong)UIImageView *companyImg;
@property (nonatomic, strong)UILabel *companyTitle;
@property (nonatomic, strong)UILabel *companyAddress;
@property (nonatomic, strong)UILabel *companyDetail;
@property (nonatomic, strong)UILabel *companyJob;


@end
@implementation GoodCompanyTableViewCell
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
    self.companyImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
    self.companyImg.layer.cornerRadius = 8;
    self.companyImg.layer.masksToBounds = YES;
    self.companyImg.layer.borderWidth = 1;
    self.companyImg.layer.borderColor = [UIColor colorFromHexCode:@"#bbb"].CGColor;
    
//    self.companyImg.backgroundColor = [UIColor redColor];
   
    [self.contentView addSubview:self.companyImg];
    
    self.companyTitle = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, [UIScreen mainScreen].bounds.size.width - 110, 25)];
    self.companyTitle.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.companyTitle.text = @"上海百度研发中心";
    [self.contentView addSubview:self.companyTitle];
    
    self.companyAddress = [[UILabel alloc]initWithFrame:CGRectMake(85, 45, [UIScreen mainScreen].bounds.size.width - 110, 20)];
    self.companyAddress.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.companyAddress.text = @"上海市浦东新区张江";
    self.companyAddress.textColor = [UIColor colorFromHexCode:@"#666"];
    [self.contentView addSubview:self.companyAddress];
    
    self.companyDetail = [[UILabel alloc]initWithFrame:CGRectMake(85, 70, [UIScreen mainScreen].bounds.size.width - 110, 20)];
    self.companyDetail.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.companyDetail.text =  @"移动互联网 | D轮及以上 | 1000-9999人";
    self.companyDetail.textColor = [UIColor colorFromHexCode:@"#666"];
    [self.contentView addSubview:self.companyDetail];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 95, [UIScreen mainScreen].bounds.size.width - 30, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.contentView addSubview:lineView];
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setValueWithDic:(NSDictionary *)dic
{
    self.companyAddress.text = [dic objectForKey:@"address"];
    [self.companyImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    self.companyTitle.text = [dic objectForKey:@"title"];
    self.companyDetail.text =  [NSString stringWithFormat:@"%@ | %@ | %@",[dic objectForKey:@"companyType"],[dic objectForKey:@"companyMoney"],[dic objectForKey:@"companySize"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
