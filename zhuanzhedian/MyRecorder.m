//
//  MyRecorder.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MyRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface MyRecorder ()<AVAudioRecorderDelegate>
@property (nonatomic, strong)NSURL *recordFileUrl;
@end
@implementation MyRecorder



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createAudioRecorder
{
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
  
    //Setup the audioSession for playback and record.
    //We could just use record and then switch it to playback leter, but
    //since we are going to do both lets set it up once.
     [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //Activate the session
    [audioSession setActive:YES error:nil];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *str = [array lastObject];
    
    

     self.recordFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/record.wav", str]];

    // 设置录音的一些参数
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    // 音频格式
    setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    setting[AVSampleRateKey] = @(8000);
    // 音频通道数 1 或 2
    setting[AVNumberOfChannelsKey] = @(1);
    // 线性音频的位深度  8、16、24、32
    setting[AVLinearPCMBitDepthKey] = @(8);
    //录音的质量
    setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityMedium];

   NSError *error=nil;
    self.myRecorder = [[AVAudioRecorder alloc]initWithURL:self.recordFileUrl settings:setting error:&error];
    self.myRecorder.delegate = self;
    self.myRecorder.meteringEnabled = YES;
    [self.myRecorder prepareToRecord];

     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
}
- (void)startRecord
{

        [self.myRecorder record];
    
    
}
- (void)stopRecord
{
    [self.myRecorder stop];
}
- (void)destructionRecordingFile
{
    
    [self.myRecorder deleteRecording];
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}
@end
