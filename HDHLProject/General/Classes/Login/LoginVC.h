//
//  LoginVC.h
//  Carte
//
//  Created by user on 14-4-11.
//
//

#import "BetterVC.h"
#import "UploadDeviceTokenRequest.h"

/**
 *  登录
 */

@interface LoginVC : BetterVC

@property (retain, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (assign, nonatomic) BOOL   boolSingleSignOn;
- (IBAction)ForgetPasswordAction:(UIButton *)sender;
- (IBAction)RegisterAction:(UIButton *)sender;
- (IBAction)LoginAction:(UIButton *)sender;

@end
