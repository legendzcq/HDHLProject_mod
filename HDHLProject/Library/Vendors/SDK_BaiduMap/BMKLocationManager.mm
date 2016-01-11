//
//  BMKLocationManager.m
//  ZWProject
//
//  Created by ZGX on 15/5/24.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "BMKLocationManager.h"
#import "MessageAlertView.h"
#import "UIImage+Rotate.h"

#define kZoomLevel     13 //手机上当前可使用的级别为3-19级

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
@interface RouteAnnotation : BMKPointAnnotation {
    int _type; ///<0:起点   1：终点   2：公交   3：地铁   4:驾乘   5:途经点
    int _degree;
}
@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
@implementation RouteAnnotation
@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface BMKLocationManager () <BMKGeneralDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKMapViewDelegate, BMKRouteSearchDelegate> {
    //注册地图
    BMKMapManager *_mapManager;
    BOOL           _stopManager; //是否关闭了百度地图引擎
    
    //定位
    BMKLocationService     *_locationService;
    UpdateBMKLocationBlock  _locationSuccessBlock;
    LocationFailBlock       _locationFailBlock;
    BOOL                    _locationing; //是否在定位中
    
    //地理编码
    BMKGeoCodeSearch           *_geoCodeSearch;
    ReverseGeoCodeSuccessBlock  _successBlock;
    ReverseGeoCodeFailBlock     _failBlock;
    //正向编码  地址-> 经纬度
    BMKGeoCodeResultSuccessBlock _geoCodeResultSucessBlock;
    //路径规划
    BMKMapView     *_mapView;
    BMKRouteSearch *_routesearch;
}
@end

@implementation BMKLocationManager

static id instance;
+ (id)defaultInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        //注册地图
        [instance initBMKMap];
    });
    return instance;
}

//释放内存
- (void)dealloc {
    RELEASE_SAFELY(_mapManager);
    
    RELEASE_SAFELY(_locationSuccessBlock);
    RELEASE_SAFELY(_locationFailBlock);
    RELEASE_SAFELY(_locationService);
    
    RELEASE_SAFELY(_successBlock);
    RELEASE_SAFELY(_failBlock);
    RELEASE_SAFELY(_geoCodeSearch);
    
    RELEASE_SAFELY(_mapView);
    RELEASE_SAFELY(_routesearch);
}

- (void)releaseBMKLocationManager {
    _locationService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _mapView.delegate = nil;
    _routesearch.delegate = nil;
}

- (void)bMapViewSuperViewWillAppear {
    [_mapView viewWillAppear];
}

- (void)bMapViewSuperViewWillDisAppear {
    [_mapView viewWillDisappear];
    [self releaseBMKLocationManager];
}

- (void)bMapStopUserLocationService {
    [self stopUpdatingLocation];
    [self releaseBMKLocationManager];
}

//地图动态更新位置
- (void)updateUserLocationData:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    //添加我的位置标注
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
    pointAnnotation.coordinate = userLocation.location.coordinate;
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark -
#pragma mark - BMKGeneralDelegate

- (void)initBMKMap {
    _stopManager = NO;
    
    //响应后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)startBMKMapSettingManager {
    if (!_mapManager) {
        _mapManager = [[BMKMapManager alloc] init];
    }
    BOOL ret = [_mapManager start:BMKAppAK generalDelegate:self];
    if (!ret) {
        ITTDINFO(@"manager start failed!");
    }
}

- (void)startBMKManager {
    if (_stopManager) {
        if (!_mapManager) {
            _mapManager = [[BMKMapManager alloc] init];
        }
        BOOL ret = [_mapManager start:BMKAppAK generalDelegate:self];
        if (!ret) {
            ITTDINFO(@"manager start failed!");
        }
    }
}

- (void)stopBMKManager {
    _stopManager = YES;
    [_mapManager stop];
    ITTDINFO(@"------------------关闭引擎");
}

- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        ITTDINFO(@"------------------联网成功");
    } else{
        ITTDINFO(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        ITTDINFO(@"------------------授权成功");
    } else {
        ITTDINFO(@"onGetPermissionState %d",iError);
    }
}

#pragma mark -
#pragma mark - UIApplication Notification

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self startBMKManager];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self stopBMKManager];
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate

