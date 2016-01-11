//
//  MessageAlertView.h
//  ShenHuaLuGang
//
//  Created by ligh on 13-9-3.
//
//

#import <UIKit/UIKit.h>
#import "XibView.h"

#define kMsgWebViewHeight 200 //默认web显示消息最大高度

@interface MessageAlertView : XibView

-(void) showAlertViewInView:(UIView *) inView msg:(NSString *) msg cancelTitle:(NSString *) cancelTitle confirmTitle:(NSString *) confirmTitle onCanleBlock:(void(^)()) cancelBlock onConfirmBlock:(void(^)()) confirmBlock;

-(void) showAlertViewInView:(UIView *)inView msg:(NSString *)msg onCanleBlock:(void (^)())cancelBlock onConfirmBlock:(void (^)())confirmBlock;

-(void) showAlertViewInView:(UIView *)inView msg:(NSString *)msg confirmTitle:(NSString *) confirmTitle onConfirmBlock:(void (^)())confirmBlock;

//显示xml消息
- (void)showAlertViewInView:(UIView *)inView msgXML:(NSString *)msgXML cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle onCanleBlock:(void(^)())cancelBlock onConfirmBlock:(void(^)())confirmBlock;
//显示消息
//- (void)showAlertViewInView:(UIView *)inView message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle onCanleBlock:(void(^)())cancelBlock onConfirmBlock:(void(^)())confirmBlock;
//第一次进入

@end
