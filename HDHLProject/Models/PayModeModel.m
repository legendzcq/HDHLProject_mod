//
//  PayModeModel.m
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import "PayModeModel.h"

/**
 *  支付信息model
 */
@implementation PayModeModel

- (void)dealloc
{
    RELEASE_SAFELY(_pay_id);
    RELEASE_SAFELY(_pay_name);
    RELEASE_SAFELY(_pay_code);
    RELEASE_SAFELY(_user_money);
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.pay_id = [dict stringForKey:@"pay_id"];
        self.pay_name = [dict stringForKey:@"pay_name"];
        self.pay_code = [dict stringForKey:@"pay_code"];
        self.user_money = [dict stringForKey:@"user_money"];
        self.is_default = [dict stringForKey:@"username"];
    }
    return self;
}

- (NSString *)title
{
    //如果是支付宝
    if (_pay_id.intValue == PayModeAlipay)
    {
        return [_pay_name copy];
        
    }else if(_pay_id.intValue == PayModeUserAccount)
    {
        //显示金额
//        return [NSString stringWithFormat:@"%@ ￥%@",_pay_name,_user_money];
        return [_pay_name copy];
    }
    
    return [_pay_name copy];
}

- (NSInteger)actionTag
{
    return _pay_id.intValue;
}

@end
