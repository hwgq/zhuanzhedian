
//
//  CheakBubble.m
//  LeanCloudDemo
//
//  Created by Gaara on 15/11/10.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CheakBubble.h"
#import <UIKit/UIKit.h>
#import "UIColor+AddColor.h"
#import "MessageModel.h"
#import "FontTool.h"
@interface CheakBubble ()

@end
@implementation CheakBubble


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
+ (NSInteger)textGetSize:(NSString *)str
{
    NSInteger a = 0;
    for (int i = 0; i < str.length; i++) {
        NSString * temp = [str substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@":"]) {
            a++;
        }
    }
    
    
    return a;
}

+ (MessageModel *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position attributedStr:(NSAttributedString *)attStr{
    
    
    
    //计算大小
    //    UIFont *font = [UIFont systemFontOfSize:16];
    //    NSString * str = [text substringWithRange:NSMakeRange(0, text.length - [ self textGetSize:text] / 2 * 4)];
    //
    //    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    //    CGSize size = [str boundingRectWithSize:CGSizeMake(180.0f, 20000.0f) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    // build single chat bubble cell with given text
    UIImageView *returnView = [[UIImageView alloc] initWithFrame:CGRectZero];
    returnView.userInteractionEnabled = YES;
//    returnView.backgroundColor = [UIColor clearColor];
    returnView.layer.masksToBounds = YES;
    
    
    UIView *finalView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //背影图片
//    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"4":@"3" ofType:@"png"]];
    
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
    
    //添加文本信息
    UITextView *bubbleText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 0)];
    bubbleText.editable = NO;
    bubbleText.userInteractionEnabled = YES;
    bubbleText.backgroundColor = [UIColor clearColor];
    //    bubbleText.font = font;
    
    bubbleText.textAlignment =2;
    bubbleText.showsHorizontalScrollIndicator = NO;
    bubbleText.showsVerticalScrollIndicator = NO;
    
    //    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.selectable = YES;
    bubbleText.autocapitalizationType=UIViewAutoresizingFlexibleHeight;
    bubbleText.contentInset = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    bubbleText.font = [[FontTool customFontArrayWithSize:15]objectAtIndex:1];
    bubbleText.scrollEnabled = NO;
    if (attStr.length == 0) {
        bubbleText.attributedText = [self getTrueText:text];

    }else{
        bubbleText.attributedText = attStr;
     
    }
    
    bubbleText.textAlignment = 0;
    bubbleText.font = [[FontTool customFontArrayWithSize:15]objectAtIndex:1];
   
    if (!fromSelf) {
        bubbleText.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
        
    }else{
        bubbleText.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
        
    }
