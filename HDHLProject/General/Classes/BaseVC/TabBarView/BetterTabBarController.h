//
//  BetterTabBarController.h
//  ZWProject
//
//  Created by ZGX on 15/5/23.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarView.h"

@class CustomTabBarView;
@interface BetterTabBarController : UITabBarController

@property (nonatomic, strong) CustomTabBarView *customTabbarView;
- (void)configTabBarWithViewControllerArray:(NSArray *)controllerArray;

//显示指定视图
- (void)selectedViewControllerWithIndex:(NSInteger)index;

@end
