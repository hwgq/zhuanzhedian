//
//  ZZDWriteInforView.m
//  NewModelZZD
//
//  Created by Gaara on 16/6/22.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ZZDWriteInforView.h"
#import "AppDelegate.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface ZZDWriteInforView ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign)BOOL editable;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UITextField *writeField;
@property (nonatomic, strong)UIImageView *titleImage;
@property (nonatomic, strong)NSString *imageName;
@property (nonatomic, strong)NSString *key;
@property (nonatomic, strong)UILabel *btnLabel;
@property (nonatomic, strong)NSArray *pickerArr;
@property (nonatomic, strong)NSArray *pickerSubArr;
@property (nonatomic, strong)UIPickerView *picker;
@property (nonatomic, strong)UIView *pickerView;
@property (nonatomic, strong)UIView *pickerBackView;
@property (nonatomic, strong)NSString *currentValue;
@property (nonatomic, strong)NSString *currentId;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *cityId;
@property (nonatomic, strong)NSString *provinceId;

@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *styleSelectView;
@end
@implementation ZZDWriteInforView
- (instancetype)initWithFrame:(CGRect)frame editable:(BOOL)editable title:(NSString *)title imageName:(NSString *)name key:(NSString *)key
{
    self = [super initWithFrame:frame];
    if (self) {
        self.key = key;
        self.title = title;
        self.editable = editable;
        self.imageName = name;
        [self createViews];
    }
    return self;
}
- (void)selectAction:(UITapGestureRecognizer *)tap
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window endEditing:YES];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];
    if ([self.key isEqualToString:@"sex"]) {
        self.pickerArr = @[@{@"name":@"男"},@{@"name":@"女"}];
        self.currentValue = @"男";
        [self createPicker];
    }else if([self.key isEqualToString:@"hightest_edu"]){
        self.pickerArr = [dic objectForKey:@"education"];
        self.currentValue = @"大专";
        self.currentId = @"1";
        [self createPicker];
    }else if([self.key isEqualToString:@"work_state"]){
        self.pickerArr = @[@{@"name":@"在职-寻找机会",@"id":@"0"},@{@"name":@"离职-随时上岗",@"id":@"1"},@{@"name":@"应届毕业生",@"id":@"2"}];
        self.currentValue = @"在职-寻找机会";
        self.currentId = @"0";
        [self createPicker];
    }else if([self.key isEqualToString:@"work_year"]){
        self.pickerArr = [dic objectForKey:@"work_year"];
        self.currentValue = @"应届生";
        self.currentId = @"1";
        [self createPicker];
    }else if ([self.key isEqualToString:@"sub_category"]){
        [self.delegate jumpToTagVC];
    }else if ([self.key isEqualToString:@"salary"]){
        self.pickerArr = [dic objectForKey:@"salary"];
        self.currentValue = @"3k以下";
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
    }else if ([self.key isEqualToString:@"title"])
    {
         [self.delegate jumpToCategory];
    }else if ([self.key isEqualToString:@"cp_size"])
    {
        self.pickerArr = [dic objectForKey:@"cp_size"];
        self.currentValue = @"0-19人";
        self.currentId = @"1";
        [self createPicker];
    }else if ([self.key isEqualToString:@"tag_boss"])
    {
        [self.delegate jumpToTagVC];
    }else if ([self.key isEqualToString:@"cp_address"])
    {
        [self.delegate jumpToGaoDeView];
    }
    
    
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
    }else if([self.key isEqualToString:@"sex"]){
        self.currentValue = [[self.pickerArr objectAtIndex:row]objectForKey:@"name"];
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
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumScaleFactor = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[[FontTool customFontArrayWithSize:18]objectAtIndex:1]];
        pickerLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
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
- (void)createPicker
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
        [self.delegate inforValueChange:self.provinceId key:@"province_id"];
        [self.delegate inforValueChange:self.province key:@"province"];
        [self.delegate inforValueChange:self.cityId key:@"city_id"];
        [self.delegate inforValueChange:self.city key:@"city"];
        self.btnLabel.text = self.city;
    }else if([self.key isEqualToString:@"sex"]){
        [self.delegate inforValueChange:self.currentValue key:self.key];
        self.btnLabel.text = self.currentValue;
        
    }else if ([self.key isEqualToString:@"work_state"])
    {
        [self.delegate inforValueChange:self.currentId key:self.key];
        self.btnLabel.text = self.currentValue;
    }else{
        NSString *idStr = [NSString stringWithFormat:@"%@_id",self.key];
     [self.delegate inforValueChange:self.currentValue key:self.key];
        [self.delegate inforValueChange:self.currentId key:idStr];
        self.btnLabel.text = self.currentValue;
    }
    self.btnLabel.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
}
- (void)backToWindow1
{
    
   AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.backView.frame = CGRectZero;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alertView.frame =CGRectMake(0, app.window.frame.size.height, app.window.frame.size.width, 0);
    }];
}
- (void)backToMain
{
    [self backToWindow1];
}
- (void)headerTap:(UITapGestureRecognizer *)tap
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMain)];
    [self.backView addGestureRecognizer:backTap];
    [app.window addSubview:self.backView];
    
    
    
    self.alertView = [[UIView alloc]initWithFrame:CGRectMake(0, app.window.frame.size.height, app.window.frame.size.width, 0)];
    //    self.alertView.layer.borderWidth = 0.5;
    self.alertView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [app.window addSubview:self.alertView];
    
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 150, app.window.frame.size.width - 30, 40)];
    [backButton addTarget:self action:@selector(backToWindow1) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor colorFromHexCode:@"eeeeee"].CGColor;
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [backButton setTitleColor:[UIColor colorFromHexCode:@"666666"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor whiteColor];
    [self.alertView addSubview:backButton];
    
    self.styleSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, 0)];
    //    self.styleSelectView.backgroundColor = [UIColor clearColor];
    [self.alertView addSubview:self.styleSelectView];
    //标题名的数组
    NSArray *titleArr = @[@"拍摄照片",@"相册照片"];
    for (int i = 0; i < 2; i++) {
        //        UIImageView *styleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 5 * (2 * i + 1) , 30, self.view.frame.size.width / 5, self.view.frame.size.width / 5)];
        //        styleImage.tag = i + 1;
        //        styleImage.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectStyle:)];
        //        [styleImage addGestureRecognizer:tapImage];
        //        styleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico-%d.png",19 + i]];
        //        //        styleImage.backgroundColor = [UIColor blackColor];
        //        [self.styleSelectView addSubview:styleImage];
        
        
        UILabel *styleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 ,25 + i * 43, app.window.frame.size.width  - 30, 40)];
        styleNameLabel.text = [titleArr objectAtIndex:i];
        styleNameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        styleNameLabel.tag = i + 1;
        styleNameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectStyle:)];
        [styleNameLabel addGestureRecognizer:tapImage];
        styleNameLabel.textAlignment = 1;
        styleNameLabel.backgroundColor = [UIColor whiteColor];
        styleNameLabel.textColor = [UIColor colorFromHexCode:@"666666"];
        styleNameLabel.layer.borderColor = [UIColor colorFromHexCode:@"eeeeee"].CGColor;
        styleNameLabel.layer.borderWidth = 1;
        [self.styleSelectView addSubview:styleNameLabel];
    }
    self.backView.frame = CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height);
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, app.window.frame.size.height - 200, app.window.frame.size.width, 200);
        
        self.styleSelectView.frame = CGRectMake(0, 0, app.window.frame.size.width, 160);
    }];
    
    
}
- (void)tapSelectStyle:(UITapGestureRecognizer *)tap
{
    [self backToWindow1];
    [self.delegate selectAvatar:tap.view.tag];
}
- (void)createViews
{
    
//    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 30, 30)];
////    self.titleImage.backgroundColor = [UIColor orangeColor];
//    self.titleImage.image = [UIImage imageNamed:self.imageName];
//    [self addSubview:self.titleImage];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, 90, 30)];
    self.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.titleLabel.textColor = [UIColor colorFromHexCode:@"#2b2b2b"];
    self.titleLabel.text = self.title;
//    self.titleLabel.backgroundColor = [UIColor redColor];
    
    
    [self addSubview:self.titleLabel];
    if ([self.key isEqualToString:@"avatar"]) {
        self.titleLabel.frame = CGRectMake(25, 25, 90, 30);
        UIImageView *avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 80, 10, 60, 60)];
        avatarImg.layer.cornerRadius = 30;
        avatarImg.tag = 55;
        avatarImg.layer.masksToBounds = YES;
        avatarImg.userInteractionEnabled = YES;
        avatarImg.image = [UIImage imageNamed:@"v1.png"];
        [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)]];
        avatarImg.backgroundColor = [UIColor redColor];
        [self addSubview:avatarImg];
    }else
    if ( [self.key isEqualToString:@"name"]||[self.key isEqualToString:@"email"]||[self.key isEqualToString:@"titleB"]||[self.key isEqualToString:@"cp_name"]||[self.key isEqualToString:@"cp_sub_name"] ) {
        
        self.writeField = [[UITextField alloc]initWithFrame:CGRectMake(170, 25, [UIScreen mainScreen].bounds.size.width - 195, 30)];
        self.writeField.textAlignment = 2;
        self.writeField.placeholder = @"请填写";
        self.writeField.delegate = self;
         [self.writeField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        if ([self.key isEqualToString:@"mobilePhoneNumber"]) {
            self.writeField.keyboardType = UIKeyboardTypeNumberPad;
        }
        self.writeField.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
        self.writeField.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        //    self.writeField.backgroundColor = [UIColor greenColor];
        [self.writeField setValue:[UIColor colorFromHexCode:@"b0b0b0"] forKeyPath:@"_placeholderLabel.textColor"];
        [self.writeField setValue:[[FontTool customFontArrayWithSize:16]objectAtIndex:1]
 forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:self.writeField];
        
    }else if([self.key isEqualToString:@"mobilePhoneNumber"]){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(170, 25, [UIScreen mainScreen].bounds.size.width - 195, 30)];
        label.textAlignment = 2;
        label.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
        label.text = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"mobile"];
        label.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        [self addSubview:label];
        
    }else{
    
        self.btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 25, [UIScreen mainScreen].bounds.size.width - 195, 30)];
        self.btnLabel.textAlignment = 2;
        self.btnLabel.text = @"请选择";
        
        if ([self.key isEqualToString:@"title"]) {
            self.btnLabel.tag = 115;
            self.btnLabel.text = @"请选择(系统据此为你推荐职位)";
        }else if ([self.key isEqualToString:@"sub_category"] || [self.key isEqualToString:@"tag_boss"])
        {
            self.btnLabel.tag = 102;
        }else if ([self.key isEqualToString:@"cp_address"])
        {
            self.btnLabel.tag = 103;
        }else if ([self.key isEqualToString:@"city"])
        {
            self.btnLabel.text = @"请选择(系统据此为你推荐职位)";
        }
        self.btnLabel.userInteractionEnabled = YES;
        [self.btnLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAction:)]];
        self.btnLabel.textColor = [UIColor colorFromHexCode:@"b0b0b0"];
        self.btnLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
        [self addSubview:self.btnLabel];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(25, self.frame.size.height - 1, self.frame.size.width - 50, 1)];
    lineView.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
    [self addSubview:lineView];
    if ([self.key isEqualToString:@"avatar"]) {
        
    }

    
}
- (void)textFieldChanged:(NSNotification *)noti
{

}

-(void)valueChanged:(UITextField *)textField
{
  [self.delegate inforValueChange:textField.text key:self.key];
}
@end