//    bubbleText.textColor = [UIColor blackColor];
//    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+10.0f, bubbleText.frame.size.height+10.0f);
    returnView.layer.cornerRadius = 10;
    if(fromSelf){
        bubbleText.frame =  CGRectMake(3, 0, [UIScreen mainScreen].bounds.size.width / 2, 0);
         [bubbleText sizeToFit];
        returnView.frame = CGRectMake(0, 0, bubbleText.frame.size.width+17.0f, bubbleText.frame.size.height);
        UIImage *origin = [UIImage imageNamed:@"lt_bgqp_white.png"];
        // 左端盖宽度
        NSInteger leftCapWidth = origin.size.width * 0.8f;
        // 顶端盖高度
        NSInteger topCapHeight = origin.size.height * 0.7f;
        UIImage *image = [origin stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        returnView.image = image;
//        returnView.layer.shadowRadius = 1.0;
        returnView.clipsToBounds = NO;
//        returnView.backgroundColor = [UIColor whiteColor];
    }else{
        bubbleText.frame =  CGRectMake(13, 0, [UIScreen mainScreen].bounds.size.width / 2 - 10, 0);
         [bubbleText sizeToFit];
        returnView.frame = CGRectMake(0, 0, bubbleText.frame.size.width+17.0f, bubbleText.frame.size.height);
        UIImage *origin = [UIImage imageNamed:@"lt_bgqp_green.png"];
        // 左端盖宽度
        NSInteger leftCapWidth = origin.size.width * 0.8f;
        // 顶端盖高度
        NSInteger topCapHeight = origin.size.height * 0.7f;
        UIImage *image = [origin stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        returnView.image = image;
//      returnView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
//      returnView.layer.shadowOffset = CGSizeMake(1,1);
        
//      returnView.layer.shadowOpacity = 0.6;
        
//        returnView.layer.shadowRadius = 1.0;
        
        returnView.clipsToBounds = NO;
//        returnView.backgroundColor = [UIColor colorFromHexCode:@"#00abea"];
        
    }
    
    [returnView addSubview:bubbleText];
    
    if (fromSelf) {
        
        
        finalView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-position-(bubbleText.frame.size.width+50.0f), 30.0f, bubbleText.frame.size.width+20.0f, bubbleText.frame.size.height+5.0f);
        
    }else{
        finalView.frame = CGRectMake(position + 30.0f, 30.0f, bubbleText.frame.size.width+20.0f, bubbleText.frame.size.height+5.0f);
        
    }
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
//    if (fromSelf) {
//        image.image = [UIImage imageNamed:@"icon_r.png"];
//        image.frame = CGRectMake(finalView.frame.size.width - 15, 5, 15, 23);
//        
//    }else{
//        image.frame = CGRectMake(0, 5, 15, 23);
//        image.image = [UIImage imageNamed:@"icon_l.png"];
//        
//    }
//    [finalView addSubview:image];
    [finalView addSubview:returnView];
    if (bubbleText.attributedText.length > 7) {
        
        
    if ([[bubbleText.attributedText.string substringWithRange:NSMakeRange(bubbleText.attributedText.string.length - 8, 8)]isEqualToString:@"\n\n点击查看详情"]) {
        NSMutableAttributedString *ymsAttStr = bubbleText.attributedText.mutableCopy;
        [ymsAttStr addAttribute:NSForegroundColorAttributeName value:
         [UIColor colorFromHexCode:@"#38ab99"]range:NSMakeRange(bubbleText.attributedText.string.length - 6, 6)];
        
        bubbleText.attributedText = ymsAttStr;
        
    }
    }
    
    
    
    MessageModel *messageModel = [[MessageModel alloc]init];
    messageModel.messageView = finalView;
    messageModel.rowHeight = finalView.frame.size.height + 35;
    messageModel.attStr = bubbleText.attributedText;
    return messageModel;
}
+ (NSAttributedString *)getTrueText:(NSString *)str
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"];
    NSString *plistPath = [path stringByAppendingPathComponent:@"LookImage.plist"];
    
    NSDictionary *otherDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:@"lookImage.json"];
    //第四步：准备好要存到本地的数组
    NSArray *dataArray = [NSArray arrayWithObjects:@"你好", @"我是", @"沙盒", nil];
    //第五步：将数组存入到指定的本地文件
    [otherDic writeToFile:documentPath atomically:YES];
    
    
    
    NSAttributedString *begin = [[NSAttributedString alloc]initWithString:@"["];
    NSAttributedString *end = [[NSAttributedString alloc]initWithString:@"]"];
    NSAttributedString *dd = [[NSAttributedString alloc]initWithString:@":"];
    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:str];
    NSMutableAttributedString *strF = [[NSMutableAttributedString alloc]initWithString:@""];
    
    
    for (int i = 0; i < 100000; i++) {
        if (str1.length == 0) {
            
            
            return strF;
        }
        NSAttributedString *temp = [str1 attributedSubstringFromRange:NSMakeRange(0, 1)];
        
        if ([temp isEqualToAttributedString:dd]) {
            
            if (str1.length != 1) {
              NSInteger aa = 0;
            
            for (int k = 0; k < str1.length  - 1; k++) {
                if ([[str1 attributedSubstringFromRange:NSMakeRange(k + 1, 1)]isEqualToAttributedString:dd]) {
                    aa = 1;
                }
            }
            if (aa == 0) {
                [strF appendAttributedString:str1];
                break;
            }
            }else
            {
                [strF appendAttributedString:str1];
                break;
            }
            NSLog(@"----%@----",str1);
            for (int j = 0; j < [str1 length]-1 ; j++) {
                
                NSAttributedString * temp1 = [str1 attributedSubstringFromRange:NSMakeRange(j, 1)];
                
                if ([[str1 attributedSubstringFromRange:NSMakeRange(j + 1, 1)]isEqualToAttributedString:dd]) {
                    NSAttributedString *emoji = [str1 attributedSubstringFromRange:NSMakeRange(0, j + 2)];
                    
                    UIImage * smileImage = [ UIImage imageNamed:[NSString stringWithFormat:@"emoji_%@.png",[[emoji attributedSubstringFromRange:NSMakeRange(1, emoji.length - 2)]string]]] ;
                    if (smileImage == nil) {
                        [strF appendAttributedString:emoji];
                        str1 = [str1 attributedSubstringFromRange:NSMakeRange(emoji.length, str1.length - emoji.length)];
                        break;
                    }
                    NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:UIImagePNGRepresentation(smileImage) ofType:nil] ;
                    textAttachment.image = smileImage ;
                    textAttachment.bounds = CGRectMake(2, -4, 20, 20);
                    NSAttributedString * textAttachmentString = [ NSAttributedString attributedStringWithAttachment:textAttachment ] ;
                    [strF appendAttributedString:textAttachmentString];
                    
                    str1 = [str1 attributedSubstringFromRange:NSMakeRange(emoji.length, str1.length - emoji.length)];
                    
                    break;
                    
                }
            }
        }else if([temp isEqualToAttributedString:begin]){
            for (int j = 0; j < [str1 length]-1 ; j++) {
                
                NSAttributedString * temp1 = [str1 attributedSubstringFromRange:NSMakeRange(j, 1)];
                
                if ([[str1 attributedSubstringFromRange:NSMakeRange(j + 1, 1)]isEqualToAttributedString:end]) {
                    NSAttributedString *emoji = [str1 attributedSubstringFromRange:NSMakeRange(0, j + 2)];
                        UIImage *um = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:[otherDic objectForKey:[emoji string]]]];
                            
//                            UIImage * smileImage = [ UIImage imageNamed:[NSString stringWithFormat:@"emoji_%@.png",[[emoji attributedSubstringFromRange:NSMakeRange(1, emoji.length - 2)]string]]] ;
                            
                            NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:UIImagePNGRepresentation(um) ofType:nil] ;
                            textAttachment.image = um ;
                            textAttachment.bounds = CGRectMake(2, -4, 20, 20);
                            NSAttributedString * textAttachmentString = [ NSAttributedString attributedStringWithAttachment:textAttachment ] ;
                            [strF appendAttributedString:textAttachmentString];
                            
                            str1 = [str1 attributedSubstringFromRange:NSMakeRange(emoji.length, str1.length - emoji.length)];
                            
                            break;
                        }
                
                }
            

        }else{
            [strF appendAttributedString:temp];
            str1 = [str1 attributedSubstringFromRange:NSMakeRange(1, str1.length - 1)];
        }
    }
    
    
    return strF;
}




@end
