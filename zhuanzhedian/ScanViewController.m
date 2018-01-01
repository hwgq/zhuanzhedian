//
//  ScanViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/12/27.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "ScanViewController.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "FontTool.h"
#import "UIColor+AddColor.h"
#import <UMMobClick/MobClick.h>
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif
static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";


@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) UIView *sanFrameView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIButton *lightButton;
@property (nonatomic, strong) NSTimer *timer;
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (assign,nonatomic) BOOL lastResut;
@property (nonatomic, strong)UIView *scanLine;
@property (nonatomic, assign)CGFloat scanY;
@property (nonatomic, assign)BOOL hasScaned;
@end

@implementation ScanViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"ScanVC"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"ScanVC"];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.hasScaned = NO;
    self.sanFrameView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.sanFrameView];
    [self startReading];
    
    
    
    
    CGRect rect = self.view.bounds;
    
    CGRect holeRection = CGRectMake(60, (self.view.frame.size.height - self.view.frame.size.width + 120) / 2, self.view.frame.size.width - 120, self.view.frame.size.width - 120);
    
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:holeRection cornerRadius:0];
    
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    [self.view.layer addSublayer:fillLayer];
    
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 20, 20)];
    backImage.image= [UIImage imageNamed:@"deletePage.png"];
    backImage.userInteractionEnabled = YES;
    [backImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTo)]];
    [self.sanFrameView addSubview:backImage];
    
    self.scanLine = [[UIView alloc]initWithFrame:CGRectMake(60, (self.view.frame.size.height - self.view.frame.size.width + 120) / 2, self.view.frame.size.width - 120, 1)];
    self.scanLine.backgroundColor = [UIColor redColor];
    [self.sanFrameView addSubview:self.scanLine];
    self.scanY = (self.view.frame.size.height - self.view.frame.size.width + 120) / 2;
    
    
    UILabel *alertLabelFirst = [[UILabel alloc]initWithFrame:CGRectMake(40, (self.view.frame.size.height - self.view.frame.size.width + 120) / 2 - 90, self.view.frame.size.width - 80, 20)];
    alertLabelFirst.text = @"在电脑浏览器打开";
    alertLabelFirst.textColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    alertLabelFirst.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    alertLabelFirst.textAlignment = 1;
    [self.view addSubview:alertLabelFirst];
    
    UILabel *alertLabelSecond = [[UILabel alloc]initWithFrame:CGRectMake(40, (self.view.frame.size.height - self.view.frame.size.width + 120) / 2 - 70, self.view.frame.size.width - 80, 30)];
    alertLabelSecond.text = @"www.izhuanzhe.com/a";
    alertLabelSecond.textColor = [[UIColor colorFromHexCode:@"#38ab99"]colorWithAlphaComponent:1];
    alertLabelSecond.textAlignment = 1;
    alertLabelSecond.font = [[FontTool customFontArrayWithSize:18]objectAtIndex:1];
    [self.view addSubview:alertLabelSecond];
    
    UILabel *alertLabelThird = [[UILabel alloc]initWithFrame:CGRectMake(40, (self.view.frame.size.height - self.view.frame.size.width + 120) / 2 - 40, self.view.frame.size.width - 80, 20)];
    alertLabelThird.text = @"并扫描页面中的二维码登录网页版操作";
    alertLabelThird.textColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    alertLabelThird.textAlignment = 1;
    alertLabelThird.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    [self.view addSubview:alertLabelThird];
    
    UIImageView *scanImg = [[UIImageView alloc]initWithFrame:CGRectMake(40, (self.view.frame.size.height - self.view.frame.size.width + 84) / 2, self.view.frame.size.width - 84, self.view.frame.size.width - 84)];
    scanImg.image = [UIImage imageNamed:@"scan2.png"];
    [self.view addSubview:scanImg];
    
    
    
    
   self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanAction:) userInfo:nil repeats:YES];
    
}
- (void)scanAction:(NSTimer *)timer
{
    self.scanY = self.scanY + 1.0;
    self.scanLine.frame = CGRectMake(60, self.scanY, self.view.frame.size.width - 120, 1);
    if (self.scanY > (((self.view.frame.size.height - self.view.frame.size.width + 120) / 2)) + self.view.frame.size.width - 120) {
        self.scanLine.frame = CGRectMake(60, (self.view.frame.size.height - self.view.frame.size.width + 120) / 2, self.view.frame.size.width - 120, 1);
        self.scanY = (self.view.frame.size.height - self.view.frame.size.width + 120) / 2;
        
    }
//    NSLog(@"-----%lf------",self.scanY);
    
}
- (void)backTo
{
    [self stopReading];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startReading
{
    [_button setTitle:@"停止" forState:UIControlStateNormal];
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_sanFrameView.layer.bounds];
    [_sanFrameView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    [_button setTitle:@"开始" forState:UIControlStateNormal];
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResut) {
        return;
    }
    _lastResut = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二维码扫描"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles: nil];
    [alert show];
    // 以及处理了结果，下次扫描
    _lastResut = YES;
}

- (void)systemLightSwitch:(BOOL)open
{
    if (open) {
        [_lightButton setTitle:@"关闭照明" forState:UIControlStateNormal];
    } else {
        [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
//            NSLog(@"----%@------",[[NSUserDefaults standardUserDefaults]objectForKey:@"user"]);
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
            
            
            if ([dic objectForKey:@"uid"]) {
                
            
            [manager POST:@"http://139.196.6.172/getLoginUidAndQrcode" parameters:@{@"qrcode":result,@"uid":[dic objectForKey:@"uid"]} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"扫码成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
                [alert show];
                if ([self.state isEqualToString:@"jd"]) {
//                    self.navigationController.navigationBar.hidden = NO;
//                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.hasScaned == NO) {
                        
                        [self.delegate saveBossInfor];
                        self.hasScaned = YES;
                    }
                }else{
                [manager.operationQueue cancelAllOperations];
                [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
            }
            [self stopReading];
            
            
            
            
            
            
            
            
        } else {
            NSLog(@"不是二维码");
        }
        
        
//        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}
- (IBAction)startScanner:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"开始"]) {
        [self startReading];
    } else {
        [self stopReading];
    }
}

- (IBAction)openSystemLight:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"打开照明"]) {
        [self systemLightSwitch:YES];
    } else {
        [self systemLightSwitch:NO];
    }
}


@end
