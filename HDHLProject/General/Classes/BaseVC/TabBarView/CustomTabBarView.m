//
//  CustomTabBarView.m
//  ZWProject
//
//  Created by ZGX on 15/5/24.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "CustomTabBarView.h"
#import "BaseTabbarItem.h"

//TabbarItem 图片名
#define kTabBarItemImageName0_Select @"home_brand_click"
#define kTabBarItemImageName1_Select @"home_list_click"
#define kTabBarItemImageName2_Select @"home_me_click"

#define kTabBarItemImageName0_Normal @"home_brand"
#define kTabBarItemImageName1_Normal @"home_list"
#define kTabBarItemImageName2_Normal @"home_me"

//TabbarItem 标题名
#define kTabBarItemTitle0 @"首页"
#define kTabBarItemTitle1 @"订单"
#define kTabBarItemTitle2 @"我的"

#define defaultMetricsDictionary @{@"space": @10, @"priority": @700}

@interface CustomTabBarView ()

@property (nonatomic, retain) BaseTabbarItem *tabbartItem0;
@property (nonatomic, retain) BaseTabbarItem *tabbartItem1;
@property (nonatomic, retain) BaseTabbarItem *tabbartItem2;

@property (nonatomic, weak) IBOutlet UIImageView *personBadgeView;
@property (nonatomic, weak) IBOutlet UIImageView *preferBadgeView;

@end

@implementation CustomTabBarView

- (id)initWithSuperView:(UIView *)superView {
    if (self = [super init]) {
        self.frame = CGRectMake(0, superView.height - TAB_BAR_HEIGHT, superView.width, TAB_BAR_HEIGHT);
        self.backgroundColor = [UIColor clearColor];

        [self setBackgroundImageColor];
        [self setItemViewsWithSuperView:superView];
        [self setSelectAction];
        
        [superView addSubview:self];
        [superView bringSubviewToFront:self];
    }
    return self;
}

- (void)setBackgroundImageColor {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageNamed:@"home_tabbg"];
    [self addSubview:bgImageView];
}

- (void)setItemViewsWithSuperView:(UIView *)superView {
    _tabbartItem0 = [[BaseTabbarItem alloc] init];
    _tabbartItem1 = [[BaseTabbarItem alloc] init];
    _tabbartItem2 = [[BaseTabbarItem alloc] init];

    [self addSubview:_tabbartItem0];
    [self addSubview:_tabbartItem1];
    [self addSubview:_tabbartItem2];

    NSArray *itemsArray = @[_tabbartItem0, _tabbartItem1, _tabbartItem2];
    
    float itemsWidth = superView.width/itemsArray.count;
    for (int k = 0; k < itemsArray.count; k ++) {
        BaseTabbarItem *items = (BaseTabbarItem *)itemsArray[k];
        items.frame = CGRectMake(k * itemsWidth, 0, itemsWidth, TAB_BAR_HEIGHT);
    }
}

- (void)setSelectAction {
    _tabbartItem0.itemLabel.text = kTabBarItemTitle0;
    _tabbartItem1.itemLabel.text = kTabBarItemTitle1;
    _tabbartItem2.itemLabel.text = kTabBarItemTitle2;

    __weak __typeof(self)weakSelf = self;
    [self.tabbartItem0 setClickHandler:^{
        weakSelf.selectedIndex = kTabbarIndex0;
        if (weakSelf.selectedIndexChangedTo) {
            weakSelf.selectedIndexChangedTo(kTabbarIndex0);
        }
    }];
    [self.tabbartItem1 setClickHandler:^{
        weakSelf.selectedIndex = kTabbarIndex1;
        if (weakSelf.selectedIndexChangedTo) {
            weakSelf.selectedIndexChangedTo(kTabbarIndex1);
        }
    }];
    [self.tabbartItem2 setClickHandler:^{
        weakSelf.selectedIndex = kTabbarIndex2;
        if (weakSelf.selectedIndexChangedTo) {
            weakSelf.selectedIndexChangedTo(kTabbarIndex2);
        }
    }];
}

- (void)updateTabBarViews {
    BOOL isVC0 = (self.selectedIndex == kTabbarIndex0);
    BOOL isVC1 = (self.selectedIndex == kTabbarIndex1);
    BOOL isVC2 = (self.selectedIndex == kTabbarIndex2);

    if (isVC0) {
        _tabbartItem0.itemImageView.image = [UIImage imageNamed:kTabBarItemImageName0_Select];
        _tabbartItem0.itemLabel.textColor = HomeColorForHexKey(AppColor_Home_TabBatItemSelect);
    } else {
        _tabbartItem0.itemImageView.image = [UIImage imageNamed:kTabBarItemImageName0_Normal];
        _tabbartItem0.itemLabel.textColor = HomeColorForHexKey(AppColor_Home_TabBatItemNormal);
    }
    if (isVC1) {
        _tabbartItem1.itemImageView.image = [UIImage imageNamed:kTabBarItemImageName1_Select];
        _tabbartItem1.itemLabel.textColor = HomeColorForHexKey(AppColor_Home_TabBatItemSelect);
    } else {
        _tabbartItem1.itemImageView.image = [UIImage imageNamed:kTabBarItemImageName1_Normal];
        _tabbartItem1.itemLabel.textColor = HomeColorForHexKey(AppColor_Home_TabBatItemNormal);
    }
    if (isVC2) {
        _tabbartItem2.itemImageView.image = [UIImage imageNamed:kTabBarItemImageName2_Select];
        _tabbartItem2.itemLabel.textColor = HomeColorForHexKey(AppColor_Home_TabBatItemSelect);
    } else {
        _tabbartItem2.itemImageView.image = [UIImage imageNamed:kTabBarItemImageName2_Normal];
        _tabbartItem2.itemLabel.textColor = HomeColorForHexKey(AppColor_Home_TabBatItemNormal);
    }
}

- (void)setSelectedIndex:(kTabbarIndex)selectedIndex {
    _selectedIndex = selectedIndex;
    [self updateTabBarViews];
}

- (void)setHasNewBadge:(BOOL)hasNew forTabbarIndex:(kTabbarIndex)tabbarIndex {
    //暂时只有优惠需要提示小红点
    if (tabbarIndex == kTabbarIndex1) {
        self.preferBadgeView.hidden = !hasNew;
    }
}

@end
