//
//  RetrievePasswordVC.m
//  Carte
//
//  Created by user on 14-4-12.
//
//

#import "RetrievePasswordVC.h"
#import "ResetPasswordVC.h"
#import "RetrievePasswordVerificationRequest.h"
#import "VerificationRequest.h"

@interface RetrievePasswordVC ()
{

    IBOutlet UIButton   *_nextButton;

}
@end

@implementation RetrievePasswordVC

- (void)dealloc {
    
    RELEASE_SAFELY(_phoneNumberText);
    RELEASE_SAFELY(_verificationCodeText);
    RELEASE_SAFELY(_getVarificationBtn);
    RELEASE_SAFELY(_buttonTitleLabel);
    RELEASE_SAFELY(_nextButton);
}
- (void)viewDidUnload
{
    
    RELEASE_SAFELY(_phoneNumberText);
    RELEASE_SAFELY(_verificationCodeText);
    RELEASE_SAFELY(_getVarificationBtn);
    RELEASE_SAFELY(_buttonTitleLabel);
    RELEASE_SAFELY(_nextButton);
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadColorConfig];
    [self setNavigationBarTitle:@"找回密码"];
    
}


-(void) loadColorConfig
{
    _buttonTitleLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
}

-(void)actionClickNavigationBarLeftButton
{
    [_countDomnTimer invalidate];
    _countDomnTimer = nil;
    
    [VerificationRequest cancelUseDefaultSubjectRequest];
    [RetrievePasswordVerificationRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

//获取验证码
- (IBAction)GetVerificationCodeAction:(UIButton *)sender
{
    
    [self endEditing];
    
   if ([self validatePhoneNumberInput])
    {
        [self startTimer];
       [self sendRetrievePasswordVerificationRequestAction];
    }
}

//下一步
- (IBAction)pushToResetPasswordAction:(UIButton *)sender
{
    [self endEditing];
    if ([self validatePhoneNumberInput] && [self validateNextInput])
    {
        [self sendRetrievePasswordRequestAction];
        
    }
}

-(void)startTimer
{
    _countDownNum = 60;
    _countDomnTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES];
    
    _getVarificationBtn.enabled = NO;
    [_getVarificationBtn setBackgroundImage:UIImageForName(@"public_button10") forState:UIControlStateNormal];
    
    _buttonTitleLabel.textColor = ColorForHexKey(AppColor_Disable_click_button_text2);
}

-(void) stopTimer
{
    [_countDomnTimer invalidate];
    _countDomnTimer = nil;
    _countDownNum = 60;
    _buttonTitleLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _getVarificationBtn.enabled = YES;
    [_getVarificationBtn setBackgroundImage:UIImageForName(@"login_validation") forState:UIControlStateNormal];
    _buttonTitleLabel.text = @"重新获取";    
}



//获取验证码倒计时
-(void)countDownAction:(NSTimer *)timer
{
    [_getVarificationBtn setBackgroundImage:UIImageForName(@"public_button10") forState:UIControlStateSelected];
    _countDownNum--;
    _buttonTitleLabel.text = [NSString stringWithFormat:@"重新获取(%ld)",(long)_countDownNum];
    _buttonTitleLabel.textColor = [UIColor grayColor];
    if (_countDownNum == 0)
    {
        [self stopTimer];
    }
}

-(BOOL)validatePhoneNumberInput
{
    if (!_phoneNumberText.text.length)
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入手机号"];
        return NO;
    }
    if (!(_phoneNumberText.text.length == 11))
    {
        [BDKNotifyHUD showCryingHUDWithText:@"输入的手机号码格式不正确"];
        return NO;
    }
    
    return YES;
}

-(BOOL)validateNextInput{
    
    if (!_phoneNumberText.text.length || !_verificationCodeText.text.length)
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入手机号及验证码"];
        return NO;
    }
    
    return YES;
}

//找回密码获取验证码请求
-(void)sendRetrievePasswordVerificationRequestAction
{
    [VerificationRequest requestWithParameters:@{@"mobile":_phoneNumberText.text,@"type":@"1"} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess) {
            
            [BDKNotifyHUD showSmileyHUDWithText:@"验证码已经下发到您输入的手机上"];
        }else{
            [self stopTimer];
            [BDKNotifyHUD showCryingHUDWithText:request.resultDic[@"msg"]];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [self stopTimer];
        [BDKNotifyHUD showCryingHUDWithText:@"验证码获取失败"];
    }];
}

//找回密码请求
-(void)sendRetrievePasswordRequestAction
{
    [RetrievePasswordVerificationRequest requestWithParameters:@{@"mobile":_phoneNumberText.text,@"verify":_verificationCodeText.text,@"type":@"1"} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess) {
            ResetPasswordVC* resetPasswordVC = [[ResetPasswordVC alloc]initWithRetrievePasswordPhoneNumber:_phoneNumberText.text withResetPasswordWithType:ResetPasswordWithLoginType];
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }else{
            [BDKNotifyHUD showCryingHUDWithText:request.resultDic[@"msg"]];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDWithText:request.resultDic[@"msg"]];
    }];
}

@end










