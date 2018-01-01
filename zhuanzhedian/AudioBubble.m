//
//  AudioBubble.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/11.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "AudioBubble.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIColor+AddColor.h"
@interface AudioBubble ()<AVAudioPlayerDelegate>
@property (nonatomic, strong)UIImageView *audioImage;
@end
@implementation AudioBubble



- (UIView *)cheatBubble:(NSString *)url from:(BOOL)fromSelf withPosition:(int)position duration:(double)duration
{
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectZero];
    mainView.backgroundColor = [UIColor clearColor];
    
    NSURL *urlStr = [self judgeUrlExistOrNot:url];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:urlStr error:nil];
   
    self.audioPlayer.delegate = self;
    
    self.audioLabel = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _audioLabel.layer.masksToBounds = YES;
//    _audioLabel.layer.cornerRadius = 10;
    NSInteger labelLength = duration * 3 + 50;
    if (duration > 30) {
        labelLength = 100 + 50;
        
    }
    _audioLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startPlay)];
//    [audioLabel addGestureRecognizer:startTap];
    
    
    
    self.audioImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    if (fromSelf) {
        NSArray *imagesArr = @[[UIImage imageNamed:@"icon_voice_green_1.png"],[UIImage imageNamed:@"icon_voice_green_2.png"],[UIImage imageNamed:@"icon_voice_green_3.png"]];
        self.audioImage.image = [UIImage imageNamed:@"icon_voice_green_3.png"];
        self.audioImage.animationImages = imagesArr;
        
    }else{
        NSArray *imagesArr = @[[UIImage imageNamed:@"icon_voice_white_1.png"],[UIImage imageNamed:@"icon_voice_white_2.png"],[UIImage imageNamed:@"icon_voice_white_3.png"]];
        self.audioImage.image = [UIImage imageNamed:@"icon_voice_white_3.png"];
        self.audioImage.animationImages = imagesArr;
    }
    self.audioImage.animationDuration = 1;
    self.audioImage.animationRepeatCount = 999;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = 1;
    timeLabel.text = [NSString stringWithFormat:@"%.0f″",duration];
    
    if (fromSelf) {
        self.audioLabel.frame = CGRectMake(50, 10, labelLength, 36);
        self.audioImage.frame = CGRectMake(_audioLabel.frame.size.width - 32, 10, 16, 16);
        self.audioImage.transform =  CGAffineTransformMakeRotation(180 * M_PI/180);
        [self.audioLabel addSubview:self.audioImage];
//        _audioLabel.backgroundColor = [UIColor whiteColor];
        UIImage *origin = [UIImage imageNamed:@"lt_bgqp_white.png"];
        // 左端盖宽度
        NSInteger leftCapWidth = origin.size.width * 0.8f;
        // 顶端盖高度
        NSInteger topCapHeight = origin.size.height * 0.7f;
        UIImage *image = [origin stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        self.audioLabel.image = image;
       
        self.audioLabel.layer.shadowRadius = 1.0;
        
        self.audioLabel.clipsToBounds = NO;
        
        
        timeLabel.frame = CGRectMake(0, 10, 50, 36);
        
        mainView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - position - labelLength - 50 - 50, 20, labelLength + 50, 80);
        
    }else{
        self.audioLabel.frame = CGRectMake(0, 10, labelLength, 36);
        self.audioImage.frame = CGRectMake(22, 10, 16, 16);
        [self.audioLabel addSubview:self.audioImage];
//        _audioLabel.backgroundColor = [UIColor colorFromHexCode:@"#00abea"];
        UIImage *origin = [UIImage imageNamed:@"lt_bgqp_green.png"];
        // 左端盖宽度
        NSInteger leftCapWidth = origin.size.width * 0.8f;
        // 顶端盖高度
        NSInteger topCapHeight = origin.size.height * 0.7f;
        UIImage *image = [origin stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        self.audioLabel.image = image;
        
        self.audioLabel.layer.shadowRadius = 1.0;
        
        self.audioLabel.clipsToBounds = NO;
        
        timeLabel.frame = CGRectMake(labelLength, 10, 50, 36);
        
        mainView.frame = CGRectMake(position + 50, 20, labelLength + 50, 80);
    }
    [mainView addSubview:timeLabel];
    [mainView addSubview:_audioLabel];
    mainView.userInteractionEnabled = YES;

    
    return mainView;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.audioImage stopAnimating];
    
    
}
- (void)startToPlay
{
    [self.audioImage startAnimating];
}
- (NSURL *)judgeUrlExistOrNot:(NSString *)urlStr
{
   
    NSArray *arr = [urlStr componentsSeparatedByString:@"/"];
    NSString *str1 = [arr lastObject];
    NSString *strName = [str1 substringWithRange:NSMakeRange(0, str1.length - 4)];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    NSString *speechPath = [NSString stringWithFormat:@"%@/%@",path,@"speech"];
    
    NSString *speechFilePath = [NSString stringWithFormat:@"%@/%@",speechPath,strName];

    if ([fileManager fileExistsAtPath:speechPath]) {
        if ([fileManager fileExistsAtPath:speechFilePath]) {
            NSURL *url = [NSURL fileURLWithPath:speechFilePath];
            return url;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: urlStr]];
            BOOL a = [data writeToFile:speechFilePath atomically:YES];
            NSURL *url = nil;
            if (a) {
                url = [NSURL fileURLWithPath:speechFilePath];
            }else{
      
            }
            return url;
            
        }
    }else{
        [fileManager createDirectoryAtPath:speechPath withIntermediateDirectories:YES attributes:nil error:nil];
        
       NSURL *url = [self judgeUrlExistOrNot:urlStr];
        return url;
    }
    
    
    
    return nil;
}

//- (void)startPlay
//{
//    [self.audioPlayer stop];
//    
//    
//    [self.audioPlayer play];
//}
@end
