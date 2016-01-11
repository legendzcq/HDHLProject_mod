//
//  LoginVC.h
//  Carte
//
//  Created by ligh on 14-4-9.
//
//

#import "BetterVC.h"

/**
 *  设置密码
 */
@interface SettingPasswordVC : BetterVC

@property (retain,nonatomic) NSString *birthDay;
@property (retain,nonatomic) NSString *gender;

-(id)initWithRegisterPhoneNumber:(NSString *)phoneNumber Verify:(NSString *)verify;


@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (retain, nonatomic) IBOutlet UITextField *passwordAgainText;


- (IBAction)completedAction:(UIButton *)sender;

@end
