//
//  NotifiTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 16/2/18.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationMessage;
@interface NotifiTableViewCell : UITableViewCell
- (void)getValueFrom:(NotificationMessage *)message;
@end
