//
//  DataKeyMacro.h
//  PMS
//
//  Created by ligh on 14/10/22.
//
//

#ifndef PMS_DataKeyMacro_h
#define PMS_DataKeyMacro_h


//没有活动内容的提示
#define kDefaultActivityContent @"当前没有活动内容！"
//没有选中支付方式的提示
#define kDefaultPayAlertContent @"请选择支付方式！"

#define ActivityTipViewPromptText @"请用团购代金券充值！团购充值不享受充值活动！"

//HTTP key
#define HTTP_AlbuminfoResultKey     @"AlbuminfoResultKey"
//Data Key
#define Store_UserInfoKey           @"UserInfoKey"//登录的用户缓存key
#define App_City_Key                @"city_key" //用户选择的城市

#define DayWeatherModekKey @"DayWeatherModekKey"
#define WeatherModelArray  @"WeatherModelArray"
#

#define KDeviceTokenKey            @"DeviceTokenKey" //设备token
#define kLoginTypeCodeKey          @"LoginTypeCodeKey" //单点登录唯一识别字段
#define KAddressListCacheKey       @"AddressListKey" //外卖地址缓存key
#define KDefaultStoreKey           @"DefaultStoreKey" //常用分店缓存key


#define ACTIVITYSHARE_KEY @"activityShare"
#define ACTIVITYSHARE_PARAMERKEY @"activityParmer"


#define KTakeOrderInfoResultRequest @"KTakeOrderInfoResultRequest"
#define KTakeOrderDateResultRequest @"TakeOrderDateResultRequest"
#define KTakeOrderMaxPerResultRequest @"TakeOrderMaxPerResultRequest"
#define KTakeOrderPayModeResultRequest @"TakeOrderPayModeResultRequest"
#define KTakeOrderVoucherModelResultRequest @"TakeOrderVoucherModelResultRequest"
#define KTakeOrderHourcesModelResultRequest @"TakeOrderHourcesModelResultRequest"
#define KTakeOrderSeatsModelResultRequest @"TakeOrderSeatsModelResultRequest"
#define KTakeOrderActivitiesResultRequest @"TakeOrderActivitiesResultRequest"
#define KTakeOrderGiftsResultRequest @"TakeOrderGiftsResultRequest"
#define KTakeOrderGoodsResultRequest @"TakeOrderGoodsResultRequest"


typedef enum
{
    SendOrder = 1,//送餐
    SelfServiceOrder = 2,//自提
    
}SendType;//送餐类型

typedef enum
{
    TakeOrderDefaultType = 2,//点菜
    TakeOrderOutType     = 4,//外卖
}TakeOrderType;//点菜外卖类型

typedef enum {
    SeatOrderType = 1,//订座订单
    DishOrderType = 2,//点菜订单
    GrouponOrderType = 3,//团购订单
    TakeOutOrderType = 4,//外卖订单
    
    OrderHistoryType = 5,//订单历史列表
    TakeOutHistoryType =6,  //外卖历史列表
    GrouponHistoryType =7 ,//团购历史列表
    SeatHistoryType   = 8   //订座历史列表
}OrderType;//订单类型

typedef enum
{
    
    StoreListBookSeatActionType  = 1, //订座
    StoreListTakeOrderActionType = 2, //点菜
    StoreListTakewayActionType   = 4, //外卖
    StoreListFromStoreDetailActionType   = 3, //由品牌首页进入
    StoreListFromVouchersDetailsTakeOrderType = 5,
    StoreListFromVouchersDetailsTakewayType = 6,
    StoreListNoneActionType      = 7, //
}StoreListActionType;

typedef enum
{
    DishOrderWaitPayStatus,//等待付款
    DishOrderNotCostStatus,//未消费
    DishOrderConsumptionStatus,//已消费
    DishOrderRefundStatus,//已退款
    DishOrderTheRefund = 7 //退款中
}DishOrderStatus;//点菜订单状态码

typedef enum
{
    OrderExpired = -1,//订单已过期
    
    WaitAlipayPaymentStatus = 201, //下单成功 等待使用支付宝支付
    WaitUPPayPaymentStatus  = 301, //下单成功 等待使用银联支付
    WaitWXPayPaymentStatus  = 501, //下单成功 等待使用微信支付
    WaitDZPayPaymentStatus  = 601, //下单成功 等待使用大众点评支付
    WaitMTPayPaymentStatus  = 701, //下单成功 等待使用美团团购支付
    WaitNMPayPaymentStatus  = 801, //下单成功 等待使用百度糯米支付
    
    HaveToPay = 2,//下单成功并且支付成功
    Balance = 3,//余额不足
    
}PayStatus;//支付方式状态码
typedef enum
{
    WaitPayUnValidationStatus = 0, //等待验证(未验)
    PayUnValidationStatus = 1 ,    //已支付(未验)/等待确认   付款中
    OrderFinshStatus = 2,          //商家确认              已付款
    StoreRefusedStatus =3 ,        //退款完成/商家拒绝
    OrderRefundFinshStatus =4,     //订单完成
    WaitPayValidationStatus = 5,   //等待付款(已验)/（退款完成）
    PayValidationStatus = 6 ,       //已支付(已验)
    OrderRefundingStatus =7,       //退款中
    OrderOverdueStatus  = 99,      //订单过期
    OrderCancleStatus =-1          //已取消
}OrderSeatStatus;
//枚举触发方法
typedef enum
{
    //订单管理
    EditOperationState = 0x01,
    DeleteOperationState =0x02,
    PayOperationState =0x03,
    //外卖管理
    ConfirmOperationState = 0x04,
    //订座管理
    OrderOperationState = 0x05,
    //分享
    ShareFriendOperationState =0x06,
    //打电话
    CallPhoneOperationState =0x07,
    //确认送达
    ConfirmDeliveryState = 0x08,
    //团购继续支付
    GroupBuyOperationState = 0x09,
    //查看验证码
    CheckCodeOperationState = 0x10,
    //取消订单
    CancelOrderOperationState=0x11,
    //联系商家
    LinkSalesOperationState
}OperationState;

typedef enum
{
    ExpenseUnUseStatus,//未使用
    ExpenseUsedStatus,//已使用
    ExpenseExpiredStatus,//已过期
    ExpenseDisableStatus,//已作废
    
}ExpenseStatus;//消费码状态
//分享渠道
typedef enum {
    ShareChannelTypeWXF        = 1,//微信好友
    ShareChannelTypeWXQ        = 2,//微信朋友圈
    ShareChannelTypeTencentQQ  = 3,//qq好友
    ShareChannelTypeSinaWB     = 4,//新浪微博
    ShareChannelTypeTencentWB  = 5,//腾讯微博
} ShareChannelType;

typedef enum
{
    GrouponOrderWaitPayStatus = 0,//等待付款
    GrouponOrderPayStatus = 1 ,//已支付
    GrouponOrderRefundStatus,//已退款
    GrouponOrderTheRefundStatus = 7//退款中
}GrouponOrderStatus;//团购订单状态码

#endif
