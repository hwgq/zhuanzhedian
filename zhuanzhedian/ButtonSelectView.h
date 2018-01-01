//
//  ButtonSelectView.h
//  zhuanzhedian
//
//  Created by Gaara on 16/3/3.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonSelectView : UIView
@property (nonatomic, strong)UILabel *numLabel;
- (void)getValueWithNum:(NSString *)num title:(NSString *)title image:(NSString *)imageName;
@end
