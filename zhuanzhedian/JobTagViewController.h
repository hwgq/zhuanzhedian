//
//  JobTagViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/12/7.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JobTagDelegate <NSObject>

- (void)setBossTagArr:(NSMutableArray *)arr;
- (void)setBossTagArrToWork:(NSMutableArray *)arr;
@end

@interface JobTagViewController : UIViewController
@property (nonatomic, strong)NSDictionary *dic;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, assign)id<JobTagDelegate>delegate;

@end
