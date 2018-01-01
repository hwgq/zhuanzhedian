//
//  MessageUtils.h
//  zhuanzhedian
//
//  Created by Chaoyong Zhang on 16/1/19.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
@interface MessageUtils : NSObject
+ (NSString *)getMessageBrief:(AVIMTypedMessage *)message;
@end
