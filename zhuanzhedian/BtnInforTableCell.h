//
//  BtnInforTableCell.h
//  CompleteRS
//
//  Created by Gaara on 16/7/4.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BtnInforTagDelegate <NSObject>

- (void)jumpToTagVC;

@end
@protocol BtnInforCategoryDelegate <NSObject>

- (void)jumpToCategory;

@end


@protocol BtnInforTableCellDelegate <NSObject>

- (void)setValue:(NSString *)value key:(NSString *)key;

@end
@interface BtnInforTableCell : UITableViewCell
- (void)setPlaceHolder:(NSString *)placeHolder key:(NSString *)key state:(NSString *)state;
@property (nonatomic, assign)id<BtnInforTableCellDelegate,BtnInforTagDelegate,BtnInforCategoryDelegate>delegate;
@property (nonatomic, strong)NSDictionary *mainDic;

@end
