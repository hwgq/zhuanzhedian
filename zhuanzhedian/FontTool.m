//
//  FontTool.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/1.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "FontTool.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@implementation FontTool
+ (NSArray*)customFontArrayWithSize:(CGFloat)size
{
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"经典圆体简" ofType:@"ttf"];
//    CFStringRef fontPath = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
//    
//    CFURLRef fontUrl = CFURLCreateWithFileSystemPath(NULL, fontPath, kCFURLPOSIXPathStyle, 0);
//    
//    CFArrayRef fontArray = CTFontManagerCreateFontDescriptorsFromURL(fontUrl);
//    
//    CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeNone, NULL);
//    
    NSMutableArray *customFontArray = [NSMutableArray array];
//    
////    for (CFIndex i = 0 ; i < CFArrayGetCount(fontArray); i++){
//    
//        CTFontDescriptorRef  descriptor = CFArrayGetValueAtIndex(fontArray, 0);
//        
//        CTFontRef fontRef = CTFontCreateWithFontDescriptor(descriptor, size, NULL);
//        
//        NSString *fontName = CFBridgingRelease(CTFontCopyName(fontRef, kCTFontPostScriptNameKey));
//        
//        UIFont *font = [UIFont fontWithName:fontName size:size];
//    if (font != nil) {
//        
//    
//        [customFontArray addObject:font];
//        [customFontArray addObject:font];
//        [customFontArray addObject:font];
//        
//    }else
//    {
        [customFontArray addObject:[UIFont systemFontOfSize:size]];
        [customFontArray addObject:[UIFont systemFontOfSize:size]];
        [customFontArray addObject:[UIFont systemFontOfSize:size]];
//    }
//    }
    
    return customFontArray;
    
}
@end
