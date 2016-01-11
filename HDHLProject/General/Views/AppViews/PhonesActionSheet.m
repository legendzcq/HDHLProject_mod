//
//  PhonesActionSheet.m
//  PMS
//
//  Created by ligh on 14-8-13.
//
//

#import "PhonesActionSheet.h"

@interface PhonesActionSheet() {
    IBOutlet UIControl *_backgroundView;
    IBOutlet UIView    *_actionView;
    IBOutlet UIButton  *_cancelButton;
}
@end

@implementation PhonesActionSheet

- (void)installDataWithPhoneString:(NSString *)phoneString {
    NSArray *phoneNumberArray = [PhoneNumberHelper parseText:phoneString];
    
    float y = MARGIN_L;
    
    for (NSString *phoneNumber in phoneNumberArray) {
        UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneButton setBackgroundImage:UIImageForName(@"bg2_nav") forState:UIControlStateNormal];
        [phoneButton setTitle:phoneNumber forState:UIControlStateNormal];
        [phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        phoneButton.titleLabel.font = FONT_M;
        phoneButton.frame = CGRectMake(30, y, 260, 44);
        y = phoneButton.bottom + MARGIN_M;
        [phoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        
        [_actionView addSubview:phoneButton];
    }
    _cancelButton.top = y;
    _actionView.height = _cancelButton.bottom+MARGIN_M;
}

- (void)callPhone:(UIButton *)sender {
    [PhoneNumberHelper callPhoneWithText:sender.titleLabel.text];
    [self dismiss:YES];
}

- (void)showInView:(UIView *)inView phoneString:(NSString *)phoneString {
    [self installDataWithPhoneString:phoneString];

    _backgroundView.alpha = 0;
    _actionView.top = self.height;
    self.height = inView.height;
    [inView addSubview:self];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _backgroundView.alpha = 0.6;
    _actionView.top = self.height - _actionView.height;
    [UIView commitAnimations];
}

- (void)dismiss:(BOOL)isRemove {
    [UIView animateWithDuration:0.3 animations:^{
        
        _backgroundView.alpha = 0;
        _actionView.top = self.height;
    } completion:^(BOOL finished) {
        if (isRemove) {
            [self removeFromSuperview];
        }
    }];
}

//点击背景 关闭
- (IBAction)touchuBackgroundView:(id)sender {
    [self dismiss:YES];
}

//取消
- (IBAction)cancelAction:(id)sender {
    [self dismiss:YES];
}

@end
