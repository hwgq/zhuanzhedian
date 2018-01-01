//
//  KeyWordTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/26.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyWordCellDelegate <NSObject>

- (void)getKey:(NSString*)key title:(NSString *)title;

@end
@interface KeyWordTableViewCell : UITableViewCell


- (void)setValueText:(NSString *)title placeHolder:(NSString *)str;
- (void)createButton;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, assign)id<KeyWordCellDelegate>delegate;
@property (nonatomic, strong)UITextField *keyTextField;
@end
