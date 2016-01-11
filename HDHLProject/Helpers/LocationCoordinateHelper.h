//
//  CoordinateHelper.h
//  EKS
//
//  Created by ligh on 14/12/1.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//位置坐标助手
@interface LocationCoordinateHelper : NSObject

+ (double)KMDistance:(CLLocation *)orig dist:(CLLocation *)dist;

@end
