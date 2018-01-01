//
//  EditInforTableCell.m
//  EditInforVC
//
//  Created by Gaara on 16/6/28.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "EditInforTableCell.h"
#import "FontTool.h"
@interface EditInforTableCell ()<UITextFieldDelegate>
@property (nonatomic, strong)NSString *key;
@property (nonatomic, strong)UIImageView *stateImg;
@property (nonatomic, strong)UITextField *editTextField;
@end
@implementation EditInforTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
- (void)createSubViews
{
    self.stateImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
//    self.stateImg.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.stateImg];
    
    self.editTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 23, [UIScreen mainScreen].bounds.size.width - 80, 20)];
    self.editTextField.delegate = self;
    self.editTextField.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.editTextField.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.editTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 59, [UIScreen mainScreen].bounds.size.width - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.contentView addSubview:lineView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChangeOneCI:)
     name:UITextFieldTextDidChangeNotification
     object:self.editTextField];
}
- (void)setPlaceHolder:(NSString *)placeHolder key:(NSString *)key state:(NSString *)state
{
    self.key = key;
    self.editTextField.text = state;
    self.editTextField.placeholder = placeHolder;
    if (state.length == 0) {
        self.stateImg.image = [UIImage imageNamed:@"++.png"];
    }else{
        self.stateImg.image = [UIImage imageNamed:@"editP.png"];
    }
}

-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    NSLog(@"%@",textfield.text);

        [self.delegate setValue:textfield.text andKey:self.key];

    
}
@end
