//
//  DishOrderModel.h
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "OrderModel.h"
#import "GoodsModel.h"
#import "GiftModel.h"
#import "ActivityModel.h"
#import "VoucherModel.h"

/**
 *  菜品订单
 */
@interface DishOrderModel : OrderModel
//activitys
@property (retain,nonatomic) NSArray *goods;//点菜清单
@property (retain,nonatomic) NSArray *gifts;//赠品
@property (retain,nonatomic) NSMutableArray*activitys;//参加的活动
@property (retain,nonatomic) NSMutableArray *coupons;//此订单使用的代金劵
@property (retain,nonatomic) NSString *change_number;//
@property (retain,nonatomic) NSArray *goods_return;//退款菜品

@property (retain,nonatomic) NSNumber *refund_money; //退款总额
@property (retain,nonatomic) NSNumber *refund_service;// 退的服务费
@property (retain,nonatomic) NSNumber *coupon_type;//判断代金券类型
@property (retain,nonatomic) NSString *user_money;

//@property (retain,nonatomic) NSString *service; //服务费百分比
//@property (retain,nonatomic) NSString *service_money;//服务费金额
@property (retain,nonatomic) NSString *share_content;

- (NSString *)totalCartePrice;
//@property (retain,nonatomic) NSArray *pays;

@end
