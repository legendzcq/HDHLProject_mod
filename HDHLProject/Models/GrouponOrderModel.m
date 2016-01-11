//
//  GrouponOrderModel.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "GrouponOrderModel.h"

@implementation GrouponOrderModel


- (void)dealloc
{
    RELEASE_SAFELY(_groupon_name);
    RELEASE_SAFELY(_shop_price);
    RELEASE_SAFELY(_endtime);
    RELEASE_SAFELY(_groupon_id);
    RELEASE_SAFELY(_notice);
    RELEASE_SAFELY(_groupon_store);
    RELEASE_SAFELY(_is_cancel);
    RELEASE_SAFELY(_expenseArray);
    RELEASE_SAFELY(_market_price);
    RELEASE_SAFELY(_sales);
    RELEASE_SAFELY(_surplus_day);
    RELEASE_SAFELY(_store_number);
    RELEASE_SAFELY(_share_content);
}



-(id) initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
//
//        //团购分店
        NSArray *grouponJSONArray = dict[@"groupon_store"];
        NSMutableArray *grouponArray = [NSMutableArray array];
        for (id eachGrouponStoreJSONDic in grouponJSONArray)
        {
            GrouponStoreModel *storeModel = [[GrouponStoreModel alloc] initWithDictionary:eachGrouponStoreJSONDic];
            [grouponArray addObject:storeModel];
        }
//
        self.groupon_store = grouponArray;
        
        
        //团购劵代码
        NSArray *expenseSNJsonArray =  dict[@"expense"];
        NSMutableArray *expenseCodeModelArray = [NSMutableArray array];
    
        if ([expenseSNJsonArray isKindOfClass:[NSArray class]])
        {
            for (id expenseSNJsonDic in expenseSNJsonArray)
            {
                ExpenseCodeModel *expenseCodeModel = [[ExpenseCodeModel alloc] initWithDictionary:expenseSNJsonDic];
                [expenseCodeModelArray addObject:expenseCodeModel];
            }
        }
//
        self.expenseArray = expenseCodeModelArray;
 
        
    }
    return self;
}
-(NSString *)endtimeOfForamt
{
    return [NSDate stringOfDefaultFormatWithInterval:[_endtime doubleValue]];
}


-(BOOL)enableOfExpenseSN
{
    int orderStatusIntValue = self.order_status.intValue;
    return [super enableOfExpenseSN] && (  orderStatusIntValue == GrouponOrderPayStatus );

}

-(NSString *)orderStatusString
{
    //0等待付款	1已付款	  2退款成功
    int orderStatusIntValue = self.order_status.intValue;
    
    if (orderStatusIntValue == GrouponOrderWaitPayStatus)
    {
        return @"等待付款";
        
    } else if (orderStatusIntValue == GrouponOrderPayStatus)
    {
        return @"购买成功";
        
    }else if(orderStatusIntValue == GrouponOrderRefundStatus)
    {
         return @"已退款";
        
    }else if(orderStatusIntValue == GrouponOrderTheRefundStatus)
    {
        return @"退款中";
    }
    
    return @"";
}

-(BOOL)isCancelOrder
{
    int orderStatusIntValue = self.order_status.intValue;
    //如果已付款 并且可以取消订单
    return  (orderStatusIntValue == GrouponOrderPayStatus && _is_cancel.intValue == 1);
}
- (NSString *)GroupBuyendTimeOfForamt
{
    return [[NSDate dateWithTimeIntervalSince1970:[_endtime doubleValue]] stringWithFormat:@"yyyy-MM-dd HH:mm"];
}
-(BOOL)isAgainPay
{
    int orderStatusIntValue = self.order_status.intValue;
    
    return orderStatusIntValue == GrouponOrderWaitPayStatus;
}



@end
