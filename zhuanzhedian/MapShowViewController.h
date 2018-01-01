//
//  MapShowViewController.h
//  zhuanzhedian
//
//  Created by Gaara on 16/8/2.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapShowViewController : UIViewController
@property (nonatomic, assign)double lat;
@property (nonatomic, assign)double lon;
@property (nonatomic, strong)NSString *addressStr;
@end
