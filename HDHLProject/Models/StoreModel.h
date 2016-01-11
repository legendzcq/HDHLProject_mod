//
//  StoreModel.h
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import <UIKit/UIKit.h>

/**
 *  商家 分店信息
 */
@interface StoreModel : BaseModelObject

@property (retain, nonatomic) NSString *brand_name; //品牌名
@property (retain, nonatomic) NSString *store_id;   //店铺id
@property (retain, nonatomic) NSString *store_name; //店铺名称
@property (retain, nonatomic) NSString *address;    //店铺地址
@property (retain, nonatomic) NSString *phone;      //店铺电话
@property (retain, nonatomic) NSString *open_time;  //营业时间
@property (retain, nonatomic) NSString *user_money; //店铺详情用到
@property (retain, nonatomic) NSString *distance;    //距离（与我的位置）

@property (retain, nonatomic) NSString *image_big;   //店铺大图
@property (retain, nonatomic) NSString *image_small; //店铺小图

@property (retain, nonatomic) NSNumber *is_seat;    //是否支持订座： 0为不支持，1为支持
@property (retain, nonatomic) NSNumber *is_dishes;  //是否支持点菜
@property (retain, nonatomic) NSNumber *is_groupon; //是否支持团购
@property (retain, nonatomic) NSNumber *is_send;    //是否支持外卖

@property (retain, nonatomic) NSNumber *is_discount;     //是否支持折扣：0为不支持，1为支持
@property (retain, nonatomic) NSNumber *is_voucher;      //是否支持代金券
@property (retain, nonatomic) NSNumber *is_gift;         //是否支持赠品
@property (retain, nonatomic) NSNumber *is_preferential; //是否支持优惠

@property (retain, nonatomic) NSString *activity_title; //最新活动标题
@property (retain, nonatomic) NSString *activity_id;    //最新活动ID (字符串)
@property (retain, nonatomic) NSNumber *store_number;   //支持的店铺

@property (retain, nonatomic) CLLocation *userLocation; //用户的位置信息（常用分店用到）

@property (retain, nonatomic) NSString *share_content;

//2.1新加
@property (retain, nonatomic)NSArray *activitys;
@property (retain, nonatomic)NSString *activity_desc;
@property (retain, nonatomic)NSString *level_name;
@property (retain, nonatomic)NSString *store_count;
@property (retain, nonatomic)NSDictionary *default_store;
@property (retain, nonatomic)NSString *brand_id;
@property (retain, nonatomic)NSString *city_name;
@property (retain, nonatomic)StoreModel *default_storeModel;


//以下字段为1.0版本的，旧版本
@property (retain,nonatomic) NSString *groupon_phone;// 团购电话
@property (retain,nonatomic) NSString *lat;//		纬度
@property (retain,nonatomic) NSString *lng;//经度

@property (retain,nonatomic) NSString *position;//经纬度
@property (retain,nonatomic) NSNumber *park;//是否支持停车
@property (retain,nonatomic) NSNumber *wifi;//是否支持wifi
@property (retain,nonatomic) NSNumber *visa;//是否支持刷卡

@property (retain,nonatomic) NSString  *expense;//人均消费

@property (retain,nonatomic) NSString  *bus;//			乘车线路
@property (retain,nonatomic) NSString  *discount;//		几折折扣（目前这个仅供展示用了，计算折扣按照单个菜品的折扣计算）
@property (retain,nonatomic) NSString  *discount_desc;//	折扣文字描述

//HDCAI 3.0
@property (retain,nonatomic) NSString *discount_id;
@property (retain,nonatomic) NSString *discount_title;
@property (retain,nonatomic) NSString *sales_id;
@property (retain,nonatomic) NSString *sales_title;
@property (retain,nonatomic) NSString *user_level_name;

@end
