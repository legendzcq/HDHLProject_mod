//
//  CustomTabBarView.h
//  ZWProject
//
//  Created by ZGX on 15/5/24.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kTabbarIndex) {
    kTabbarIndex0 = 0,
    kTabbarIndex1 = 1,
    kTabbarIndex2 = 2,
    kTabbarIndex3 = 3,
};

@interface CustomTabBarView : UIView

@property (nonatomic, assign) kTabbarIndex selectedIndex;
@property (nonatomic, copy) void(^selectedIndexChangedTo)(kTabbarIndex index);

- (id)initWithSuperView:(UIView *)superView;
- (void)setHasNewBadge:(BOOL)hasNew forTabbarIndex:(kTabbarIndex)tabbarIndex;

@end
