//
//  SelectJobTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/17.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "SelectJobTableViewCell.h"
#import "UILableFitText.h"
@interface SelectJobTableViewCell ()
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIImageView *lookImage;
@property (nonatomic, strong)UILabel *lookLabel;

@property (nonatomic, strong)UIImageView *loveImage;
@property (nonatomic, strong)UILabel *loveLabel;

@property (nonatomic, strong)UIImageView *shareImage;
@property (nonatomic, strong)UILabel *shareLabel;
@end
@implementation SelectJobTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 20, 30)];
//    self.titleLabel.backgroundColor = [UIColor orangeColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    [self.contentView addSubview:self.titleLabel];
    
    
//    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, [UIScreen mainScreen].bounds.size.width - 20, 20)];
////    self.detailLabel.backgroundColor = [UIColor redColor];
//    self.detailLabel.textColor = [UIColor grayColor];
//    self.detailLabel.font = [UIFont systemFontOfSize:13];
//    [self.contentView addSubview:self.detailLabel];
    
    self.lookImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 36, 18, 18)];
//    self.lookImage.backgroundColor = [UIColor blackColor];
    self.lookImage.image = [UIImage imageNamed:@"ck.png"];
    [self.contentView addSubview:self.lookImage];
    
    self.lookLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.lookLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    self.lookLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lookLabel];
    
    self.loveImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.loveImage.image = [UIImage imageNamed:@"sc.png"];
    [self.contentView addSubview:self.loveImage];
    
    self.loveLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.loveLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    self.loveLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.loveLabel];
    
    self.shareImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.shareImage.image = [UIImage imageNamed:@"zs.png"];
    [self.contentView addSubview:self.shareImage];
    
    self.shareLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.shareLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    self.shareLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.shareLabel];
    
    UIImageView *nextImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 26, 27, 7, 11)];
    nextImage.image = [UIImage imageNamed:@"caidan.png"];
    [self.contentView addSubview:nextImage];
    
}

- (void)getLabelValue:(NSDictionary *)dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
    
    
    self.lookLabel.text = [dic objectForKey:@"browser_num"];
    CGSize lookSize = [UILableFitText fitTextWithHeight:20 label:self.lookLabel];
    self.lookLabel.frame = CGRectMake(30, 35, lookSize.width, 20);
    
    self.loveImage.frame = CGRectMake(30 + lookSize.width + 15, 36, 18, 18);
    
    self.loveLabel.text = [dic objectForKey:@"favorite_num"];
    CGSize loveSize = [UILableFitText fitTextWithHeight:20 label:self.loveLabel];
    self.loveLabel.frame = CGRectMake(50 + lookSize.width + 15, 35, loveSize.width, 20);
    
    self.shareImage.frame = CGRectMake(self.loveLabel.frame.origin.x + loveSize.width + 15, 36, 18, 18);
    
    self.shareLabel.text = @"15";
    CGSize shareSize = [UILableFitText fitTextWithHeight:20 label:self.shareLabel];
    self.shareLabel.frame = CGRectMake(self.shareImage.frame.origin.x + 20, 35, shareSize.width, 20);
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
