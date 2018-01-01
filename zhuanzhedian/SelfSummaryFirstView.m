//
//  SelfSummaryFirstView.m
//  zhuanzhedian
//
//  Created by Gaara on 17/4/6.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "SelfSummaryFirstView.h"
#import "FontTool.h"
#import "CountHowMuchStr.h"
#import "UIColor+AddColor.h"
@interface SelfSummaryFirstView ()<UITextViewDelegate>

@property (nonatomic, strong)UILabel *backLabel;
@property (nonatomic, strong)UILabel *numLabel;

@end
@implementation SelfSummaryFirstView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTextView];
    }
    return self;
}
- (void)createTextView
{

    UILabel *titleImage = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 25)];
    
    titleImage.textAlignment = 1;
    titleImage.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    titleImage.text = @"\"你的自我介绍\"";
    titleImage.textColor = [UIColor colorFromHexCode:@"38ab99"];
    [self addSubview:titleImage];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 75, self.frame.size.width - 20, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    self.backLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, self.frame.size.width - 25, 24)];
    self.backLabel.text = [NSString stringWithFormat:@"自我介绍对用人单位十分重要，请认真填写"];
    self.backLabel.textColor = [UIColor lightGrayColor];
    self.backLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    if (self.currentStr.length != 0) {
//        self.backLabel.frame = CGRectMake(5, 4, 0, 24);
//    }
    //    self.backLabel.backgroundColor = [UIColor yellowColor];
    [backView addSubview:self.backLabel];
    
    self.myTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 75, self.frame.size.width - 20, 200)];
    self.myTextView.delegate = self;
    self.myTextView.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    //    self.myTextView.textAlignment = 0;
    //    self.myTextView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    //    self.myTextView.text = @"请填写职位要求";
    //    self.myTextView.textColor = [UIColor grayColor];
    self.myTextView.text = @"";
    self.myTextView.layer.borderColor = [UIColor colorFromHexCode:@"eee"].CGColor;
    self.myTextView.layer.borderWidth = 1;
    self.myTextView.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    self.myTextView.backgroundColor = [UIColor clearColor];
    self.myTextView.showsVerticalScrollIndicator = NO;
    
    
    
    [self addSubview:self.myTextView];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 200, 228 + 50, 190, 20)];
    self.numLabel.textAlignment = 2;
    self.numLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    self.numLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
    //    self.numLabel.backgroundColor = [UIColor whiteColor];
    self.numLabel.text = [NSString stringWithFormat:@"%ld/180",[CountHowMuchStr convertToInt:@""]];
    [self addSubview:self.numLabel];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate textDidChange:textView.text];
    if (textView.text.length == 0) {
        self.backLabel.frame = CGRectMake(5, 4, self.frame.size.width - 25, 24);
        self.numLabel.text = @"0/180";
    }else{
        self.backLabel.frame = CGRectMake(5, 4, 0, 24);
        if ([CountHowMuchStr convertToInt:textView.text] > 180) {
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/180",[CountHowMuchStr convertToInt:textView.text]]];
            NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"/"].location);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
            [self.numLabel setAttributedText:noteStr] ;
            
        }else{
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/180",[CountHowMuchStr convertToInt:textView.text]]];
            [self.numLabel setAttributedText:noteStr] ;
        }
        
    }
}
@end
