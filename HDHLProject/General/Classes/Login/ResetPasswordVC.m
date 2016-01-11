//
//  ResetPasswordVC.m
//  Carte
//
//  Created by user on 14-4-12.
//
//

#import "ResetPasswordVC.h"
#import "ResetPasswoedRequest.h"
#import "UserModel.h"
#import "LoginVC.h"

@interface ResetPasswordVC (){
    
    NSString            *_phoneNumber;
    NSInteger           _passType;
    IBOutlet UIButton   *_okButton;
}

@end

@implementation ResetPasswordVC



- (void)dealloc
{
    
    [ResetPasswoedRequest cancelUseDefaultSubjectRequest];
    
    RELEASE_SAFELY(_nePasswordText);
    RELEASE_SAFELY(_nePasswordAgainText);
    RELEASE_SAFELY(_okButton);
}

- (void)viewDidUnload
{
    
    [ResetPasswoedRequest cancelUseDefaultSubjectRequest];
    
    RELEASE_SAFELY(_nePasswordText);
    RELEASE_SAFELY(_nePasswordAgainText);
    RELEASE_SAFELY(_okButton);
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarTitle:@"重设密码"];
    [_okButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
}


-(id)initWithRetrievePasswordPhoneNumber:(NSString *) phoneNumber withResetPasswordWithType:(ResetPasswordWithType)passType{
    if (self = [super init])
    {
        _phoneNumber = phoneNumber;
        _passType = passType;
    }
    
    return self;
}
-(void)actionClickNavigationBarLeftButton{
    [ResetPasswoedRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

//完成
- (IBAction)completedAction:(UIButton *)sender {
    if ([self validateRegistInput])
    {
    
        [self sendCompleteRequestAction];
    }
    [self endEditing];
}

//密码输入验证
-(BOOL)validateRegistInput{
    if (!_nePasswordText.text.length || !_nePasswordAgainText.text.length)
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入新密码及确认新密码"];
        return NO;
    }
    if (![_nePasswordText.text isEqual:_nePasswordAgainText.text])
    {
        [BDKNotifyHUD showCryingHUDWithText:@"新密码和确认新密码不一致"];
        return NO;
    }
    if (_nePasswordText.text.length < 6 || _nePasswordText.text.length > 20) {
        [BDKNotifyHUD showCryingHUDWithText:@"密码应为6—20位数字或字母。"];
        return NO;
    }
    
    return YES;
}

//重置密码完成请求
-(void)sendCompleteRequestAction{
    
    [ResetPasswoedRequest requestWithParameters:@{@"mobile":_phoneNumber,@"password":_nePasswordText.text} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
        
            [BDKNotifyHUD showSmileyHUDWithText:@"密码修改成功" completion:^{
                if (_passType == ResetPasswordWithLoginType) {
                    NSInteger count = self.navigationController.viewControllers.count;
                    UIViewController *vc = (UIViewController*)self.navigationController.viewControllers[count -3];
                    [self.navigationController popToViewController:vc animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        
        }else{
            
            [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
    }];
}


@end


















