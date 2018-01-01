//
//  JudgeCreateCheatWindow.h
//  zhuanzhedian
//
//  Created by Gaara on 15/11/19.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
@class MyConversation;
@interface JudgeCreateCheatWindow : NSObject
+ (NSMutableArray *)getLocalConversationWindowArr;
+ (void)judgeConversationExist:(AVIMTypedMessage *)message objectId:(NSString *)objectId jdDic:(NSDictionary *)jdDic userDic:(NSDictionary *)userDic state:(NSString *)state;
+ (void)deleteLocalConversationWithDic:(MyConversation *)dic;
+ (void)moveConversationToTop:(NSDictionary *)dic;
+ (void)judgeServiceConversationExist:(AVIMTypedMessage *)message objectId:(NSString *)objectId;
@end
