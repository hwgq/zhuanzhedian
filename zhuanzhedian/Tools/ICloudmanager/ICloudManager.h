//
//  ICloudManager.h
//  HWHGetFileDemo
//
//  Created by GuoQing Huang on 2018/1/3.
//  Copyright © 2018年 GuoQing Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^downloadBlock)(id obj);

@interface ICloudManager : NSObject

+ (BOOL)iCloudEnable;
+ (void)downloadWithDocumentURL:(NSURL *)url callback:(downloadBlock)block;

@end
