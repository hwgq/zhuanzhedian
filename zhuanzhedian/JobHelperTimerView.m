//
//  JobHelperTimerView.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/8/29.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "JobHelperTimerView.h"
#import "UIColor+AddColor.h"
@interface JobHelperTimerView ()
@property (nonatomic, strong)UIImageView *pointImg;
@end
@implementation JobHelperTimerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}
- (void)createSubView
{
    
    self.pointImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.pointImg.image = [UIImage imageNamed:@"右箭头(1).png"];
    [self addSubview:self.pointImg];
    NSArray *arr = @[@"转折点工作人员已收到你的约面试请求,等待处理",@"转折点工作人员已开始处理,将为你确认对方意向",@"约面试处理结果:合适/不合适",@"约面试服务结束"];
    for (int i = 0 ; i < 4; i++) {
        UIImageView *pointImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + i * 60, 20, 20)];
        pointImg.image = [UIImage imageNamed:@"timeNoChoose.png"];
        pointImg.tag = i + 1;
        [self addSubview:pointImg];
        
        if (i != 3) {
            
            
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(29, 40 + 60 * i, 2, 40)];
        lineView.backgroundColor = [UIColor colorFromHexCode:@"ccc"];
        lineView.tag = i + 10;
        [self addSubview:lineView];
            
        }
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50,10 + 60 * i, [UIScreen mainScreen].bounds.size.width - 70, 40)];
//        textLabel.backgroundColor = [UIColor greenColor];
        textLabel.textColor = [UIColor colorFromHexCode:@"ccc"];
        textLabel.text = [arr objectAtIndex:i];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 0;
        textLabel.tag = 20 + i;
        [self addSubview:textLabel];
        
    }
}
- (void)setStatusAndWords:(NSDictionary *)dic
{
    NSInteger status = [[dic objectForKey:@"status"]integerValue];
    NSInteger feedback = [[dic objectForKey:@"feedback"]integerValue];
    if (status == 0) {
        UIImageView *pointImg = [self viewWithTag:1];
        pointImg.image = [UIImage imageNamed:@"timeSelecteded.png"];
        
        self.pointImg.frame = CGRectMake(3, pointImg.frame.origin.y + 3, 13, 13);
        UILabel *textLabel = [self viewWithTag:20];
        textLabel.text = [NSString stringWithFormat:@"%@\n%@",textLabel.text,[dic objectForKey:@"created_at"]];
        textLabel.textColor = [UIColor colorFromHexCode:@"999"];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString  alloc] initWithString:textLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle setLineSpacing:3];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle range:NSMakeRange(0, [textLabel.text length])];
        
        textLabel.attributedText = attributedString;
        textLabel.font = [UIFont boldSystemFontOfSize:14];
    }else if (status == 1)
    {
        UIImageView *pointImg = [self viewWithTag:1];
        pointImg.image = [UIImage imageNamed:@"quanquan.jpg"];
        
        UILabel *textLabel = [self viewWithTag:20];
        textLabel.text = [NSString stringWithFormat:@"%@\n%@",textLabel.text,[dic objectForKey:@"created_at"]];
        textLabel.textColor = [UIColor colorFromHexCode:@"999"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString  alloc] initWithString:textLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle setLineSpacing:3];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle range:NSMakeRange(0, [textLabel.text length])];
        
        textLabel.attributedText = attributedString;
        textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        UIView *lineView = [self viewWithTag:10];
        lineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        
        UIImageView *pointImg1 = [self viewWithTag:2];
        pointImg1.image = [UIImage imageNamed:@"timeSelecteded.png"];
        
        self.pointImg.frame = CGRectMake(3, pointImg1.frame.origin.y + 3, 13, 13);
        
        
        UILabel *textLabel1 = [self viewWithTag:21];
        textLabel1.text = [NSString stringWithFormat:@"%@\n%@",textLabel1.text,[dic objectForKey:@"running_time"]];
        textLabel1.textColor = [UIColor colorFromHexCode:@"999"];
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString  alloc] initWithString:textLabel1.text];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle1 setLineSpacing:3];//调整行间距
        [attributedString1 addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle1 range:NSMakeRange(0, [textLabel1.text length])];
        
        textLabel1.attributedText = attributedString1;
        textLabel1.font = [UIFont boldSystemFontOfSize:14];
        
        
    }else if (status == 2)
    {
        UIImageView *pointImg = [self viewWithTag:1];
        pointImg.image = [UIImage imageNamed:@"quanquan.jpg"];
        
        UILabel *textLabel = [self viewWithTag:20];
        textLabel.text = [NSString stringWithFormat:@"%@\n%@",textLabel.text,[dic objectForKey:@"created_at"]];
        textLabel.textColor = [UIColor colorFromHexCode:@"999"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString  alloc] initWithString:textLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle setLineSpacing:3];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle range:NSMakeRange(0, [textLabel.text length])];
        
        textLabel.attributedText = attributedString;
        textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        UIView *lineView = [self viewWithTag:10];
        lineView.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        
        UIImageView *pointImg1 = [self viewWithTag:2];
        pointImg1.image = [UIImage imageNamed:@"quanquan.jpg"];
        UILabel *textLabel1 = [self viewWithTag:21];
        textLabel1.text = [NSString stringWithFormat:@"%@\n%@",textLabel1.text,[dic objectForKey:@"running_time"]];
        textLabel1.textColor = [UIColor colorFromHexCode:@"999"];
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString  alloc] initWithString:textLabel1.text];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle1 setLineSpacing:3];//调整行间距
        [attributedString1 addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle1 range:NSMakeRange(0, [textLabel1.text length])];
        
        textLabel1.attributedText = attributedString1;
        textLabel1.font = [UIFont boldSystemFontOfSize:14];
        
        UIView *lineView1 = [self viewWithTag:11];
        lineView1.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        
        UIImageView *pointImg2 = [self viewWithTag:3];
        pointImg2.image = [UIImage imageNamed:@"quanquan.jpg"];
        UILabel *textLabel2 = [self viewWithTag:22];
        textLabel2.text = [NSString stringWithFormat:@"约面试处理结果:%@\n%@",feedback==1?@"合适":@"不合适",[dic objectForKey:@"updated_at"]];
        textLabel2.textColor = [UIColor colorFromHexCode:@"999"];
        textLabel2.font = [UIFont boldSystemFontOfSize:14];
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString  alloc] initWithString:textLabel2.text];
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle2 setLineSpacing:3];//调整行间距
        [attributedString2 addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle2 range:NSMakeRange(0, [textLabel2.text length])];
        
        [attributedString2 addAttribute:NSForegroundColorAttributeName
                                  value:feedback == 1?[UIColor colorFromHexCode:@"38ab99"]:[UIColor colorFromHexCode:@"666"] range:NSMakeRange(8, feedback==1?2:3)];
        [attributedString2 addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:16] range:NSMakeRange(8, feedback==1?2:3)];
        textLabel2.attributedText = attributedString2;
        
        UIView *lineView2 = [self viewWithTag:12];
        lineView2.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
        
        UIImageView *pointImg3 = [self viewWithTag:4];
        pointImg3.image = [UIImage imageNamed:@"timeSelecteded.png"];
        
        
        self.pointImg.frame = CGRectMake(3, pointImg3.frame.origin.y + 3, 13, 13);
        UILabel *textLabel3 = [self viewWithTag:23];
        NSString *currentRole = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"current_role"];
        textLabel3.text = [NSString stringWithFormat:@"%@\n%@",feedback==1?@"我们将为你安排后续面试事宜":[NSString stringWithFormat:@"本次约面试服务结束,请你关注其他%@",[currentRole isEqualToString:@"1"]?@"职位":@"人才"],[dic objectForKey:@"updated_at"]];
        textLabel3.textColor = [UIColor colorFromHexCode:@"999"];
        textLabel3.font = [UIFont boldSystemFontOfSize:14];
        NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString  alloc] initWithString:textLabel3.text];
        NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle
                                                    alloc] init];
        [paragraphStyle3 setLineSpacing:3];//调整行间距
        [attributedString3 addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle3 range:NSMakeRange(0, [textLabel3.text length])];
        
        textLabel3.attributedText = attributedString3;
    }
}
@end
