//
//  ActivityModel.h
//  Carte
//
//  Created by ligh on 14-9-17.
//
//

#import "BaseModelObject.h"

/**
 *  活动
 */
@interface ActivityModel : BaseModelObject

//状态:1,是互斥 0,是不互斥
@property (assign,nonatomic) BOOL    coexist;
@property (retain,nonatomic) NSString *activity_id;//活动id
@property (retain,nonatomic) NSString *activity_title;//活动名称
@property (retain,nonatomic) NSString *gifts;//赠品
@property (retain,nonatomic) NSString *activity_desc;//活动说明
@property (retain,nonatomic) NSString *activity_endtime;
@property (retain,nonatomic) NSString *activity_starttime;
@property (retain,nonatomic) NSString *activity_rel;////赠品
@property (retain,nonatomic) NSString *activity_type;
@property (retain,nonatomic) NSString *addtime;
@property (retain,nonatomic) NSString *brand_id;
@property (retain,nonatomic) NSString *module;
@property (retain,nonatomic) NSString *nodate;
@property (retain,nonatomic) NSString *orders;
@property (retain,nonatomic) NSString *rel_id;
@property (retain,nonatomic) NSString *status;
@property (retain,nonatomic) NSString *store_ids;
@property (retain,nonatomic) NSString *coupon_sn;
@property (retain,nonatomic) NSString *discount;//活动折扣discount
@property (retain,nonatomic) NSString *amount_dec;//折扣多少钱
@property (retain,nonatomic) NSString *order_by;////计算排序order_by

//活动详情页面用到
@property (retain,nonatomic) NSString *content; //活动内容
@property (retain,nonatomic) NSString *share_content; //分享内容
@property (retain,nonatomic) NSString *share_link;    //分享链接 QQ分享
@property (retain,nonatomic) NSString *share_param;   //分享活动成功用到

//2.0 互斥用到的字段
//@property (nonatomic, assign) NSInteger  noSelecte; // > 0不可选
@property (nonatomic, assign) BOOL       selected; //YES 已选中
//@property (nonatomic, retain) NSString  *activity_mutex;

//HDCAI 3.0
PROPERTY_STRONG NSString *sales_id;    //优惠id
PROPERTY_STRONG NSString *sales_title; //优惠名称
PROPERTY_STRONG NSString *discount_id;    //折扣id
PROPERTY_STRONG NSString *discount_title; //折扣名称

@end
