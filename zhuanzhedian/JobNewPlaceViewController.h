//
//  JobNewPlaceViewController.h
//  zhuanzhedian
//
//  Created by 李文涵 on 16/1/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JobNewPlaceViewDelegate<NSObject>

- (void)getJobNewPlaceTextDic:(NSDictionary *)dic;
@end

@interface JobNewPlaceViewController : UIViewController

@property (nonatomic, strong)NSString *value;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UITableView *provinceTable;
@property (nonatomic, strong)NSString *mainTitle;
@property (nonatomic, strong)NSString *word;

@property (nonatomic, assign)id<JobNewPlaceViewDelegate>delegate;

@end
