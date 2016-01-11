//
//  DishOrderDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "DishOrderDetailsRequest.h"
#import "PayModeModel.h"
#import "ActivityModel.h"
#import "VoucherModel.h"

@implementation DishOrderDetailsRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=showOrder&"];
}


-(void)processResult
{    [super processResult];
    if (self.isSuccess)
    {
        DishOrderModel *dishOrderModel = [[DishOrderModel alloc] 
initWithDictionary:self.resultDic[@"data"]];
        dishOrderModel.orderType = DishOrderType;
        dishOrderModel.activitys =[NSMutableArray arrayWithCapacity:0];
        dishOrderModel.coupons = [NSMutableArray arrayWithCapacity:0];
        //活动
        NSArray *activityArray = self.resultDic[@"data"][@"activitys"];
        NSArray *couponsArray = self.resultDic[@"data"][@"coupons"];
        for (NSDictionary *activityDic in activityArray) {
            ActivityModel *activityModel = [[ActivityModel alloc]initWithDictionary:activityDic];
            [dishOrderModel.activitys addObject:activityModel];
        }
        //优惠劵
        for (NSDictionary *couponsDic in couponsArray) {
            VoucherModel *vouModel = [[VoucherModel alloc]initWithDictionary:couponsDic];
            [dishOrderModel.coupons addObject:vouModel];
           
        }
        
        //支付
        NSArray *paysJSONArray = self.resultDic[@"data"][@"pays"];
        NSMutableArray *paysArray = [NSMutableArray array];
        for ( id dic  in paysJSONArray) {
            PayModeModel *payModel = [[PayModeModel alloc] initWithDictionary:dic];
            if (payModel.pay_id.intValue == PayModeUserAccount) {
                payModel.user_money = self.resultDic[@"data"][@"user_money"];
            }
            [paysArray addObject:payModel];
           
        }
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:dishOrderModel forKey:KRequestResultDataKey];
        }
}


@end
