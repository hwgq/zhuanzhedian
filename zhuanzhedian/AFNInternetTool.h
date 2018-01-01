//
//  AFNInternetTool.h
//  zhuanzhedian
//
//  Created by Gaara on 16/10/24.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNInternetTool : NSObject
+(void)getLaunchViewWithBlock:(void (^)( id result , NSString *str))block;
+ (void)getTimeStampWithBlock:(void (^)(id result, NSString *str))block;
+ (void)getCityListAndSave;
+ (void)getPreListWithUrl:(NSString *)url andBlock:(void (^)( id result, NSString *str))block;
@end
