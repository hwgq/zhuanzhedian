//
//  CompanyDetailLabelView.h
//  zhuanzhedian
//
//  Created by Gaara on 16/9/8.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyDetailLabelView : UIView
@property (nonatomic, strong)UILabel *detailLabel;
- (void)setDetailLabelSize:(CGFloat)sizeHeight;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title detailStr:(NSString *)detailStr;
@end
