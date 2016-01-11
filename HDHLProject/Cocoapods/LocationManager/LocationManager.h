//
//  LocationManager.h
//  iSchool
//
//  Created by ligh on 13-10-14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//定位成功
typedef void(^UpdateToLocationBlock)(CLLocation *newLocation,CLLocation *oldLocation);
//定位失败
typedef void(^LocationFailBlock)(NSError *error);

@interface LocationManager : CLLocationManager

+ (id)defaultInstance;

//开始定位 定位成功后调用UpdateToLocationBlock 定位错误后调用LocationFailBlock
- (void)startUpdatingLocationWithUpdateToLocationBlock:(UpdateToLocationBlock) locationBlock errorBlock:(LocationFailBlock) errorBlock;

//开始定位 定位成功后调用UpdateToLocationBlock 定位错误后调用LocationFailBlock
- (void)startUpdatingLocationWithUpdateToLocationBlock:(UpdateToLocationBlock) locationBlock errorBlock:(LocationFailBlock) errorBlock activityIndicator:(BOOL) isShow;

@end
