//
//  LoginVC.m
//  Carte
//
//  Created by user on 14-4-11.
//
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "RetrievePasswordVC.h"
#import "UserModel.h"
#import "LoginRequest.h"
#import "AccountStatusObserverManager.h"
#import "RegisterAgreementVC.h"

@interface LoginVC () {
    
    //登录按钮
    IBOutlet UIButton *_loginButton;
    IBOutlet UILabel *_commonLoginTitleLabel;
    IBOutlet UIButton *_registerButton;
    IBOutlet UIView *_registerLineView;
    IBOutlet UIButton *_forgotPasswordButton;
    IBOutlet UIView *_forgotPasswordLineView;
    IBOutlet UIButton *_agreeProtocolButton;
    IBOutlet UILabel *_divideLine;
}
@end

@implementation LoginVC

-(id)init
{
    if (self = [super init]) {
        _boolSingleSignOn = NO;
    }
    return self;
}

- (void)dealloc {
    [[AccountStatusObserverManager shareManager] removeAllObserver];
    RELEASE_SAFELY(_phoneNumberText);
    RELEASE_SAFELY(_passwordText);
    RELEASE_SAFELY(_loginButton);
    RELEASE_SAFELY(_commonLoginTitleLabel);
    RELEASE_SAFELY(_forgotPasswordButton);
    RELEASE_SAFELY(_registerButton);
    RELEASE_SAFELY(_forgotPasswordLineView);
    RELEASE_SAFELY(_registerLineView);
    RELEASE_SAFELY(_agreeProtocolButton);
}

- (void)viewDidUnload {
    RELEASE_SAFELY(_phoneNumberText);
    RELEASE_SAFELY(_passwordText);
    RELEASE_SAFELY(_loginButton);
    RELEASE_SAFELY(_commonLoginTitleLabel);
    RELEASE_SAFELY(_forgotPasswordButton);
    RELEASE_SAFELY(_registerButton);
    RELEASE_SAFELY(_forgotPasswordLineView);
    RELEASE_SAFELY(_registerLineView);
    RELEASE_SAFELY(_agreeProtocolButton);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadColorConfig];
    if (_boolSingleSignOn) {
        self.navigationBarView.leftBarButton.hidden = YES;
        [self enableInteractivePopGestureRecognizer:NO];
    }else{
        self.navigationBarView.leftBarButton.hidden = NO;
        [self enableInteractivePopGestureRecognizer:YES];
    }
    [self setNavigationBarTitle:@"登录"];
}

//加载颜色配置
- (void)loadColorConfig {
    _divideLine.width = 0.5;
    [_divideLine setBackgroundColor:ColorForHexKey(AppColor_Jump_Function_Text9)];
    [_loginButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
     [_agreeProtocolButton setTitleColor:ColorForHexKey(AppColor_Jump_Function_Text9)forState:UIControlStateNormal];
    [_forgotPasswordButton setTitleColor:ColorForHexKey(AppColor_Jump_Function_Text9) forState:UIControlStateNormal];
    [_registerButton setTitleColor:ColorForHexKey(AppColor_Jump_Function_Text9) forState:UIControlStateNormal];
}

#pragma mark viewActions
- (void)actionClickNavigationBarLeftButton {
    [[AccountStatusObserverManager shareManager] removeAllObserver];
    [LoginRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

//查看协议
- (IBAction)lookAgreementAction:(id)sender {
    RegisterAgreementVC *agreementVC = [[RegisterAgreementVC alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

//忘记密码
- (IBAction)ForgetPasswordAction:(UIButton *)sender {
    RetrievePasswordVC* retrievePasswordVC =[[RetrievePasswordVC alloc]init];
    [self.navigationController pushViewController:retrievePasswordVC animated:YES];
}

//注册
- (IBAction)RegisterAction:(UIButton *)sender {
    RegisterVC * registerVC = [[RegisterVC alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//登录
- (IBAction)LoginAction:(UIButton *)sender {
    [self endEditing];
    if (![self validateInput]) {
        return;
    }
    [self sendLoginRequest];
}

- (BOOL)validateInput {
    if (!_phoneNumberText.text.length || !_passwordText.text.length) {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入手机号及登录密码"];
        return NO;
    }
    
    if (!(_phoneNumberText.text.length == 11)) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"输入的手机号码格式不正确"];
        return NO;
    }
    return YES;
}

#pragma mark - network request

- (void)sendLoginRequest {
    //时间戳
    [AccountHelper saveLoginTypeCode];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneNumberText.text forKey:@"mobile"];
    [params setObject:_passwordText.text forKey:@"password"];
    
    //deviceToken
    NSString *deviceToken = [AccountHelper getDeviceToken];
    if (deviceToken) {
        [params setObject:deviceToken forKey:@"device_token"];
    }
    
    [LoginRequest requestWithParameters:params
                      withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
         if (request.isSuccess) {
             UserModel *userModel =  request.resultDic[KRequestResultDataKey];
             [AccountHelper saveUserInfo:userModel];
             [BDKNotifyHUD showSmileyHUDInView:self.view text:@"登录成功" completion:^{
                 //再次登录发出通知
                 [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:self];
                 if (![[AccountStatusObserverManager shareManager] postNotifyWithAcconutStatusType:LoginSuccess]) {
                     if (!_boolSingleSignOn) {
                         [self.navigationController popViewControllerAnimated:YES];
                     }else{
                         [self popFromViewControllerToRootViewControllerWithTabBarIndex:kTabbarIndex0 animation:YES];
                     }
                 }else{
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }];
             if (deviceToken) {
                 [UploadDeviceTokenRequest requestWithParameters:@{@"user_id":User_Id,@"device_tokens":deviceToken,@"device_tokens_from":@"1"} withIndicatorView:nil onRequestFinished:^(ITTBaseDataRequest *request) {
                 } onRequestFailed:^(ITTBaseDataRequest *request) {
                 }];
             }
         } else {
             NSString *msg = request.resultDic[@"msg"];
             [BDKNotifyHUD showCryingHUDInView:self.view text:[NSString isBlankString:msg] ? @"登录失败" : msg];
         }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接失败！"];
    }];
}

@end















