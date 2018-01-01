//
//  JudgeCreateCheatWindow.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/19.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JudgeCreateCheatWindow.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "SortTextDate.h"
#import "MyConversation.h"
#import "AVOSCloud/AVOSCloud.h"


@implementation JudgeCreateCheatWindow
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (void)judgeServiceConversationExist:(AVIMTypedMessage *)message objectId:(NSString *)objectId
{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:message.text options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *docPath = [NSString stringWithFormat:@"%@/%@",path,@"conversation"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:docPath]) {
        NSString *userPath = [NSString stringWithFormat:@"%@/%@",docPath,[AVUser currentUser].username];
        if ([manager fileExistsAtPath:userPath]) {
            NSString *arrPath = [NSString stringWithFormat:@"%@/%@",userPath,@"array"];
            NSMutableArray *array = [NSMutableArray array];
            if ([manager fileExistsAtPath:arrPath]) {
                NSData *data = [NSData dataWithContentsOfFile:arrPath];
                NSMutableArray * array1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                array = [NSMutableArray arrayWithArray:array1];
                NSInteger a = 0;
                for (NSMutableDictionary *dic in array) {
                    if ([[dic objectForKey:@"objectId"]isEqualToString:objectId]) {
                        a = 1;
//                        NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:message.sendTimestamp] message:message];
                        [dic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
                        [dic setObject:[jsonDic objectForKey:@"title"] forKey:@"lastText"];
                        
                       
                    }
                }
                if (a == 0) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:message.sendTimestamp] message:message];
                    //测试用
                    [dic setObject:objectId forKey:@"objectId"];
                    [dic setObject:[jsonDic objectForKey:@"title"] forKey:@"lastText"];
                    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]forKey:@"state"];
                   
                    [dic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
                    [dic setObject:@"service" forKey:@"type"];
                    [array addObject:dic];
                }
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
                BOOL judge = [data1 writeToFile:arrPath atomically:YES];
                if (judge) {
                    NSLog(@"新的对话存储成功");
                }
                
            }else{
                NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil ];
                BOOL judge = [data writeToFile:arrPath atomically:YES];
                if (judge) {
                    [JudgeCreateCheatWindow judgeServiceConversationExist:message objectId:objectId];
                }
            }
        }else{
            BOOL judge =  [manager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (judge) {
                [JudgeCreateCheatWindow judgeServiceConversationExist:message objectId:objectId];
            }
        }
        
    }else{
        BOOL judge =  [manager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (judge) {
            [JudgeCreateCheatWindow judgeServiceConversationExist:message objectId:objectId];
        }
    }
    
}

