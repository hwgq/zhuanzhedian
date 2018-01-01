//
//  NSTimer+CLBlockSupport.h
//  
//
//  Created by Gaara on 17/3/14.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (CLBlockSupport)
+(NSTimer *)clscheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;
@end
