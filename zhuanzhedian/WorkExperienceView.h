//
//  WorkExperienceView.h
//  CompleteRS
//
//  Created by Gaara on 16/6/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkExperienceView : UIView

@property (nonatomic, strong)NSDictionary *dic;
@property (nonatomic, strong)NSString *state;

- (void)setLabelText:(NSString *)date title:(NSString *)title detail:(NSString *)detail count:(NSInteger)a;
@end
