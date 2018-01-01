//
//  MyMessage.h
//  zhuanzhedian
//
//  Created by Gaara on 15/12/15.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessage : NSObject
@property (nonatomic, assign)double timeStamp;
@property (nonatomic, assign)NSInteger bossOrWorker;
@property (nonatomic, assign)NSInteger jdId;
@property (nonatomic, assign)NSInteger rsId;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)NSString *text;
@property (nonatomic, assign)NSInteger mediaType;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *sendId;
@property (nonatomic, strong)NSString *receiveId;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, strong)NSString *sendType;
@property (nonatomic, strong)NSString *yms;
@end
