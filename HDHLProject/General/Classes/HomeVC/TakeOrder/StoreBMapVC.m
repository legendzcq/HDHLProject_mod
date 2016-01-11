//
//  StoreBMapVC.m
//  HDHLProject
//
//  Created by Mac on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StoreBMapVC.h"

@interface StoreBMapVC () {
    StoreModel *_storeModel;
}
@end

@implementation StoreBMapVC

- (id)initWithStoreModel:(StoreModel *)storeModel {
    if (self  = [super init]) {
        _storeModel = [[StoreModel alloc] init];
        _storeModel = storeModel;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[BMKLocationManager defaultInstance] bMapViewSuperViewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[BMKLocationManager defaultInstance] bMapViewSuperViewWillDisAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"店铺地图"];
    [[BMKLocationManager defaultInstance] setBMKMapViewSuperView:self.contentView];
    UIButton *locateButton = [UIButton buttonWithFrame:CGRectMake(0, 0, 36, 35) imageNormal:@"public_relocation" imageHighlighted:nil target:self action:@selector(startLocateMyPosition)];
    locateButton.left = 15;
    locateButton.bottom = self.contentView.height - 18;
    [self.contentView addSubview:locateButton];
    
    [self startLocateMyPosition];
}

#pragma mark -
#pragma mark - 启动定位

- (void)startLocateMyPosition {
    ITTMaskActivityView *activityView = [ITTMaskActivityView viewFromXIB];
    [activityView showInView:self.view];
    [[BMKLocationManager defaultInstance] startUpdatingLocationWithUpdateBMKUserLocationBlock:^(BMKUserLocation *userLocation) {
        [activityView hide];
        //我的坐标
        [[BMKLocationManager defaultInstance] updateUserLocationData:userLocation];
        //店铺坐标
        CLLocationCoordinate2D endLocation;
        endLocation.latitude = _storeModel.lat.doubleValue;
        endLocation.longitude = _storeModel.lng.doubleValue;
        [[BMKLocationManager defaultInstance] startGeoCodeSearchWithUserLocation:userLocation reverseGeoCodeBlock:^(NSDictionary *address) {
            
            if ([NSString isBlankString:_storeModel.lat] || [NSString isBlankString:_storeModel.lng]) {
                [BDKNotifyHUD showCryingHUDWithText:@"店铺地址为空！"];
                return ;
            }
            [[BMKLocationManager defaultInstance] routeSearchWithStartLocation:userLocation.location.coordinate endLocation:CLLocationCoordinate2DMake(_storeModel.lat.floatValue, _storeModel.lng.floatValue)];
            
        } reverseGeoCodeFailBlock:^(NSString *error) {
            
        }];
    } errorBlock:^(NSError *error) {
        [activityView hide];

    }];
}

@end
