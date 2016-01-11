//
//  SHBaseViewController.m
//  ShenHuaLuGang
//
//  Created by sprint on 13-6-27.
//
//

#import "BetterVC.h"
//#import "LoginVC.h"

#define KNavigationBarHeight 64

@interface BetterVC ()
{
    NavigationBarView       *_navigationBarView;
    PromptView              *_promptView;
    
    //***************键盘弹起时自动拖动TextField 到可见区域******************/
    //正在编辑的textview
    UIView                  *_editingTextFieldOrTextView;
    id                      _textViewOrFieldOrgDelegate;

    float                   _contentViewTop;
}
@end

@implementation BetterVC
@synthesize contentView = _contentView;

+ (id)initVC
{
    return [[self alloc] init];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RELEASE_SAFELY(_contentView);
    RELEASE_SAFELY(_promptView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self enableInteractivePopGestureRecognizer:YES];
    [self configViewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableKeyboardManger];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEditing];
    [self disableKeyboardManager];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing];
}

- (void)endEditing
{
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/**
    配置ViewController 调整contentView的高度和top属性 如果是ios7版本则设置ViewController的edgesForExtendedLayout 取消偏移
 */

- (void)setContentViewWithTabBarViewShow {
    if (self.contentView.height >= (self.view.height - _contentView.top)) {
        self.contentView.height -= TAB_BAR_HEIGHT;
    }
}

- (void)configViewController {
    if ([self isCustomNavigationBar]) {
        [self loadNavigationBar];
        if(!_contentView) {
            _contentView = [[UIView alloc] init];
            [self.view addSubview:_contentView];
        }
    }

    UIWindow *window = (UIWindow *)KAPP_DELEGATE.window;
    self.view.size = window.size;
    self.navigationBarView.width = self.view.width;

    _contentView.top =  _navigationBarView.bottom;
    _contentView.size = CGSizeMake(self.view.width, self.view.height - _contentView.top);
    
    //设置Viewcontroller背景颜色
    _contentView.backgroundColor = UIColorFromRGB_BGColor;
    [_contentView setClipsToBounds:YES];
    [self.view setClipsToBounds:YES];
    self.view.backgroundColor = UIColorFromRGB_BGColor;
    
    if ([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//自定义导航栏背景
- (void)loadNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    _navigationBarView = [[NavigationBarView alloc] initWithNavBarSuperView:self.view];

    [_navigationBarView.rightBarButton addTarget:self action:@selector(actionClickNavigationBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView.leftBarButton addTarget:self action:@selector(actionClickNavigationBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView.right2BarButton addTarget:self action:@selector(actionClickNavigationBarRightButton2) forControlEvents:UIControlEventTouchUpInside];
    
    //默认显示左导航栏按钮
    [self setLeftNavigationBarButtonStyle:UIButtonStyleBack];
}

- (void)setNavigationBarTitle:(NSString *)title
{
    if([self isCustomNavigationBar]) {
        [self.navigationBarView setNavigationBarTitle:title];
    } else {
        [self.navigationController setTitle:title];
    }
}

- (NavigationBarView *)navigationBarView
{
    return _navigationBarView;
}

- (PromptView *)promptView
{
    if (!_promptView) {
        _promptView = [PromptView viewFromXIB];
        _promptView.size = self.contentView.size;
        [_promptView.actionButton addTarget:self action:@selector(tapPromptViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _promptView;
}

- (void)showPromptViewWithText:(NSString *)text
{
    [self.contentView addSubview:[self promptView]];
    [self.contentView sendSubviewToBack:_promptView];
    [_promptView setPromptText:text];
}

- (void)showNoDataPromptView
{
    [self showPromptViewWithText:[self defaultNoDataPromptText]];
}

- (void)showNetErrorPromptView
{
    [self showPromptViewWithText:@"网络连接错误，请重新载入"];
}

- (void)showServerErrorPromptView
{
    [self showPromptViewWithText:@"加载失败，请重新载入"];
}

- (void)hidePromptView
{
    [_promptView removeFromSuperview];
}

- (void)tapPromptViewAction
{
    
}

- (NSString *)defaultNoDataPromptText
{
    return @"暂无数据";
}

- (void)setUIButtonStyle:(UIButtonStyle)style withUIButton:(UIButton *)button
{
    if (style == UIButtonStyleBack) {
        [button setImage:[UIImage imageNamed:@"order_return_white"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_return_pink_click"] forState:UIControlStateHighlighted];

    } else if (style == UIButtonStyleBackSecond) {
        [button setImage:[UIImage imageNamed:@"order_return_pink"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_return_pink_click"] forState:UIControlStateHighlighted];
        
    } else if (style == UIButtonStyleMessage) {
        [button setImage:[UIImage imageNamed:@"public_history_news_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"public_history_news_click"] forState:UIControlStateHighlighted];
        
    } else if(style == UIButtonStyleSetting) {
        [button setImage:[UIImage imageNamed:@"public_setting_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"public_setting_click"] forState:UIControlStateHighlighted];
        
    } else if (style == UIButtonStyleShare) {
        [button setImage:[UIImage imageNamed:@"public_share_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"public_share_click"] forState:UIControlStateHighlighted];
        
    } else if (style == UIButtonStyleStores) {
        [button setImage:[UIImage imageNamed:@"nav_The store"] forState:UIControlStateNormal];
        button.frame = CGRectMake(button.left + MARGIN_S, button.top, 32, 28);
        
    } else if (style == UIButtonStyleSave) {
        [button setImage:[UIImage imageNamed:@"finish_click"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"finish_unclick"] forState:UIControlStateHighlighted];
        
    } else if(style == UIButtonStyleHistory) {
        [button setTitle:@"历史" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navigationBarView resetConstraintsRightButtonTitle:@"历史"];
        
    } else if (style == UIButtonStyleISSave) {
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:HomeColorForHexKey(AppColor_Home_NavigationBarTitle) forState:UIControlStateNormal];
        [_navigationBarView resetConstraintsRightButtonTitle:@"保存"];
        
    } else if (style == UIButtonStyleQrcode) {
        [button setImage:[UIImage imageNamed:@"code"] forState:UIControlStateNormal];
        
    } else if (style == UIButtonStyleRechargeRecoder) {
        [button setTitle:@"充值记录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navigationBarView resetConstraintsRightButtonTitle:@"充值记录"];
        
    } else if (style ==  UIButtonStyleFaBu) {
        [button setTitle:@"发布" forState:UIControlStateNormal];
        [button setTitleColor:HomeColorForHexKey(AppColor_Home_NavigationBarTitle) forState:UIControlStateNormal];
        [_navigationBarView resetConstraintsRightButtonTitle:@"发布"];
        
    } else if (style ==  UIButtonStylePosition){
        [button setTitle:@"北京" forState:UIControlStateNormal];
        [button setTitleColor:HomeColorForHexKey(AppColor_Home_NavigationBarTitle) forState:UIControlStateNormal];
        [_navigationBarView resetConstraintsRightButtonTitle:@"北京"];
        
    } else if (style ==  UIButtonStyleUnCollect){
        [button setImage:[UIImage imageNamed:@"order_collection"] forState:UIControlStateNormal];
    }else if (style == UIButtonStyleCollected){
        [button setImage:[UIImage imageNamed:@"order_collection_click"] forState:UIControlStateNormal];
    }else if (style == UIButtonStyleSearch){
        [button setImage:[UIImage imageNamed:@"home_search.png"] forState:UIControlStateNormal];
    }
}

- (void)setNavigationRightButtonTitle:(NSString *)title
{
    [self.navigationBarView.rightBarButton setTitle:title forState:UIControlStateNormal];
    self.navigationBarView.rightBarButton.width =  [self.navigationBarView.rightBarButton.titleLabel sizeThatFits:CGSizeMake(100, self.navigationBarView.rightBarButton.height)].width;;
    self.navigationBarView.rightBarButton.right = self.navigationBarView.width - MARGIN_M;
    
    
}

- (void)setLeftNavigationBarButtonStyle:(UIButtonStyle)style
{
    self.navigationBarView.leftBarButton.hidden = NO;
    [self setUIButtonStyle:style withUIButton:self.navigationBarView.leftBarButton];
}

- (void)setRightNavigationBarButtonStyle:(UIButtonStyle)style
{
    self.navigationBarView.rightBarButton.hidden = NO;
    [self setUIButtonStyle:style withUIButton:self.navigationBarView.rightBarButton];
}

//
- (Boolean)isCustomNavigationBar
{
    return true;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  view actions
///////////////////////////////////////////////////////////////////////////////

- (BOOL)respondsToPresentAsPushAndPopAnimation {
    return YES;
}

- (void)enableInteractivePopGestureRecognizer:(BOOL)isEnabled {
//    if (IOS_SDK_7_LATER) {
//        if (isEnabled) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        } else {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)actionClickNavigationBarLeftButton
{
    [self endEditing];
    
//    if ([self respondsToPresentAsPushAndPopAnimation]) {
//        [self dismissAsPushAndPopAnimation:YES];
//    } else {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)actionClickNavigationBarRightButton
{

}

- (void)actionClickNavigationBarRightButton2
{

}


#pragma mark - 
#pragma mark - 主视图切换

//主视图到下一视图
- (void)pushFromRootViewControllerToViewController:(UIViewController *)viewController animation:(BOOL)animation {
    [[KAPP_DELEGATE navigationController] pushViewController:viewController animated:animation];
}

//回到主视图
- (void)popFromViewControllerToRootViewControllerWithTabBarIndex:(kTabbarIndex)tabbarIndex animation:(BOOL)animation {
    [[KAPP_DELEGATE rootViewController] selectedViewControllerWithIndex:tabbarIndex];
    [self.navigationController popToRootViewControllerAnimated:animation];
}

//标签栏间视图切换
- (void)changeTabBarControllerWithTabbarIndex:(kTabbarIndex)tabbarIndex {
    [[KAPP_DELEGATE rootViewController] selectedViewControllerWithIndex:tabbarIndex];
}

//push一个新的viewcontroller 并将自己之上的ViewControler 弹出堆栈
- (void)pushViewController:(UIViewController *)vc
{
    NSArray *allViewControllers = self.navigationController.viewControllers;
    
    if (![allViewControllers containsObject:self]) {
        [self.navigationController setViewControllers:@[allViewControllers[0],vc] animated:YES];
    } else {
        NSArray *fillterViewControllers = [allViewControllers subarrayWithRange:NSMakeRange(0,[allViewControllers indexOfObject:self]+1)];
        NSMutableArray  *viewControllers = [NSMutableArray arrayWithArray:fillterViewControllers];
        [viewControllers addObject:vc];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    }
}

- (void)popAndPushViewController:(UIViewController *)vc
{
    NSArray *allViewControllers = self.navigationController.viewControllers;
    NSInteger selfIndex = [allViewControllers indexOfObject:self];
    NSMutableArray *newViewControlelrs = [NSMutableArray arrayWithArray:[allViewControllers subarrayWithRange:NSMakeRange(0, selfIndex)]];
    [newViewControlelrs addObject:vc];
    [self.navigationController setViewControllers:newViewControlelrs animated:YES];

}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  键盘事件
///////////////////////////////////////////////////////////////////////////////

- (BOOL)isEnableKeyboardManger
{
    return YES;
}

- (void)enableKeyboardManger
{
    if (![self isEnableKeyboardManger]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    /*Registering for textField notification*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    /*Registering for textView notification*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)disableKeyboardManager
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}


- (void)setContentViewTop:(float)contentViewTop
{
    _contentView.top = contentViewTop;
}

- (void)keyboardWillShow:(NSNotification *)notification
{

    /*
        获取通知携带的信息
     */
    NSDictionary *userInfo = [notification userInfo];
    
    if (userInfo)
    {
        [[DataCacheManager sharedManager] addObject:userInfo forKey:UIKeyboardFrameEndUserInfoKey];
    }
    
    if (!_editingTextFieldOrTextView)
    {
        return;
    }
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    if (CGRectEqualToRect(keyboardRect, CGRectZero))
    {
        NSDictionary *userInfo = (NSDictionary *)[[DataCacheManager sharedManager] getCachedObjectByKey:UIKeyboardFrameEndUserInfoKey];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardRect = [aValue CGRectValue];
    }
    
    keyboardRect = [self.view convertRect:keyboardRect toView:self.view];
    
    CGRect textViewRect =  [_editingTextFieldOrTextView.superview convertRect:_editingTextFieldOrTextView.frame toView:self.view];
    
    
    float offsetY  = (textViewRect.origin.y + textViewRect.size.height) - keyboardRect.origin.y;
    
    //输入框未被键盘遮挡 无需调整
    if (offsetY <=0)
    {
        return;
    }
    
  //  offsetY += IOS_VERSION_CODE < IOS_SDK_7 ? 44 :0;
  
    //获取键盘的动画执行时长
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
     self.contentView.top -= (offsetY + 10);
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification
{

    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.contentView.top =   _contentViewTop > 0? _contentViewTop : self.navigationBarView.bottom;

    [UIView commitAnimations];
}


#pragma mark - UITextField Delegate methods
//Fetching UITextField object from notification.
- (void)textFieldDidBeginEditingNotification:(NSNotification *) notification
{
    _editingTextFieldOrTextView = notification.object;
    if ([_editingTextFieldOrTextView isKindOfClass:[UITextField class]])
    {
        UITextField *textFiled = (UITextField *)_editingTextFieldOrTextView;
        if (!textFiled.delegate)
        {
            [textFiled setDelegate:self];
        }
        [textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textFiled setReturnKeyType:UIReturnKeyDone];
    }else
    {
        UITextView *textView = (UITextView *)_editingTextFieldOrTextView;
        [textView setReturnKeyType:UIReturnKeyDone];
    }
}

//Removing fetched object.
- (void)textFieldDidEndEditingNotification:(NSNotification*)notification
{
    [_editingTextFieldOrTextView resignFirstResponder];
    _editingTextFieldOrTextView = nil;
    _textViewOrFieldOrgDelegate =nil;
}

//禁止textView换行
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
/////////////////////////////////////////////////////////////////////////
#pragma mark UITextViewDelegate
/////////////////////////////////////////////////////////////////////////
//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidBeginEditingNotification object:textView];
//    
//}

- (void) textFieldDidChange:(UITextField *) textField
{

}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleBlackOpaque;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing];
    return YES;
}

- (void)postNotificaitonName:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing];
}


- (void)loginIfNeed:(AccountStatusObserverBlock)block
{
    if (![AccountHelper isLogin]) {
        
        [[AccountStatusObserverManager shareManager] addObserverBlock:block];
        
//        LoginVC *loginVC = [[LoginVC alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//        [loginVC release];
        
    } else {
        block(LoginSuccess);
    }
}

@end
