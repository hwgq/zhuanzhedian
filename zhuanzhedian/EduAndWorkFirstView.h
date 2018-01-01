//
//  EduAndWorkFirstView.h
//  zhuanzhedian
//
//  Created by Gaara on 17/4/6.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EduAndWorkFirstDelegate <NSObject>

- (void)setEduAndWorkFirstValue:(NSString *)value key:(NSString *)key state:(NSString *)state;
- (void)setCategory;
- (void)setTag;
@end

@interface EduAndWorkFirstView : UIView
@property (nonatomic, strong)NSString *state;
- (void)setFirstLine:(NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame state:(NSString *)state;
@property (nonatomic, assign)id<EduAndWorkFirstDelegate>firstDelegate;
@end
