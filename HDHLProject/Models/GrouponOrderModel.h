//
//  GrouponOrderModel.h
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "BaseModelObject.h"
#import "GrouponStoreModel.h"
#import "OrderModel.h"
#import "ExpenseCodeModel.h"

/**
 *  团购订单model
 */
@interface GrouponOrderModel : OrderModel

@property (retain,nonatomic) NSString *groupon_name;//团购名称
@property (retain,nonatomic) NSNumber *market_price;//		市场价
@property (retain,nonatomic) NSNumber *shop_price;//团购总价
@property (retain,nonatomic) NSString *endtime;//有效期
@property (retain,nonatomic) NSString *groupon_id;//团购id
@property (retain,nonatomic) NSString *notice;//消费须知
@property (retain,nonatomic) NSString *groupon_introduction;
@property (retain,nonatomic) NSNumber *store_number;
@property (retain,nonatomic) NSArray  *groupon_store;//支持的商家
@property (retain,nonatomic) NSNumber  *store_more;
@property (retain,nonatomic) NSArray  *expenseArray; //团购卷消费码数组 (ExpenseCodeModel)
@property (retain,nonatomic) NSNumber *order_num;

@property (retain,nonatomic) NSNumber  *is_cancel;//is_refund 是1否0能撤销订单

@property (retain,nonatomic) NSNumber *sales;//团购数量
@property (retain,nonatomic) NSNumber *surplus_day;//剩余天数/-1未开始/-2过期
//@property (retain,nonatomic) NSNumber *store_total;//参与团购的数量（几个店通用）

@property (retain,nonatomic) StoreModel *store;//支持的分店

@property (retain,nonatomic) NSString *share_content;

-(NSString *)endtimeOfForamt;
- (NSString *)GroupBuyendTimeOfForamt;
@end
