//
//  FirstBossRegistGuideViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 2017/9/30.
//  Copyright © 2017年 Gaara. All rights reserved.
//

#import "FirstBossRegistGuideViewController.h"
#import "FontTool.h"
#import "ZZDRegistGuideView.h"
#import "JobTagViewController.h"
#import "UIColor+AddColor.h"
#import "GaoDeMapViewController.h"
#import "AFNetworking.h"
#import "InternetRequest.pch"
#import "MD5NSString.h"
#import "BossSummaryFirstView.h"
@interface FirstBossRegistGuideViewController ()<UIScrollViewDelegate,ZZDRegistGuideViewDelegate,GaoDeMapVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,BossSummaryFirstDelegate>
@property (nonatomic, strong)UIScrollView *mainScroll;
@property (nonatomic, strong)NSMutableDictionary *mainDic;
@property (nonatomic, strong)ZZDRegistGuideView *guideTwo;
@property (nonatomic, strong)UIImage *photoImage;
@property (nonatomic, strong)ZZDRegistGuideView *guideOne;
@property (nonatomic, strong)BossSummaryFirstView *selfView;
@end

@implementation FirstBossRegistGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainDic = [NSMutableDictionary dictionary];
    [self createSubViews];
}
- (void)createSubViews
{
    UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    navLabel.textColor = [UIColor lightGrayColor];
    navLabel.text = @"下一步";
    navLabel.textAlignment = 2;
    navLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    navLabel.userInteractionEnabled = YES;
    [navLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextAction:)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLabel];
    
    
    UILabel *navLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    navLabel1.textColor = [UIColor lightGrayColor];
    navLabel1.text = @"上一步";
    navLabel1.textAlignment = 2;
    navLabel1.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    navLabel1.userInteractionEnabled = YES;
    [navLabel1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lastAction:)]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLabel1];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 400)];
    [self.view addSubview:self.mainScroll];
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width * 6, 0);
    self.mainScroll.userInteractionEnabled = YES;
//    [self.mainScroll addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)]];
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.delegate = self;
    self.mainScroll.scrollEnabled = NO;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    
    self.guideOne = [[ZZDRegistGuideView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,350) titleImgArr:@[@"",@"",@"",@""] titleArr:@[@"头像",@"姓名",@"我的职位",@"公司邮箱"] rowHeight:60 imgName:@"\"对你的初步了解\""keys:@[@"avatar",@"name",@"titleB",@"email"]];
    self.guideOne.delegate = self;
    [self.mainScroll addSubview:self.guideOne];
    
    self.guideTwo = [[ZZDRegistGuideView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,380) titleImgArr:@[@"",@"",@"",@"",@""] titleArr:@[@"公司全称",@"公司简称",@"公司行业",@"公司规模",@"公司地址"] rowHeight:60 imgName:@"\"公司目前的情况\""keys:@[@"cp_name",@"cp_sub_name",@"tag_boss",@"cp_size",@"cp_address"]];
    self.guideTwo.delegate = self;
    [self.mainScroll addSubview:self.guideTwo];
    
    self.selfView = [[BossSummaryFirstView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, 350)];
    self.selfView.delegate = self;
    [self.mainScroll addSubview:self.selfView];
    
    
    
}
- (void)textDidChange:(NSString *)str
{
    if (str != nil) {
        
        
        [self.mainDic setObject:str forKey:@"cp_intr"];
        
    }
}
- (void)setAvatarWithTag:(NSInteger)tag
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];

    switch (tag) {
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
            
       
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    self.photoImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImageView *avatarImg = [self.guideOne viewWithTag:55];
//    [self.myInforTable reloadData];
    avatarImg.image = self.photoImage;
    [self uploadHeaderImage:self.photoImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
   
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
                
                
            }else if([[responseObject objectForKey:@"msg"] isEqualToString:@"Sign Error"])
            {
               
                
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    //
    
    
    
}

- (void)nextAction:(id)sender
{
    self.mainScroll.contentOffset = CGPointMake(self.mainScroll.contentOffset.x + self.view.frame.size.width, 0);
    
}
- (void)lastAction:(id)sender
{
    self.mainScroll.contentOffset = CGPointMake(self.mainScroll.contentOffset.x - self.view.frame.size.width, 0);
}
- (void)valueChangeWith:(NSString *)value key:(NSString *)key
{
    
}
- (void)jumpToCategory
{
    
}
- (void)jumpToTagVC
{
    JobTagViewController *jobTagVC = [[JobTagViewController alloc]init];
    jobTagVC.dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"rs"];
    jobTagVC.delegate = self;
    [self.navigationController pushViewController:jobTagVC animated:YES];
}
- (void)jumpToGaoDeView
{
    GaoDeMapViewController *gaoDe = [[GaoDeMapViewController alloc]init];
    gaoDe.delegate = self;
    [self.navigationController pushViewController:gaoDe animated:YES];
}
- (void)getPlaceStr:(NSString *)placeStr WithLat:(CGFloat)lat lon:(CGFloat)lon
{
    [self.mainDic setObject:placeStr forKey:@"cp_address"];
    [self.mainDic setObject:[NSNumber numberWithDouble:lat] forKey:@"cp_lat"];
    [self.mainDic setObject:[NSNumber numberWithDouble:lon] forKey:@"cp_lon"];
    UILabel *label = [self.guideTwo viewWithTag:103];
    label.text = @"已选择";
    label.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
}
- (void)setBossTagArr:(NSMutableArray *)arr
{
    if (arr.count > 0) {
        [self.mainDic setObject:arr forKey:@"tag_boss"];
        UILabel *label = [self.guideTwo viewWithTag:102];
        label.text = @"已选择";
        label.textColor = [UIColor colorFromHexCode:@"2b2b2b"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
