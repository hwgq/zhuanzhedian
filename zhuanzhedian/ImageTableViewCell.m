//
//  ImageTableViewCell.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/11.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AddColor.h"
#import "MessageModel.h"
@interface ImageTableViewCell ()
@property (nonatomic, strong)UIImageView *main;
@property (nonatomic, strong)MessageModel *messageModel;

@end
@implementation ImageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (MessageModel *)createImage:(BOOL)fromSelf image:(NSString *)imageUrl
{    NSURL *url = [NSURL URLWithString:imageUrl];
    [self.main removeFromSuperview];
    self.main = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.main.layer.masksToBounds = YES;
    self.main.layer.cornerRadius = 7;
    [self.imageImage removeFromSuperview];
    self.imageImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageImage.layer.masksToBounds = YES;
    self.imageImage.layer.cornerRadius = 3;
    self.messageModel = [[MessageModel alloc]init];
    if (fromSelf) {
        [self.leftHeader removeFromSuperview];
        [self.rightHeader removeFromSuperview];
        self.leftHeader = [[UIImageView alloc]initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width - 43, 30, 35, 35)];
        self.leftHeader.layer.masksToBounds = YES;
        self.leftHeader.image = [UIImage imageNamed:@"111.jpeg"];
        self.leftHeader.layer.cornerRadius = 35 / 2.0;
        self.leftHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.leftHeader.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.leftHeader];
        
        
//        self.main.backgroundColor = [UIColor whiteColor];
        UIImage *origin = [UIImage imageNamed:@"lt_bgqp_white.png"];
        // 左端盖宽度
        NSInteger leftCapWidth = origin.size.width * 0.8f;
        // 顶端盖高度
        NSInteger topCapHeight = origin.size.height * 0.7f;
        UIImage *image = [origin stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        self.main.image = image;
        
        self.main.layer.shadowRadius = 1.0;
        
        self.main.clipsToBounds = NO;
        
        [self.imageImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head1200.png"]];
        self.imageImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 180, 35, 112  , 110 );
        
        self.main.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 185, 30, 130, 100 + 20);
        self.messageModel.rowHeight = self.main.frame.size.height + 60;
    }else{
        [self.leftHeader removeFromSuperview];
        [self.rightHeader removeFromSuperview];
        self.rightHeader = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 35, 35)];
        self.rightHeader.layer.masksToBounds = YES;
        self.rightHeader.image = [UIImage imageNamed:@"222.jpg"];
        self.rightHeader.layer.cornerRadius = 35 / 2.0;
        self.rightHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.rightHeader.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.rightHeader];
        
        
//        self.main.backgroundColor = [UIColor colorFromHexCode:@"#00abea"];
        UIImage *origin = [UIImage imageNamed:@"lt_bgqp_green.png"];
        // 左端盖宽度
        NSInteger leftCapWidth = origin.size.width * 0.8f;
        // 顶端盖高度
        NSInteger topCapHeight = origin.size.height * 0.7f;
        UIImage *image = [origin stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        self.main.image = image;
        
        self.main.layer.shadowRadius = 1.0;
        
        self.main.clipsToBounds = NO;
        
        
        [self.imageImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head1200.png"]];
        self.imageImage.frame = CGRectMake(63, 35, 112 ,  110);
        self.main.frame = CGRectMake(50, 30, 130, 100 + 20);
        self.messageModel.rowHeight = self.main.frame.size.height + 60;
    }
//    image.layer.masksToBounds = YES;
//    image.layer.cornerRadius = 7;
    [self.contentView addSubview:self.main];
    [self.contentView addSubview:self.imageImage];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 10)];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = 1;
    [self.contentView addSubview:self.timeLabel];
    return self.messageModel;
}
- (void)setLeftHeaderImage:(NSString *)url
{
    [self.leftHeader sd_setImageWithURL:[NSURL URLWithString:url]];
    
}
- (void)setRightHeaderImage:(NSString *)url
{
    [self.rightHeader sd_setImageWithURL:[NSURL URLWithString:url]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
