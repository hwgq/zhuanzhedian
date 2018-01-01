//
//  ConversationTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/19.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SortTextDate.h"
#import "MyConversation.h"
#import "CheakBubble.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface ConversationTableViewCell ()
@property (nonatomic, strong)UIImageView *headImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *lastTextLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@end
@implementation ConversationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createConversationView];
    }
    return self;
}
- (void)createConversationView
{
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 30;
    self.headImage.layer.borderWidth = 0.7;
    self.headImage.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
//    self.headImage.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.headImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 17, 100, 18)];
    self.nameLabel.textColor = [UIColor colorFromHexCode:@"#2B2B2B"];
    self.nameLabel.textAlignment = 0;
    
//    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.contentView addSubview:self.nameLabel];
    
    self.lastTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 44, [UIScreen mainScreen].bounds.size.width - 110, 20)];
//    self.lastTextLabel.font = [UIFont systemFontOfSize:14];
    self.lastTextLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.lastTextLabel.textAlignment = 0;
    self.lastTextLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
//    self.lastTextLabel.textColor = [UIColor lightGrayColor];
//    self.lastTextLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.lastTextLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 17, [UIScreen mainScreen].bounds.size.width - 185, 18)];
    self.timeLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.timeLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
    self.timeLabel.textAlignment = 2;
//    self.timeLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.timeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 79, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#f9f9f9"];
    [self.contentView addSubview:lineView];
    
//    UIView *lineViewUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
//    lineViewUp.backgroundColor = [UIColor colorFromHexCode:@"#f9f9f9"];
//    [self.contentView addSubview:lineViewUp];
    
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 12, 17, 17)];
    self.alertLabel.backgroundColor = [UIColor redColor];
    self.alertLabel.layer.masksToBounds = YES;
    self.alertLabel.layer.cornerRadius = 8.5;
    self.alertLabel.textAlignment = 1;
    self.alertLabel.font = [UIFont systemFontOfSize:13];
    self.alertLabel.textColor = [UIColor whiteColor];
    self.alertLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.alertLabel.layer.borderWidth = 1;
    [self.contentView addSubview:self.alertLabel];
    
}
- (void)cellGetValue:(MyConversation *)dic
{
    self.alertLabel.frame = CGRectMake(53, 12, 17, 17);
    if (self.a == 0) {
        self.alertLabel.backgroundColor = [UIColor clearColor];
        self.alertLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.alertLabel.text = @"";
    }else{
        self.alertLabel.backgroundColor = [UIColor redColor];
        self.alertLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.alertLabel.text = [NSString stringWithFormat:@"%ld",self.a];
    }
    self.nameLabel.text = dic.name;
    self.lastTextLabel.attributedText = [CheakBubble getTrueText:dic.lastText];
    
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic.header]placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    
    
    NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:dic.lastTime] time:dic.lastTime ];
    self.timeLabel.text = time;
    
}
- (void)getHeaderValue:(MyConversation *)dic
{
    self.nameLabel.text = dic.name;
    self.lastTextLabel.text = dic.lastText;
    self.headImage.image = [UIImage imageNamed:@"message_icon_message"];
    if (dic.lastTime == 0) {
        self.timeLabel.text = @"";
    }else{
    NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:dic.lastTime] time:dic.lastTime ];
    self.timeLabel.text = time;
    }
    if (self.a == 0) {
        self.alertLabel.backgroundColor = [UIColor clearColor];
        self.alertLabel.text = @"";
        self.alertLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.alertLabel.backgroundColor = [UIColor redColor];
        self.alertLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.alertLabel.frame = CGRectMake(56, 15, 10, 10);
        self.alertLabel.layer.cornerRadius = 5;
    }
}
- (void)cellGetOther:(NSDictionary *)dic
{
    self.alertLabel.frame = CGRectMake(46, 12, 17, 17);
    if (self.a == 0) {
        self.alertLabel.backgroundColor = [UIColor clearColor];
        self.alertLabel.text = @"";
    }else{
        self.alertLabel.backgroundColor = [UIColor redColor];
        self.alertLabel.text = [NSString stringWithFormat:@"%ld",self.a];
    }
    self.nameLabel.text = @"小秘书";
//    self.lastTextLabel.text = [dic objectForKey:@"lastText"];
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"userDic"]objectForKey:@"avatar"]]];
    self.lastTextLabel.attributedText = [CheakBubble getTrueText:[dic objectForKey:@"lastText"]];
    self.headImage.image = [UIImage imageNamed:@"kf.png"];
    
    NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:atof([[dic objectForKey:@"time"]UTF8String])] time:atof([[dic objectForKey:@"time"]UTF8String])];
    self.timeLabel.text = time;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
