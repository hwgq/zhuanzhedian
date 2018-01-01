//
//  SelectAsBtnView.h
//  SelectBtnView
//
//  Created by Gaara on 16/6/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAsBtnView : UIView
- (void)setText:(NSString *)title detail:(NSString *)detail key:(NSString *)key;
@property (nonatomic, assign)NSInteger signCount;
@property (nonatomic, strong)NSString *key;
@property (nonatomic,strong)NSString *state;
@end
