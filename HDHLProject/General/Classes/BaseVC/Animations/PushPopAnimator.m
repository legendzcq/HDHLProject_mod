//
//  PushPopAnimator.m
//  NavigationTransitionController
//
//  Created by zhaojunwei on 1/13/15.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

#import "PushPopAnimator.h"

@interface PushPopAnimator()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> currentContext;
@end

@implementation PushPopAnimator

- (void)endAnimation {
    if (IOS_SDK_8_3) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.currentContext completeTransition:![self.currentContext transitionWasCancelled]];
            self.currentContext = nil;
        });
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.currentContext = transitionContext;
    
    if (self.isPop) {
        [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
        __block CGRect toRect = toViewController.view.frame;
        toRect.origin.x = - toRect.size.width / 3;
        toViewController.view.frame = toRect;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect fromRect = fromViewController.view.frame;
            fromRect.origin.x = fromRect.size.width;
            fromViewController.view.frame = fromRect;
            
            toRect.origin.x = 0;
            toViewController.view.frame = toRect;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            self.currentContext = nil;
        }];
    }
    else {
        [[transitionContext containerView] insertSubview:toViewController.view aboveSubview:fromViewController.view];
        __block CGRect toRect = toViewController.view.frame;
        CGFloat originX = toRect.origin.x;
        toRect.origin.x = toRect.size.width;
        toViewController.view.frame = toRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect fromRect = fromViewController.view.frame;
            fromRect.origin.x -= fromRect.size.width / 3;
            fromViewController.view.frame = fromRect;
            
            toRect.origin.x = originX;
            toViewController.view.frame = toRect;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            self.currentContext = nil;
        }];
    }
}

@end
