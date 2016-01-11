//
//  UIDevice+ITTAdditions.h
//  iTotemFrame
//
//  Created by jack ligh on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

@interface UIDevice (ITTAdditions)

+ (BOOL)isHighResolutionDevice;
+ (UIInterfaceOrientation)currentOrientation;
- (NSString *)getIPAddress;
- (NSString *)getMacAddress;
- (NSString*)getDeviceVersion;
- (NSString*)platformString;
@end
