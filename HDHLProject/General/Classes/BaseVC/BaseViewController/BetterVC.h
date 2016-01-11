//
//  SHBaseViewController.h
//  ShenHuaLuGang
//
//  Created by 李光辉 on 13-6-27.
//  
//

#import <UIKit/UIKit.h>
#import "NavigationBarView.h"
#import "PromptView.h"
#import "ITTMaskActivityView.h"
#import "AccountStatusObserverManager.h"
//#import "UIViewController+PresentAnimation.h" //特殊页面切换(push/pop)

typedef enum
{
    UIButtonStyleBack,       //返回
    UIButtonStyleBackSecond, //返回(第二种样式)
    UIButtonStyleShare, //分享
    UIButtonStyleStores,//店铺列表
    UIButtonStyleSave,  //保存新增（编辑）地址
    UIButtonStyleMessage, //消息提示
    UIButtonStyleSetting, //设置
    UIButtonStylePosition,//定位城市
    UIButtonStyleRechargeRecoder,//充值记录
    UIButtonStyleQrcode,//二维码
    UIButtonStyleFaBu,  //发布
    UIButtonStyleUnCollect, //未收藏
    UIButtonStyleCollected, //已收藏
    UIButtonStyleHistory, //历史
    UIButtonStyleISSave,  //保存
    UIButtonStyleAddress, //饭卡首页地址
    UIButtonStyleSearch,  //搜索
} UIButtonStyle;

/**
    基本的ViewController    定制navigationBar
 **/
@interface BetterVC : UIViewController <UITextFieldDelegate,UITextViewDelegate>



+ (id)initVC;

- (void)loginIfNeed:(AccountStatusObserverBlock)block;


/***
    ContentView的作用： 主要用来适配ios7 在ios7中所有y=0 代表UIView从状态栏显示
                                      在ios7之前y=0 有两种情况如果显示系统导航栏代表导航栏之下为0 否则状态栏之下
 
    为了适配这三种情况加入contentView  xib 或者代码布局时 应该将显示内容的view放入此view种（导航栏view排除），BaseViewController 会自动根据当前ViewController状态（是显示系统导航栏还是自定义导航栏）及 ios版本调整contentView的显示位置。 xib布局则按照以前的布局方式
 
 **/
@property (strong,nonatomic) IBOutlet UIView *contentView;


//解释下：
//
//有些ViewController contentView的top 可能不是从navigationBarView的底部开始。如果带有tab栏的viewcontroller
//通过此function设置contentview的顶部坐标时，当键盘消失后 会参考此contentViewTop，而不是使用navigationBarView.bottom的数值。
//如果不设置contentViewTop,键盘消失后会使用navigationBarView.bottom作为contentView的y坐标。
//
//
- (void)setContentViewTop:(float)contentViewTop;

/**************导航栏**************************/
- (NavigationBarView *)navigationBarView;
//点击左边导航栏按钮
- (void)actionClickNavigationBarLeftButton;
//点击右边导航栏按钮
- (void)actionClickNavigationBarRightButton;
- (void)actionClickNavigationBarRightButton2;
//是否显示自定义导航栏 需要子类重写 默认显示
- (Boolean)isCustomNavigationBar;
- (void)setNavigationBarTitle:(NSString *)title;
- (void)setNavigationRightButtonTitle:(NSString *) title;
//设置UIButton 样式
- (void)setUIButtonStyle:(UIButtonStyle) style withUIButton:(UIButton *) button;
- (void)setLeftNavigationBarButtonStyle:(UIButtonStyle) style;
- (void)setRightNavigationBarButtonStyle:(UIButtonStyle) style;
- (void)configViewController;
//解决有tabbar的时候contentView高度问题
- (void)setContentViewWithTabBarViewShow;

//主视图的切换
- (void)pushFromRootViewControllerToViewController:(UIViewController *)viewController animation:(BOOL)animation; //主视图到下一视图
- (void)popFromViewControllerToRootViewControllerWithTabBarIndex:(kTabbarIndex)tabbarIndex animation:(BOOL)animation; //回到主视图
//标签栏间视图切换（适用当前视图为标签栏对应视图）
- (void)changeTabBarControllerWithTabbarIndex:(kTabbarIndex)tabbarIndex;

//push一个新的viewcontroller 并将自己之上的ViewControler 弹出堆栈
- (void)pushViewController:(UIViewController *)vc;
//push一个新的viewcontroller 并将自己及及自己之上的ViewControler 弹出堆栈
- (void)popAndPushViewController:(UIViewController *)vc;

/*
 *调用 CustomTabBar 的时候用这个方法
 */
//响应 PresentAsPushAndPopAnimation 页面切换效果
- (BOOL)respondsToPresentAsPushAndPopAnimation;
/*
 *没有 CustomTabBar 的时候用这个方法
 */
- (void)enableInteractivePopGestureRecognizer:(BOOL)isEnabled;  //iOS7以上可以开启滑动返回

/****************键盘事件************************/
//如果开启此功能 则VieController 会自动监听键盘弹起事件 自动将编辑中的view拖动到可见区域
- (void)enableKeyboardManger;    /*default enabled*/
//禁用自动托起功能
- (void)disableKeyboardManager;
- (BOOL)isEnableKeyboardManger;

//结束编辑退出软键盘
- (void)endEditing;
//键盘弹起通知
- (void)keyboardWillShow:(NSNotification *)notification;
//键盘退出通知
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)textFieldDidChange:(UITextField *)textField;

//一般通知
- (void)postNotificaitonName:(NSString *)notificationName;

- (NSString *)defaultNoDataPromptText;
- (PromptView *)promptView;
- (void)showPromptViewWithText:(NSString *)text;
- (void)showNoDataPromptView;
- (void)showNetErrorPromptView;
- (void)showServerErrorPromptView;
- (void)hidePromptView;
- (void)tapPromptViewAction;

@end
