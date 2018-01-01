//
//  MyConversation.h
//  zhuanzhedian
//
//  Created by Gaara on 15/12/17.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyConversation : NSObject
//@"yourId",@"myId",@"jdId",@"rsId",@"lastText",@"lastTime",@"name",@"header"
@property (nonatomic, copy)NSString *yourId;
@property (nonatomic, copy)NSString *myId;
@property (nonatomic, assign)NSInteger jdId;
@property (nonatomic, assign)NSInteger rsId;
@property (nonatomic, copy)NSString *lastText;
@property (nonatomic, assign)double lastTime;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong)NSString *header;
@property (nonatomic, assign)NSInteger bossOrWorker;
@end
