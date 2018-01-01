//
//  MD5NSString.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/29.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MD5NSString.h"
#import <CommonCrypto/CommonDigest.h>
@implementation MD5NSString
+ (NSString *)md5HexDigest:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}
@end