- (void)startUpdatingLocationWithUpdateBMKUserLocationBlock:(UpdateBMKLocationBlock)successBlock errorBlock:(LocationFailBlock) failBlock {
    
    //初始化定位
    _locationService = [[BMKLocationService alloc] init];
    
    RELEASE_SAFELY(_locationSuccessBlock);
    RELEASE_SAFELY(_locationFailBlock);
    _locationSuccessBlock = [successBlock copy];
    _locationFailBlock    = [failBlock copy];
    
    //强制将delegate 置为自身 只有这样才能监听位置变化 并且调用block
    _locationService.delegate = self;
//    [self setDesiredAccuracy:kCLLocationAccuracyBest]; //SDK默认定位品质
    
    //防止多次开启定位事件
    if (_locationing) {
        [self stopUpdatingLocation];
    }
    //BMK 定位方法
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation {
    if(_locationing || ![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        if(_locationFailBlock) {
            _locationFailBlock(nil);
        }
        [BDKNotifyHUD showCryingHUDWithText:@"定位服务不可用 请启用定位服务"];
        return; //如果用户禁用了定位服务则定位失败直接返回
    }
    
    _locationing = YES;
    
    [_locationService startUserLocationService];
    
    if(!_locationService.delegate) {
        _locationService.delegate = self;
    }
}

//重写SDK停止定位方法 将block置为NULL 回收资源
-(void)stopUpdatingLocation {
    [_locationService stopUserLocationService];
    RELEASE_SAFELY(_locationSuccessBlock);
    RELEASE_SAFELY(_locationFailBlock);
    
    _locationing = NO;
}

//在地图View将要启动定位时，会调用此函数
- (void)willStartLocatingUser {
    ITTDINFO(@"------------------locate start");
}

//用户位置更新后，会调用此函数 : userLocation 新的用户位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //    ITTDINFO(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    ITTDINFO(@"------------------locate success");
    if(_locationSuccessBlock) {
        _locationSuccessBlock(userLocation);
    }
    [self stopUpdatingLocation];
}

//定位失败后，会调用此函数 : error 错误号，参考CLError.h中定义的错误号
- (void)didFailToLocateUserWithError:(NSError *)error
{
    ITTDINFO(@"------------------location error");
    if(_locationFailBlock) {
        _locationFailBlock(error);
    }
    [self stopUpdatingLocation];
}

//在地图View停止定位后，会调用此函数
- (void)didStopLocatingUser {
    ITTDINFO(@"------------------locate stop");
}


#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _geoCodeResultSucessBlock(result);
    }
    else{
        _failBlock(@"查找该地址失败");
    }
}
- (void)startGeoCodeSearchWithUserLocation:(BMKUserLocation *)userLocation reverseGeoCodeBlock:(ReverseGeoCodeSuccessBlock)successBlock reverseGeoCodeFailBlock:(ReverseGeoCodeFailBlock)failBlock {
    
    //初始化编码
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    RELEASE_SAFELY(_successBlock);
    RELEASE_SAFELY(_failBlock);
    _successBlock = [successBlock copy];
    _failBlock    = [failBlock   copy];
    
    _geoCodeSearch.delegate = self;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D)userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        ITTDINFO(@"反geo检索发送成功");
    } else {
        ITTDINFO(@"反geo检索发送失败");
        if (_failBlock) {
            _failBlock(@"查找该地址失败");
        }
    }
}

- (void)startGeoCodeSearchWithCity:(NSString *)city adressText:(NSString *)startAddrText reverseGeoCodeBlock:(BMKGeoCodeResultSuccessBlock)successBlock reverseGeoCodeFailBlock:(ReverseGeoCodeFailBlock)failBlock{
    
    //初始化编码
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    RELEASE_SAFELY(_successBlock);
    RELEASE_SAFELY(_failBlock);
    _geoCodeResultSucessBlock = [successBlock copy];
    _failBlock  = [failBlock   copy];
    _geoCodeSearch.delegate = self;
    
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= city;
    geoCodeSearchOption.address = startAddrText;
    BOOL flag = [_geoCodeSearch geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if(_successBlock) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:result.address forKey:@"address"];
            [dic setObject:result.addressDetail.province     forKey:@"province"];
            [dic setObject:result.addressDetail.city         forKey:@"city"];
            [dic setObject:result.addressDetail.district     forKey:@"district"];
            [dic setObject:result.addressDetail.streetName   forKey:@"streetName"];
            [dic setObject:result.addressDetail.streetNumber forKey:@"streetNumber"];
            _successBlock(dic);
        }
    } else {
        if (_failBlock) {
            _failBlock(@"位置检索发送失败");
        }
    }
}


#pragma mark -
#pragma mark - BMKRouteSearchDelegate

