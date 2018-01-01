//
//  HideCompanyTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/12/8.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HideCompanyTableViewCell : UITableViewCell
- (void)getTitleLabelText:(NSString *)str;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UISwitch *setting;
@end
