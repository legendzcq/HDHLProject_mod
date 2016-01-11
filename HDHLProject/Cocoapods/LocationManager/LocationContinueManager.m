//
//  LocationContinueManager.m
//  ZWProject
//
//  Created by ZGX on 15/5/25.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "LocationContinueManager.h"

#define kLocationTimeInterval 10.0 //位置更新时间

@interface LocationContinueManager () <CLLocationManagerDelegate> {
    UIBackgroundTaskIdentifier backgroundTask;
}
@end

@implementation LocationContinueManager

static id instance;
+ (id)defaultInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    [self.locationArray addObject:newLocation];
    [self stopUpdateAction];
    
    self.useTimeString = [NSString stringWithFormat:@"%d",self.useTimeString.intValue + 10];
    
    //显示所有定位数据
    NSLog(@"--------%@",self.locationArray);

    /*
    //App 活动状态
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
        //如果后台没有关闭，结束
        if (backgroundTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
            backgroundTask = UIBackgroundTaskInvalid;
        }
        
        //显示所有定位数据
        NSLog(@"--------%@",self.saveLocations);
       
    }
    //App 后台状态
    else {
        NSLog(@"applicationD in Background,newLocation:%@", newLocation);
    }*/
}

#pragma mark -
#pragma mark - UIApplicationDidEnterBackgroundNotification

- (void)applicationDidEnterBackground:(NSNotificationCenter *)notication {
    UIApplication* app = [UIApplication sharedApplication];
    
    backgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"applicationD in Background");
    }];
    
    //添加定时器
    [self addUpdateTimer];
}

//开启定时器
- (void)addUpdateTimer {
    if (!self.updateTimer) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kLocationTimeInterval target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
        //    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:backgroundUpdateInterval target:self selector:@selector(stopUpdateAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark -
#pragma mark - LocationAction

- (void)startUpdatingLocationAction {
    //响应后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.locationArray   = [NSMutableArray array];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    //添加定时器
    [self addUpdateTimer];
}

- (void)closeUpdatingLocationAction {
    //停止后台运行定位
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    /*
    if (backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }*/
}

- (void)updateAction {
    self.locationManager.delegate = self;
}

- (void)stopUpdateAction {
    self.locationManager.delegate = nil;
}

@end
