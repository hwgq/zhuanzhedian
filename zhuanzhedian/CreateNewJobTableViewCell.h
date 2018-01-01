//
//  CreateNewJobTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateNewJobDelegate <NSObject>

- (void)setTitle:(NSString *)title andStr:(NSString *)str;
@end
@interface CreateNewJobTableViewCell : UITableViewCell
- (void)getTitleLabelText:(NSString *)str;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *returnLabel;
@property (nonatomic, strong)UITextField *returnField;
@property (nonatomic, strong)NSString *returnStr;
@property (nonatomic, assign)id<CreateNewJobDelegate>delegate;
@end

