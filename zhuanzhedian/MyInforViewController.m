//
//  MyInforViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/22.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "MyInforViewController.h"
#import "CreateNewJobTableViewCell.h"
#import "UIColor+AddColor.h"
#import "HeaderImageTableViewCell.h"
#import "JobNameViewController.h"
#import "PriceRangeViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "JobRequireViewController.h"
#import "MD5NSString.h"
#import "JobTagViewController.h"
#import "ZZDLoginViewController.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"
#import "ZZDAlertView.h"
#import "GaoDeMapViewController.h"
#import "FontTool.h"
@interface MyInforViewController ()<UITableViewDataSource,UITableViewDelegate,PriceRangeViewControllerDelegate,JobNameDelegate,JobRequireDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JobTagDelegate,GaoDeMapVCDelegate,CreateNewJobDelegate>
@property (nonatomic, strong)UITableView *myInforTable;
@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, strong)NSMutableDictionary *mainDic;

@property (nonatomic, strong)UIImage *photoImage;

//alert
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *styleSelectView;
@property (nonatomic, strong)UIView *currentView;

@property (nonatomic, strong)UIButton *createButton;
@end

@implementation MyInforViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mainDic = [NSMutableDictionary dictionary];
    }
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"MyInforView"];
    [self.myInforTable reloadData];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
}
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AVAnalytics endLogPageView:@"MyInforView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    if ([[[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]objectForKey:@"is_fill_boss"]isEqualToString:@"0"]) {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }else{
        
    }
    self.navigationController.navigationBar.barTintColor = [UIColor zzdColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"个人信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = 1;
    titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    self.navigationItem.titleView = titleLabel;
    
    [self getLocalUserData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    
    
    [self createBottomButton];
    [self createAlertView];
    [self startConnection];
    [self updateUserInfor];
    
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.myInforTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - height);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.myInforTable.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)updateUserInfor
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/user/%@",[self.mainDic objectForKey:@"uid"]];
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[self.mainDic objectForKey:@"token"],time];
        [self.mainDic setObject:time forKey:@"timestamp"];
        [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        
        

      
        [manager GET:url parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"msg"]isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"data"] forKey:@"user"];
                [self.mainDic setValuesForKeysWithDictionary:[responseObject objectForKey:@"data"]];
                [self.myInforTable reloadData];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
          
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}
- (void)goToLastPage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有保存?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self save:nil];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
- (void)getLocalUserData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [self.mainDic addEntriesFromDictionary: [user objectForKey:@"user"]];
    
    
    
}
- (void)createBottomButton
{
    self.createButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height  - 64 + 2.5, self.view.frame.size.width - 30, 49 - 15)];
        self.createButton.backgroundColor = [UIColor colorFromHexCode:@"38ab99"];
    
  
    [self.createButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.createButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    
    
        
//    self.createButton.layer.shadowOffset = CGSizeMake(-1, 1);
//    self.createButton.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.createButton.layer.shadowOpacity = 0.8;
    [self.myInforTable addSubview:self.createButton];
}
#warning 需要加判断
//avatar
//name
//title
//cp_sub_name
//cp_size
//cp_name
//cp_address
//cp_intr
//tag_boss
- (void)save:(id)sender
{
        if ([[self.mainDic objectForKey:@"avatar"] isEqualToString:@""] || [[self.mainDic objectForKey:@"name"] isEqualToString:@""] || [[self.mainDic objectForKey:@"title"] isEqualToString:@""] || [[self.mainDic objectForKey:@"cp_sub_name"] isEqualToString:@""] || [[self.mainDic objectForKey:@"cp_size"] isEqualToString:@""] || [[self.mainDic objectForKey:@"cp_name"] isEqualToString:@""] || [[self.mainDic objectForKey:@"cp_address"] isEqualToString:@""] || [[self.mainDic objectForKey:@"cp_intr"] isEqualToString:@""] || [self.mainDic objectForKey:@"tag_boss"] == nil) {
        
            ZZDAlertView *alertView = [[ZZDAlertView alloc]initWithView:self.view];
            [alertView setTitle:@"转折点提示" detail:@"请完善信息后保存" alert:ZZDAlertStateNo];
            [self.view addSubview:alertView];
        return;
        
        
    }else{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://api.zzd.hidna.cn/v1/user";
    [manager GET:TIMESTAMP parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *time = [[responseObject objectForKey:@"data"]objectForKey:@"timestamp"];
        NSString *sign = [NSString stringWithFormat:@"%@||%@||%@",url,[self.mainDic objectForKey:@"token"],time];
        [self.mainDic setObject:time forKey:@"timestamp"];
        [self.mainDic setObject:[MD5NSString md5HexDigest:sign] forKey:@"sign"];
        [self.mainDic setObject:@"1" forKey:@"is_fill_boss"];
        NSArray *arr = [self.mainDic objectForKey:@"tag_boss"];
        if ([arr isKindOfClass:[NSArray class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self.mainDic setObject:jsonString forKey:@"tag_boss"];
        }else{
            [self.mainDic setObject:arr forKey:@"tag_boss"];
        }
        
        
        NSArray *arr1 = [self.mainDic objectForKey:@"tag_user"];
        if ([arr1 isKindOfClass:[NSArray class]]) {
            NSData *data1 = [NSJSONSerialization dataWithJSONObject:arr1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            [self.mainDic setObject:jsonString1 forKey:@"tag_user"];
            
        }else{
              [self.mainDic setObject:arr1 forKey:@"tag_user"];
        }
        [manager POST:@"http://api.zzd.hidna.cn/v1/user" parameters:self.mainDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSString *str = [responseObject objectForKey:@"ret"];
            if ([str isEqualToString:@"0"]) {
                NSLog(@"修改成功");
                [[NSUserDefaults standardUserDefaults] setObject:self.mainDic forKey:@"user"];
                
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


- (void)createView
{
    self.myInforTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.myInforTable.delegate = self;
    self.myInforTable.dataSource = self;
    self.myInforTable.backgroundColor = [UIColor colorFromHexCode:@"#fbfbf8"];
    [self.view addSubview:self.myInforTable];
    
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
    //    self.alertView.layer.borderWidth = 0.5;
    self.alertView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self.view addSubview:self.alertView];
    
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 150, self.view.frame.size.width - 30, 40)];
    [backButton addTarget:self action:@selector(backToWindow) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor colorFromHexCode:@"eeeeee"].CGColor;
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    [backButton setTitleColor:[UIColor colorFromHexCode:@"666666"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor whiteColor];
    [self.alertView addSubview:backButton];
    
    self.styleSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
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
        
        
        UILabel *styleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 ,25 + i * 43, self.view.frame.size.width  - 30, 40)];
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
}
- (void)currentSelect:(UITapGestureRecognizer *)sender
{
    UIImageView *currentImage = (UIImageView *)sender.view;
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
//相册点击完成后触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    self.photoImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self.myInforTable reloadData];
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
                
                [self.myInforTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
                if ([AVIMClient defaultClient]!=nil && [AVIMClient defaultClient].status == AVIMClientStatusOpened  ) {
                    [AVUser logOut];
                    [[AVIMClient defaultClient] closeWithCallback:^(BOOL succeeded, NSError *error) {
                        [self log];
                    }];
                } else
                {
                    [AVUser logOut];
                    [self log];
                }
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
      
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    //
    
    
    
}

- (void)setTitle:(NSString *)title andStr:(NSString *)str
{
    [self.mainDic setObject:str forKey:title];
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
//    [self createBottomButton];
    self.currentView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 160);
    self.backView.frame = CGRectZero;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alertView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
    }];
}
//开始网络请求
- (void)startConnection
{
    self.dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"comm"];

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 5;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.mainDic objectForKey:@"cp_intr"];
    if (indexPath.row == 0 && indexPath.section == 0) {
        static NSString *cellIdentify1 = @"cell1";
        HeaderImageTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
        if (!cell1) {
            cell1 = [[HeaderImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify1];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1 setTitleLabelText:@"头像"];
        [cell1.headerImageView sd_setImageWithURL:[self.mainDic objectForKey:@"avatar"]];
        return cell1;
        
        
    }else{
    static NSString *cellIdentify = @"cell";
    CreateNewJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CreateNewJobTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *arr = [NSArray array];
        NSInteger a = 0;
        if (indexPath.row == 3) {
            
        if ([[self.mainDic objectForKey:@"tag_boss"]isKindOfClass:[NSArray class]] || [[self.mainDic objectForKey:@"tag_boss"]isKindOfClass:[NSMutableArray class]]){
            arr = [self.mainDic objectForKey:@"tag_boss"];
            a = arr.count;
        }else{
            NSData *data = [[self.mainDic objectForKey:@"tag_boss"] dataUsingEncoding:NSUTF8StringEncoding];
            arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        }
            a = arr.count;
            
        }
        a = arr.count;
        NSLog(@"------%ld-------",arr.count);
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
              
                    break;
                    
                case 1:
                    [cell getTitleLabelText:@"姓名"];
                    cell.returnStr = @"name";
                    cell.delegate = self;
                        cell.returnField.text = [self.mainDic objectForKey:@"name"];

                    break;
                    
                case 2:
                    [cell getTitleLabelText:@"你的职位"];
                 cell.returnStr = @"title";
                    cell.delegate = self;
                        cell.returnField.text = [self.mainDic objectForKey:@"title"];

                    break;
                    
                case 3:
                    [cell getTitleLabelText:@"公司简称"];
                   cell.returnStr = @"cp_sub_name";
                    cell.delegate = self;
                        cell.returnField.text = [self.mainDic objectForKey:@"cp_sub_name"];
                    

                    break;
                case 4:
                    [cell getTitleLabelText:@"公司邮箱"];
                    cell.returnStr = @"email";
                    cell.delegate = self;
                    cell.returnField.text = [self.mainDic objectForKey:@"email"];
                    
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    [cell getTitleLabelText:@"公司规模"];
                   
                        cell.returnLabel.text = [self.mainDic objectForKey:@"cp_size"];
                    if (cell.returnLabel.text.length == 0) {
                        cell.returnLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
                        cell.returnLabel.text = @"请选择公司规模";
                    }else{
                         cell.returnLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
                    }
                    
                    break;
                    
                case 1:
                    [cell getTitleLabelText:@"公司全称"];
                    cell.returnStr = @"cp_name";
                    cell.delegate = self;
                        cell.returnField.text = [self.mainDic objectForKey:@"cp_name"];
                    
                    break;
                    
                case 2:
                    [cell getTitleLabelText:@"公司地址"];
                   
                        cell.returnLabel.text = [self.mainDic objectForKey:@"cp_address"];
                    if (cell.returnLabel.text.length == 0) {
                        cell.returnLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
                        cell.returnLabel.text = @"请选择公司地址";
                    }else{
                        cell.returnLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
                    }

                    break;
                    
                case 3:
                    [cell getTitleLabelText:@"公司行业"];
                    cell.returnLabel.text = [NSString stringWithFormat:@"%ld个标签",a];
                    NSLog(@"===%@===", [self.mainDic objectForKey:@"tag_boss"]);
                    if (a == 0) {
                        cell.returnLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
                        cell.returnLabel.text = @"请选择公司行业";
                    }else{
                        cell.returnLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
                    }
                    break;
                    
                case 4:
                                        [cell getTitleLabelText:@"公司简介"];
                    if (str.length != 0) {
                        cell.returnLabel.text = @"已填";
                         cell.returnLabel.textColor = [UIColor colorFromHexCode:@"38ab99"];
                    }else{
                        cell.returnLabel.text = @"请填写公司简介";
                        cell.returnLabel.textColor = [UIColor colorFromHexCode:@"#b0b0b0"];
                    }
                    
                    break;
                default:
                    break;
            }
            
        default:
            break;
    }
        self.myInforTable.contentSize = CGSizeMake(0, 750);
    return cell;
    }
}
- (void)doSomeThing
{
    
    
//     [self.createButton removeFromSuperview];
    self.backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
        
        self.styleSelectView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobNameViewController *jobName = [[JobNameViewController alloc]init];
    PriceRangeViewController *priceRange = [[PriceRangeViewController alloc]init];
    JobRequireViewController *jobRequire = [[JobRequireViewController alloc]init];
    JobTagViewController *jobTag = [[JobTagViewController alloc]init];
    GaoDeMapViewController *gaoDe = [[GaoDeMapViewController alloc]init];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self doSomeThing];
                    break;
                case 1:
