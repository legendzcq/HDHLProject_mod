//
//  UIViewController+PresentAnimation.m
//  NavigationTransitionController
//
//  Created by zhaojunwei on 1/13/15.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

#import "UIViewController+PresentAnimation.h"
#import <objc/runtime.h>
#import "PresentTransitioningDelegate.h"

static char kPresentDelegate;
static char kYXPViewControllerPushPopAnimationKey;

@implementation UIViewController (PresentAnimation)

- (void)presentAsPushAndPopAnimationWithViewController:(UIViewController *)controller animation:(BOOL)animation
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)controller;
        ((UIViewController *)(navController.viewControllers.firstObject)).useYXPPresentAnimation = YES;
    } else {
        controller.useYXPPresentAnimation = YES;
    }
    controller.useYXPPresentAnimation = YES;
    if (IOS_SDK_7_LATER) {
        //iOS7以上
        PresentTransitioningDelegate *presentDelegate = [PresentTransitioningDelegate new];
        [controller setPresentDelegate:presentDelegate];
        controller.transitioningDelegate = presentDelegate;
        presentDelegate.delegatedViewController = controller;
        [self presentViewController:controller animated:animation completion:nil];
    }
    else {
        //iOS7以下,未调试
//        [self.view.superview insertSubview:controller.view aboveSubview:self.view];
        [self.view.window addSubview:controller.view];
        __block CGRect toRect = controller.view.frame;
        toRect.origin.x = toRect.size.width;
//        if (![self isKindOfClass:[UINavigationController class]]) {
//            toRect.origin.y = 20;
//        }
        controller.view.frame = toRect;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toRect.origin.x = 0;
            controller.view.frame = toRect;
        } completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
            controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:controller animated:NO completion:nil];
        }];
    }
}

- (void)dismissAsPushAndPopAnimation:(BOOL)animation
{
    UINavigationController *navController = self.navigationController;
    UIViewController *targetController = nil;
    if (navController != nil) {
        targetController = navController;
    } else {
        targetController = self;
    }
    if (IOS_SDK_7_LATER) {
        [targetController.presentingViewController dismissViewControllerAnimated:animation completion:nil];
    } else {
        UIViewController *presentingViewControllr = targetController.presentingViewController;
        [presentingViewControllr dismissViewControllerAnimated:NO completion:nil];
        [presentingViewControllr.view.superview insertSubview:targetController.view aboveSubview:presentingViewControllr.view];
        __block CGRect toRect = targetController.view.frame;
        toRect.origin.x = 0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toRect.origin.x = toRect.size.width;
            targetController.view.frame = toRect;
        } completion:^(BOOL finished) {
            [targetController.view removeFromSuperview];
        }];
    }
}

- (PresentTransitioningDelegate *)presentDelegate
{
    return objc_getAssociatedObject(self, &kPresentDelegate);
}

- (void)setPresentDelegate:(PresentTransitioningDelegate *)presentDelegate
{
    objc_setAssociatedObject(self, &kPresentDelegate, presentDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)setUseYXPPresentAnimation:(BOOL)useYXPPresentAnimation {
    objc_setAssociatedObject(self, &kYXPViewControllerPushPopAnimationKey, [NSNumber numberWithBool:useYXPPresentAnimation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)useYXPPresentAnimation {
    return [objc_getAssociatedObject(self, &kYXPViewControllerPushPopAnimationKey) boolValue];
}

@end
