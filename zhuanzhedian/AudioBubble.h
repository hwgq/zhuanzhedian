//
//  AudioBubble.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/11.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioBubble : NSObject
- (UIView *)cheatBubble:(NSString *)url from:(BOOL)fromSelf withPosition:(int)position duration:(double)duration;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (nonatomic, strong)UIImageView *audioLabel;
- (void)startToPlay;
@end
