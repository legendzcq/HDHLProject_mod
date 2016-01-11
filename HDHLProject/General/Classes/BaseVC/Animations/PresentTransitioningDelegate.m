//
//  PresentTransitioningDelegate.m
//  NavigationTransitionController
//
//  Created by zhaojunwei on 1/13/15.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

#import "PresentTransitioningDelegate.h"
#import "PushPopAnimator.h"

@interface PresentTransitioningDelegate()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) PushPopAnimator *popAnimator;
@end

@implementation PresentTransitioningDelegate
- (void)setDelegatedViewController:(UIViewController *)delegatedViewController
{
    _delegatedViewController = delegatedViewController;
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panRecognizer.delegate = self;
    if ([delegatedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)delegatedViewController;
        navController.interactivePopGestureRecognizer.delegate = self;
    }
    [_delegatedViewController.view addGestureRecognizer:self.panRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegatedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)self.delegatedViewController;
        if (gestureRecognizer == self.panRecognizer) {
            if (navController.viewControllers.count == 1) {
                return YES;
            }
        }
        else {
            if (navController.viewControllers.count > 1) {
                return YES;
            }
        }
    }
    else {
        return YES;
    }
    return NO;
}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
//    if (IOS8_3) {
//        return;
//    }
    UIView* view = self.delegatedViewController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UINavigationController *navController = nil;
        if ([self.delegatedViewController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController *)self.delegatedViewController;
        }
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) / 2 && self.delegatedViewController.presentingViewController) { // left half
            if ((navController != nil && navController.viewControllers.count == 1) || navController ==nil) {
                self.interactionController = [UIPercentDrivenInteractiveTransition new];
                [self.delegatedViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
            if (IOS_SDK_8_3) {
                [self.popAnimator endAnimation];
            }
            self.interactionController = nil;
        } else {
            if (IOS_SDK_8_3) {
                [self.interactionController updateInteractiveTransition:0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.interactionController cancelInteractiveTransition];
                    self.interactionController = nil;
                });
            }
            else {
                [self.interactionController cancelInteractiveTransition];
                self.interactionController = nil;
            }
        }
        
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PushPopAnimator new];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    PushPopAnimator *animator = [PushPopAnimator new];
    animator.isPop = YES;
    self.popAnimator = animator;
    return animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactionController;
}

@end
