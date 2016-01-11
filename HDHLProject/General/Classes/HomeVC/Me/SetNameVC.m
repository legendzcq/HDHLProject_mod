//
//  SetNameVC.m
//  Carte
//
//  Created by zln on 14/12/12.
//
//

#import "SetNameVC.h"
#import "ModifyNickNameRequest.h"

@interface SetNameVC ()
{
    NSString *text;
}

@end


@implementation SetNameVC


- (void)dealloc {
    
    RELEASE_SAFELY(_nameTextField);
    RELEASE_SAFELY(text);
}
- (void)viewDidUnload {
    
    RELEASE_SAFELY(_nameTextField);
    RELEASE_SAFELY(text);
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBarView setNavigationBarTitle:@"名字"];
    
    _nameTextField.text = [AccountHelper userInfo].username;
    [self setRightNavigationBarButtonStyle:UIButtonStyleISSave];
    self.navigationBarView.rightBarButton.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    text = [[NSString alloc] initWithString:_nameTextField.text];
    
    [_nameTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:_nameTextField];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//姓名保存信息
- (void)actionClickNavigationBarRightButton
{
    [_nameTextField resignFirstResponder];
    
    [self sendRequestOfModifyUserName];
    
}

#pragma mark UITextFieldDelegate nickname
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"亲昵称不能为空哦"];
        return NO;
    }
    
    textField.tag = 1;
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }else if (_nameTextField.text.length >=8 && range.length < 1){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - NSNotification

- (void)fieldTextChanged:(NSNotification *)notification
{
    _nameTextField = (UITextField *)notification.object;
    
    NSString *toBeString = _nameTextField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_nameTextField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [_nameTextField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 8) {
                _nameTextField.text = [toBeString  substringWithRange:NSMakeRange(0,8)];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 8) {
            _nameTextField.text = [toBeString  substringWithRange:NSMakeRange(0,8)];
        }
    }
}

//发送修改用户昵称请求
-(void) sendRequestOfModifyUserName
{
    [ModifyNickNameRequest requestWithParameters:@{@"user_id":[AccountHelper uid] , @"username":_nameTextField.text}
                               withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             
             [BDKNotifyHUD showSmileyHUDInView:self.view text:@"保存成功"];
             
             UserModel *userInfo = [AccountHelper userInfo];
             userInfo.username = _nameTextField.text;
             [AccountHelper saveUserInfo:userInfo];
             [[NSNotificationCenter defaultCenter]postNotificationName:kUserInfoChangedNotification object:nil];
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
             [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败"];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败"];
     }];
}

@end

