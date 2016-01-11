//
//  SeatOrderModel.h
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "BaseModelObject.h"
#import "PayModeModel.h"
#import "StoreModel.h"
#import "GoodsModel.h"

typedef enum
{
    SeatOrderWaitConfirmStatus = 0,//等待确认
    SeatOrderStoreCancelStatus = 1,//用户取消
    SeatOrderUserCanceledStatus = 4,//用户取消（已接受）
    SeatOrderBookSuccessStatus = 2,//订座成功
    SeatOrderStoreRefusalStatus = 3,//商家拒绝
//    SeatOrderStoreCancelStatus,//商家取消
//    SeatOrderTheRefund = 7//退款中
}SeatOrderStatus;//订座订单状态码


/**
 *  座位订单
 */
@interface OrderModel : BaseModelObject

//2.0_POS用到
@property (retain,nonatomic) NSString *payPriceString;  //最终价格
@property (assign,nonatomic) CGFloat   couponsTotalPay; //优惠券总额
@property (assign,nonatomic) BOOL      isExit; //YES 共享，活动代金券都可选
@property (retain,nonatomic) NSString *goods_count;//菜单数量

@property (nonatomic,retain) NSString *pay_status; //支付状态
@property (retain,nonatomic) NSString *order_sn;//订单id（服务器id）
@property (retain,nonatomic) NSString *order_id;//订单编号
@property (retain,nonatomic) NSString *store_id;//分店id
@property (retain,nonatomic) NSString *store_name;//分店名称
@property (retain,nonatomic) NSString *address;//详细地址
@property (retain,nonatomic) NSString *image_big;//分店图片
@property (retain,nonatomic) NSString *image_small;//分店缩略图
@property (retain,nonatomic) NSString *order_time;//订单消费日期
@property (retain,nonatomic) NSString *order_status;//订单状态
@property (retain,nonatomic) NSString *order_amount;//订单金额
@property (retain,nonatomic) NSString *order_man;//订座人数
@property (retain, nonatomic) NSString *phone;    //店铺电话


@property (retain,nonatomic) NSString *payment_name;//支付名称
@property (retain,nonatomic) NSString *pay_time;//支付时间
@property (retain,nonatomic) NSString *addtime;//下单时间
@property (retain,nonatomic) NSString *expense_sn;//消费吗
@property (retain,nonatomic) NSString *expense_sn_status;//小费码状态
@property (retain,nonatomic) NSString *invoice;//是否开发票
@property (retain,nonatomic) NSString *invoice_title;//发票抬头
@property (retain,nonatomic) NSString *content;//菜品备注

@property (retain,nonatomic) NSString *coupon_amount; //  使用的代金券总价格
@property (retain,nonatomic) NSString *amount_dec; //  活动减免

@property (retain,nonatomic) NSString *service_money; //服务费
@property (retain,nonatomic) NSString *service;       //服务费收费比例
@property (retain,nonatomic) NSString *box_price;     //外卖 餐盒费
@property (retain,nonatomic) NSString *send_price;    //外卖 送餐费

@property (retain,nonatomic) NSString *user_name;//用户名
@property (retain,nonatomic) NSString *user_mobile; //用户联系方式

@property (retain,nonatomic) StoreModel *storeModel;
@property (retain,nonatomic) NSString   *brand_id; //品牌id
@property (retain,nonatomic) NSString   *brand_name; //品牌名

@property (nonatomic,strong) NSString * seat_name;//订座类型
@property (retain,nonatomic) NSArray *pays;

//是否绑定支付
@property (nonatomic,retain) NSString *bind_pay;
PROPERTY_ASSIGN NSString *overtime; //是否过期 1 是，0 不是

//订单类型
@property (nonatomic,retain) NSString  *order_type;
@property (assign,nonatomic) OrderType  orderType;

@property (assign,nonatomic) BOOL isHistoryOrder;
-(NSDateComponents *) componentsWithOrderTime:(double) timestamp;

-(NSString *) orderTimeOfForamtAndAppendWeekday;
-(NSString *) orderTimeOfForamt;
-(NSString *) payTimeOfForamt;
-(NSString *) addTimeOfForamt;
-(NSString *) outOrderTimeOfForamt;


//消费码是否可用
-(BOOL) enableOfExpenseSN;
-(NSString *) expenseSNString;
-(NSString *) expenseSNString2;
-(NSString *) orderStatusString;
-(NSString *) expense_snOfFormat;

//是否可以撤销退款
-(BOOL) isCancelOrder;
//是否可以 继续支付
-(BOOL) isAgainPay;
//订单过期
- (BOOL)isOrderExpired;

//退款中
- (BOOL)isOrderRefund;
//已退款
- (BOOL)isOrderRefunded;

- (Product *) convert2ProductInfo;

//菜品信息转成json串
- (NSString *)goodsJSONString:(NSArray *)goodsArray;
//支付宝订单转换
- (Product *)generateProductInfo:(NSArray *)goodsArray;
//得到所有菜品数量
- (int)ordersTotalWithArray:(NSArray *)goodsArray ;

@end