//                    jobName.placeHolderStr = @"请填写姓名";
//                    jobName.mainTitle = @"name";
//                    jobName.delegate = self;
//                    jobName.word = @"姓名";
//                    jobName.len = 6;
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
//                    [self.navigationController pushViewController:jobName animated:YES];
                    break;
                    
                case 2:
//                    jobName.placeHolderStr = @"请填写职位";
//                    jobName.mainTitle = @"title";
//                    jobName.delegate = self;
//                    jobName.word = @"职位";
//                    jobName.len = 6;
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
//                    [self.navigationController pushViewController:jobName animated:YES];
                    break;
                    
                case 3:
//                    jobName.placeHolderStr = @"请填写公司简称";
//                    jobName.mainTitle = @"cp_sub_name";
//                    jobName.delegate = self;
//                    jobName.word = @"公司简称";
//                    jobName.len = 6;
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
//                    [self.navigationController pushViewController:jobName animated:YES];
                    break;
                case 4:
//                    jobName.placeHolderStr = @"请填写企业邮箱";
//                    jobName.mainTitle = @"email";
//                    jobName.delegate = self;
//                    jobName.word = @"企业邮箱";
//                    jobName.len = 50;
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
//                    [self.navigationController pushViewController:jobName animated:YES];
                default:
                    break;
            }
            break;
        
        case 1:
            switch (indexPath.row) {
                case 0:
                    priceRange.array = [self.dataDic objectForKey:@"cp_size"];
                    priceRange.mainTitle = @"cp_size";
                    priceRange.delegate = self;
                    priceRange.word = @"公司规模";
                    [self.navigationController pushViewController:priceRange animated:YES];
                    break;
                    
                case 1:
//                    jobName.placeHolderStr = @"请填写公司全称";
//                    jobName.mainTitle = @"cp_name";
//                    jobName.delegate = self;
//                    jobName.word = @"公司全称";
//                    jobName.len = 18;
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
//                    [self.navigationController pushViewController:jobName animated:YES];
                    break;
                    
                case 2:
//                    jobName.placeHolderStr = @"请填写公司地址";
//                    jobName.mainTitle = @"cp_address";
//                    jobName.delegate = self;
//                    jobName.word = @"公司地址";
//                    jobName.len = 50;
//                    jobName.currentStr = [self.mainDic objectForKey:jobName.mainTitle];
                    gaoDe.delegate = self;
                    [self.navigationController pushViewController:gaoDe animated:YES];
                    break;
                
                case 3:
                    jobTag.delegate = self;
                    jobTag.dic = self.mainDic;
                    [self.navigationController pushViewController: jobTag animated:YES];
                    break;
                    
                case 4:
                    
                    jobRequire.currentStr = [self.mainDic objectForKey:@"cp_intr"];
                    jobRequire.delegate  = self;
                    jobRequire.word = @"公司简介";
                    [self.navigationController pushViewController:jobRequire animated:YES];
                    
                    
                    
                    
                default:
                break;
            }
            break;
        default:
            break;
    }
}
- (void)scanSuccess
{
    [self save:nil];
}
- (void)getChangedText:(NSString *)str
{
    [self.mainDic setObject:str forKey:@"cp_intr"];
}
- (void)getMyValue:(NSDictionary *)dic
{
    [self.mainDic setValuesForKeysWithDictionary:dic];
    
}
- (void)getNameTextDic:(NSDictionary *)dic
{
    
    [self.mainDic setValuesForKeysWithDictionary:dic ];
    
    
    
}
- (void)setBossTagArr:(NSMutableArray *)arr
{
    
    [self.mainDic setObject:arr forKey:@"tag_boss"];
    [self.myInforTable reloadData];
}
- (void)getPlaceStr:(NSString *)placeStr WithLat:(CGFloat)lat lon:(CGFloat)lon
{

    [self.mainDic setObject:placeStr forKey:@"cp_address"];
    [self.mainDic setObject:[NSNumber numberWithDouble:lat] forKey:@"cp_lat"];
    [self.mainDic setObject:[NSNumber numberWithDouble:lon] forKey:@"cp_lon"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70.5;
    }else{
        return 48;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
