//
//  HWHDocument.m
//  HWHGetFileDemo
//
//  Created by GuoQing Huang on 2018/1/3.
//  Copyright © 2018年 GuoQing Huang. All rights reserved.
//

#import "HWHDocument.h"

@implementation HWHDocument

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.data = contents;
    return YES;
}

@end
