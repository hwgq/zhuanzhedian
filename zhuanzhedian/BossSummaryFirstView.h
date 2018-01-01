//
//  BossSummaryFirstView.h
//  zhuanzhedian
//
//  Created by Gaara on 2017/10/9.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BossSummaryFirstDelegate <NSObject>

- (void)textDidChange:(NSString *)str;

@end
@interface BossSummaryFirstView : UIView
@property (nonatomic, strong)UITextView *myTextView;
@property (nonatomic, assign)id<BossSummaryFirstDelegate>delegate;
@end
