//
//  LocationContinueManager.h
//  ZWProject
//
//  Created by ZGX on 15/5/25.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationContinueManager : NSObject

+ (id)defaultInstance;

- (void)startUpdatingLocationAction; //开启间隔定位事件
- (void)closeUpdatingLocationAction; //关闭间隔定位事件

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray    *locationArray;
@property (nonatomic, strong) NSTimer           *updateTimer;
@property (nonatomic, strong) NSString          *useTimeString;

@end
