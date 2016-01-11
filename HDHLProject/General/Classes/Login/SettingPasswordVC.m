//
//  LoginVC.m
//  Carte
//
//  Created by ligh on 14-4-9.
//
//

#import "SettingPasswordVC.h"
#import "RegisterRequest.h"
#import "RegisterVC.h"
#import "AccountHelper.h"
#import "UserModel.h"

#import "UploadDeviceTokenRequest.h"

@interface SettingPasswordVC ()
{
    IBOutlet UIButton *okButton;
    NSString *_phoneNumber;
    NSString *_verify;
}
@end

@implementation SettingPasswordVC


- (void)dealloc {
    
    RELEASE_SAFELY(_passwordText);
    RELEASE_SAFELY(_passwordAgainText);
    
    RELEASE_SAFELY(_phoneNumber);
    RELEASE_SAFELY(_gender);
    RELEASE_SAFELY(_birthDay);
}
- (void)viewDidUnload {
    
    RELEASE_SAFELY(_birthDay);
    RELEASE_SAFELY(_gender);
    RELEASE_SAFELY(_passwordText);
    RELEASE_SAFELY(_passwordAgainText);
    [super viewDidUnload];
}

-(void)actionClickNavigationBarLeftButton
{
    [RegisterRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

-(id)initWithRegisterPhoneNumber:(NSString *)phoneNumber Verify:(NSString *)verify
{
    if (self = [super init])
    {
        _phoneNumber = [phoneNumber copy];
        _verify = [verify copy];
    }
    
    return self;
}


-(void)configViewController
{
    [super configViewController];
    
    [self setNavigationBarTitle:@"设置密码"];
}

//完成
- (IBAction)completedAction:(UIButton *)sender {
    
    if (![self validateRegistInput])
    {
        return;
    }
    
    [self sendRegisterRequest];
    [self endEditing];
}


-(BOOL)validateRegistInput{
    if (!_passwordText.text.length || !_passwordAgainText.text.length)
    {
        [BDKNotifyHUD showVexedlyHUDWithText:@"请输入密码及确认密码"];
        return NO;
    }
    if (![_passwordText.text isEqual:_passwordAgainText.text])
    {
        [BDKNotifyHUD showCryingHUDWithText:@"密码和确认密码不一致"];
        return NO;
    }
    if (_passwordText.text.length < 6 || _passwordText.text.length > 20) {
        [BDKNotifyHUD showCryingHUDWithText:@"密码应为6—20位数字或字母。"];
        return NO;
    }
    return YES;
}

-(void)sendRegisterRequest{
    //时间戳
    [AccountHelper saveLoginTypeCode];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_phoneNumber forKey:@"mobile"];
    [params setObject:_passwordText.text forKey:@"password"];
    if (_gender) {
        [params setObject:_gender forKey:@"gender"];
    }
    if (_birthDay) {
        [params setObject:_birthDay forKey:@"birthday"];
    }
    if (_verify) {
        [params setObject:_verify forKey:@"verify"];
    }
    
    NSString *deviceToken = [NSString stringWithFormat:@"%@",[[DataCacheManager sharedManager] getCachedObjectByKey:KDeviceTokenKey]];
    if (deviceToken)
    {
        [params setObject:deviceToken forKey:@"device_token"];
    }
    [RegisterRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request){
        
        if (request.isSuccess) {
            
            UserModel *userModel = request.resultDic[KRequestResultDataKey];
            [AccountHelper saveUserInfo:userModel];
            [BDKNotifyHUD showSmileyHUDWithText:@"注册并登录成功" completion:^{
        
                if(![[AccountStatusObserverManager shareManager] postNotifyWithAcconutStatusType:LoginSuccess])
                {
                    //再次登录发出通知//注册成功登陆也发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:self];
                    NSInteger count = self.navigationController.viewControllers.count;
                    UIViewController *vc = (UIViewController*)self.navigationController.viewControllers[count -4];
                    [self.navigationController popToViewController:vc animated:YES];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
            if ([[DataCacheManager sharedManager] getCachedObjectByKey:KDeviceTokenKey]) {
                [UploadDeviceTokenRequest requestWithParameters:@{@"user_id":([AccountHelper uid]==nil) ? @"":[AccountHelper uid],@"device_tokens":[[DataCacheManager sharedManager] getCachedObjectByKey:KDeviceTokenKey],@"device_tokens_from":@"1"} withIndicatorView:nil onRequestFinished:^(ITTBaseDataRequest *request) {
                    
                } onRequestFailed:^(ITTBaseDataRequest *request) {
                    
                }];
            }
        }else
        {
            [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
        }
     
    }onRequestFailed:^(ITTBaseDataRequest *request){
        [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
    }];
}

@end




















