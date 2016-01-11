//
//  BMKLocationManager.h
//  ZWProject
//
//  Created by ZGX on 15/5/24.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKGeoCodeSearch.h>

typedef NS_ENUM (NSInteger, RouteSearchType) {
    RouteSearchBus   = 0, //公交
    RouteSearchDrive = 1, //驾车
    RouteSearchWalk  = 2, //步行
};

//百度地图定位
typedef void(^UpdateBMKLocationBlock)(BMKUserLocation *userLocation); //定位成功
typedef void(^LocationFailBlock)(NSError *error);                     //定位失败

//百度地图地理编码
typedef void(^ReverseGeoCodeSuccessBlock) (NSDictionary *address);
typedef void(^ReverseGeoCodeFailBlock)    (NSString *error);
//正向编码 地址->经纬度
typedef void(^BMKGeoCodeResultSuccessBlock) (BMKGeoCodeResult*result);

@interface BMKLocationManager : NSObject

+ (id)defaultInstance;

//释放内存
- (void)releaseBMKLocationManager;
- (void)bMapViewSuperViewWillAppear;
- (void)bMapViewSuperViewWillDisAppear;
- (void)bMapStopUserLocationService; //关闭定位服务

//地图动态更新位置
- (void)updateUserLocationData:(BMKUserLocation *)userLocation;

//要使用百度地图，请先启动BaiduMapManager
- (void)startBMKMapSettingManager;
- (void)startBMKManager; //重新开启
- (void)stopBMKManager;  //关闭

//开始定位 定位成功后调用UpdateBMKLocationBlock 定位错误后调用LocationFailBlock
- (void)startUpdatingLocationWithUpdateBMKUserLocationBlock:(UpdateBMKLocationBlock)successBlock errorBlock:(LocationFailBlock) failBlock;
//正向编码  地址-> 经纬度
- (void)startGeoCodeSearchWithCity:(NSString *)city adressText:(NSString *)startAddrText reverseGeoCodeBlock:(BMKGeoCodeResultSuccessBlock)successBlock reverseGeoCodeFailBlock:(ReverseGeoCodeFailBlock)failBlock;
//反向地理编码
- (void)startGeoCodeSearchWithUserLocation:(BMKUserLocation *)userLocation reverseGeoCodeBlock:(ReverseGeoCodeSuccessBlock)successBlock reverseGeoCodeFailBlock:(ReverseGeoCodeFailBlock)failBlock;

//路径规划
- (void)setBMKMapViewSuperView:(UIView *)mapSuperView;
- (void)routeSearchType:(RouteSearchType)routeSearchType city:(NSString *)city startAddrText:(NSString *)startAddrText endAddrText:(NSString *)endAddrText;
- (void)routeSearchType:(RouteSearchType)routeSearchType startLocation:(CLLocationCoordinate2D)startLoaction endLocation:(CLLocationCoordinate2D)endLocation;
//自动选取规划路径（公交，驾车，步行）
- (void)routeSearchWithCity:(NSString *)city startAddrText:(NSString *)startAddrText endAddrText:(NSString *)endAddrText;
- (void)routeSearchWithStartLocation:(CLLocationCoordinate2D)startLoaction endLocation:(CLLocationCoordinate2D)endLocation;

@end
