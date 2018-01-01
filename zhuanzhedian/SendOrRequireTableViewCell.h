//
//  SendOrRequireTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 17/3/9.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrRequireTableViewCell : UITableViewCell
@property (nonatomic,copy) void(^resultBlock)(NSString *);
- (void)hadDone:(NSString *)str;
- (void)setHeaderImage:(NSString *)image;
@end
