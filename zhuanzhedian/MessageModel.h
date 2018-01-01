//
//  MessageModel.h
//  zhuanzhedian
//
//  Created by Gaara on 16/2/13.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MessageModel : NSObject
@property (nonatomic, assign)CGFloat rowHeight;
@property (nonatomic, strong)UIView *messageView;
@property (nonatomic, strong)NSAttributedString *attStr;
@end
