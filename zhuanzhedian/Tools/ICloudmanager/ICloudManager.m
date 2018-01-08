//
//  ICloudManager.m
//  HWHGetFileDemo
//
//  Created by GuoQing Huang on 2018/1/3.
//  Copyright © 2018年 GuoQing Huang. All rights reserved.
//

#import "ICloudManager.h"
#import "HWHDocument.h"


@implementation ICloudManager

// 判断iCloud是否可用
+ (BOOL)iCloudEnable {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    NSLog(@"iCloud 不可用");
    return NO;
}

+ (void)downloadWithDocumentURL:(NSURL *)url callback:(downloadBlock)block {
    HWHDocument *iCloudDoc = [[HWHDocument alloc] initWithFileURL:url];
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                NSLog(@"关闭成功");
            }];
            
            if (block) {
                block(iCloudDoc.data);
            }
        }
    }];
}

@end
