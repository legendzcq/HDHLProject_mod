//
//  VoucherDetailModel.m
//  Carte
//
//  Created by hdcai on 15/4/22.
//
//

#import "VoucherDetailModel.h"

@implementation VoucherDetailModel
-(void)dealloc{
    RELEASE_SAFELY(_coupon_value);
    RELEASE_SAFELY(_brand_id);
    RELEASE_SAFELY(_coupon_sn);
    RELEASE_SAFELY(_use_type);
    RELEASE_SAFELY(_end_time);
    RELEASE_SAFELY(_arrstoreid);
    RELEASE_SAFELY(_min_amount);
    RELEASE_SAFELY(_activity_title);
    RELEASE_SAFELY(_scope);
    RELEASE_SAFELY(_brand_name);
    RELEASE_SAFELY(_store_count);

}


-(NSDictionary *)attributeMapDictionary{
    
    return @{
             
             @"_coupon_vale":@"_coupon_vale",
             @"_brand_id":@"_brand_id",
             @"_coupon_sn":@"_coupon_sn",
             @"_use_type":@"_use_type",
             @"_end_time":@"_end_time",
             @"_arrstoreid":@"_arrstoreid",
             @"_min_amount":@"_min_amount",
             @"_activity_title":@"_activity_title",
             @"_scope":@"_scope",
             @"_brand_name":@"_brand_name",
             @"_store_count":@"_store_count",
             @"store_id":@"store_id"
             };
    
}

@end
