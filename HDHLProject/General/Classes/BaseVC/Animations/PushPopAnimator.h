//
//  PushPopAnimator.h
//  NavigationTransitionController
//
//  Created by zhaojunwei on 1/13/15.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushPopAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (void)endAnimation;  //解决8.3快滑的bug

@property (nonatomic, assign) BOOL isPop;  //default is NO, YES is push
@end
