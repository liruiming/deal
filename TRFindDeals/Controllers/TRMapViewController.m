
//
//  TRMapViewController.m
//  TRFindDeals
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "UIBarButtonItem+TRBarItem.h"
#import "TRDataManager.h"
#import "TRDeal.h"
#import "TRAnnotation.h"
#import "TRBusiness.h"
#import "TRCategory.h"
#import "MKAnnotationViewController.h"
#import "WebViewController.h"
@interface TRMapViewController ()<MKMapViewDelegate,DPRequestDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSArray *dealsArr;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation TRMapViewController
- (CLGeocoder *)geocoder {
    if(_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加回退item
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"icon_back"withHighLightedImage:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"地图定位";
    
    self.manager = [CLLocationManager new];
    //iOS8+ (Info.plist)
    [self.manager requestWhenInUseAuthorization];
    
    //假定用户允许定位
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
   // 设置Delegate
    self.mapView.delegate = self;
    
    
}
- (void)clickBackItem
{

    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
   //设定参数,发送请求
    //City
 [self.geocoder  reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    
     CLPlacemark *placemark = placemarks.firstObject;
     NSString *cityName = placemark.addressDictionary[@"City"];
   //北京市 --> 北京(前提:语言中文的)
    self.cityName = [cityName substringToIndex:cityName.length - 1];
     
 }];

    [self mapView:mapView regionDidChangeAnimated:YES];

}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //如果城市名字为空,直接返回
    if (!self.cityName)
    {
        return;
    }
    
    
   //设定参数,发送请求(city/地图中心经纬/半径)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.cityName;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(3000);
    
    //发送请求
    DPAPI *api = [DPAPI new];
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    

}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *identifier = @"annoView";
    MKAnnotationView * annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annoView)
    {
        annoView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        annoView.canShowCallout = YES;
        TRAnnotation *anno = (TRAnnotation *)annotation;
        
            annoView.image = anno.image;
            
      
        
    }
    else
    {
        annoView.annotation = annotation;
        
    }
  
    
    return annoView;

}

////点击anntation方法,加载所选的deal信息
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    
        if ([view.annotation isKindOfClass:[MKUserLocation class]])
        {
            return;
        }
    
        TRAnnotation *anno = [TRAnnotation changeAnnotationClass:view.annotation];
    
    
// 设置大头针视图右边button
    UIView *cview =[UIView new];
    cview.frame = CGRectMake(0, 0, 100, 20);
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = cview.bounds;
    [button setTitle:@"查看详情 >>" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [cview addSubview:button];
    view.rightCalloutAccessoryView = cview ;
    
    [button addTarget:self action:@selector(clickDealButton) forControlEvents:UIControlEventTouchUpInside];
    
     self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:anno.dealUrlStr]];
    
    
//显示大头针所在的订单
   MKAnnotationViewController *annotationViewController = [MKAnnotationViewController new];
    
    annotationViewController.deal = anno.deal;
    
    annotationViewController.modalPresentationStyle = UIModalPresentationPopover;
    annotationViewController.popoverPresentationController.sourceView = view;
    annotationViewController.popoverPresentationController.sourceRect = view.bounds;
    annotationViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;

    [self presentViewController: annotationViewController animated:YES completion:nil];
    
  
}
//点击大头针右按钮执行
- (void)clickDealButton
{

  
     WebViewController *wvc = [WebViewController new];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:wvc];
    wvc.request = self.request;
    [self presentViewController:navi animated:YES completion:nil];


}




#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"result:%@",result);
    
    //需求:服务器返回的数据,获取经纬度,添加大头针对象
    NSArray *resultArray = [TRDataManager parseDealsResult:result];
    for (TRDeal *deal in resultArray)
    {
        NSArray *businessArr = [TRDataManager getAndParseBusiness:deal];
        //给定一个订单的模型对象,返回该订单所属的分类模型对象
        TRCategory *category = [TRDataManager getCategoryWithDeal:deal];
        
        
        for (TRBusiness *business in businessArr)
        {
            //添加大头针对象到地图视图上
            TRAnnotation *annotation = [TRAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotation.title = business.name;
            annotation.subtitle = deal.desc;
            
            annotation.dealUrlStr = deal.deal_h5_url;
            annotation.deal = deal;
           
            
            
            if (category)
            {
                annotation.image = [UIImage imageNamed:category.map_icon];
           
            }
          
            else
            {
                
//              annotation.image = [UIImage imageNamed:@"icon_map_refresh"];
                NSLog(@"没有找到分类");
                
            }
            
            
            if ([self.mapView.annotations containsObject:annotation])
            {
                
                continue;
            }
    
                [self.mapView addAnnotation:annotation];
            
            }
       
        
    }
    
    


}



- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    
      NSLog(@"失败:%@", error.userInfo);
    
    
}


@end
