//
//  EditInforTableCell.h
//  EditInforVC
//
//  Created by Gaara on 16/6/28.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInforTableCellDelegate <NSObject>

- (void)setValue:(NSString *)value andKey:(NSString *)key;

@end
@interface EditInforTableCell : UITableViewCell
- (void)setPlaceHolder:(NSString *)placeHolder key:(NSString *)key state:(NSString *)state;
@property (nonatomic, assign)id<EditInforTableCellDelegate>delegate;
@end
