//
//  AppDelegate.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AVOSCloud/AVOSCloud.h"

#import "AVOSCloudIM/AVOSCloudIM.h"
@class UsersViewController;
@class BossMainViewController;
@class ZZDAlertView;
@protocol AppDelegateDelegate <NSObject>

- (void)goIntoCheatView:(NSString *)clientId;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate,AVIMClientDelegate>
@property (nonatomic, strong)UITabBarController *tabBar;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)AVIMClient *mainClient;
@property (nonatomic, strong)UsersViewController *message;
@property (nonatomic, strong)BossMainViewController *bossVC;
@property (nonatomic, strong)UINavigationController *bossNav;
@property (nonatomic, strong)ZZDAlertView *alert;
@property (nonatomic, assign)id<AppDelegateDelegate>ddelegate;
+ (void)judgeServiceConversationExist:(AVIMTypedMessage *)message objectId:(NSString *)objectId;
- (void)tellUser;
- (void)doBigThing;
@end

