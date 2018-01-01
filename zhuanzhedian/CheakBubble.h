//
//  CheakBubble.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MessageModel;
@interface CheakBubble : NSObject
+ (MessageModel *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position attributedStr:(NSAttributedString *)attStr;
+ (NSAttributedString *)getTrueText:(NSString *)str;
@end
