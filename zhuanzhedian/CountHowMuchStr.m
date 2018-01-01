//
//  CountHowMuchStr.m
//  zhuanzhedian
//
//  Created by Gaara on 15/12/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CountHowMuchStr.h"

@implementation CountHowMuchStr
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+(NSInteger)convertToInt:(NSString*)strtemp
{
    
    int strlength = 0;
    
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        
        if (*p) {
            
            p++;
            
            strlength++;
            
        }
        
        else {
            
            p++;
            
        }
        
    }
    
    return (strlength+1)/2;
    
}
@end
