//
//  NewCheatTableViewCell.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "NewCheatTableViewCell.h"
#import "CheakBubble.h"
#import "UIImageView+WebCache.h"
#import "MessageModel.h"
@interface NewCheatTableViewCell ()
@property (nonatomic, strong)MessageModel *messageModel;
@end
@implementation NewCheatTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (MessageModel *)createCheatBubble:(BOOL)user text:(NSString *)text attributedStr:(NSAttributedString *)attStr
{
    
    if (user) {
       
        self.leftHeader = [[UIImageView alloc]initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width - 43, 30, 35, 35)];
        self.leftHeader.layer.masksToBounds = YES;
        self.leftHeader.layer.cornerRadius = 35 / 2.0;
        self.leftHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.leftHeader.layer.borderWidth = 0.5;
        self.messageModel = [CheakBubble bubbleView:text from:user withPosition:20 attributedStr:attStr];
        self.leftView = self.messageModel.messageView;

        
        self.statusImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - self.leftView.frame.size.width - 100, self.leftView.frame.size.height / 2 + 20, 20, 20)];
//        self.statusImage.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.statusImage];
        
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.leftHeader];
        [self.rightView removeFromSuperview];
        [self.rightHeader removeFromSuperview];
    }else{
        self.messageModel = [CheakBubble bubbleView:text from:user withPosition:20 attributedStr:attStr];
        
        self.rightView = self.messageModel.messageView;
        self.rightHeader = [[UIImageView alloc]initWithFrame:CGRectMake(8, 30, 35, 35)];
        self.rightHeader.layer.borderWidth = 0.5;
        self.rightHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.rightHeader.layer.masksToBounds = YES;
        
//        self.rightHeader.image = [UIImage imageNamed:@"222.jpg"];
        self.rightHeader.layer.cornerRadius = 35 / 2.0;

        [self.contentView addSubview:self.rightView];
        [self.contentView addSubview:self.rightHeader];
        [self.leftHeader removeFromSuperview];
        [self.leftView removeFromSuperview];
    }
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 10)];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = 1;
    [self.contentView addSubview:self.timeLabel];
    
    return self.messageModel;
}
- (void)getLeftImage:(NSString *)leftImage
{
    [self.rightHeader sd_setImageWithURL:[NSURL URLWithString:leftImage]];
    
}

- (void)getRightImage:(NSString *)rightImage
{
    [self.leftHeader sd_setImageWithURL:[NSURL URLWithString:rightImage]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
