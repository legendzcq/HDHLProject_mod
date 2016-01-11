
#import "LXLayoutDebugger.h"
#import "UIView+LXAutoLayout.h"

@interface LXLayoutDebugger () <UIAlertViewDelegate>
{
    UIViewController *_tempRootViewController;  //测试前的根视图控制器
    UIView *_tempSuperview;                     //测试前的父视图
    NSArray *_tempSuperviewConstraints;         //测试前的父视图约束条件
    
    UIView *_containerView;     //容器视图
    UIView *_contentView;       //内容视图
    UIButton *_centerButton;    //中心按钮
    UIButton *_widthButton;     //宽按钮
    UIButton *_heightButton;    //高按钮
    UIButton *_closeButton;     //关闭按钮
    
    CGSize _beginSize;          //拖动手势触发时的视图大小
    CGPoint _beginOffset;       //拖动手势触发时的中心位移
    
    BOOL _isDebugging;          //是否正在测试
}

@property (nonatomic, strong) UIView *debugView; //测试视图

@end

@implementation LXLayoutDebugger

+ (id)sharedInstance
{
    static LXLayoutDebugger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LXLayoutDebugger alloc] init];
    });
    
    return sharedInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _containerView = self.view;
    _containerView.backgroundColor = [UIColor blackColor];
    
    //内容容器
    _contentView = [[UIView alloc] init];
    _contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _contentView.layer.borderWidth = 1.0;
    [_containerView addSubview:_contentView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [_contentView addGestureRecognizer:panGestureRecognizer];
    
    //四角拖动控件
    float radius = 20.0;
    for (int i = 0; i < 4; i++) {
        UIView *cornerView = [[UIView alloc] init];
        cornerView.tag = i + 1;
        cornerView.backgroundColor = [UIColor lightGrayColor];
        cornerView.layer.cornerRadius = radius / 2.0;
        [_containerView addSubview:cornerView];
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [cornerView addGestureRecognizer:panGestureRecognizer];
    }
    
    //调试按钮
    _centerButton = [self buttonWithTag:0 title:@"居中" action:@selector(centerAlignment)];
    [_containerView addSubview:_centerButton];
    
    _widthButton = [self buttonWithTag:1 title:@"设置宽" action:@selector(inputSize:)];
    [_containerView addSubview:_widthButton];
    
    _heightButton = [self buttonWithTag:2 title:@"设置高" action:@selector(inputSize:)];
    [_containerView addSubview:_heightButton];
    
    //关闭按钮
    _closeButton = [self buttonWithTag:0 title:@"关闭" action:@selector(stopDebugging)];
    [_containerView addSubview:_closeButton];
}

- (UIButton *)buttonWithTag:(NSInteger)tag title:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



#pragma mark - Debug

/*测试布局*/
+ (void)debugLayout:(UIView *)debugView
{
    LXLayoutDebugger *layoutDebugger = [LXLayoutDebugger sharedInstance];
    layoutDebugger.debugView = debugView;
    [layoutDebugger startDebugging];
}

/*延迟测试布局*/
+ (void)debugLayout:(UIView *)debugView afterDelay:(NSTimeInterval)delay
{
    LXLayoutDebugger *layoutDebugger = [LXLayoutDebugger sharedInstance];
    layoutDebugger.debugView = debugView;
    [layoutDebugger performSelector:@selector(startDebugging) withObject:nil afterDelay:delay];
}

/*双击测试布局*/
+ (void)debugLayoutWhenDoubleTapped:(UIView *)debugView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[LXLayoutDebugger sharedInstance]
                                                                                           action:@selector(doubleTapGestureAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [debugView addGestureRecognizer:tapGestureRecognizer];
}

/*开始测试*/
- (void)startDebugging
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) return;
    if (_isDebugging) return; //正在测试
    
    _isDebugging = YES;
    
    _tempSuperview = _debugView.superview;
    _tempSuperviewConstraints = _tempSuperview.constraints;
    _tempRootViewController = window.rootViewController;
    
    window.rootViewController = self;
    
    [_debugView removeFromSuperview];
    [_contentView addSubview:_debugView];
    NSLog(@"%@ %@", _contentView, _debugView.subviews);
    [self setupConstraintsWithDebugViewCenterOffset:CGPointZero size:_debugView.frame.size];
}

/*停止测试*/
- (void)stopDebugging
{
    [_debugView removeFromSuperview];
    [_tempSuperview addSubview:_debugView];
    
    [_tempSuperview removeAllConstraints];
    [_tempSuperview addConstraints:_tempSuperviewConstraints];
    
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:_tempRootViewController];
    
    _debugView = nil;
    _tempSuperview = nil;
    _tempSuperviewConstraints = nil;
    _tempRootViewController = nil;
    
    _isDebugging = NO;
}

/*中心对齐*/
- (void)centerAlignment
{
    [self setupConstraintsWithDebugViewCenterOffset:CGPointZero size:_contentView.frame.size];
}



