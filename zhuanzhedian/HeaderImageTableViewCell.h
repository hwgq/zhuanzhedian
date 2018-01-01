//
//  HeaderImageTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderImageTableViewCell : UITableViewCell
- (void)setTitleLabelText:(NSString *)str;
@property (nonatomic, strong)UIImageView *headerImageView;
@end
