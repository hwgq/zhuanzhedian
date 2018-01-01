//
//  WorkUserInforViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/27.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "WorkUserInforViewController.h"
#import "HeaderImageTableViewCell.h"
#import "CreateNewJobTableViewCell.h"
#import "JobNameViewController.h"
#import "PriceRangeViewController.h"
#import "AFNetworking.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
#import "MD5NSString.h"
#import "InternetRequest.pch"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import <UMMobClick/MobClick.h>
@interface WorkUserInforViewController ()<UITableViewDelegate,UITableViewDataSource,JobNameDelegate,PriceRangeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)UITableView *userInforTable;
@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, strong)UIImage *photoImage;

//alert
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *styleSelectView;
@property (nonatomic, strong)UIView *currentView;

@property (nonatomic, strong)UIButton *createButton;
@end

@implementation WorkUserInforViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainDic = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"WorkUserInforView"];
    [AVAnalytics endLogPageView:@"WorkUserInforView"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"WorkUserInforView"];
    [AVAnalytics beginLogPageView:@"WorkUserInforView"];
    [self.userInforTable reloadData];
}
- (void)firstTap:(UITapGestureRecognizer *)tap
{
//    UIAlertView * titleAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善信息后离开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [titleAlert show];
    ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
    [alertView setTitle:@"转折点提示" detail:@"请完善信息后离开" alert:ZZDAlertStateNo];
    [self.view addSubview:alertView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_user"]isEqualToString:@"0"]) {
        //        self.navigationController.tabBarController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }else{
        
    }
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"个人信息";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = 1;
    self.navigationItem.titleView = titleLabel;
    
    [self getLocalUserData];
    [self createUserInforTable];
    [self createAlertView];
    [self createBottomButton];
    
    
    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    imageBack.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    if ([self.isFirst isEqualToString:@"YES"]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstTap:)];
        [imageBack addGestureRecognizer:tap];
    }else{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [imageBack addGestureRecognizer:tap];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageBack];
    
    
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getLocalUserData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [self.mainDic addEntriesFromDictionary: [user objectForKey:@"user"]];
    
    
    
}
- (void)createBottomButton
{
    self.createButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 36, self.view.frame.size.width, 36)];
    self.createButton.backgroundColor = [UIColor whiteColor];
    
    self.createButton.layer.borderColor = [UIColor colorFromHexCode:@"#cecece"].CGColor;
    self.createButton.layer.borderWidth = 1;
    [self.createButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.createButton setTitleColor:[UIColor zzdColor] forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.createButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.createButton];
}
- (void)save:(id)sender
{
   
    if (([[self.mainDic objectForKey:@"name"] isEqualToString:@""]) || ([[self.mainDic objectForKey:@"sex"] isEqualToString:@""])) {
        
        ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
        [alertView setTitle:@"转折点提示" detail:@"请完善信息后保存" alert:ZZDAlertStateNo];
        [self.view addSubview:alertView];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://api.zzd.hidna.cn/v1/user";
    [manager GET:TIMESTAMP parameters:nil success:^ (AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[self.mainDic objectForKey:@"token"],time];
        [self.mainDic setObject:time forKey:@"timestamp"];
        [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [self.mainDic setObject:@"1" forKey:@"is_fill_user"];
        
  
        if ([[self.mainDic objectForKey:@"tag_user"]isKindOfClass:[NSArray class]]){
           
            NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_user"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            [self.mainDic setObject:jsonString1 forKey:@"tag_user"];
        }else{
            
           
            
        }

       
       
        if ([[self.mainDic objectForKey:@"tag_boss"]isKindOfClass:[NSArray class]]){
            
            NSData *data1 = [NSJSONSerialization dataWithJSONObject:[self.mainDic objectForKey:@"tag_boss"] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            [self.mainDic setObject:jsonString1 forKey:@"tag_boss"];
        }else{
           
            
        }
        
        [manager POST:url parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSString *str = [responseObject objectForKey:@"ret"];
            if ([str isEqualToString:@"0"]) {
                NSLog(@"修改成功");
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:(NSDictionary *)self.mainDic forKey:@"user"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                if ([AVUser currentUser].objectId != nil) {
                AVIMClient * client = [AVIMClient defaultClient];
                [client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
                    
                }];
                if (client!=nil && client.status == AVIMClientStatusOpened) {
                    
                    [AVUser logOut];
                    [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                } else {
                    [AVUser logOut];
                    [client closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                }
                }else{
                    [AVUser logOut];
                    [self log];
                }
                           }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
-(void)log
{
    [AVUser logOut];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
    ZZDLoginViewController *login = [[ZZDLoginViewController alloc]init];
    
    UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:login];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = navLogin;
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (app.alert == nil) {
//        app.alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您的账号在另外一台设备上登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [app.alert show];
        app.alert = [[ZZDAlertView alloc]initWithView:app.window];
        [app.alert setTitle:@"转折点提示" detail:@"您的账号在另外一台设备上登录" alert:ZZDAlertStateNormal];
        [app.window addSubview:app.alert];
    }
    
}


- (void)createAlertView
{
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToMain)];
    [self.backView addGestureRecognizer:backTap];
    [self.view addSubview:self.backView];
    
    
    
    self.alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
    self.alertView.layer.borderWidth = 0.5;
    self.alertView.layer.borderColor = [UIColor grayColor].CGColor;
    self.alertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.alertView];
    
 
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 40)];
    [backButton addTarget:self action:@selector(backToWindow) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.borderWidth = 0.5;
    backButton.layer.borderColor = [UIColor grayColor].CGColor;
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.alertView addSubview:backButton];
    
    self.styleSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    //    self.styleSelectView.backgroundColor = [UIColor clearColor];
    [self.alertView addSubview:self.styleSelectView];
   //标题名的数组
    NSArray *titleArr = @[@"拍摄照片",@"相册照片",@"默认头像"];
    for (int i = 0; i < 3; i++) {
        UIImageView *styleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 7 * (2 * i + 1) - 5, (160 - self.view.frame.size.width / 7) / 2  - 20, self.view.frame.size.width / 7 + 10, self.view.frame.size.width / 7 + 10)];
        styleImage.tag = i + 1;
        styleImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectStyle:)];
        [styleImage addGestureRecognizer:tapImage];
        styleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico-%d.png",19 + i]];
