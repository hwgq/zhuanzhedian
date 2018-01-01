//
//  PriceRangeViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceRangeViewControllerDelegate <NSObject>

- (void)getMyValue:(NSDictionary *)dic;

@end

@interface PriceRangeViewController : UIViewController
@property (nonatomic, retain)NSMutableArray *array;
@property (nonatomic, weak)id<PriceRangeViewControllerDelegate>delegate;
@property (nonatomic, strong)NSString *mainTitle;
@property (nonatomic, strong)NSString *word;
@end
