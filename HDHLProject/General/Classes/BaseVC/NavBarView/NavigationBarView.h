//
//  SHNavigationBarView.h
//  ShenHuaLuGang
//
//  Created by sprint on 13-7-3.
//
//

/*
 *自定义导航栏
 */
#import <UIKit/UIKit.h>

#define kNavBarTitleLabelFont [UIFont boldSystemFontOfSize:19.0f]
#define kNavBarTitleLabelLeft   50
#define kNavBarTitleLabelHeight 44

#define kNavBarButtonFont   [UIFont boldSystemFontOfSize:15.0f]
#define kNavBarButtonWidth  50
#define kNavBarButtonHeight 44

@interface NavigationBarView : UIView

//背景图
@property (nonatomic, strong) UIImageView *navigationImageView;

- (id)initWithNavBarSuperView:(UIView *)superView;
- (void)resetConstraintsRightButtonTitle:(NSString *)title; //设置文字样式按钮
- (void)setNavBarTitleViewHide;
- (UIButton *)leftBarButton;
- (UIButton *)left2BarButton;

- (UIButton *)rightBarButton;
- (UIButton *)right2BarButton;

- (UILabel *)navigationBarTitleLabel;

- (void)setNavigationBarTitle:(NSString *)title;
- (void)setNavigationStyleWithTakeOrderController;

@end
