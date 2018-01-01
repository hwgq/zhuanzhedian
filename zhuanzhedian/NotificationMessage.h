//
//  NotificationMessage.h
//  zhuanzhedian
//
//  Created by Gaara on 16/3/24.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationMessage : NSObject
@property (nonatomic, assign)NSInteger bossOrWorker;
@property (nonatomic, assign)NSInteger jdId;
@property (nonatomic, assign)NSInteger rsId;
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *receiveId;
@property (nonatomic, strong)NSString *subType;
@property (nonatomic, strong)NSString *jdCount;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *detail;
@property (nonatomic, assign)double timestamps;
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSString *jdTitle;
@property (nonatomic, strong)NSString *sendId;
@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *token;
@end
