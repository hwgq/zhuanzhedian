//
//  WorkResumeDetailViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/30.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkResumeDetailViewController : UIViewController
@property (nonatomic, strong)NSMutableDictionary *dic;
- (instancetype)initWithButton:(NSString *)buttonType;
@property (nonatomic, copy)NSString *buttonType;
@property (nonatomic, copy)NSString *collectType;
@property (nonatomic, assign)NSInteger a;
@property (nonatomic, assign)NSInteger buttonCount;
@end