#pragma mark - Constraints

/*设置测试视图约束条件*/
- (void)setupConstraintsWithDebugViewCenterOffset:(CGPoint)cOffset size:(CGSize)size
{
    [_containerView removeAllConstraints];
    [_contentView removeAllConstraints];
    
    //内容副本
    [_contentView addMarginConstraintsWithItem:_debugView relativeItem:nil margin:UIEdgeInsetsZero];
    
    [_containerView addCenterConstraintsWithItem:_contentView relativeItem:nil offset:cOffset];
    [_containerView addSizeConstraintsWithItem:_contentView size:size];
    
    //四角拖动控件
    float radius = 10.0;
    for (int i = 0; i < 4; i++) {
        UIView *cornerView = [_containerView viewWithTag:i+1];
        
        CGPoint offset;
        if (i == 0) {
            offset = CGPointMake(-size.width / 2.0, -size.height / 2.0);
        } else if (i == 1) {
            offset = CGPointMake(-size.width / 2.0,  size.height / 2.0);
        } else if (i == 2) {
            offset = CGPointMake( size.width / 2.0,  size.height / 2.0);
        } else {
            offset = CGPointMake( size.width / 2.0, -size.height / 2.0);
        }
        [_containerView addCenterConstraintsWithItem:cornerView relativeItem:_contentView offset:offset];
        [_containerView addSizeConstraintsWithItem:cornerView size:CGSizeMake(radius * 2, radius * 2)];
    }
    
    //调试、关闭按钮
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_centerButton, _widthButton, _heightButton, _closeButton);
    [_containerView addConstraintsWithVisualFormat:@"[_centerButton]-[_widthButton]-[_heightButton]-[_closeButton]"
                                           options:NSLayoutFormatAlignAllBaseline
                                           metrics:nil
                                             views:viewsDictionary];
    [_containerView addConstantConstraintWithItem:_heightButton
                                        attribute:NSLayoutAttributeLeading
                                     relativeItem:nil
                                        attribute:NSLayoutAttributeCenterX
                                         constant:4.0];
    [_containerView addMarginConstraintsWithItem:_closeButton
                                    relativeItem:nil
                                          margin:UIEdgeInsetsMake(kConstantNone, kConstantNone, 20.0, kConstantNone)];
    
    [UIView animateWithDuration:0.2 animations:^{
        [_containerView setNeedsDisplay];
    } completion:nil];
}



#pragma mark - Gesture

/*双击手势*/
- (void)doubleTapGestureAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    LXLayoutDebugger *layoutDebugger = [LXLayoutDebugger sharedInstance];
    layoutDebugger.debugView = tapGestureRecognizer.view;
    [layoutDebugger startDebugging];
}

/*拖动手势*/
- (void)panGestureAction:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _beginOffset = CGPointMake(_contentView.center.x - _containerView.bounds.size.width / 2.0, _contentView.center.y - _containerView.bounds.size.height / 2.0);
        _beginSize = _contentView.frame.size;
    } else {
        CGPoint centerOffset = _beginOffset; //中心位移
        CGSize size = _beginSize; //大小
        
        CGPoint translation = [panGestureRecognizer translationInView:_containerView];
        
        UIView *touchView = panGestureRecognizer.view;
        if (touchView == _contentView) { //拖动整体
            centerOffset.x += translation.x;
            centerOffset.y += translation.y;
        } else {
            centerOffset.x += translation.x / 2.0;
            centerOffset.y += translation.y / 2.0;
            
            if (touchView.tag == 1 || touchView.tag == 2) {//左
                size.width -= translation.x;
            } else {//右
                size.width += translation.x;
            }
            
            if (touchView.tag == 1 || touchView.tag == 4) {//上
                size.height -= translation.y;
            } else {//下
                size.height += translation.y;
            }
        }
        [self setupConstraintsWithDebugViewCenterOffset:centerOffset size:size];
    }
}



#pragma mark - Alert

/*输入尺寸警告窗*/
- (void)inputSize:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:(sender.tag == 1) ? @"设置宽" : @"设置高"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = sender.tag;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    NSString *sizeString = [NSString stringWithFormat:@"%.1f", (sender.tag == 1) ? _contentView.frame.size.width : _contentView.frame.size.height];
    [[alertView textFieldAtIndex:0] setPlaceholder:sizeString];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        if (text) {
            CGPoint centerOffset = CGPointMake(_contentView.center.x - _containerView.bounds.size.width / 2.0, _contentView.center.y - _containerView.bounds.size.height / 2.0);
            if (alertView.tag == 1) {//宽
                [self setupConstraintsWithDebugViewCenterOffset:centerOffset size:CGSizeMake(text.floatValue, _contentView.frame.size.height)];
            } else {//高
                [self setupConstraintsWithDebugViewCenterOffset:centerOffset size:CGSizeMake(_contentView.frame.size.width, text.floatValue)];
            }
        }
    }
}

@end
