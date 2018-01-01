//
//  UserSaveTool.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/16.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVIMKeyedConversation;
@interface UserSaveTool : NSObject
+ (AVIMKeyedConversation *)getLocalConversation:(NSString *)username client:(NSString *)clientId;
+ (BOOL)saveConversationToLocal:(AVIMKeyedConversation *)keyedConversation user:(NSString *)username client:(NSString *)clientId;
+(NSArray *)getAllDocumentsName:(NSString *)username;
@end
