//
//  JobNameViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

// 往前传值协议一
@protocol JobNameDelegate <NSObject>

- (void)getNameTextDic:(NSDictionary *)dic;

@end
@interface JobNameViewController : UIViewController
@property (nonatomic, strong)NSString *placeHolderStr;
@property (nonatomic, strong)NSString *mainTitle;

// 协议步骤二
@property (nonatomic, assign)id<JobNameDelegate>delegate;
@property (nonatomic, strong)NSString *currentStr;
@property (nonatomic, strong)NSString *word;
@property (nonatomic, assign)NSInteger len;
@end
