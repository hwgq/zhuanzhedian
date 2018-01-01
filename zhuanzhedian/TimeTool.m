//
//  TimeTool.m
//  zhuanzhedian
//
//  Created by Gaara on 17/3/3.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool
+ (NSString *)judgeTimeBetweenNow:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSString *timeSp1 = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSInteger timeDiffer = [timeSp integerValue] - [timeSp1 integerValue];
    timeDiffer = timeDiffer / 5.0;
    NSString *showStr;
    if (timeDiffer / (86400 * 2)) {
        showStr = [NSString stringWithFormat:@"2天"];
    }else if (timeDiffer / 86400) {
        showStr = [NSString stringWithFormat:@"%ld天",timeDiffer / 86400];
    }else if (timeDiffer / 3600){
        showStr = [NSString stringWithFormat:@"%ld小时",timeDiffer / 3600];
    }else if(timeDiffer / 60){
        showStr = [NSString stringWithFormat:@"%ld分钟",timeDiffer / 60];
    }else{
        showStr = [NSString stringWithFormat:@"%ld秒",timeDiffer];
    }
    return showStr;
    
}
@end
