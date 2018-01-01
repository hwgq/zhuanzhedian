//
//  CreateNewJobViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeMainViewDelegate <NSObject>

- (void)changeMainValue:(NSDictionary *)dic;




@end

@interface CreateNewJobViewController : UIViewController



@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign)id<changeMainViewDelegate>delegate;
@end
