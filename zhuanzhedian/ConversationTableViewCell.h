//
//  ConversationTableViewCell.h
//  zhuanzhedian
//
//  Created by Gaara on 15/11/19.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyConversation;
@interface ConversationTableViewCell : UITableViewCell
- (void)cellGetValue:(MyConversation *)dic;
@property (nonatomic, assign)NSInteger a;
@property (nonatomic, strong)MyConversation *dic;
@property (nonatomic, strong)UILabel *alertLabel;
- (void)cellGetOther:(MyConversation *)dic;
- (void)getHeaderValue:(MyConversation *)dic;
@end
