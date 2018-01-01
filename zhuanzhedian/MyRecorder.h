//
//  MyRecorder.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MyRecorder : NSObject
- (void)startRecord;
- (void)stopRecord;
- (void)createAudioRecorder;
- (void)destructionRecordingFile;
@property (nonatomic, strong)AVAudioRecorder *myRecorder;
@end
