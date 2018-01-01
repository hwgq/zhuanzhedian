//
//  SecretaryTableViewCell.m
//  小秘书消息
//
//  Created by Gaara on 15/11/24.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "SecretaryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SortTextDate.h"
@interface SecretaryTableViewCell ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@end
@implementation SecretaryTableViewCell
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
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15
                                                              , [UIScreen mainScreen].bounds.size.width - 50, 20)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.text = @"10月27日 15:46";
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.timeLabel.textAlignment = 1;
    [self.contentView addSubview:self.timeLabel];
    
    
    
    
    
    
    
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, 290)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 7;
    self.mainView.layer.borderWidth = 0.3;
    self.mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mainView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.mainView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7.5, 5, self.mainView.frame.size.width - 15, 40)];
//    self.titleLabel.backgroundColor = [UIColor redColor];
//    self.titleLabel.text = @"你真的聊天面试桌对面的TA么?";
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    [self.mainView addSubview:self.titleLabel];
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 50, self.mainView.frame.size.width - 15, 150)];
//    self.titleImageView.backgroundColor = [UIColor purpleColor];
  
    [self.mainView addSubview:self.titleImageView];
    
    
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(7.5, 205, self.mainView.frame.size.width - 15, 35)];
//    self.detailLabel.backgroundColor = [UIColor blackColor];
//    self.detailLabel.text = @"有数据、也有故事的牛人求职小调查来啦";
    self.detailLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.mainView addSubview:self.detailLabel];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(7.5, self.mainView.frame.size.height - 45.5, self.mainView.frame.size.width - 15, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.mainView addSubview:lineView];
    
    self.clickView = [[UIView alloc]initWithFrame:CGRectMake(7.5, self.mainView.frame.size.height - 45, self.mainView.frame.size.width - 15, 40)];
//    clickView.backgroundColor = [UIColor greenColor];
    [self.mainView addSubview:self.clickView];
    
    UILabel *clickButton  =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.clickView.frame.size.width - 40, 40)];
    clickButton.text = @" 点击查看详情";
    
    clickButton.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    clickButton.backgroundColor = [UIColor yellowColor];
    [self.clickView addSubview:clickButton];
    
    UIImageView *clickImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.clickView.frame.size.width - 20, 10, 20, 20)];
    clickImage.image = [UIImage imageNamed:@"clickNext.png"];
    [self.clickView addSubview:clickImage];
    
    
    
}
//    {
//        pic = "http://7xnj9p.com1.z0.glb.clouddn.com/im_sys_ff9c735e422fbc46c552.jpeg";
//        summary = "\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5";
//        title = "\U6d4b\U8bd5\U6d4b\U8bd5\U6d4b\U8bd5\U7cfb\U7edf\U6d88\U606f";
//        url = "http://api.zzd.hidna.cn/v1/im/sys/950";
//    }
- (void)getCellValue:(NSDictionary *)dic
{
    
    
      [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"text"]objectForKey:@"pic"]]];
    self.detailLabel.text = [[dic objectForKey:@"text"]objectForKey:@"summary"];
    self.titleLabel.text = [[dic objectForKey:@"text"]objectForKey:@"title"];
    self.timeLabel.text = [SortTextDate dateWithTimerDetail:[[dic objectForKey:@"time"]doubleValue]];
   
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
