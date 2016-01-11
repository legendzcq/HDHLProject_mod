//
//  CustomPointAnnotation.h
//  ZWProject
//
//  Created by ZGX on 15/5/24.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>

@interface CustomPointAnnotation : BMKPointAnnotation

@property (nonatomic, retain) NSDictionary *pointCalloutInfo; //吹出框显示内容;

@end
