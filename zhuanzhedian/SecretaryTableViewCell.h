//
//  SecretaryTableViewCell.h
//  小秘书消息
//
//  Created by Gaara on 15/11/24.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecretaryTableViewCell : UITableViewCell
@property (nonatomic, strong)UIView *clickView;
@property (nonatomic, strong)UIView *mainView;
- (void)getCellValue:(NSDictionary *)dic;
@end
