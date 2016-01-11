//
//  GrouponModel.h
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
#import "PageModel.h"


typedef enum
{
    GrouponStatusNotStarted = 1,//未开始
    GrouponStatusExpired = 2,//已过期
    GrouponStatusSale = 3,//售卖中
    GrouponStatusSaleSoldOut = 4,//已售罄
    
}GrouponStatus;

/**
 *  团购信息model
 */

@interface GrouponModel : BaseModelObject

//卡包相关
@property (retain,nonatomic) NSString *brand_name;     //品牌名
@property (retain,nonatomic) NSString *groupon_name;   //名称（团购）
@property (retain,nonatomic) NSString *activity_title; //名称（团购、活动）
@property (retain,nonatomic) NSString *activity_id;    //活动id
@property (retain,nonatomic) NSString *groupon_id;     //团购id
@property (retain,nonatomic) NSString *sale_type;      //团购和活动的类别
@property (retain,nonatomic) NSString *market_price;   //团购原价
@property (retain,nonatomic) NSString *shop_price;     //团购价
@property (retain,nonatomic) NSString *image_big;      //大图
@property (retain,nonatomic) NSString *image_small;    //小图
@property (retain,nonatomic) NSString *content;        //说明
@property (retain,nonatomic) NSString *endtime;        //结束时间
@property (retain,nonatomic) NSString *distance;       //距离
@property (nonatomic,assign) OrderType orderType;
/*
@property (retain,nonatomic) NSString *starttime;//		开始时间
@property (retain,nonatomic) NSString *groupon_introduction;//	团购说明
@property (retain,nonatomic) NSString *expense_sn;//消费吗
@property (retain,nonatomic) NSString *status;//团购状态

@property (retain,nonatomic) NSNumber *store_total;//参与团购的数量（几个店通用）

*/
@property (retain,nonatomic) NSString *use_scope;//显示支持哪些分店
@property (retain,nonatomic) NSString *is_suppor;//支持分店文字颜色
@property (retain,nonatomic) NSString *notice;//须知
@property (retain,nonatomic) NSString *sales;//团购数量
@property (retain,nonatomic) NSString *surplus_day;//剩余天数/-1未开始/-2过期
@property (retain,nonatomic) NSString   *share_content;
@property (retain,nonatomic) StoreModel *store;//支持的分店

//截止日期
- (NSString *)endTimeOfForamt;

@end
