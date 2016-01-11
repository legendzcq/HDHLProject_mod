//
//  BaseTabbarItem.h
//  YXPBuyer-iPhone
//
//  Created by zhaojunwei on 3/26/15.
//  Copyright (c) 2015 youxinpai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTabBar_ImageTop    5
#define kTabBar_ImageWidth  25
#define kTabBar_ImageHeight 25

#define kTabBar_LabelBottom 2
#define kTabBar_LabelHeight 15
#define kTabBar_LabelFont   12.0f

@interface BaseTabbarItem : UIView

@property (nonatomic, retain) UIImageView *itemImageView;
@property (nonatomic, retain) UILabel *itemLabel;

@property (nonatomic, copy) void(^clickHandler)(void);

@end
