//
//  RegisterVC.m
//  Carte
//
//  Created by user on 14-4-12.
//
//

#import "RegisterVC.h"
#import "SettingPasswordVC.h"
#import "MessageAlertView.h"
#import "RegisterAgreementVC.h"

#import "VerificationRequest.h"
#import "TestMobileAndVerificationRequest.h"

#import "AccountStatusObserverManager.h"
#import "SettingPasswordVC.h"

@interface RegisterVC ()
{

    //协议按钮
    IBOutlet UIButton *agreementCheckboxButton;
    IBOutlet UILabel *_commonRegisterTitleLabel;
    IBOutlet UIButton *_agreeProtocolButton;
    IBOutlet UIButton *_nextButton;

}
@end

@implementation RegisterVC

- (void)dealloc
{

    
    RELEASE_SAFELY(_nePhoneNumberText);
    RELEASE_SAFELY(_verificationCodeText);
    RELEASE_SAFELY(_getVerificationBtn);
    RELEASE_SAFELY(_buttonTitleLabel);
    RELEASE_SAFELY(agreementCheckboxButton);
    RELEASE_SAFELY(_commonRegisterTitleLabel);
    RELEASE_SAFELY(_agreeProtocolButton);
    RELEASE_SAFELY(_nextButton);
}
- (void)viewDidUnload
{

    RELEASE_SAFELY(_nePhoneNumberText);
    RELEASE_SAFELY(_verificationCodeText);
    RELEASE_SAFELY(agreementCheckboxButton);
    RELEASE_SAFELY(_commonRegisterTitleLabel);
    RELEASE_SAFELY(_agreeProtocolButton);
    RELEASE_SAFELY(_nextButton);
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadColorConfig];
   
    [self setNavigationBarTitle:@"注册"];
}

-(void) loadColorConfig
{
    _buttonTitleLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    [_agreeProtocolButton setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateNormal];
    [_nextButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
}

int countDownNum;
-(void) startTimer
{
    countDownNum = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES];
    _getVerificationBtn.enabled = NO;
    [_getVerificationBtn setBackgroundImage:[UIImage imageNamed:@"public_button10"] forState:UIControlStateNormal];

}

-(void) stopTimer
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    countDownNum = 60;
    _getVerificationBtn.enabled = YES;
    _buttonTitleLabel.text = @"重新获取";
    
    _buttonTitleLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    [_getVerificationBtn setBackgroundImage:UIImageForName(@"login_validation") forState:UIControlStateNormal];
    
}


-(void)actionClickNavigationBarLeftButton
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    
    [[AccountStatusObserverManager shareManager] removeAllObserver];
    [TestMobileAndVerificationRequest cancelUseDefaultSubjectRequest];
    [VerificationRequest cancelUseDefaultSubjectRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

//下一步
- (IBAction)PushToSettingPasswordAction:(UIButton *)sender {
    
    [self endEditing];

    if ([self validateRegistInput])
    {
        if (!agreementCheckboxButton.selected)
        {
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"尚未同意汇点协议"];
            return;
        }
        [self sendTestMobileAndVerificationRequest];
    }
   
    
}

//获取验证码
- (IBAction)GetVerificationCodeAction:(UIButton *)sender {
    
    if ([self validatePhoneNumberInput])
    {
        [self startTimer];
        [self sendGetVerificationRequest];
    }
    
    [self endEditing];
}


- (IBAction)agreementCheckAction:(id)sender
{
    agreementCheckboxButton.selected = !agreementCheckboxButton.selected;
}

//查看协议
- (IBAction)lookAgreementAction:(id)sender
{
    RegisterAgreementVC *agreementVC = [[RegisterAgreementVC alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

//重新获取倒计时
-(void)countDownAction:(NSTimer*)timer{
    
    _buttonTitleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",countDownNum];
    [_getVerificationBtn setBackgroundImage:[UIImage imageNamed:@"public_button10"] forState:UIControlStateNormal];
    _buttonTitleLabel.textColor = [UIColor grayColor];
    countDownNum--;
    if (countDownNum == 0)
    {
        [self stopTimer];
        
    }

}

//手机号码输入验证
-(BOOL)validatePhoneNumberInput
{
   
    if ([NSString isBlankString:_nePhoneNumberText.text])
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入手机号"];
        
        return NO;
    }
    
    if (![PhoneNumberHelper validateMobile:_nePhoneNumberText.text])
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"输入的手机号码格式不正确"];
        return NO;
    }
    return YES;
}



-(BOOL)validateRegistInput{

    if ([NSString isBlankString:_nePhoneNumberText.text] || [NSString isBlankString:_verificationCodeText.text])
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入手机号及验证码"];
        return NO;
    }
    
    return YES;
}


#pragma mark regesterRequest

//获取验证码请求
-(void)sendGetVerificationRequest{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_nePhoneNumberText.text forKey:@"mobile"];
    [params setObject:@"" forKey:@"verify"];
    
    [VerificationRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request){
        
        if (request.isSuccess)
        {

            [BDKNotifyHUD showSmileyHUDWithText:request.resultDic[@"msg"]];
        }else
        {
            [self stopTimer];
            NSString *errorMsg = request.resultDic[@"msg"];
            [BDKNotifyHUD showCryingHUDWithText:[NSString isBlankString:errorMsg] ? @"验证码获取失败" : errorMsg];
        }
        
    }onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [self stopTimer];
        [BDKNotifyHUD showCryingHUDWithText:@"验证码获取失败"];
    }];
}

//验证手机号码和验证码请求
-(void)sendTestMobileAndVerificationRequest
{
    
    [TestMobileAndVerificationRequest requestWithParameters:@{@"mobile": _nePhoneNumberText.text,@"verify":_verificationCodeText.text} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request){
        
        if (request.isSuccess)
        {
        
            SettingPasswordVC *setVC = [[SettingPasswordVC alloc] initWithRegisterPhoneNumber:_nePhoneNumberText.text Verify:_verificationCodeText.text];
            [self.navigationController pushViewController:setVC animated:YES];
        }else
        {
            [BDKNotifyHUD showCryingHUDWithText:request.resultDic[@"msg"]];
        }

    }onRequestFailed:^(ITTBaseDataRequest *request){
        
        [BDKNotifyHUD showCryingHUDWithText:request.resultDic[@"msg"]];
    }];
}





@end


