//
//  PayModeModel.h
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import "OptionsModel.h"

typedef enum
{
    PayModeUserAccount = 1, //用户余额
    PayModeAlipay      = 2, //支付宝
    PayModeUPPayPlugin = 3, //银联
    PayModeCod         = 4, //餐到付款
    PayModeWXPay       = 5, //微信支付
    PayModeDPay        = 6, //大众点评
    PayModeMTPay       = 7, //美团团购
    PayModeNMPay       = 8, //百度糯米
    
}PayModeType;


@interface PayModeModel : OptionsModel

@property (retain,nonatomic) NSString *pay_id;    //支付方式id
@property (retain,nonatomic) NSString *pay_name;  //支付方式名称
@property (retain,nonatomic) NSString *pay_code;  //支付code
@property (retain,nonatomic) NSString *user_money; //用户账号余额
@property (retain,nonatomic) NSString *is_default; //是否为默认支付方式

@end
