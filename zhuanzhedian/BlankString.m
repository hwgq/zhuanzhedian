//
//  BlankString.m
//  zhuanzhedian
//
//  Created by 李文涵 on 16/1/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "BlankString.h"

@implementation BlankString
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}
@end
