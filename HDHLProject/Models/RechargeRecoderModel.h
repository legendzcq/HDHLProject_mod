//
//  RechargeRecoderModel.h
//  Carte
//
//  Created by ligh on 15-1-7.
//
//

//充值记录

#import "BaseModelObject.h"

@interface RechargeRecoderModel : BaseModelObject

@property (retain,nonatomic) NSString *activity_id;  //活动id
@property (retain,nonatomic) NSString *addtime;      //充值时间
@property (retain,nonatomic) NSString *payment_id;   //充值方式id
@property (retain,nonatomic) NSString *payment;      //充值方式名称
@property (retain,nonatomic) NSString *amount;       //充值金额
@property (retain,nonatomic) NSString *process_type; //0，预付费，其实就是充值；1，提现；2，退菜退款；3.消费
@property (retain,nonatomic) NSString *order_amount;
@property (retain,nonatomic) NSString *pay_name;
@property (retain,nonatomic) NSString *pay_time;
@property (retain,nonatomic) NSString *order_id;
@property (retain,nonatomic) NSString *is_success;
@property (retain,nonatomic) NSString *brand_name;
@end
