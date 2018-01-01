//
//  ZZDRegistGuideView.m
//  NewModelZZD
//
//  Created by Gaara on 16/6/23.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDRegistGuideView.h"
#import "ZZDWriteInforView.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface ZZDRegistGuideView ()<ZZDWriteInforViewDelegate,BtnInforTagDelegate,BtnInforCategoryDelegate,ZZDGaoDeViewDelegate,ZZDAvatarSelectDelegate>
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imgArr;
@property (nonatomic, assign)CGFloat rowHeight;
@property (nonatomic, strong)NSArray *keys;
@end
@implementation ZZDRegistGuideView
- (instancetype)initWithFrame:(CGRect)frame titleImgArr:(NSArray *)imgArr titleArr:(NSArray *)titleArr rowHeight:(CGFloat)rowHeight imgName:(NSString *)imgName keys:(NSArray *)keys
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rowHeight = rowHeight;
        self.titleArr = titleArr;
        self.imgArr = imgArr;
        self.keys = keys;
        [self createView:imgName];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)createView:(NSString *)imgName
{
    
    UILabel *titleImage = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 25)];
    
    titleImage.textAlignment = 1;
    titleImage.font = [[FontTool customFontArrayWithSize:20]objectAtIndex:1];
    titleImage.text = imgName;
    titleImage.textColor = [UIColor colorFromHexCode:@"38ab99"];
    [self addSubview:titleImage];
    
    NSInteger a = 0;
    for (int i = 0; i < self.titleArr.count; i++) {
        
        if ([[self.titleArr objectAtIndex:i]isEqualToString:@"头像"]) {
            ZZDWriteInforView *inforView = [[ZZDWriteInforView alloc]initWithFrame:CGRectMake(0,a + i * self.rowHeight + 80, self.frame.size.width, self.rowHeight * 1.5)  editable:YES title:[self.titleArr  objectAtIndex:i]imageName:[self.imgArr objectAtIndex:i]key:[self.keys objectAtIndex:i]];
            inforView.delegate = self;
            [self addSubview:inforView];
           
            a = self.rowHeight * 0.5;
        }else{
            ZZDWriteInforView *inforView = [[ZZDWriteInforView alloc]initWithFrame:CGRectMake(0,a + i * self.rowHeight + 80, self.frame.size.width, self.rowHeight) editable:YES title:[self.titleArr  objectAtIndex:i]imageName:[self.imgArr objectAtIndex:i]key:[self.keys objectAtIndex:i]];
            inforView.delegate = self;
            [self addSubview:inforView];
            
            
        }
        
    }
    
}
- (void)selectAvatar:(NSInteger)tag
{
    [self.delegate setAvatarWithTag:tag];
}
- (void)jumpToGaoDeView
{
    [self.delegate jumpToGaoDeView];
}
- (void)jumpToTagVC
{
    [self.delegate jumpToTagVC];
}
- (void)jumpToCategory
{
    [self.delegate jumpToCategory];
}
- (void)inforValueChange:(NSString *)value key:(NSString *)key
{
   
    [self.delegate valueChangeWith:value key:key];
    
    
}
@end
