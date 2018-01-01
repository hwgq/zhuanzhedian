//
//  NewCheatTableViewCell.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;
@interface NewCheatTableViewCell : UITableViewCell
- (MessageModel *)createCheatBubble:(BOOL)user text:(NSString *)text attributedStr:(NSAttributedString *)attStr;
@property (nonatomic, strong)UIView *leftView;
@property (nonatomic, strong)UIView *rightView;
@property (nonatomic, strong)UIImageView *rightHeader;
@property (nonatomic, strong)UIImageView *leftHeader;

@property (nonatomic, strong)UILabel *timeLabel;
- (void)getLeftImage:(NSString *)leftImage;
- (void)getRightImage:(NSString *)rightImage;
@property (nonatomic, strong)UIImageView *statusImage;
@end
