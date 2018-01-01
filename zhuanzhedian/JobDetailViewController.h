//
//  JobDetailViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailViewController : UIViewController
@property (nonatomic, strong)NSMutableDictionary *dic;
- (instancetype)initWithButton:(NSString *)buttonType;
@property (nonatomic, copy)NSString *collectType;

@end
