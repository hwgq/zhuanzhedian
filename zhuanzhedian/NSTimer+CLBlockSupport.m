//
//  NSTimer+CLBlockSupport.m
//  
//
//  Created by Gaara on 17/3/14.
//
//

#import "NSTimer+CLBlockSupport.h"

@implementation NSTimer (CLBlockSupport)
+(NSTimer *)clscheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(clblockInvoke:)userInfo:[block copy]repeats:repeats];
}
+(void)clblockInvoke:(NSTimer*)timer
{
    void(^block)()=timer.userInfo;
    if (block) {
        block();
    }
}
@end
