//
//  UserSaveTool.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/16.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "UserSaveTool.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"

@implementation UserSaveTool
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (AVIMKeyedConversation *)getLocalConversation:(NSString *)username client:(NSString *)clientId
{
//    AVIMKeyedConversation *keyedConversation = [[AVIMKeyedConversation alloc]init];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *userPath = [NSString stringWithFormat:@"%@/%@",path,username];
    if ([fileManager fileExistsAtPath:userPath]) {
        NSString *clientPath = [NSString stringWithFormat:@"%@/%@",userPath,clientId];
        if ([fileManager fileExistsAtPath:clientPath]) {
            NSString *conversationPath = [NSString stringWithFormat:@"%@/%@",clientPath,@"conversation"];
            if ([fileManager fileExistsAtPath:conversationPath]) {
                NSData *data = [[NSData alloc] initWithContentsOfFile:conversationPath];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
               
                AVIMKeyedConversation *conversation = [unarchiver decodeObjectForKey:@"conversation"];
                //关闭解档
                [unarchiver finishDecoding];
                return conversation;
 
            }else{
                return nil;
            }
        }else{
            [fileManager createDirectoryAtPath:clientPath withIntermediateDirectories:YES attributes:nil error:nil];
            return nil;
        }
    }else{
        NSString *clientPath = [NSString stringWithFormat:@"%@/%@",userPath,clientId];
        [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:clientPath withIntermediateDirectories:YES attributes:nil error:nil];
        return nil;
        
    }
    return nil;
}

+ (BOOL)saveConversationToLocal:(AVIMKeyedConversation *)keyedConversation user:(NSString *)username client:(NSString *)clientId
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *clientPath = [NSString stringWithFormat:@"%@/%@/%@/%@",path,username,clientId,@"conversation"];
    NSMutableData *data = [[NSMutableData alloc] init];
    //创建归档辅助类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    [archiver encodeObject:keyedConversation forKey:@"conversation"];
    //结束编码
    [archiver finishEncoding];
    //写入
    BOOL a = [data writeToFile:clientPath atomically:YES];
    return a;
}


+(NSArray *)getAllDocumentsName:(NSString *)username
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *documentPath = [NSString stringWithFormat:@"%@/%@",path,username];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   NSArray  *array = [fileManager  contentsOfDirectoryAtPath:documentPath error:nil];
    return array;
}
@end
