//
//  SortTextDate.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/13.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "SortTextDate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AVOSCloudIM/AVOSCloudIM.h"
#import "MyMessage.h"
@implementation SortTextDate
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (NSString *)retrunTimeLabelText:(NSInteger)indexPathRow arr:(NSArray *)arr
{
    
    MyMessage *messageOne = [arr objectAtIndex:indexPathRow];
    if (indexPathRow == 0) {
        return nil;
        
    }else if (indexPathRow == 1) {
        NSString *str = [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:messageOne.timeStamp] message:messageOne];
        return str;
    }else {
       
        MyMessage *messageTwo = [arr objectAtIndex:indexPathRow - 1];
        if ((messageOne.timeStamp - messageTwo.timeStamp ) > 200000) {
            NSString *str = [SortTextDate returnFinalText:[SortTextDate toKnowTodayIsWhat:messageOne.timeStamp] message:messageOne];
            return str;
        }else{
            return nil;
        }
        
    }
    
}
+ (NSString *)returnFinalText:(NSInteger)number message:(MyMessage *)message
{
    switch (number) {
        case 0:
            
            return [SortTextDate dateWithTimerDetail:message.timeStamp];
            
            break;
            
        case 1:
            
            return  [NSString stringWithFormat:@"%@ %@",@"今天",[SortTextDate dateWithHourAndMinute:message.timeStamp]];
            
            break;
            
        case 2:
            
            return [NSString stringWithFormat:@"%@ %@",@"昨天",[SortTextDate dateWithHourAndMinute:message.timeStamp]];
            
            break;
            
        case 3:
            
            return  [NSString stringWithFormat:@"%@ %@",@"前天",[SortTextDate dateWithHourAndMinute:message.timeStamp]];
            
            break;
        default:
            return nil;
            break;
    }

}
+ (NSString *)returnFinalText:(NSInteger)number time:(int64_t)time
{
    switch (number) {
        case 0:
            
            return [SortTextDate dateWithTimerDetail:time];
            
            break;
            
        case 1:
            
            return  [NSString stringWithFormat:@"%@ %@",@"今天",[SortTextDate dateWithHourAndMinute:time]];
            
            break;
            
        case 2:
            
            return [NSString stringWithFormat:@"%@ %@",@"昨天",[SortTextDate dateWithHourAndMinute:time]];
            
            break;
            
        case 3:
            
            return  [NSString stringWithFormat:@"%@ %@",@"前天",[SortTextDate dateWithHourAndMinute:time]];
            
            break;
        default:
            return nil;
            break;
    }
    
}

+ (NSString *)dateWithTimer:(int64_t)timer
{
    NSString *timeStr= [NSString stringWithFormat:@"%lld",timer/ 1000];//时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
   
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
//    [SortTextDate toKnowTodayIsWhat:timer];

    
  
    return currentDateStr;
}
+ (NSString *)dateWithHourAndMinute:(int64_t)timer
{
    NSString *timeStr= [NSString stringWithFormat:@"%lld",timer/ 1000];//时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    
    
    return currentDateStr;
}
+ (NSString *)dateWithTimerDetail:(int64_t)timer
{
    NSString *timeStr= [NSString stringWithFormat:@"%lld",timer/ 1000];//时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
   
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    

    
    
    
    return currentDateStr;
}
+ (NSInteger)toKnowTodayIsWhat:(int64_t)timer
{
    NSString *current = [SortTextDate dateWithTimer:timer];
    
    NSDate * senddate=[NSDate date];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *yesterdayfor = [[NSDateFormatter alloc]init];
    [yesterdayfor setDateFormat:@"yyyy-MM-dd"];
    NSString *yesterdayStr = [yesterdayfor stringFromDate:yesterday];
    
    
    NSDate *bigYes = [NSDate dateWithTimeIntervalSinceNow:- (24 * 60 * 60 * 2)];
    NSDateFormatter *bigYesterdayfor = [[NSDateFormatter alloc]init];
    [bigYesterdayfor setDateFormat:@"yyyy-MM-dd"];
    NSString *bigYesterdayStr = [bigYesterdayfor stringFromDate:bigYes];
    
    
    
    if ([current isEqualToString:locationString]) {
        return 1;//今天
    }
    if ([current isEqualToString:yesterdayStr]) {
        return 2;//昨天
    }
    if ([current isEqualToString:bigYesterdayStr]) {
        return 3;//前天
    }
    return 0;
}
@end
