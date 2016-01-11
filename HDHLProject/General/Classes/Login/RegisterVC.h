//
//  RegisterVC.h
//  Carte
//
//  Created by user on 14-4-12.
//
//

#import "BetterVC.h"

/**
 *  注册
 */

@interface RegisterVC : BetterVC
@property (retain, nonatomic) IBOutlet UITextField *nePhoneNumberText;
@property (retain, nonatomic) IBOutlet UITextField *verificationCodeText;
@property (retain, nonatomic) IBOutlet UIButton *getVerificationBtn;
@property (retain, nonatomic) IBOutlet UILabel *buttonTitleLabel;
@property (nonatomic,retain) NSTimer * countDownTimer;

- (IBAction)PushToSettingPasswordAction:(UIButton *)sender;
- (IBAction)GetVerificationCodeAction:(UIButton *)sender;

@end
