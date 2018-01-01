//
//  FMDBMessages.h
//  zhuanzhedian
//
//  Created by Gaara on 15/12/15.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
@class MyMessage;
@interface FMDBMessages : NSObject
+ (BOOL)saveMessage:(AVIMTypedMessage *)message;
+ (NSMutableArray *)getMessageFromDB:(NSString *)sid rid:(NSString *)rid jd:(NSString *)jdId count:(NSInteger)count sendType:(NSString *)sendType;
+ (BOOL)saveMessageWhenSend:(AVIMTypedMessage *)message Rid:(NSString *)receiveId;
+ (MyMessage *)messageTranToModel:(AVIMTypedMessage *)message WithSid:(NSString *)sid rid:(NSString *)rid;
+ (BOOL)judgeConversationExist:(NSMutableDictionary *)dic;
+ (NSMutableArray *)selectAllConversation;
+ (BOOL)deleteOneConversation:(NSInteger)jdId rsId:(NSInteger)rsId;
+ (NSMutableArray *)getHeaderJDMessagejd:(NSString *)jdId rsId:(NSString *)rsId;
+(BOOL)deleteAllConversation;
+ (BOOL)judgeServiceConversationExist:(NSMutableDictionary *)dic;
+ (BOOL)saveNotificationMessage:(AVIMTypedMessage *)message text:(NSString *)text;
+ (NSMutableArray *)selectAllNotifiMessage;
+ (BOOL)updateEmailMessageState:(MyMessage *)message;
@end
