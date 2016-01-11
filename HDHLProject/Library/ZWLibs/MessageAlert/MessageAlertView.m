//
//  MessageAlertView.m
//  ShenHuaLuGang
//
//  Created by ligh on 13-9-3.
//
//

#import "MessageAlertView.h"

@interface MessageAlertView() <UIWebViewDelegate>
{

    IBOutlet UIWebView *_msgWebView; //网页文本
    
    IBOutlet UIImageView *_msgImageView;
    IBOutlet UILabel    *_msgTextView;
    
    IBOutlet UIButton *_cancelButton;

    IBOutlet UIButton *_confirmButton;
    
    IBOutlet UIView     *_backgroundView;
    
    IBOutlet UIView     *_alertView;
    //cancel
    void(^_onCancelBlock)();
    
    //update
    void(^_onConfirmBlock)();
    
    UIView *_superView;
}
@end

@implementation MessageAlertView

- (void)dealloc
{
    RELEASE_SAFELY(_msgTextView);
    RELEASE_SAFELY(_cancelButton);
    RELEASE_SAFELY(_confirmButton);
    RELEASE_SAFELY(_backgroundView);
    RELEASE_SAFELY(_onCancelBlock);
    RELEASE_SAFELY(_onConfirmBlock);
    RELEASE_SAFELY(_alertView);
    RELEASE_SAFELY(_msgTextView);
    RELEASE_SAFELY(_msgWebView);
    RELEASE_SAFELY(_msgImageView);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    _msgTextView.textColor = ColorForHexKey(AppColor_Defaule_Hollow_Button_Text3);
    [_confirmButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text2) forState:UIControlStateNormal];
    [_cancelButton setTitleColor:ColorForHexKey(AppColor_Disable_Click_Button_Text1) forState:UIControlStateNormal];
    
    UIImage *msgImage = [UIImage imageNamed:@"public_dialog"];
    _msgImageView.image = [msgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
    
    //UIWebView背景色设置
    [_msgWebView setBackgroundColor:[UIColor clearColor]];
    [_msgWebView setOpaque:NO];
}


