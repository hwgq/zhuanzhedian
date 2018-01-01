//
//  MD5NSString.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/29.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5NSString : NSObject
+ (NSString *)md5HexDigest:(NSString *)input;
@end
