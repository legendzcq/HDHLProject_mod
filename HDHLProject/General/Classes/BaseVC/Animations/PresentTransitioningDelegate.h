//
//  PresentTransitioningDelegate.h
//  NavigationTransitionController
//
//  Created by zhaojunwei on 1/13/15.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) UIViewController *delegatedViewController;
@end
