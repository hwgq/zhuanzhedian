//
//  MapShowViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/8/2.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "MapShowViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "UIColor+AddColor.h"
#import "UILableFitText.h"
@interface MapShowViewController ()<MAMapViewDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@end
@implementation MapShowViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.delegate = self;
//    MAAnnotationView *point = [[MAAnnotationView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
    point.coordinate = CLLocationCoordinate2DMake(self.lat, self.lon);
    
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.lat, self.lon) animated:YES];
    [self.mapView addAnnotation:point];
    self.mapView.zoomLevel = 15;
    [self.view addSubview:self.mapView];
    
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 75 - 64 - 100, self.view.frame.size.width, 75)];
    addressView.backgroundColor = [UIColor whiteColor];
    [self.mapView addSubview:addressView];
    
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 25, 25)];
    iconImg.image = [UIImage imageNamed:@"address-icon.png"];
    [addressView addSubview:iconImg];
    
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, self.view.frame.size.width - 80, 25)];
    distanceLabel.textColor = [UIColor zzdColor];
    distanceLabel.font = [UIFont systemFontOfSize:15];
//    distanceLabel.backgroundColor = [UIColor greenColor];
    [addressView addSubview:distanceLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, self.view.frame.size.width - 80, 25)];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.text = self.addressStr;
    addressLabel.numberOfLines = 0;
//    addressLabel.backgroundColor = [UIColor greenColor];
    [addressView addSubview:addressLabel];
    
    CGSize addressSize = [UILableFitText fitTextWithWidth:self.view.frame.size.width - 80 label:addressLabel];
    addressLabel.frame = CGRectMake(60, 40, self.view.frame.size.width - 80, addressSize.height);
    
    addressView.frame = CGRectMake(0, self.view.frame.size.height - (75 - 25 + addressSize.height )- 64, self.view.frame.size.width, 75 - 25 + addressSize.height );
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"lat"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"] ) {
        
            
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"]doubleValue],[[[NSUserDefaults standardUserDefaults]objectForKey:@"lon"]doubleValue]));
            
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.lat,self.lon));
            
            
            
            //2.计算距离
            
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            distanceLabel.text = [NSString stringWithFormat:@"距我%.1fkm",distance / 1000.0];
    }
    
    
    
}
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    MAAnnotationView *point = [[MAAnnotationView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    point.image = [UIImage imageNamed:@"annPoint.png"];
    return point;
}
@end
