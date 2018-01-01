//
//  ZZDMineTableViewCell.m
//  Mine
//
//  Created by Gaara on 16/6/30.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDMineTableViewCell.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface ZZDMineTableViewCell ()
@property (nonatomic, strong)UIImageView *launchImg;
@property (nonatomic, strong)UILabel *launchTitle;

@end
@implementation ZZDMineTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createFrame];
    }
    return self;
}
- (void)createFrame
{
    self.launchImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    [self.contentView addSubview:self.launchImg];
    
    self.launchTitle = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 100, 30)];
    self.launchTitle.textColor = [UIColor colorFromHexCode:@"#777777"];
    self.launchTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    
    [self.contentView addSubview:self.launchTitle];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#EEEEEE"];
    [self.contentView addSubview:lineView];
    
   
}

- (void)setImage:(NSString *)imageName title:(NSString *)title
{
    if (imageName == nil || imageName.length == 0) {
        self.launchTitle.frame = CGRectMake(15, 10, 100, 30);
        self.launchTitle.textColor = [UIColor colorFromHexCode:@"#b1b1b1"];
        self.launchTitle.text = title;
    }else{
    self.launchImg.image = [UIImage imageNamed:imageName];
        self.launchTitle.frame = CGRectMake(55, 10, 100, 30);
        self.launchTitle.textColor = [UIColor colorFromHexCode:@"#777777"];
        self.launchTitle.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.launchTitle.text = title;
    }
 

}
@end
