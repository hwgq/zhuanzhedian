//
//  ScanViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 16/12/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanViewControllerDelegate <NSObject>

- (void)saveBossInfor;

@end
@interface ScanViewController : UIViewController
@property (nonatomic, strong)NSString *state;
@property (nonatomic, assign)id<ScanViewControllerDelegate>delegate;
@end
