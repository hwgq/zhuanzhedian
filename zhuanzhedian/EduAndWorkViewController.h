//
//  EduAndWorkViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/11/4.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EduAndWorkDeleteDelegate <NSObject>

- (void)deleteEduAndWork:(NSString *)arrTitle dic:(NSDictionary *)dic;
@end


@protocol EduAndWorkSaveDelegate <NSObject>

- (void)saveNewEduAndWork:(NSString *)arrTitle dic:(NSDictionary *)dic;

@end

@protocol EduAndWorkChangeDelegate <NSObject>

- (void)changeEduAndWork:(NSString *)arrTitle dic:(NSDictionary *)dic row:(NSInteger)row;

@end
@interface EduAndWorkViewController : UIViewController
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, assign)NSInteger b;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)NSString *arrTitle;
@property (nonatomic, assign)id<EduAndWorkSaveDelegate>saveDelegate;
@property (nonatomic, assign)id<EduAndWorkChangeDelegate>changeDelegate;
@property (nonatomic, assign)id<EduAndWorkDeleteDelegate>deleteDelegate;
@end
