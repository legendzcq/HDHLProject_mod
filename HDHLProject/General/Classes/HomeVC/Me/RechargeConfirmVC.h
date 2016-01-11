//
//  RechargeConfirmVC.h
//  Carte
//
//  Created by hdcai on 15/4/27.
//
//

#import "BetterVC.h"
typedef enum
{
    RechargeConfirmWithRechargeType = 1,//由充值页进入
    RechargeConfirmWithRechargeRecoderType,    //由充值记录页进入
}RechargeConfirmWithType; //从哪进入充值确认页


@interface RechargeConfirmVC : BetterVC


-(id) initWithOrderID:(NSString *) order_id withRechargeConfirmWithType:(RechargeConfirmWithType)rechargeConfirmType;

@end
