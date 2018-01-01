//
//  MessageUtils.m
//  zhuanzhedian
//
//  Created by Chaoyong Zhang on 16/1/19.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "MessageUtils.h"

@implementation MessageUtils
+ (NSString *)getMessageBrief:(AVIMTypedMessage *)message
{
    /*
     kAVIMMessageMediaTypeNone = 0,
     kAVIMMessageMediaTypeText = -1,
     kAVIMMessageMediaTypeImage = -2,
     kAVIMMessageMediaTypeAudio = -3,
     kAVIMMessageMediaTypeVideo = -4,
     kAVIMMessageMediaTypeLocation = -5,
     kAVIMMessageMediaTypeFile = -6
     */
    NSString *brief = @"";
    switch (message.mediaType) {
        case kAVIMMessageMediaTypeNone:
            break;
        case kAVIMMessageMediaTypeText:
            brief = message.text;
            break;
        case kAVIMMessageMediaTypeImage:
            brief = @"[图片]";
            break;
        case kAVIMMessageMediaTypeAudio:
            brief = @"[语音]";
            break;
        case kAVIMMessageMediaTypeVideo:
            brief = @"[小视频]";
            break;
        case kAVIMMessageMediaTypeLocation:
            brief = @"[位置]";
            break;
        case kAVIMMessageMediaTypeFile:
            brief = @"[文件]";
            break;
        default:
            break;
    }
    return brief;
}
@end
