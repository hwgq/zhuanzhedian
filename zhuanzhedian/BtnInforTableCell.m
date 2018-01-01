//
//  BtnInforTableCell.m
//  CompleteRS
//
//  Created by Gaara on 16/7/4.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "BtnInforTableCell.h"
#import "AppDelegate.h"
#import "JobTagViewController.h"
#import "JobPlaceViewController.h"
#import "FontTool.h"
@interface BtnInforTableCell ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UIImageView *stateImg;
@property (nonatomic, strong)UILabel *selectedBtn;
@property (nonatomic, strong)NSString *key;
@property (nonatomic, strong)NSString *idKey;
@property (nonatomic, strong)NSArray *pickerArr;
@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)UIView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;
@property (nonatomic, strong)NSString *currentValue;
@property (nonatomic, strong)NSString *currentId;
@property (nonatomic, strong)NSArray *pickerSubArr;


@property (nonatomic, strong)NSString *cityId;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *provinceId;
@property (nonatomic, strong)NSString *province;

@end
@implementation BtnInforTableCell
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
- (void)selectTap:(UITapGestureRecognizer *)tap
{
   
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];
    if ([self.key isEqualToString:@"sex"]) {
        self.pickerArr = @[@{@"name":@"男"},@{@"name":@"女"}];
        self.currentValue = @"男";
        [self createPicker];
    }else if([self.key isEqualToString:@"highest_edu"]){
        self.pickerArr = [dic objectForKey:@"education"];
        self.currentId = @"1";
        self.idKey = @"highest_edu_id";
        self.currentValue = @"大专";
        [self createPicker];
    }else if([self.key isEqualToString:@"work_state"]){
        self.pickerArr = @[@{@"name":@"应届毕业生"},@{@"name":@"在职-寻找机会"},@{@"name":@"离职-随时上岗"}];
        self.currentValue = @"在职-寻找机会";
        [self createPicker];
    }else if([self.key isEqualToString:@"work_year"]){
        self.pickerArr = [dic objectForKey:@"work_year"];
        self.currentId = @"1";
        self.currentValue = @"应届生";
        self.idKey = @"work_year_id";
        [self createPicker];
    }else if ([self.key isEqualToString:@"sub_category"]){
        
    }else if ([self.key isEqualToString:@"salary"]){
        self.pickerArr = [dic objectForKey:@"salary"];
        self.currentValue = @"3k以下";
        self.currentId = @"1";
        self.idKey = @"salary_id";
        [self createPicker];
    }else if([self.key isEqualToString:@"edu_experience"]){
        self.pickerArr = [dic objectForKey:@"education"];
        self.currentValue = @"大专";
        self.idKey = @"edu_experience_id";
        self.currentId = @"1";
        [self createPicker];
    }else if ([self.key isEqualToString:@"city"]){
        self.pickerArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
        self.pickerSubArr = [[self.pickerArr objectAtIndex:0]objectForKey:@"data"];
//        self.currentValue = @"上海";
        self.city = @"上海";
        self.province = @"上海";
        self.cityId = @"862";
        self.provinceId = @"861";
        [self createPicker];
        
    }else if([self.key isEqualToString:@"tag_user"]){
        [self.delegate jumpToTagVC];
        
    }else if ([self.key isEqualToString:@"title"]){
        [self.delegate jumpToCategory];
    }else if ([self.key isEqualToString:@"category"]){
//        JobPlaceViewController *jobPlace = [[JobPlaceViewController alloc]init];
//        jobPlace.dataArr = [dic objectForKey:@"category"];
//        jobPlace.delegate = self;
//        jobPlace.mainTitle = @"job";
//        jobPlace.word = @"职位类型";
//        
//        // 5. 前代理人
//        jobPlace.delegate = self;
//        
//        [self.navigationController pushViewController:jobPlace animated:YES];
        [self.delegate jumpToCategory];
        
    }

}
- (void)setPlaceHolder:(NSString *)placeHolder key:(NSString *)key state:(NSString *)state
{
    self.key = key;
    if ([state isKindOfClass:[NSString class]]) {
        if (state.length == 0) {
            self.selectedBtn.textColor = [UIColor colorWithWhite:0.80 alpha:1];
        }else{
            self.selectedBtn.textColor = [UIColor blackColor];
        }
        
        if (state.length == 0) {
            self.stateImg.image = [UIImage imageNamed:@"++.png"];
        }else{
            self.stateImg.image = [UIImage imageNamed:@"editP.png"];
        }
    }else if([state isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray *)state;
        if (arr.count == 0) {
            self.stateImg.image = [UIImage imageNamed:@"++.png"];
        }else{
            self.stateImg.image = [UIImage imageNamed:@"editP.png"];
        }
    }
    if ([state isKindOfClass:[NSString class]]) {
    if (state.length == 0) {
        self.selectedBtn.text = placeHolder;
    }else{
        self.selectedBtn.text = state;
    }
    }
     if([state isKindOfClass:[NSArray class]] || [key isEqualToString:@"tag_user"]){
        if ([state isKindOfClass:[NSArray class]]) {
            
            NSArray *arr = (NSArray *)state;
            if (arr.count == 0) {
                self.selectedBtn.text = @"未选择";
            }else{
                self.selectedBtn.text = @"已选择";
            }
        }else if([state isKindOfClass:[NSString class]]){
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:[state dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            if (arr.count == 0) {
                self.selectedBtn.text = @"未选择";
            }else{
                self.selectedBtn.text = @"已选择";
            }
        }
     }

}
- (void)createPicker
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
    
}
- (void)completeTap
{
    [self backToWindow];
    if ([self.key isEqualToString:@"city"]) {
        [self.delegate setValue:self.provinceId key:@"province_id"];
        [self.delegate setValue:self.province key:@"province"];
        [self.delegate setValue:self.cityId key:@"city_id"];
        [self.delegate setValue:self.city key:@"city"];
        self.selectedBtn.text = self.city;
    }else if([self.key isEqualToString:@"work_state"]){
        if ([self.currentValue isEqualToString:@"离职-随时上岗"]) {
            [self.delegate setValue:@"0" key:self.key];
            self.selectedBtn.text = @"离职";
        }else if([self.currentValue isEqualToString:@"在职-寻找机会"])
        {
            [self.delegate setValue:@"1" key:self.key];
            self.selectedBtn.text = @"在职";
        }else if ([self.currentValue isEqualToString:@"应届毕业生"])
        {
            [self.delegate setValue:@"2" key:self.key];
            self.selectedBtn.text = @"应届";
        }
    
    }else{
    [self.delegate setValue:self.currentValue key:self.key];
    if (self.idKey.length != 0) {
        
        [self.delegate setValue:self.currentId key:self.idKey];
    }
        
    self.selectedBtn.text = self.currentValue;
    }
    self.selectedBtn.textColor = [UIColor blackColor];
//    self.btnLabel.textColor = [UIColor colorWithRed:26 / 255.0 green:171 / 255.0 blue:125 / 255.0 alpha:1];
    
}
- (void)backToWindow
{
    [self.picker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.pickerBackView removeFromSuperview];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.key isEqualToString:@"city"]) {
        if (component == 1) {
            
            self.cityId = [[self.pickerSubArr objectAtIndex:row]objectForKey:@"id"];
            self.city = [[self.pickerSubArr objectAtIndex:row]objectForKey:@"name"];
            
            
        }else if(component == 0)
        {
            self.pickerSubArr = [[self.pickerArr objectAtIndex:row]objectForKey:@"data"];
            [self.picker reloadComponent:1];
            self.province = [[self.pickerArr objectAtIndex:row]objectForKey:@"name"];
            self.provinceId = [[self.pickerArr objectAtIndex:row]objectForKey:@"id"];
            self.city = [[self.pickerSubArr objectAtIndex:0]objectForKey:@"name"];
            self.cityId = [[self.pickerSubArr objectAtIndex:0]objectForKey:@"id"];

        }
    }else{
        self.currentValue = [[self.pickerArr objectAtIndex:row]objectForKey:@"name"];
        self.currentId = [[self.pickerArr objectAtIndex:row]objectForKey:@"id"];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([self.key isEqualToString:@"city"]) {
        return 2;
    }else{
        return 1;
    }
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if ([self.key isEqualToString:@"city"] && component == 1) {
        return [self.pickerSubArr count];
    }else{
        return [self.pickerArr count];
    }
    
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 1) {
        return [[self.pickerSubArr objectAtIndex:row]objectForKey:@"name"];
    }else{
        return [[self.pickerArr objectAtIndex:row]objectForKey:@"name"];
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
@end
