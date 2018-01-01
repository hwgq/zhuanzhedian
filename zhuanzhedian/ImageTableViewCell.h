//
//  ImageTableViewCell.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/11.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;

@interface ImageTableViewCell : UITableViewCell
- (MessageModel *)createImage:(BOOL)fromSelf image:(NSString *)imageUrl;
@property (nonatomic, strong)UIImageView *image;
@property (nonatomic, assign)CGSize size;
@property (nonatomic, strong)UIImageView *rightHeader;
@property (nonatomic, strong)UIImageView *leftHeader;
@property (nonatomic, strong)UIImageView *imageImage;

@property (nonatomic, strong)UILabel *timeLabel;
- (void)setLeftHeaderImage:(NSString *)url;
- (void)setRightHeaderImage:(NSString *)url;
@end
