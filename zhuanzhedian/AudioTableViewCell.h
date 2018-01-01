//
//  AudioTableViewCell.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/11.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableViewCell : UITableViewCell
@property (nonatomic, strong)UIView *view;
- (void)createAudioView:(BOOL)user url:(NSString *)url duration:(double)duration;
@property (nonatomic, strong)UIImageView *rightHeader;
@property (nonatomic, strong)UIImageView *leftHeader;

@property (nonatomic, strong)UILabel *timeLabel;
- (void)setLeftHeaderImage:(NSString *)url;
- (void)setRightHeaderImage:(NSString *)url;
@end
