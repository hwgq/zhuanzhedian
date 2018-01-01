//
//  SelfSummaryFirstView.h
//  zhuanzhedian
//
//  Created by Gaara on 17/4/6.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelfSummaryFirstDelegate <NSObject>

- (void)textDidChange:(NSString *)str;

@end
@interface SelfSummaryFirstView : UIView
@property (nonatomic, strong)UITextView *myTextView;
@property (nonatomic, assign)id<SelfSummaryFirstDelegate>delegate;
@end
