//
//  BossCheatTitleCell.m
//  DifferentCell
//
//  Created by Gaara on 16/7/18.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "BossCheatTitleCell.h"
#import "BossCheatTitleView.h"
#import "UIColor+AddColor.h"
@interface BossCheatTitleCell ()
@property (nonatomic, strong)BossCheatTitleView *headerView;

@end
@implementation BossCheatTitleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews
{
    
    self.headerView = [[BossCheatTitleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 85)];
    
    self.headerView.backgroundColor = [UIColor colorFromHexCode:@"#ffffff"];
//    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.contentView addSubview:self.headerView];
}
- (void)setValuesFromText:(NSString *)text
{
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *valueDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [self.headerView setValueFromDic:valueDic];
    
}
@end
