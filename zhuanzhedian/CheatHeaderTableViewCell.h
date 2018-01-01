//
//  CheatHeaderTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/11/18.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheatHeaderView;
@interface CheatHeaderTableViewCell : UITableViewCell
@property (nonatomic, strong)CheatHeaderView *headerView;
@property (nonatomic, strong)UILabel *nameTitleLabel;
- (void)getNameFromCell:(NSString *)name;
@end
