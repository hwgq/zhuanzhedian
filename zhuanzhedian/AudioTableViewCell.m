//
//  AudioTableViewCell.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/11.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "AudioTableViewCell.h"
#import "AudioBubble.h"
#import "UIImageView+WebCache.h"
@interface AudioTableViewCell ()
@property (nonatomic, strong)AudioBubble *audio;

@end
@implementation AudioTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)createAudioView:(BOOL)user url:(NSString *)url duration:(double)duration
{
    self.audio = [[AudioBubble alloc]init];
    
    if (user) {
        [self.rightHeader removeFromSuperview];
        self.leftHeader = [[UIImageView alloc]initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width - 43, 30, 35, 35)];
        self.leftHeader.layer.masksToBounds = YES;
        self.leftHeader.image = [UIImage imageNamed:@"111.jpeg"];
        self.leftHeader.layer.cornerRadius = 35 / 2.0;
        self.leftHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.leftHeader.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.leftHeader];
       self.view =  [self.audio cheatBubble:url from:YES withPosition:0 duration:duration];
        [self.contentView addSubview:self.view];
        self.view.userInteractionEnabled = YES;
    }else{
        [self.leftHeader removeFromSuperview];
        self.view =  [self.audio cheatBubble:url from:NO withPosition:0 duration:duration];
   
        self.rightHeader = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 35, 35)];
        self.rightHeader.layer.masksToBounds = YES;
        self.rightHeader.image = [UIImage imageNamed:@"222.jpg"];
        self.rightHeader.layer.cornerRadius = 35 / 2.0;
        self.rightHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.rightHeader.layer.borderWidth = 0.5;
        [self.contentView  addSubview:self.rightHeader];

        [self.contentView addSubview:self.view];
        [self.view becomeFirstResponder];
        
        self.view.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startPlay)];
    
    self.audio.audioLabel.userInteractionEnabled = YES;
    [self.audio.audioLabel addGestureRecognizer:startTap];
    self.contentView.userInteractionEnabled = YES;
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 10)];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = 1;
    [self.contentView addSubview:self.timeLabel];
}
- (void)startPlay
{
    [self.audio.audioPlayer pause];
    self.audio.audioPlayer.volume = 5;
    [self.audio.audioPlayer play];
    
    [self.audio startToPlay];
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setLeftHeaderImage:(NSString *)url
{
    [self.leftHeader sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head1200.png"]];
    
}
- (void)setRightHeaderImage:(NSString *)url
{
    [self.rightHeader sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head1200.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
