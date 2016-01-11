//
//  PayResultModel.h
//  Carte
//
//  Created by ligh on 15-5-7.
//
//

#import "BaseModelObject.h"

@interface PayResultModel : BaseModelObject

@property (nonatomic, strong) NSString *add_result;   //支付方式
@property (nonatomic, strong) NSString *order_amount; //支付金额
@property (nonatomic, strong) NSString *order_sn;     //支付订单号
@property (nonatomic, strong) NSString *order_id;   //支付订单号3.0
//微信支付字段
@property (nonatomic,retain) NSDictionary *wxpay_result;

@end
