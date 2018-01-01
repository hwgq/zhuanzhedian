//
//  JobRequireViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JobRequireDelegate <NSObject>

- (void)getChangedText:(NSString *)str;
- (void)scanSuccess;
@end
@interface JobRequireViewController : UIViewController
@property (nonatomic, copy)NSString *currentStr;
@property (nonatomic, assign)id<JobRequireDelegate>delegate;
@property (nonatomic, strong)NSString *word;
@end
