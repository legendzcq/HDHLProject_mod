//
//  BaseTabbarItem.m
//  YXPBuyer-iPhone
//
//  Created by zhaojunwei on 3/26/15.
//  Copyright (c) 2015 youxinpai. All rights reserved.
//

#import "BaseTabbarItem.h"

@implementation BaseTabbarItem

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setItemSubViews];
    }
    return self;
}

- (void)setItemSubViews {
    self.itemImageView = [[UIImageView alloc] init];
    self.itemLabel     = [[UILabel alloc] init];
    [self addSubview:self.itemImageView];
    [self addSubview:self.itemLabel];
    
    self.itemLabel.backgroundColor = [UIColor clearColor];
    self.itemLabel.textAlignment = NSTextAlignmentCenter;
    self.itemLabel.font = [UIFont systemFontOfSize:kTabBar_LabelFont];
    
    [self addMarginConstraintsWithItem:self.itemImageView relativeItem:nil margin:UIEdgeInsetsMake(kTabBar_ImageTop, kConstantNone, kConstantNone, kConstantNone)];
    [self addSizeConstraintsWithItem:self.itemImageView size:CGSizeMake(kTabBar_ImageWidth, kTabBar_ImageHeight)];

    [self addMarginConstraintsWithItem:self.itemLabel relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, 0, kTabBar_LabelBottom, 0)];
    [self addSizeConstraintsWithItem:self.itemLabel size:CGSizeMake(kConstantNone, kTabBar_LabelHeight)];
    //权重限制
    [self addWeightConstraintsWithItems:@[self.itemImageView, self.itemLabel]
                                  weights:nil
                                attribute:NSLayoutAttributeCenterX];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.clickHandler) {
        self.clickHandler();
    }
}

@end