-(void)showAlertViewInView:(UIView *)inView msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle onCanleBlock:(void (^)())cancelBlock onConfirmBlock:(void (^)())confirmBlock
{
    
    self.height = inView.height;
    self.width = inView.width;
    [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    [_confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    
    if(!cancelTitle)
    {
        _cancelButton.hidden = YES;
      
        _confirmButton.left = _backgroundView.left  + (_backgroundView.width - _confirmButton.width)/2.0;
    }
    
    if (!confirmTitle)
    {
        _confirmButton.hidden = YES;
        _cancelButton.left = _backgroundView.left  + (_backgroundView.width - _cancelButton.width)/2.0;
    }
    
    _msgTextView.text = msg;

    if(cancelBlock)
    {
        _onCancelBlock = [cancelBlock copy];
    }
    if(confirmBlock)
    {
        _onConfirmBlock = [confirmBlock copy];
    }
    _backgroundView.height = inView.height;
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.3;
    [UIView commitAnimations];
    [_alertView.layer addAnimation:[self scaleAnimation:YES] forKey:nil];
    _alertView.center = inView.center;

    [inView addSubview:self];
    [inView bringSubviewToFront:self];
}

-(void) showAlertViewInView:(UIView *)inView msg:(NSString *)msg confirmTitle:(NSString *) confirmTitle onConfirmBlock:(void (^)())confirmBlock{
    
    self.height = inView.height;
    self.width = inView.width;
    [_confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    _confirmButton.left = _backgroundView.left  + (_backgroundView.width - _confirmButton.width)/2.0;
    
    _msgTextView.text = msg;
    
    if(confirmBlock)
    {
        _onConfirmBlock = [confirmBlock copy];
    }
    
    _backgroundView.height = inView.height;
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.3;
    [UIView commitAnimations];
    [_alertView.layer addAnimation:[self scaleAnimation:YES] forKey:nil];
    _alertView.center = inView.center;

    [inView addSubview:self];
    [inView bringSubviewToFront:self];
}

-(void)showAlertViewInView:(UIView *)inView msg:(NSString *)msg onCanleBlock:(void (^)())cancelBlock onConfirmBlock:(void (^)())confirmBlock
{
    [self showAlertViewInView:inView msg:msg cancelTitle:@"取消" confirmTitle:@"确定" onCanleBlock:cancelBlock onConfirmBlock:confirmBlock];
}
//显示xml消息
- (void)showAlertViewInView:(UIView *)inView msgXML:(NSString *)msgXML cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle onCanleBlock:(void(^)())cancelBlock onConfirmBlock:(void(^)())confirmBlock
{
    _superView = inView;
    
    self.height = inView.height;
    self.width = inView.width;
    [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    [_confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    
    if(!cancelTitle) {
        _cancelButton.hidden = YES;
        _confirmButton.left = (_alertView.width - _confirmButton.width)/2.0;
    }
    if (!confirmTitle)
    {
        _confirmButton.hidden = YES;
        _cancelButton.left = (_alertView.width - _cancelButton.width)/2.0;
    }
    
    //设置内容
    _msgTextView.hidden = YES;
    _msgWebView.hidden = NO;
    _msgWebView.delegate = self;
    [_msgWebView loadHTMLString:msgXML baseURL:nil];
    //设置动态高度（webView的代理实现）
    
    //
    
    if(cancelBlock){
        _onCancelBlock = [cancelBlock copy];
    }
    if(confirmBlock){
        _onConfirmBlock = [confirmBlock copy];
    }
    
    _backgroundView.height = inView.height;
    _backgroundView.alpha = 0;
//    _backgroundView.userInteractionEnabled = NO;
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    
    self.hidden = YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //内容水平居中
    NSString *bodyStyleHorizontal = @"document.getElementsByTagName('body')[0].style.textAlign = 'center'";
    [_msgWebView stringByEvaluatingJavaScriptFromString:bodyStyleHorizontal];
    
    //设置动态高度（webView的代理实现）
    CGFloat webHeight = webView.scrollView.contentSize.height;
    _msgWebView.height = webHeight;
    webView.scrollView.scrollEnabled = NO ;
    if (_msgWebView.height <= _msgTextView.height) {
        _msgWebView.height = _msgTextView.height;
    }
    if (_msgWebView.height > kMsgWebViewHeight) {
        _msgWebView.height = kMsgWebViewHeight;
    }
    _cancelButton.top = _confirmButton.top = _msgWebView.bottom + 8;
    _alertView.height = _cancelButton.bottom + 10;
    _msgImageView.height = _alertView.height;
    
    _alertView.center = [UIApplication sharedApplication].keyWindow.center;
    
    self.hidden = NO;
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.3;
    [UIView commitAnimations];
    [_alertView.layer addAnimation:[self scaleAnimation:YES] forKey:nil];
}


- (IBAction)actionCancel:(id)sender
{
    if(_onCancelBlock)
    {
        _onCancelBlock();
    }
    [self removeFromSuperview];
}


- (IBAction)actionConfirm:(id)sender
{
    if(_onConfirmBlock)
    {
        _onConfirmBlock();
    }
    
    [self removeFromSuperview];
}

#pragma mark - Animation
- (CAKeyframeAnimation*)scaleAnimation:(BOOL)show{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = show ? nil : self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show)
    {
        scaleAnimation.duration = 0.5;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else
    {
        scaleAnimation.duration = 0.3;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0.2)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}
/*
- (void)showAlertViewInView:(UIView *)inView message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle onCanleBlock:(void(^)())cancelBlock onConfirmBlock:(void(^)())confirmBlock
{
    _superView = inView;
    
    self.height = inView.height;
    self.width = inView.width;
    [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    [_confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    
    if(!cancelTitle) {
        _cancelButton.hidden = YES;
        _confirmButton.left = _backgroundView.left  + (_alertView.width - _confirmButton.width)/2.0;
    }
    if (!confirmTitle)
    {
        _confirmButton.hidden = YES;
        _cancelButton.left = _backgroundView.left  + (_alertView.width - _cancelButton.width)/2.0;
    }
    
    //设置内容
    _msgTextView.hidden = YES;
    _msgWebView.hidden = NO;
    _msgWebView.delegate = self;
    [_msgWebView loadHTMLString:msgXML baseURL:nil];
    //设置动态高度（webView的代理实现）
    
    //
    
    if(cancelBlock){
        _onCancelBlock = [cancelBlock copy];
    }
    if(confirmBlock){
        _onConfirmBlock = [confirmBlock copy];
    }
    
    _backgroundView.height = inView.height;
    _backgroundView.alpha = 0;
    //    _backgroundView.userInteractionEnabled = NO;
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    
    self.hidden = YES;
}*/
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    LOG(@"animationDidStop");
    [self removeFromSuperview];
}

@end
