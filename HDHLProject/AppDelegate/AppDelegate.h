//
//  AppDelegate.h
//  HDHLProject
//
//  Created by Mac on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BetterTabBarController.h"

@class BetterTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BetterTabBarController *rootViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

