//
//  ShoopCartHelper.h
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import <Foundation/Foundation.h>
#import "SendRulesModel.h"
#import "GoodsCategoryModel.h"
#import "StoreModel.h"


/**
 购物车助手 计算商品总价 商品折扣 商品支付信息
 **/
@interface ShoopCartPayInfo : NSObject

@property (retain,nonatomic) NSString *orderId;         //订单id
@property (retain,nonatomic) NSString *couponsString;   //优惠券id字段串
@property (assign,nonatomic) CGFloat   couponsTotalPay; //优惠券总额
@property (retain,nonatomic) NSString *payPriceString;  //最终价格
@property (assign,nonatomic) BOOL      isExit; //YES 共享，活动代金券都可选

    @property (assign,nonatomic) float  service_shopprice;//服务器返回的支付金额
    @property (assign,nonatomic) float  shop_price;//菜品金额 未计算活动折扣和代金劵
    @property (assign,nonatomic) float  discount_price;//折扣总额
    @property (assign,nonatomic) int    product_count;//购买的产品数量
    @property (assign,nonatomic) float  market_price; //市场价格 包括餐费 送餐费（自提没有送餐费）
    @property (assign,nonatomic) float  goodsAmount;//菜品的金额 （只计算菜品价格）

    @property (assign,nonatomic) float  service_money; //服务费
    @property (assign,nonatomic) float  service_money_scale; //服务费收费比例

//POS系统用到
@property (retain,nonatomic) NSString *productPayString; //支付金额 订单确认页会用到

    //用户使用的代金劵
    @property (retain,nonatomic) NSArray   *voucherModelArray;
//用户参加的活动（只是参加的，不是全部活动）
@property (retain,nonatomic) NSArray   *activitysModelArray;

    @property (retain,nonatomic) NSString *payInfoString;//支付信息描述 根据规则计算分类下已选中商品的支付信息描述 包含支付金额 折扣 共计菜

    //业务信息
    @property (retain,nonatomic) NSMutableArray *productArray;//购买的产品列表
    @property (retain,nonatomic)  StoreModel *storeModel;//商家信息
    @property (assign,nonatomic) float original_shopprice;//原shopprice
    @property (assign,nonatomic) SendRulesModel *sendRuelsModel ;//原shopprice

    @property (assign,nonatomic) SendType  sendType;//自提还是送餐
    @property (assign,nonatomic) TakeOrderType  takeOrderType;//外卖还是点菜


//HDCAI 3.0
@property (nonatomic, assign) BOOL isHaveLogin; //点菜时是否已经登录 YES：是
@property (nonatomic, strong) NSString *totalcount; //点菜总数量



    //生成支付宝支付信息
    - (Product *)generateProductInfo;

    //--传给服务器---//
    -(NSString *) goodsJSONString;//选择的菜品ison字符串
    -(NSString *) voucherJSONString;//使用的代金劵json字符串
- (NSString *)activitysJSONString;//活动json字符串

    //用户下单支付时 请使用此方法完成支付 （这个是实际应该支付的金额 已计算活动折扣和代金劵 ）
    -(float)      payPrice;

    -(float)      sendMoney;//送餐费
    -(float)      box_money;//餐盒费

    //根据目前购物车的商品计算支付信息
    -(void) calculatePayInfo;

//刷新所有菜品（selectedNumber 的设定）
+ (NSArray *)filterGoodsCategoryArray:(NSArray *)goodsCategoryArray;
//刷新选中菜品（array2:为原始数据(所有菜品)---count 字段控制选中的数量
+ (NSMutableArray *)filterSelectedArrayFromGoodsCategoryArray2:(NSArray *)array2;

+ (NSMutableArray *)filterSelectedWithGoodsCategoryArray:(NSArray *) goodsCategoryArray;
//清空选中的菜品
+ (NSMutableArray *)clearFilterSelectedWithGoodsCategoryArray:(NSArray *) goodsCategoryArray;


    +(ShoopCartPayInfo *) shoopCartPayInfoWithGoodsArray:(NSArray *)goodsArray;

    +(ShoopCartPayInfo *) shoopCartPayInfoWithGoodsCategoryArray:(NSArray *) goodsCategoryArray ;



@end
