//
//  GaoDeMapViewController.m
//  GaodeMap
//
//  Created by Gaara on 16/7/25.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "GaoDeMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "FeSpinnerTenDot.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface GaoDeMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)NSString *a;
@property (nonatomic, strong)UIImageView *image;
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong)AMapSearchAPI *keySearch;
@property (nonatomic, strong)NSArray *poiArr;
@property (nonatomic, strong)NSArray *keyArr;
@property (nonatomic, strong)UITableView *poiTable;
@property (nonatomic, strong)UITextField *searchField;
@property (nonatomic, strong)UITableView *resultTable;
@property (nonatomic, strong)FeSpinnerTenDot *loadingDot;
@end
@implementation GaoDeMapViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)backAction
{
    if (self.resultTable) {
        [self.resultTable removeFromSuperview];
        self.resultTable = nil;
        [self.poiTable reloadData];
        self.searchField.text = @"";
        [self.searchField resignFirstResponder];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(- 10, 0, 21, 16)];
    backImg.userInteractionEnabled = YES;
    [backImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)]];
    backImg.image = [UIImage imageNamed:@"navbar_icon_back"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImg];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  / 2 + 64)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomLevel = 15;
    [self.view addSubview:self.mapView];
    
    
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 65)];
//    self.image.backgroundColor = [UIColor redColor];
    self.image.image = [UIImage imageNamed:@"red.png"];
    self.image.center = self.mapView.center;
    [self.mapView addSubview:self.image];
    
    self.poiTable = [[UITableView alloc]initWithFrame:CGRectMake(0,  self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 2 ) style:UITableViewStylePlain];
    self.poiTable.delegate = self;
    self.poiTable.dataSource = self;
    self.poiTable.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    [self.view addSubview:self.poiTable];
    
    
    [self createTitleView];
    
    
    
    
}
- (void)createTitleView
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2 + 50, 30)];
    titleView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 15;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    searchImg.image = [UIImage imageNamed:@"searchImg.png"];
    [titleView addSubview:searchImg];
    
    self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, self.view.frame.size.width / 2  - 10, 30)];
    self.searchField.font = [UIFont systemFontOfSize:15];
    self.searchField.textColor = [UIColor grayColor];
    self.searchField.delegate = self;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.placeholder = @"   点击输入地理位置";
    [self.searchField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [titleView addSubview:self.searchField];
    
    self.navigationItem.titleView  = titleView;
    
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{

    if(self.a.length == 0)
    {self.a = @"1";
               self.mapView.centerCoordinate = userLocation.coordinate;
        [self startSearchWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    }else
    {
        
        
    }
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{

    if (wasUserAction) {
        
    
   CLLocationCoordinate2D a =  [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
  
    [self startSearchWithLatitude:a.latitude longitude:a.longitude];
    
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 15) {
        return self.keyArr.count;
    }else{
    return self.poiArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 15) {
        static NSString *cellId = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        AMapPOI *poi = [self.keyArr objectAtIndex:indexPath.row];
        cell.textLabel.text = poi.name;
        cell.detailTextLabel.text = poi.address;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }else{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    AMapPOI *poi = [self.poiArr objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;
        cell.textLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
    cell.detailTextLabel.text = poi.address;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
    return cell;
    }
}
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{
 
}
- (void)startSearchWithKey:(NSString *)key
{
    [self.loadingDot removeFromSuperview];
    self.loadingDot = [[FeSpinnerTenDot alloc]initWithView:self.resultTable withBlur:NO];
    [self.resultTable addSubview:self.loadingDot];
    [self.resultTable bringSubviewToFront:self.loadingDot];
    [self.loadingDot  show];
    
    self.keySearch = [[AMapSearchAPI alloc]init];
    self.keySearch.delegate = self;
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = key;
    request.city = @"上海市";
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.offset = 50;
    request.requireExtension = YES;
    [self.keySearch AMapPOIKeywordsSearch:request];
}
- (void)startSearchWithLatitude:(CGFloat)lat longitude:(CGFloat)lon
{
//    self.poiArr = @[];
//    [self.poiTable reloadData];
    [self.loadingDot removeFromSuperview];
    self.loadingDot = [[FeSpinnerTenDot alloc]initWithView:self.poiTable withBlur:NO];
    [self.poiTable addSubview:self.loadingDot];
    [self.poiTable bringSubviewToFront:self.loadingDot];
    [self.loadingDot  show];
    
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    request.keywords = @"";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
//    request.types = @"餐饮服务|生活服务";
    request.types = @"生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.offset = 50;

    request.requireExtension = YES;
    
    //发起周边搜索
    [self.search AMapPOIAroundSearch: request];
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.loadingDot dismiss];
    [self.loadingDot removeFromSuperview];
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
//    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
//    NSString *strPoi = @"";
    if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]]) {
        self.keyArr = response.pois;
        [self.resultTable reloadData];
    }else{
    self.poiArr = response.pois;
    [self.poiTable reloadData];
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 15) {
        AMapPOI *poi = [self.keyArr objectAtIndex:indexPath.row];
        
        CLLocationCoordinate2D center;
        center.latitude = poi.location.latitude;
        center.longitude = poi.location.longitude;
        [self.mapView setCenterCoordinate:center animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate getPlaceStr:poi.address WithLat:poi.location.latitude lon:poi.location.longitude];
    }else{
    AMapPOI *poi = [self.poiArr objectAtIndex:indexPath.row];
    
        CLLocationCoordinate2D center;
        center.latitude = poi.location.latitude;
        center.longitude = poi.location.longitude;
        [self.mapView setCenterCoordinate:center animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate getPlaceStr:poi.address WithLat:poi.location.latitude lon:poi.location.longitude];
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.resultTable) {
        self.resultTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
        self.keyArr = @[];
        self.resultTable.tag = 15;
        self.resultTable.delegate = self;
        self.resultTable.dataSource = self;
        [self.view addSubview:self.resultTable];
    }
}
-(void)valueChanged:(UITextField *)textField
{
//    [self.keySearch cancelAllRequests];
//    [self startSearchWithKey:textField.text];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.keySearch cancelAllRequests];
    [self startSearchWithKey:textField.text];
    return YES;
}
@end
