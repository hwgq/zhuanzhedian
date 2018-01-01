//
//  BtnDateTableCell.m
//  CompleteRS
//
//  Created by Gaara on 16/7/4.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "BtnDateTableCell.h"
#import "AppDelegate.h"
#import "FontTool.h"
@interface BtnDateTableCell ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UIImageView *stateImg;
@property (nonatomic, strong)UILabel *selectedBtn;
@property (nonatomic, strong)NSString *key;
@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)UIView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;

@property (nonatomic, copy)NSString *yearStr;
@property (nonatomic, copy)NSString *monthStr;

@end
@implementation BtnDateTableCell
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
    self.stateImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    //    self.stateImg.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.stateImg];
    
    self.selectedBtn = [[UILabel alloc]initWithFrame:CGRectMake(60, 23, [UIScreen mainScreen].bounds.size.width - 80, 20)];
    self.selectedBtn.userInteractionEnabled = YES;
    
    [self.selectedBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap:)]];
    //    self.selectedBtn.backgroundColor = [UIColor redColor];
    self.selectedBtn.textAlignment = 0;
    self.selectedBtn.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [self.contentView addSubview:self.selectedBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 59, [UIScreen mainScreen].bounds.size.width - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.contentView addSubview:lineView];

}
- (void)selectTap:(id)sender
{
    [self createPickerView];
}
- (void)setPlaceHolder:(NSString *)placeHolder key:(NSString *)key state:(NSString *)state
{
    if (state.length == 0) {
        self.selectedBtn.textColor = [UIColor colorWithWhite:0.80 alpha:1];
    }else{
        self.selectedBtn.textColor = [UIColor blackColor];
    }
    self.key = key;
    if (state.length == 0) {
        self.stateImg.image = [UIImage imageNamed:@"++.png"];
    }else{
        self.stateImg.image = [UIImage imageNamed:@"editP.png"];
    }
    if (state.length == 0) {
        self.selectedBtn.text = placeHolder;
    }else{
        self.selectedBtn.text = state;
    }
    
    
}
- (void)createPickerView
{
   
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window endEditing:YES];
    self.pickerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height - 200)];
    self.pickerBackView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    self.pickerBackView.userInteractionEnabled = YES;
    [app.window addSubview:self.pickerBackView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToWindow)];
    [self.pickerBackView addGestureRecognizer:tap];
    
    self.pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, app.window.frame.size.height - 200, app.window.frame.size.width, 200)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [app.window addSubview:self.pickerView];
    
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, app.window.frame.size.width, 150)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.pickerView addSubview:self.picker];
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(app.window.frame.size.width - 50, 10, 30, 30)];
    rightView.image = [UIImage imageNamed:@"icon_right(1).png"];
    rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *completeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(completeTap)];
    [rightView addGestureRecognizer:completeTap];
    [self.pickerView addSubview:rightView];
    self.yearStr = @"2020";
    self.monthStr = @"01";
    
}
- (void)completeTap
{   self.selectedBtn.text = [NSString stringWithFormat:@"%@-%@",self.yearStr,self.monthStr];
    self.selectedBtn.textColor = [UIColor blackColor];
    [self.delegate setDate:self.selectedBtn.text key:self.key];
    [self backToWindow];
  
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 43;
    }
    if (component == 1) {
        return 12;
    }
    return 0;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld年",2020 - row];
    }
    if (component == 1) {
        return [NSString stringWithFormat:@"%ld月",row + 1];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *str = [NSString stringWithFormat:@"%ld",2020 - row];

        self.yearStr = str;
    }
    if (component == 1) {
        if (row + 1 < 10) {
            NSString *str = [NSString stringWithFormat:@"0%ld",row + 1];
            self.monthStr = str;
        }else{
            NSString *str = [NSString stringWithFormat:@"%ld",row + 1];
            self.monthStr = str;
        }
        
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[[FontTool customFontArrayWithSize:16]objectAtIndex:1]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)backToWindow
{
    [self.picker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.pickerBackView removeFromSuperview];
}
@end
