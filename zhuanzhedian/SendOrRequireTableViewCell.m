
//
//  SendOrRequireTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 17/3/9.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "SendOrRequireTableViewCell.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "UIImageView+WebCache.h"
@interface SendOrRequireTableViewCell ()
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UIButton *confirmBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@end
@implementation SendOrRequireTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
//        self.backgroundColor =[UIColor colorFromHexCode:@"38ab99"];
        [self createSubView];
        
    }
    return self;
}
- (void)createSubView
{
//    self.contentView.backgroundColor = [UIColor colorFromHexCode:@"#38ab99"];
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(53, 30, 200, 100)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 8;
    mainView.layer.masksToBounds = YES;
    [self.contentView addSubview:mainView];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 180, 60)];
    textLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    textLabel.textColor = [UIColor colorFromHexCode:@"#666"];
    textLabel.textAlignment = 1;
    
    NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
    NSString *labelText;
    if ([currentRole isEqualToString:@"1"]) {
        
        labelText = @"我想要一份您的完整简历, 您是否同意";
    }else{
        
        labelText = @"我想发送我的简历给您, 您是否同意";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    textLabel.attributedText = attributedString;
    
    textLabel.numberOfLines = 0;
    [mainView addSubview:textLabel];
    
    
    UIImageView *tranImg = [[UIImageView alloc]initWithFrame:CGRectMake(48, 45, 5, 10)];
    tranImg.image = [UIImage imageNamed:@"Triangle 6 Copy 2"];
    [self.contentView addSubview:tranImg];
    
    self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 70, 99.5, 30)];
    [self.confirmBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = [UIColor colorFromHexCode:@"#6DC9C9"];
    self.confirmBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:self.confirmBtn];
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(100.5, 70, 99.5, 30)];
    [self.cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.backgroundColor = [UIColor colorFromHexCode:@"#FC8278"];
    self.cancelBtn.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:self.cancelBtn];
    
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 30, 35, 35)];
    self.headerImg.backgroundColor = [UIColor redColor];
//    self.headerImg.image = [UIImage imageNamed:@"shakalaka.jpg"];
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 35 / 2;
    [self.contentView addSubview:self.headerImg];
}
- (void)setHeaderImage:(NSString *)image
{
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:image]];
}
- (void)confirmAction
{
    self.resultBlock(@"confirm");
    
}
- (void)cancelAction
{
    self.resultBlock(@"cancel");
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)hadDone:(NSString *)str
{
    self.confirmBtn.userInteractionEnabled = NO;
    self.cancelBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor colorFromHexCode:@"#999"];
    self.cancelBtn.backgroundColor = [UIColor colorFromHexCode:@"#999"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
