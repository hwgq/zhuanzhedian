//
//  JudgeLocalUnreadMessage.m
//  zhuanzhedian
//
//  Created by Gaara on 15/11/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "JudgeLocalUnreadMessage.h"
#import "AppDelegate.h"
#import "UsersViewController.h"
#import "BossMainViewController.h"
@implementation JudgeLocalUnreadMessage
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (void)tellNavHowMuchMessage
{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"messageArr"];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *stateArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"state"]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"state"]]) {
            [stateArr addObject:dic];
        }
        if ([[dic objectForKey:@"state"]isEqualToString:@"3"]) {
            [stateArr addObject:dic];
        }
    }
    if (stateArr.count == 0) {
        [appdelegate.message.navigationController.tabBarItem setBadgeValue:nil];
    }else if(stateArr.count > 99){
    [appdelegate.message.navigationController.tabBarItem setBadgeValue:@"99+"];
    }else{
       [appdelegate.message.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",stateArr.count]];
    }
    
    
    if (appdelegate.bossNav!= nil) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"] == nil) {
            [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"lyArr"];
            
        }else{
            
            
        }
        NSArray *lyArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lyArr"];
        
        [appdelegate.bossNav.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",lyArr.count]];
    }
    
}
@end
