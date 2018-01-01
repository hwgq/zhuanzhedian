//
//  WorkResumeViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/27.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeMainResumeDelegate <NSObject>

- (void)changeResumeWithDic:(NSDictionary *)dic eduArr:(NSArray *)edu jobArr:(NSArray *)job;

// 向前传送选中标签的值
- (void)turnValue:(NSMutableArray *)turnArr;

@end
@interface WorkResumeViewController : UIViewController


@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, strong)NSMutableArray *eduArr;
@property (nonatomic, strong)NSMutableArray *workArr;
@property (nonatomic, assign)id<changeMainResumeDelegate>resumeChangeDelegate;
@end
