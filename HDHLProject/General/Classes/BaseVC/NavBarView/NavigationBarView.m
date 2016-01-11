//
//  SHNavigationBarView.m
//  ShenHuaLuGang
//
//  Created by sprint on 13-7-3.
//
//

#import "NavigationBarView.h"
#import "FrameLineView.h"

@interface NavigationBarView() {
    //左边按钮
    UIButton    *_leftBarButton;
    UIButton    *_left2BarButton;
    //右边按钮
    UIButton    *_rightBarButton;
    UIButton    *_right2BarButton;
    //导航栏标题
    UILabel     *_navigationTitleLabel;
}
@end

@implementation NavigationBarView

- (void)dealloc {
    RELEASE_SAFELY(_leftBarButton);
    RELEASE_SAFELY(_rightBarButton);
    RELEASE_SAFELY(_right2BarButton);
    RELEASE_SAFELY(_navigationTitleLabel);
    RELEASE_SAFELY(_left2BarButton);
}

- (id)initWithNavBarSuperView:(UIView *)superView {
    if (self = [super init]) {
        UIWindow *window = (UIWindow *)KAPP_WINDOW;
        self.frame = CGRectMake(0, 0, window.width, NAV_BAR_HEIGHT);
        if (IOS_VERSION_CODE > 6) {
            self.height = NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT;
        }
        self.backgroundColor = HomeColorForHexKey(AppColor_Home_NavBg1);
        
        //背景图
//        [self setNavBarBackgroundImageView];
        //标题
        [self setNavBarTitleView];
        //按钮
        [self setNavBarButton];
        
        [superView addSubview:self];
        [superView bringSubviewToFront:self];
    }
    return self;
}

//设置横线
- (void)setNavigationStyleWithTakeOrderController {
    self.backgroundColor = HomeColorForHexKey(AppColor_Home_NavBg2);
    FrameLineView *_bottomLineView = [[FrameLineView alloc] init];
    _bottomLineView.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    [self addSubview:_bottomLineView];
}

- (void)setNavBarBackgroundImageView {
    if (!_navigationImageView) {
        _navigationImageView = [[UIImageView alloc] init];
    }
    _navigationImageView.backgroundColor = [UIColor clearColor];
    _navigationImageView.frame = self.bounds;
    [self addSubview:_navigationImageView];
    _navigationImageView.image = [[UIImage imageNamed:@"public_navigationbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
}
- (void)setNavBarTitleViewHide
{
    _navigationTitleLabel.hidden = YES ;
}

- (void)setNavBarTitleView {
    if (!_navigationTitleLabel) {
        _navigationTitleLabel = [[UILabel alloc] init];
    }
    _navigationTitleLabel.backgroundColor = [UIColor clearColor];
    _navigationTitleLabel.font = kNavBarTitleLabelFont;
    _navigationTitleLabel.textColor = HomeColorForHexKey(AppColor_Home_NavigationBarTitle);
    _navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_navigationTitleLabel];
    [self addMarginConstraintsWithItem:_navigationTitleLabel relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, kNavBarTitleLabelLeft, 0, kNavBarTitleLabelLeft)];
    [self addSizeConstraintsWithItem:_navigationTitleLabel size:CGSizeMake(kConstantNone, kNavBarTitleLabelHeight)];
}

- (void)setNavBarButton {
    if (!_leftBarButton) {
        _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _leftBarButton.titleLabel.font = kNavBarButtonFont;
    [_leftBarButton setTitleColor:HomeColorForHexKey(AppColor_Home_NavigationBarTitle) forState:UIControlStateNormal];
    [self addSubview:_leftBarButton];
    if (!_rightBarButton) {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _rightBarButton.titleLabel.font = kNavBarButtonFont;
    [_rightBarButton setTitleColor:HomeColorForHexKey(AppColor_Home_NavigationBarTitle) forState:UIControlStateNormal];
    [self addSubview:_rightBarButton];
   
    
    [self addMarginConstraintsWithItem:_leftBarButton relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, 0, 0, kConstantNone)];
    [self addSizeConstraintsWithItem:_leftBarButton size:CGSizeMake(kNavBarButtonWidth, kNavBarButtonHeight)];
    [self addMarginConstraintsWithItem:_rightBarButton relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, kConstantNone, 0, 0)];
    [self addSizeConstraintsWithItem:_rightBarButton size:CGSizeMake(kNavBarButtonWidth, kNavBarButtonHeight)];
    
}

- (void)resetConstraintsRightButtonTitle:(NSString *)title {
    CGFloat button_width;
    if (title.length > 3) {
        button_width = 90;
    } else if (title.length > 2) {
        button_width = 70;
    } else {
        button_width = kNavBarButtonWidth;
    }
    //移除所有约束
    [self removeAllConstraints];
    //标题约束
    [self addMarginConstraintsWithItem:_navigationTitleLabel relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, kNavBarTitleLabelLeft, 0, kNavBarTitleLabelLeft)];
    [self addSizeConstraintsWithItem:_navigationTitleLabel size:CGSizeMake(kConstantNone, kNavBarTitleLabelHeight)];
    //按钮约束
    [self addMarginConstraintsWithItem:_leftBarButton relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, 0, 0, kConstantNone)];
    [self addSizeConstraintsWithItem:_leftBarButton size:CGSizeMake(kNavBarButtonWidth, kNavBarButtonHeight)];
    [self addMarginConstraintsWithItem:_rightBarButton relativeItem:nil margin:UIEdgeInsetsMake(kConstantNone, kConstantNone, 0, 0)];
    [self addSizeConstraintsWithItem:_rightBarButton size:CGSizeMake(button_width, kNavBarButtonHeight)];
}

- (void)setNavigationBarTitle:(NSString *)title {
    [_navigationTitleLabel setText:title];
}

- (UILabel *) navigationBarTitleLabel {
    return _navigationTitleLabel;
}

- (UIButton *)leftBarButton {
    return _leftBarButton;
}

- (UIButton *)left2BarButton {
    return _left2BarButton;
}

- (UIButton *)rightBarButton {
    return _rightBarButton;
}

- (UIButton *)right2BarButton {
    return _right2BarButton;
}

@end
