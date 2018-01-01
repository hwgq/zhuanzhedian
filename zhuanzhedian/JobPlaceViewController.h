//
//  JobPlaceViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JobPlaceViewDelegate <NSObject>


- (void) getJobPlaceTextDic:(NSDictionary *)dic;
- (void) getJobChangeTextDic:(NSDictionary *)dic;

@end

@interface JobPlaceViewController : UIViewController
@property (nonatomic, strong)NSString *value;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic, strong)UITableView *provinceTable;
@property (nonatomic, strong)NSString *mainTitle;
@property (nonatomic, assign)id<JobPlaceViewDelegate>delegate;
@property (nonatomic, strong)NSString *word;

// 接收传过来的值
@property (nonatomic, strong)NSMutableDictionary *mainDic;

@end
