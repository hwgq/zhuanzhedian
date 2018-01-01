//
//  EnterTitleViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 16/9/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterTitleDelegate <NSObject>

- (void)getTitleFromDic:(NSDictionary *)dic;

@end
@interface EnterTitleViewController : UIViewController
@property (nonatomic, assign)id<EnterTitleDelegate>delegate;
@property (nonatomic, copy)NSString *currentStr;
@property (nonatomic, strong)NSString *currentType;
@end
