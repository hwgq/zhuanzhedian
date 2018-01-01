//
//  JobSelectTypeViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 16/9/2.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JobSelectTypeDelegate <NSObject>

- (void)getTitleAndCategory:(NSDictionary *)dic;

- (void)getTitleAndCategoryToWork:(NSDictionary *)dic;
@end
@interface JobSelectTypeViewController : UIViewController
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, assign)id<JobSelectTypeDelegate>delegate;
@property (nonatomic, copy)NSString *currentStr;
@end
