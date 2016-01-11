//
//  TakeOutOrderModel.h
//  Carte
//
//  Created by ligh on 14-5-14.
//
//

#import <UIKit/UIKit.h>
#import "DishOrderModel.h"

//	送餐：0等待付款	1等待确认	2商家确认	3商家拒绝	4送餐完成 5退款成功

typedef enum
{
    TakeOutSendOrderWaitPayStatus,//等待付款
    TakeOutSendOrderWaitConfirmStatus,//等待确认
    TakeOutSendOrderStoreConfirmStatus,//商家确认
    TakeOutSendOrderStoreRejectStatus,//商家拒绝
    TakeOutSendOrderSendCompletedStatus,//送餐完成
    TakeOutSendOrderRefundSuccesstatus,//退款成功
    TakeOutSendOrderTheRefund = 7//退款中

}TakeOutSendOrderStatus;//外卖送餐订单状态

//自提：0等待付款	1等待确认	2商家确认	3商家拒绝	4未到店自提	5已到店自提 6退款成功
typedef enum
{
    TakeOutSelfServiceOrderWaitPayStatus,//等待付款
    TakeOutSelfServiceWaitConfirmStatus,//等待确认
    TakeOutSelfServiceStoreConfirmStatus,//商家确认
    TakeOutSelfServiceStoreRejectStatus,//商家拒绝
    TakeOutSelfServiceNotMentionedStatus,//未到店自提
    TakeOutSelfServiceMentionedStatus,//已到店自提
    TakeOutSelfServiceOrderRefundSuccesstatus,//退款成功
    TakeOutSelfServiceOrderTheRefund = 7//退款中
    
}TakeOutSelfServiceOrderStatus;//外卖送餐订单状态

/**
 *  外卖订单mdoel
 */
@interface TakeOutOrderModel : DishOrderModel

//@property (retain,nonatomic) NSString *share_content;
@property (retain,nonatomic) NSNumber *send_type;//外卖类型1送餐2自提
@property (retain,nonatomic) NSString *send_address;	//送餐地址
@property (retain,nonatomic) NSString *send_time_rel;//送餐时间

//@property (retain,nonatomic) NSString *service; //服务费百分比
//@property (retain,nonatomic) NSString *service_money;//服务费金额
//@property (retain,nonatomic) NSString *box_price;//餐盒费
//@property (retain,nonatomic) NSString *send_price;//送餐费
@property (retain,nonatomic) NSString *is_cod; //货到付款


-(NSString *) sendTypeString;



-(NSString *)sendTimeOfForamtAndAppendWeekday;

@end
