//
//  CallOutAnnotationView.h
//  ZWProject
//
//  Created by ZGX on 15/5/24.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>

@interface CallOutAnnotationView : BMKAnnotationView

@property (nonatomic, retain) UIView *contentView;

//添加 SubUIViews
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel     *label;

@end
