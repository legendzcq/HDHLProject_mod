//
//  WelcomeViewController.h
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWelcomePageViewBottom 20 //页面指示器距离底部
#define kWelcomePageViewSpace  15  //页码间隔距离
#define kWelcomePageViewImageName         @"circlehollow.png" //默认
#define kWelcomePageViewSelectedImageName @"circlesolid.png"  //当前显示

typedef void(^RemoveBlock)(BOOL removeSuccess);

@interface WelcomeViewController : UIViewController

- (void)showWelcomeView:(WelcomeViewController *)welcomeVC finishBlock:(RemoveBlock)removeBlock;

@end
