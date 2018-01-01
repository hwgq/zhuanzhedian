//
//  SortTextDate.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/13.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyMessage;
@interface SortTextDate : NSObject
+ (NSString *)retrunTimeLabelText:(NSInteger)indexPathRow arr:(NSArray *)arr;
+ (NSString *)returnFinalText:(NSInteger)number message:(MyMessage *)message;
+ (NSInteger)toKnowTodayIsWhat:(int64_t)timer;
+ (NSString *)dateWithTimerDetail:(int64_t)timer;
+ (NSString *)returnFinalText:(NSInteger)number time:(int64_t)time;
@end
