//
//  GaoDeMapViewController.h
//  GaodeMap
//
//  Created by Gaara on 16/7/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GaoDeMapVCDelegate <NSObject>

-(void)getPlaceStr:(NSString *)placeStr WithLat:(CGFloat)lat lon:(CGFloat)lon;

@end
@interface GaoDeMapViewController : UIViewController
@property (nonatomic, assign)id<GaoDeMapVCDelegate>delegate;
@end
