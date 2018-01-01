//
//  RobotViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 17/3/8.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@interface RobotViewController : UIViewController
@property (nonatomic, strong)AVUser *cheatUser;
@property (nonatomic, strong)NSString *objectId;
@property (nonatomic, strong)NSDictionary *jdDic;
@property (nonatomic, strong)NSString *cheatHeader;
@property (nonatomic, strong)NSString *title;


@property (nonatomic, strong)NSNumber *jdId;
@property (nonatomic, strong)NSNumber *rsId;
@property (nonatomic, strong)NSDictionary *rsDic;
@end
