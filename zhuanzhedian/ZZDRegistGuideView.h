//
//  ZZDRegistGuideView.h
//  NewModelZZD
//
//  Created by Gaara on 16/6/23.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZDRegistGuideViewDelegate <NSObject>

- (void)valueChangeWith:(NSString *)value key:(NSString *)key;
- (void)jumpToCategory;
- (void)jumpToTagVC;
- (void)jumpToGaoDeView;
- (void)setAvatarWithTag:(NSInteger)tag;
@end
@interface ZZDRegistGuideView : UIView
- (instancetype)initWithFrame:(CGRect)frame titleImgArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr rowHeight:(CGFloat)rowHeight imgName:(NSString *)imgName keys:(NSArray *)keys;
@property (nonatomic, assign)id<ZZDRegistGuideViewDelegate>delegate;
@end
