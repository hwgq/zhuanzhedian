//
//  SelectJobViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/11/17.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectJobViewController : UIViewController
@property (nonatomic, strong)NSString *objectId;
@property (nonatomic, strong)NSString *cheatHeader;
@property (nonatomic, strong)NSNumber *rsId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *alertType;
@property (nonatomic, strong)NSDictionary *rsDic;
@property (nonatomic, strong)NSString *robot;
@end
