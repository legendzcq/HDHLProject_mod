//
//  DishOrderModel.m
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "DishOrderModel.h"


@implementation DishOrderModel

- (void)dealloc
{
    RELEASE_SAFELY(_goods);
    RELEASE_SAFELY(_goods_return);
    RELEASE_SAFELY(_gifts);
    RELEASE_SAFELY(_user_money);
    RELEASE_SAFELY(_share_content);
}
- (NSString *)totalCartePrice
{
    double totatlPrice = 0.00;
    for (GoodsModel *model in self.goods) {
        totatlPrice +=  [model.goods_number doubleValue] *[model.goods_price doubleValue];
    }
    if(totatlPrice==(int)totatlPrice){
        return [NSString stringWithFormat:@"￥%d",(int)totatlPrice];
    }
    return [NSString stringWithFormat:@"￥%.2f",totatlPrice];
}


-(id)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
        //购买的清单
        NSArray *productJSONArray = dict[@"goods"];
        NSMutableArray *productArray = [NSMutableArray arrayWithCapacity:10];
        
        if (productJSONArray && productJSONArray.count)
        {
            for (id productDic in productJSONArray)
            {
                GoodsModel *productModel = [[GoodsModel alloc] initWithDictionary:productDic];
                [productArray addObject:productModel];
            }
        }
        
        self.goods = productArray;
        
        //购买的清单
        NSArray *returnGoodsJSONArray = dict[@"goods_return"];
        NSMutableArray *returnGoodstArray = [NSMutableArray arrayWithCapacity:10];
        
        if (returnGoodsJSONArray && returnGoodsJSONArray.count)
        {
            for (id productDic in returnGoodsJSONArray)
            {
                GoodsModel *productModel = [[GoodsModel alloc] initWithDictionary:productDic];
                [returnGoodstArray addObject:productModel];
            }
        }
        
        self.goods_return = returnGoodstArray;
        
        //赠品
        NSArray *giftsJSONArray = dict[@"gift"];
        NSMutableArray *giftsModelArray = [NSMutableArray arrayWithCapacity:10];
        
        if (giftsJSONArray && giftsJSONArray.count)
        {
            for (id giftDic in giftsJSONArray)
            {
                GiftModel *giftModel = [[GiftModel alloc] initWithDictionary:giftDic];
                [giftsModelArray addObject:giftModel];
            }
        }
        self.gifts = giftsModelArray;
        
        //此订单参加的活动
        NSArray *activityJSONArray = dict[@"activitys"];
        NSMutableArray *activityrModelArray = [NSMutableArray array];
        for (id actitiyModelJSON in activityJSONArray)
        {
            ActivityModel *activityModel = [[ActivityModel alloc] initWithDictionary:actitiyModelJSON];
            [activityrModelArray addObject:activityModel];
        }
        
        self.activitys = activityrModelArray;
        
        
        //此订单使用的代金劵
        NSArray *voucherJSONModeArray = dict[@"coupon_list"];
        NSMutableArray *voucherModelArray = [NSMutableArray array];
        for (id voucherModelJSON in voucherJSONModeArray)
        {
            VoucherModel *voucherModel = [[VoucherModel alloc] initWithDictionary:voucherModelJSON];
            [voucherModelArray addObject:voucherModel];
        }
        
        self.coupons = voucherModelArray;
        
        
    }
    return self;
}


-(BOOL)enableOfExpenseSN
{
 
    int codeIntValue = [self.order_status intValue];
    
    return [super enableOfExpenseSN] && (codeIntValue == DishOrderNotCostStatus);

}

//WaitPayUnValidationStatus = 0, //等待付款(未验)
//PayUnValidationStatus = 1 ,    //已支付(未验)/等待确认
//OrderFinshStatus = 2,          //  确认
//StoreRefusedStatus =3 ,        //退款完成/商家拒绝
//OrderRefundFinshStatus =4,     //订单完成
//WaitPayValidationStatus = 5,   //等待付款(已验)/（退款完成）
//PayValidationStatus = 6 ,       //已支付(已验)
//OrderRefundingStatus =7,       //退款中
//OrderOverdueStatus  = 99      //订单过期





//已支付 等待消费
-(BOOL)isCancelOrder
{
    int orderStatusIntValue = self.order_status.intValue;
    
    return orderStatusIntValue == DishOrderNotCostStatus;

}

//继续支付
-(BOOL)isAgainPay
{
    int orderStatusIntValue = self.order_status.intValue;
    
    return orderStatusIntValue == DishOrderWaitPayStatus;
}

//订单过期
- (BOOL)isOrderExpired
{
    int orderStatusIntValue = self.order_status.intValue;
    return orderStatusIntValue == DishOrderRefundStatus;
}

//退款中
- (BOOL)isOrderRefund
{
    int orderStatusIntValue = self.order_status.intValue;
    return orderStatusIntValue == DishOrderTheRefund;
}

//已退款
- (BOOL)isOrderRefunded
{
    int orderStatusIntValue = self.order_status.intValue;
    return orderStatusIntValue == DishOrderRefundStatus;
}

@end
