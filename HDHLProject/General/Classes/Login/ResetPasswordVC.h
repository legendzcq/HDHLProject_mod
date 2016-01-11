//
//  ResetPasswordVC.h
//  Carte
//
//  Created by user on 14-4-12.
//
//

#import "BetterVC.h"
/**
 *  重设密码
 */
typedef enum
{
    ResetPasswordWithLoginType = 1,//由登陆页忘记密码
    ResetPasswordWithSettingType,    //由个人设置修改密码
}ResetPasswordWithType; //优惠券类型


@interface ResetPasswordVC : BetterVC
@property (retain, nonatomic) IBOutlet UITextField *nePasswordText;
@property (retain, nonatomic) IBOutlet UITextField *nePasswordAgainText;

- (IBAction)completedAction:(UIButton *)sender;


-(id)initWithRetrievePasswordPhoneNumber:(NSString *) phoneNumber withResetPasswordWithType:(ResetPasswordWithType) passType;

@end
