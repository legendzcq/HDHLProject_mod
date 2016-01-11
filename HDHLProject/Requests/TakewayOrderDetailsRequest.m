//
//  TakewayOrderDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "TakewayOrderDetailsRequest.h"
#import "TakeOutOrderModel.h"

@implementation TakewayOrderDetailsRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=showOrder&"];
}


-(void)processResult
{
    [super processResult];
    
    if (self.isSuccess)
    {
        TakeOutOrderModel *takeOutOrderModel = [[TakeOutOrderModel alloc] initWithDictionary:self.resultDic[@"data"]];
        takeOutOrderModel.activitys = [NSMutableArray arrayWithCapacity:0];
        takeOutOrderModel.coupons = [NSMutableArray arrayWithCapacity:0];
        //活动
        NSArray *activityArray = self.resultDic[@"data"][@"activitys"];
        NSArray *couponsArray = self.resultDic[@"data"][@"coupons"];
        for (NSDictionary *activityDic in activityArray)
        {
            ActivityModel *activityModel = [[ActivityModel alloc]initWithDictionary:activityDic];
            [takeOutOrderModel.activitys addObject:activityModel];
        }
        //优惠劵
        for (NSDictionary *couponsDic in couponsArray)
        {
            VoucherModel *vouModel = [[VoucherModel alloc]initWithDictionary:couponsDic];
            [takeOutOrderModel.coupons addObject:vouModel];
        }
        
        takeOutOrderModel.orderType = TakeOutOrderType;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:takeOutOrderModel forKey:KRequestResultDataKey];
    }
}



@end