//        styleImage.backgroundColor = [UIColor blackColor];
        [self.styleSelectView addSubview:styleImage];
        
        
        UILabel *styleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 7 * (2 * i + 1) - 5, (160 - self.view.frame.size.width / 7) / 2 + 55, self.view.frame.size.width / 7 + 10, 20)];
        styleNameLabel.text = [titleArr objectAtIndex:i];
        styleNameLabel.textColor = [UIColor grayColor];
        styleNameLabel.font = [UIFont boldSystemFontOfSize:13];
        styleNameLabel.textAlignment = 1;
//        styleNameLabel.backgroundColor = [UIColor redColor];
        [self.styleSelectView addSubview:styleNameLabel];
    }

   
    self.currentView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 160)];
    self.currentView.backgroundColor = [UIColor whiteColor];
    [self.alertView addSubview:self.currentView];
    
    double width = (self.view.frame.size.width - 200) / 3.0;

    for (int i = 0; i < 6; i++) {
        UIImageView *currentImage = [[UIImageView alloc]initWithFrame:CGRectMake(i % 3 * (width + 30) + 70, i / 3 * (width  + 10) + (160 - width * 2 - 10) / 2, width, width)];
        
        currentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%d.png",i + 1]];
        currentImage.tag = 100 + i;
        currentImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *currentSelect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(currentSelect:)];
        [currentImage addGestureRecognizer:currentSelect];
//        currentImage.backgroundColor = [UIColor redColor];
        [self.currentView addSubview:currentImage];
    }
    
}

- (void)currentSelect:(UITapGestureRecognizer *)sender
{
    UIImageView *currentImage = (UIImageView *)sender.view;
  
    
//    [self.mainDic setObject:currentImage.image forKey:@"头像"];
    [self uploadHeaderImage:currentImage.image];
    
   
    
    [self backToWindow];
}
- (void)tapSelectStyle:(UITapGestureRecognizer *)sender
{
    
    UIImageView *image = (UIImageView *)sender.view;

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];

    switch (image.tag) {
        case 1:
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 2:
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];//进入相册
            break;
            
        case 3:
            [self showCurrentImageView];
            
            break;
        default:
            break;
    }
}
- (void)showCurrentImageView
{
    [self.createButton removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        self.currentView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    }];
}
- (void)backToMain
{
    [self backToWindow];
}
- (void)backToWindow
{
    [self createBottomButton];
    self.currentView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 160);
    self.backView.frame = CGRectZero;
    [UIView animateWithDuration:0.5 animations:^{
        
    self.alertView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
    }];
}

