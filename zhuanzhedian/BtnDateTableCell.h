//
//  BtnDateTableCell.h
//  CompleteRS
//
//  Created by Gaara on 16/7/4.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BtnDateTableCellDelegate <NSObject>

- (void)setDate:(NSString *)date key:(NSString *)key;

@end
@interface BtnDateTableCell : UITableViewCell


- (void)setPlaceHolder:(NSString *)placeHolder key:(NSString *)key state:(NSString *)state;
@property (nonatomic, assign)id<BtnDateTableCellDelegate>delegate;
@end
