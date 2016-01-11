//
//  UIViewController+PresentAnimation.h
//  NavigationTransitionController
//
//  Created by zhaojunwei on 1/13/15.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PresentAnimation)

@property (nonatomic, assign) BOOL useYXPPresentAnimation;

- (void)presentAsPushAndPopAnimationWithViewController:(UIViewController *)controller animation:(BOOL)animation;
- (void)dismissAsPushAndPopAnimation:(BOOL)animation;

@end