- (void)createUserInforTable
{
    self.userInforTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.userInforTable.delegate = self;
    self.userInforTable.dataSource = self;
    self.userInforTable.sectionHeaderHeight = 0;
    self.userInforTable.sectionFooterHeight = 20;
    [self.view addSubview:self.userInforTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70.5;
    }else{
        return 48;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    
    static NSString *cellIdentify = @"cell";
    HeaderImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[HeaderImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleLabelText:@"头像"];
        [cell.headerImageView sd_setImageWithURL:[self.mainDic objectForKey:@"avatar"]];
     
    return cell;
    }else{
        
        static NSString *cellIdentify1 = @"cell1";
        CreateNewJobTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
        if (!cell1) {
            cell1 = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify1];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 1:
                [cell1 getTitleLabelText:@"姓名"];
                
                cell1.returnLabel.text = [self.mainDic objectForKey:@"name"];
                break;
                
          case 2:
                [cell1 getTitleLabelText:@"性别"];
                cell1.returnLabel.text = [self.mainDic objectForKey:@"sex"];
            default:
                break;
        }
        return cell1;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobNameViewController *jobName = [[JobNameViewController alloc]init];
    PriceRangeViewController *priceRange = [[PriceRangeViewController alloc]init];
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"男" forKey:@"name"];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObject:@"女" forKey:@"name"];
    [arr addObject:dic];
    [arr addObject:dic1];
        switch (indexPath.row) {
        case 0:
            

            [self doSomeThing];
           
            break;
            
        case 1:
         //姓名
      
            jobName.placeHolderStr = @"请输入姓名";
            jobName.mainTitle = @"name";
            jobName.delegate = self;
            jobName.len = 6;
            jobName.word = @"姓名";
            jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
            [self.navigationController pushViewController:jobName animated:YES];
            break;
            
        case 2:
        //性别
            priceRange.mainTitle = @"sex";
            priceRange.delegate = self;
            priceRange.array = arr;
            priceRange.word = @"性别";
            [self.navigationController pushViewController:priceRange animated:YES];
            break;
        default:
            break;
    }
}
- (void)doSomeThing
{
    
    
    [self.createButton removeFromSuperview];
    self.backView.frame = self.view.frame;
    
   
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
        
        self.styleSelectView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    }];
}

- (void)getNameTextDic:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}

- (void)getMyValue:(NSDictionary *)dic
{
    [self.mainDic addEntriesFromDictionary:dic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//相册点击完成后触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    self.photoImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self.userInforTable reloadData];
    [self uploadHeaderImage:self.photoImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self backToWindow];
}
//图片上传
- (void)uploadHeaderImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    // 绘制改变大小的图片
[image drawInRect:CGRectMake(0, 0, 200, 200)];
// 从当前context中创建一个改变大小后的图片
UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
   // 使当前的context出堆栈

    UIGraphicsEndImageContext();
    
    
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSString *imagePath = [NSString stringWithFormat:@"%@/image.png",documentPath];
[[NSFileManager defaultManager]createFileAtPath:imagePath contents:imageData attributes:nil];
    
    
    NSString *url = @"http://api.zzd.hidna.cn/v1/image/upload";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
   //测试字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[userDic objectForKey:@"uid"] forKey:@"uid"];
    
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[userDic objectForKey:@"token"],time];
        [dic setObject:time forKey:@"timestamp"];
        [dic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            //         上传filename
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //         设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSURL *url = [NSURL fileURLWithPath:imagePath isDirectory:YES];
            [formData appendPartWithFileURL:url name:@"body" fileName:fileName mimeType:@"image/png" error:nil];
            
            
   
            
            
            
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
                NSString *url = [[responseObject objectForKey:@"data"]objectForKey:@"url"];
    
                [self.mainDic setObject:url forKey:@"avatar"];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                
                [self.userInforTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                
                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
                    [AVUser logOut];
                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                }else
                {
                    [AVUser logOut];
                    [self log];
                }
                
                                            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}





@end
