//
//  ButtonSelectView.m
//  zhuanzhedian
//
//  Created by Gaara on 16/3/3.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ButtonSelectView.h"

@interface ButtonSelectView ()
@property (nonatomic, strong)UIImageView *titleImage;

@property (nonatomic, strong)UILabel *titleLabel;
@end
@implementation ButtonSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}
- (void)createView
{
    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, self.frame.size.height / 4, self.frame.size.height / 2, self.frame.size.height / 2)];
//    self.titleImage.backgroundColor = [UIColor redColor];
    [self addSubview:self.titleImage];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(17 + self.frame.size.height / 2, 20, self.frame.size.width / 2 + 5, 16)];
    self.numLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
//    self.numLabel.backgroundColor = [UIColor purpleColor];
    self.numLabel.textColor = [UIColor darkGrayColor];
    self.numLabel.textAlignment = 0;
    [self addSubview:self.numLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17 + self.frame.size.height / 2, 13 + self.frame.size.height / 3, self.frame.size.width / 2 + 5, 16)];
    self.titleLabel.textAlignment = 0;
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    self.titleLabel.textColor = [UIColor darkGrayColor];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:self.titleLabel];
}
- (void)getValueWithNum:(NSString *)num title:(NSString *)title image:(NSString *)imageName
{
    self.titleImage.image = [UIImage imageNamed:imageName];
    
    self.numLabel.text = num;
    
    self.titleLabel.text = title;
}
@end
