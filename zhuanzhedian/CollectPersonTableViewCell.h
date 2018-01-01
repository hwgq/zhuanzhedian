//
//  CollectPersonTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectPersonTableViewCell : UITableViewCell
- (void)getValueDic:(NSDictionary *)dic;
@property (nonatomic, strong)UILabel *label;
@end
