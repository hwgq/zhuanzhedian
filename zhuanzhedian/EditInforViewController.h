//
//  EditInforViewController.h
//  EditInforVC
//
//  Created by Gaara on 16/6/28.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInforViewControllerDelegate <NSObject>
- (void)updateEduAndWorkDic:(NSDictionary *)dic keyId:(NSString *)keyId key:(NSString *)key;

- (void)updateDic:(NSDictionary *)dic;

- (void)setTagArr:(NSArray *)arr;
@end

@protocol DeleteEduAndWorkDelegate <NSObject>

- (void)deleteDic:(NSString *)keyId key:(NSString *)key;

@end
@interface EditInforViewController : UIViewController
- (void)setArrValue:(NSArray *)arr;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, strong)NSString *key;
@property (nonatomic,strong)NSMutableDictionary *mainDic;
@property (nonatomic, strong)NSString *keyId;
@property (nonatomic, assign)id<EditInforViewControllerDelegate,DeleteEduAndWorkDelegate>delegate;
@property (nonatomic, assign)NSInteger count;

@end
