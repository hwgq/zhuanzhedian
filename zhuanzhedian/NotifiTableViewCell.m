//
//  NotifiTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 16/2/18.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "NotifiTableViewCell.h"
#import "UIColor+AddColor.h"
#import "NotificationMessage.h"
#import "SortTextDate.h"
#import "UIImageView+WebCache.h"
#import "FontTool.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
@interface NotifiTableViewCell ()
@property (nonatomic, strong)UIImageView *headImage;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *jobNumLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIImageView *styleImage;
@property (nonatomic, strong)UILabel *timeLabel;
@end
@implementation NotifiTableViewCell
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
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    [self.contentView addSubview:lineView];
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.borderWidth = 0.7;
    self.headImage.layer.borderColor = [UIColor colorWithWhite:0.851 alpha:1.000].CGColor;
//        self.headImage.backgroundColor = [UIColor blueColor];
    self.headImage.image = [UIImage imageNamed:@"photo.png"];
    [self.contentView addSubview:self.headImage];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, screenWidth - 75 - 110, 20)];
    self.titleLabel.textColor = [UIColor zzdColor];
    self.titleLabel.textAlignment = 0;
    self.titleLabel.text = @"上海慧晨 潘刘阳";
//    self.titleLabel.backgroundColor = [UIColor blackColor];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.contentView addSubview:self.titleLabel];
    
    self.jobNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 29,screenWidth - 75 - 60, 20)];
//    self.jobNumLabel.text = @"发布了新职位 : 高通量测试工程师";
    self.jobNumLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.000];
    self.jobNumLabel.textAlignment = 0;

//    self.jobNumLabel.backgroundColor = [UIColor blackColor];
    self.jobNumLabel.font = [[FontTool customFontArrayWithSize:13]objectAtIndex:1];
    [self.contentView addSubview:self.jobNumLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 51, screenWidth - 75 - 60, 20)];
    self.detailLabel.text = @"10k-20k | 1-3年 | 本科 | 上海";
    self.detailLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.000];
    self.detailLabel.textAlignment = 0;

//    self.detailLabel.backgroundColor = [UIColor blackColor];
    self.detailLabel.font = [[FontTool customFontArrayWithSize:13]objectAtIndex:1];
    [self.contentView addSubview:self.detailLabel];
    
    
    self.styleImage = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 35, 30, 20, 20)];
    self.styleImage.layer.masksToBounds = YES;
    self.styleImage.layer.cornerRadius = 10;
//    self.styleImage.backgroundColor = [UIColor blackColor];
    self.styleImage.image = [UIImage imageNamed:@"ico-chat-view.png"];
    [self.contentView addSubview:self.styleImage];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 105 , 7, 100, 16)];
    self.timeLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
    self.timeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.000];
    self.timeLabel.textAlignment = 2;
    self.timeLabel.text = @"今天 10:11";
//    self.timeLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.timeLabel];
    
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)getValueFrom:(NotificationMessage *)message
{
    NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:message.timestamps] time:message.timestamps];
    self.timeLabel.text = time;
    
    if ([message.subType isEqualToString:@"5"]||[message.subType isEqualToString:@"6"]) {
        self.detailLabel.text = message.detail;
        if (message.bossOrWorker == 1) {
            self.jobNumLabel.text = [NSString stringWithFormat:@"发布了新职位: %@",message.jdTitle];
        }
        self.styleImage.image = [UIImage imageNamed:@"ico-chat-new.png"];
        
    }else{
        self.detailLabel.text = message.text;
        if (message.bossOrWorker == 1) {
            self.jobNumLabel.text = [NSString stringWithFormat:@"共%@个职位",message.jdCount];
        }else if(message.bossOrWorker == 2){
            self.jobNumLabel.text = message.detail;
        }
        if ([message.subType isEqualToString:@"3"] || [message.subType isEqualToString:@"4"]) {
            self.styleImage.image = [UIImage imageNamed:@"ico-chat-view.png"];
        }else{
            self.styleImage.image = [UIImage imageNamed:@"ico-chat-heart.png"];
        }
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",message.title,message.name];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:message.avatar]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
