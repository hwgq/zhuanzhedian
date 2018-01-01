//
//  WorkAndEduListController.h
//  zhuanzhedian
//
//  Created by Gaara on 16/7/6.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WorkAndEduListControllerDelegate <NSObject>

- (void)saveEduAndWorkDic:(NSMutableDictionary *)dic keyId:(NSString *)keyId key:(NSString *)key self:(id)selfVC;
- (void)deleteDicc:(NSString *)keyId key:(NSString *)key;
@end
@interface WorkAndEduListController : UIViewController
- (void)setListArrWithArr:(NSArray *)arr state:(NSString *)state;
@property (nonatomic, assign)id<WorkAndEduListControllerDelegate>delegate;
@end