+ (void)judgeConversationExist:(AVIMTypedMessage *)message objectId:(NSString *)objectId jdDic:(NSDictionary *)jdDic userDic:(NSDictionary *)userDic state:(NSString *)state
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *docPath = [NSString stringWithFormat:@"%@/%@",path,@"conversation"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:docPath]) {
        NSString *userPath = [NSString stringWithFormat:@"%@/%@",docPath,[AVUser currentUser].username];
        if ([manager fileExistsAtPath:userPath]) {
            NSString *arrPath = [NSString stringWithFormat:@"%@/%@",userPath,@"array"];
            NSMutableArray *array = [NSMutableArray array];
            if ([manager fileExistsAtPath:arrPath]) {
                NSData *data = [NSData dataWithContentsOfFile:arrPath];
                NSMutableArray * array1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                array = [NSMutableArray arrayWithArray:array1];
                NSInteger a = 0;
                for (NSMutableDictionary *dic in array) {
                    if ([[dic objectForKey:@"objectId"]isEqualToString:objectId]&&[[[dic objectForKey:@"jdDic"]objectForKey:@"id"]isEqualToString:[jdDic objectForKey:@"id"]]) {
                        a = 1;
//                         NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:message.sendTimestamp] message:message];
                        [dic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
                        if (message.text.length != 0) {
                            [dic setObject:message.text forKey:@"lastText"];
                            
                        }
                        [dic setObject:userDic forKey:@"userDic"];
                           [dic setObject:jdDic forKey:@"jdDic"];
                        [dic setObject:[message.attributes objectForKey:@"rsId"] forKey:@"rsId"];
                    }
                }
                if (a == 0) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    NSString *time =  [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:message.sendTimestamp] message:message];
                    //测试用
                    [dic setObject:objectId forKey:@"objectId"];
                    [dic setObject:jdDic forKey:@"jdDic"];
                    [dic setObject:message.text forKey:@"lastText"];
//                    [dic setObject:[[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]isEqualToString: @"1"]?@"2":@"1" forKey:@"state"];
                    [dic setObject:state forKey:@"state"];
                    [dic setObject:userDic forKey:@"userDic"];
                    [dic setObject:[NSString stringWithFormat:@"%lld",message.sendTimestamp] forKey:@"time"];
                    [dic setObject:[message.attributes objectForKey:@"rsId"] forKey:@"rsId"];
                    [array addObject:dic];
                }
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
                BOOL judge = [data1 writeToFile:arrPath atomically:YES];
                if (judge) {
                    NSLog(@"新的对话存储成功");
                }
                
            }else{
                NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil ];
               BOOL judge = [data writeToFile:arrPath atomically:YES];
                if (judge) {
                    [JudgeCreateCheatWindow judgeConversationExist:message objectId:objectId jdDic:jdDic userDic:userDic state:state];
                }
            }
        }else{
            BOOL judge =  [manager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (judge) {
                [JudgeCreateCheatWindow judgeConversationExist:message objectId:objectId jdDic:jdDic userDic:userDic state:state];
            }
        }
        
    }else{
       BOOL judge =  [manager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (judge) {
            [JudgeCreateCheatWindow judgeConversationExist:message objectId:objectId jdDic:jdDic userDic:userDic state:state];
        }
    }
    
}

+ (NSMutableArray *)getLocalConversationWindowArr
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *arrPath = [NSString stringWithFormat:@"%@/%@/%@/%@",path,@"conversation",[AVUser currentUser].username,@"array"];
    NSData *data = [NSData dataWithContentsOfFile:arrPath];
    if (data != nil) {
        
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return array;
    }else{
    return [NSMutableArray array];
    }
}

+ (void)deleteLocalConversationWithDic:(MyConversation *)dic
{

    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *arrPath = [NSString stringWithFormat:@"%@/%@/%@/%@",path,@"conversation",[AVUser currentUser].username,@"array"];
    NSData *data = [NSData dataWithContentsOfFile:arrPath];
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
    NSInteger a = 0;
    for (NSDictionary *dic1 in array1) {
        if ([dic.yourId isEqualToString:[dic1 objectForKey:@"objectId"]]&&[[NSString stringWithFormat:@"%ld", (long)dic.jdId] isEqualToString:[[dic1 objectForKey:@"jdDic"]objectForKey:@"id"]]) {
            [array removeObject:dic1];
            a = 1;
        }
    }
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    BOOL judge = [data1 writeToFile:arrPath atomically:YES];
    if (judge && a==1) {
        NSLog(@"删除成功");
    }
    
    
}
+ (void)moveConversationToTop:(NSDictionary *)dic
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    NSString *arrPath = [NSString stringWithFormat:@"%@/%@/%@/%@",path,@"conversation",[AVUser currentUser].username,@"array"];
    NSData *data = [NSData dataWithContentsOfFile:arrPath];
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSInteger a = 0;
    NSDictionary *resultDic = [NSDictionary dictionary];
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *dic1 in array1) {
        if ([[dic objectForKey:@"objectId"]isEqualToString:[dic1 objectForKey:@"objectId"]]&&[[[dic objectForKey:@"jdDic"]objectForKey:@"id"]isEqualToString:[[dic1 objectForKey:@"jdDic"]objectForKey:@"id"]]) {
            ;
            [array removeObject:dic1];
            resultDic = dic1;
            a = a + 1;
        }
    }
    if (a == 1) {
        if (resultDic != nil) {
        [array insertObject:resultDic atIndex:0];
        }
    }
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    BOOL judge = [data1 writeToFile:arrPath atomically:YES];
    if (judge && a==1) {
        NSLog(@"删除成功");
    }
}

@end
