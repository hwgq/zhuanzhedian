//
//  ButtonView.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/28.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "ButtonView.h"
#import "FontTool.h"
#import "UIColor+AddColor.h"
@interface ButtonView ()


@property (nonatomic, strong)UIImageView *directImage;

@end
@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;

        [self createView];
        
    }
    return self;
}

- (void)createView
{
    NSArray *fontArr = [FontTool customFontArrayWithSize:14];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width / 2 + 5, self.frame.size.height)];
    
    self.titleLabel.textAlignment = 2;

    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    
    self.titleLabel.font = [fontArr objectAtIndex:1];
    self.titleLabel.text = self.title;
    
    [self addSubview:self.titleLabel];
    
    self.directImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + 20, 22, 9, 6)];
    
    self.directImage.image = [UIImage imageNamed:@"bob_bt.png"];
    
    [self addSubview:self.directImage];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.delegate toDoSomeThingWithTitle:self.title image:self.directImage];
}

@end
