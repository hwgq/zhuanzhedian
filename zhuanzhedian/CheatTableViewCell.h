//
//  CheatTableViewCell.h
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/9.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheatTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *leftCheatLabel;
@property (nonatomic, strong)UILabel *rightCheatLabel;
@property (nonatomic, strong)UIImageView *leftImage;
@property (nonatomic, strong)UIImageView *rightImage;
@property (nonatomic, strong)UIImageView *left;
@property (nonatomic, strong)UIImageView *right;
- (void)getLeftImage:(NSString *)leftImage rightImage:(NSString *)rightImage;
@end
