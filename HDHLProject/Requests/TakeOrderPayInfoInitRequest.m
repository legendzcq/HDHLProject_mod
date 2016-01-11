//
//  TakeOrderPayInfoInitRequest.m
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import "TakeOrderPayInfoInitRequest.h"

@implementation TakeOrderPayInfoInitRequest

-(NSString *)getRequestUrl
{
     return [NSString stringWithFormat:@"api.php?apiUrl=payOrder&"];
}

-(void)processResult
{
    [super processResult];
    
    if (self.isSuccess)
    {
        
        //菜单信息
        OrderModel *orderModel = (OrderModel *)[OrderModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
        [self.resultDic setObject:orderModel forKey:KTakeOrderInfoResultRequest];
        if (orderModel.overtime.intValue == 1) {
            return;
        }
        
        //菜品 goods
        NSArray *goodsJSONModeArray = self.resultDic[@"data"][@"goods"];
        NSArray *goodsModeArray = [NSArray array];
        goodsModeArray = [GoodsModel reflectArrayWithInitWithDictionary:goodsJSONModeArray];
        [self.resultDic setObject:goodsModeArray forKey:KTakeOrderGoodsResultRequest];
        
        //支付方式
        NSArray *payJSONModeArray = self.resultDic[@"data"][@"pays"];
        NSArray *payModeArray = [NSArray array];
        payModeArray = [PayModeModel reflectObjectsWithArrayOfDictionaries:payJSONModeArray];
        //余额赋值
        NSMutableArray *payModeArray2 = [NSMutableArray array];
        for (PayModeModel *model in payModeArray) {
            if (model.pay_id.intValue == PayModeUserAccount) {
                model.user_money = self.resultDic[@"data"][@"user_money"];
            }
            [payModeArray2 addObject:model];
        }
        [self.resultDic setObject:payModeArray2 forKey:KTakeOrderPayModeResultRequest];
        
        //优惠券
        CouponsTotalModel *couponsTotalModel = (CouponsTotalModel *)[CouponsTotalModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
        [self.resultDic setObject:couponsTotalModel forKey:KTakeOrderVoucherModelResultRequest];
        
        //活动
        id activityJSONArray = self.resultDic[@"data"][@"activitys"];
        NSArray *activityrModelArray = [NSArray array];
        activityrModelArray = [ActivityModel reflectObjectsWithArrayOfDictionaries:activityJSONArray];
        [self.resultDic setObject:activityrModelArray forKey:KTakeOrderActivitiesResultRequest];
        
    }
}

@end
