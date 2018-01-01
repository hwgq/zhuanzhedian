//
//  ZZDWriteInforView.h
//  NewModelZZD
//
//  Created by Gaara on 16/6/22.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BtnInforTagDelegate <NSObject>

- (void)jumpToTagVC;

@end
@protocol BtnInforCategoryDelegate <NSObject>

- (void)jumpToCategory;

@end
@protocol ZZDWriteInforViewDelegate <NSObject>

- (void)inforValueChange:(NSString *)value key:(NSString *)key;

@end

@protocol ZZDGaoDeViewDelegate <NSObject>
- (void)jumpToGaoDeView;
@end
@protocol ZZDAvatarSelectDelegate <NSObject>
- (void)selectAvatar:(NSInteger)tag;
@end
@interface ZZDWriteInforView : UIView
- (instancetype)initWithFrame:(CGRect)frame editable:(BOOL)editable title:(NSString *)title imageName:(NSString *)name key:(NSString *)key;
@property (nonatomic, assign)id<ZZDWriteInforViewDelegate,BtnInforTagDelegate,BtnInforCategoryDelegate,ZZDGaoDeViewDelegate,ZZDAvatarSelectDelegate>delegate;
@end
