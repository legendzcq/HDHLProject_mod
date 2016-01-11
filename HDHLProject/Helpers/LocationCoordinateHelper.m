//
//  CoordinateHelper.m
//  EKS
//
//  Created by ligh on 14/12/1.
//
//

#import "LocationCoordinateHelper.h"

@implementation LocationCoordinateHelper

+ (double)KMDistance:(CLLocation *)orig dist:(CLLocation *)dist
{
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}

@end
