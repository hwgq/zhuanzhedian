//
//  WorkAndEduListCell.m
//  zhuanzhedian
//
//  Created by Gaara on 16/7/6.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "WorkAndEduListCell.h"
#import "WorkExperienceView.h"
@interface WorkAndEduListCell ()
@property (nonatomic, strong)WorkExperienceView *workView;
@end
@implementation WorkAndEduListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    self.workView = [[WorkExperienceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 105)];
    [self.contentView addSubview:self.workView];
}
- (void)setLabelText:(NSString *)text title:(NSString *)title detail:(NSString *)detail count:(NSInteger)a
{
    [self.workView setLabelText:text title:title detail:detail count:a];
}
@end
