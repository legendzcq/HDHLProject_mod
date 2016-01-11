//
//  RetrievePasswordVC.h
//  Carte
//
//  Created by user on 14-4-12.
//
//

#import "BetterVC.h"

/**
 *  找回密码
 */

@interface RetrievePasswordVC : BetterVC
@property (retain, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (retain, nonatomic) IBOutlet UITextField *verificationCodeText;
@property (retain, nonatomic) IBOutlet UILabel *buttonTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *getVarificationBtn;
@property (nonatomic,retain) NSTimer * countDomnTimer;
@property (nonatomic) NSInteger countDownNum;

- (IBAction)pushToResetPasswordAction:(UIButton *)sender;


- (IBAction)GetVerificationCodeAction:(UIButton *)sender;

@end
