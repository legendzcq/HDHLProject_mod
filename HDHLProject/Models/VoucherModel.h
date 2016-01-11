//
//  VoucherModel.h
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import <UIKit/UIKit.h>
#import "OptionsModel.h"

typedef enum
{
    SingleStoreLevel = 1,//单店
    DoubleStoreLevel = 2,//多店使用
    CommonStoreLevel = 3//通用
    
}VoucherLevel;

//不使用代金卷action
#define KNoUseVoucherActionTag -1

/**
 *  代金卷model
 */
@interface VoucherModel : OptionsModel

@property (retain,nonatomic) NSString *coupon_type;  //状态:1：金额代金券 2：折扣代金券 3：实物券
@property (retain,nonatomic) NSString *coupon_name;  //代金券名称
@property (retain,nonatomic) NSString *coupon_value; //代金券面值
@property (retain,nonatomic) NSString *end_time;     //有效期截至时间
@property (retain,nonatomic) NSString *is_new;       //是否为最新：1是 0不是

@property (retain,nonatomic) NSString *scope;        //几店通用显示
@property (retain,nonatomic) NSString *arrstoreid;   //通用分店id
@property (retain,nonatomic) NSString *storenames;   //通用分店名称（多个点用 , 相连）

@property (retain,nonatomic) NSString *min_amount;    //最小使用金额
@property (retain,nonatomic) NSString *activity_title; //活动名称


@property (retain,nonatomic) NSArray *listArray;

//2.1

@property (retain,nonatomic) NSString *use_type;
@property (retain,nonatomic) NSString *brand_id;
@property (retain,nonatomic) NSString *brand_name;
@property (retain,nonatomic) NSString *store_count;

@property (retain,nonatomic) NSString *ID; //代金券ID
@property (retain,nonatomic) NSString *status;//代金券使用状态
@property (retain,nonatomic) NSString *store_id;//发放代金券的分店id
@property (retain,nonatomic) NSString *store_name;//s发放代金券的分店名称
@property (retain,nonatomic) NSString *image_big;//	代金券大图
@property (retain,nonatomic) NSString *image_small;//代金券小图
@property (retain,nonatomic) NSString *coupon_desc;//代金券描述
@property (retain,nonatomic) NSString *coupon_id;//代金券id
@property (retain,nonatomic) NSString *mc_id;//代金券id

@property (retain,nonatomic) NSString *coupon_sn;//代金券sn（唯一编码）

@property (retain,nonatomic) NSString *level;//1单店使用 2指定某些店用 3 全店通用
@property (retain,nonatomic) NSString *coexist; //状态:1,是互斥 0,是不互斥;
@property (retain,nonatomic) NSString *count;//代金券数目

//计算排序order_by
@property (retain,nonatomic) NSString *order_by;

-(NSString *) endTimeOfForamt;

@end
