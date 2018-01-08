//
//  OtherDefine.h
//  zhuanzhedian
//
//  Created by GuoQing Huang on 2018/1/5.
//  Copyright © 2018年 Gaara. All rights reserved.
//

#ifndef OtherDefine_h
#define OtherDefine_h

//  当前屏幕宽度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
//  当前屏幕高度
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
//  tabbar高度
#define TABBAR_HEIGHT   self.tabBarController.tabBar.frame.size.height
//  状态栏高度
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
//  Navigationbar高度
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define WeakSelf __weak typeof(self) weakSelf = self;

#define DDLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

#endif /* OtherDefine_h */
