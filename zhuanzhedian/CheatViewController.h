//
//  CheatViewController.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/6.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVOSCloud/AVOSCloud.h"
@interface CheatViewController : UIViewController
@property (nonatomic, strong)AVUser *cheatUser;
@property (nonatomic, strong)NSString *objectId;
@property (nonatomic, strong)NSDictionary *jdDic;
@property (nonatomic, strong)NSString *cheatHeader;
@property (nonatomic, strong)NSString *title;


@property (nonatomic, strong)NSNumber *jdId;
@property (nonatomic, strong)NSNumber *rsId;
@property (nonatomic, strong)NSDictionary *rsDic;
@end