- (NSString*)getMyBundlePath1:(NSString *)filename {
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)setBMKMapViewSuperView:(UIView *)mapSuperView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
    }
    _mapView.frame = CGRectMake(0, 0, mapSuperView.frame.size.width, mapSuperView.frame.size.height);
    _mapView.mapType = BMKMapTypeStandard; //标准地图模式
    _mapView.zoomLevel = kZoomLevel;
    _mapView.zoomEnabled = YES;//允许Zoom
    [mapSuperView addSubview:_mapView];
    _mapView.delegate = self;
}

- (void)routeSearchType:(RouteSearchType)routeSearchType city:(NSString *)city startAddrText:(NSString *)startAddrText endAddrText:(NSString *)endAddrText {
    if (!_routesearch) {
        _routesearch = [[BMKRouteSearch alloc]init];
    }
    _routesearch.delegate = self;
    
    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.name = startAddrText;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = endAddrText;
    
    [self refreshRouteWithRouteSearchType:routeSearchType startPlanNode:start endPlanNode:end city:city];
}

- (void)routeSearchType:(RouteSearchType)routeSearchType startLocation:(CLLocationCoordinate2D)startLoaction endLocation:(CLLocationCoordinate2D)endLocation {
    if (!_routesearch) {
        _routesearch = [[BMKRouteSearch alloc]init];
    }
    _routesearch.delegate = self;
    
    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.pt = startLoaction;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.pt = endLocation;
    
    [self refreshRouteWithRouteSearchType:routeSearchType startPlanNode:start endPlanNode:end city:nil];
}

- (void)refreshRouteWithRouteSearchType:(RouteSearchType)routeSearchType startPlanNode:(BMKPlanNode *)startNode endPlanNode:(BMKPlanNode *)endNode city:(NSString *)city {
    if (routeSearchType == RouteSearchBus) {
        BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
        transitRouteSearchOption.city= city;
        transitRouteSearchOption.from = startNode;
        transitRouteSearchOption.to = endNode;
        BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
        if(flag) {
            ITTDINFO(@"bus检索发送成功");
        } else {
            ITTDINFO(@"bus检索发送失败");
        }
    }
    
    if (routeSearchType == RouteSearchDrive) {
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = startNode;
        drivingRouteSearchOption.to = endNode;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag) {
            ITTDINFO(@"car检索发送成功");
        } else {
            ITTDINFO(@"car检索发送失败");
        }
    }
    
    if (routeSearchType == RouteSearchWalk) {
        BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
        walkingRouteSearchOption.from = startNode;
        walkingRouteSearchOption.to = endNode;
        BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
        if(flag) {
            ITTDINFO(@"walk检索发送成功");
        } else {
            ITTDINFO(@"walk检索发送失败");
        }
    }
}

- (void)routeSearchWithCity:(NSString *)city startAddrText:(NSString *)startAddrText endAddrText:(NSString *)endAddrText {
    
    if (!_routesearch) {
        _routesearch = [[BMKRouteSearch alloc]init];
    }
    _routesearch.delegate = self;
    
    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.name = startAddrText;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = endAddrText;
    
    //默认 公交
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= city;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    if(!flag) {
        ITTDINFO(@"bus检索发送成功");
    } else {
        ITTDINFO(@"bus检索发送失败");
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag) {
            ITTDINFO(@"car检索发送成功");
        } else {
            ITTDINFO(@"car检索发送失败");
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
            walkingRouteSearchOption.from = start;
            walkingRouteSearchOption.to = end;
            BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
            if(flag) {
                ITTDINFO(@"walk检索发送成功");
            } else {
                ITTDINFO(@"walk检索发送失败");
                [BDKNotifyHUD showCryingHUDWithText:@"未找到合适的路径"];
            }
        }
    }
}

- (void)routeSearchWithStartLocation:(CLLocationCoordinate2D)startLoaction endLocation:(CLLocationCoordinate2D)endLocation {

    if (!_routesearch) {
        _routesearch = [[BMKRouteSearch alloc]init];
    }
    _routesearch.delegate = self;
    
    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.pt = startLoaction;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.pt = endLocation;
    
    //默认 公交
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    if(!flag) {
        ITTDINFO(@"bus检索发送成功");
    } else {
        ITTDINFO(@"bus检索发送失败");
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag) {
            ITTDINFO(@"car检索发送成功");
        } else {
            ITTDINFO(@"car检索发送失败");
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
            walkingRouteSearchOption.from = start;
            walkingRouteSearchOption.to = end;
            BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
            if(flag) {
                ITTDINFO(@"walk检索发送成功");
            } else {
                ITTDINFO(@"walk检索发送失败");
                [BDKNotifyHUD showCryingHUDWithText:@"未找到合适的路径"];
            }
        }
    }
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
    
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

@end
