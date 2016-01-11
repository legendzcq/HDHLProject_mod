//
//  VoucherDetailModel.h
//  Carte
//
//  Created by hdcai on 15/4/22.
//
//

#import "BaseModelObject.h"
//代金券详情model
@interface VoucherDetailModel : BaseModelObject

@property (retain,nonatomic) NSString *coupon_value;//代金券面值
@property (retain,nonatomic) NSString *brand_id;//品牌id
@property (retain,nonatomic) NSString *coupon_sn;//代金券编码
@property (retain,nonatomic) NSString *use_type;//使用类型
@property (retain,nonatomic) NSString *end_time;//使用期限
@property (retain,nonatomic) NSString *arrstoreid;//
@property (retain,nonatomic) NSString *min_amount;//代金券使用条件
@property (retain,nonatomic) NSString *activity_title;//代金券
@property (retain,nonatomic) NSString *scope;//代金券
@property (retain,nonatomic) NSString *brand_name;//品牌名称
@property (retain,nonatomic) NSString *store_count;//
@property (retain,nonatomic) NSString *store_id;
@end
