//
//  VoucherModel.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "VoucherModel.h"

@implementation VoucherModel

-(void)dealloc
{
    RELEASE_SAFELY(_status);
    RELEASE_SAFELY(_store_id);
    RELEASE_SAFELY(_store_name);
    RELEASE_SAFELY(_image_big);
    RELEASE_SAFELY(_image_small);
    RELEASE_SAFELY(_coupon_desc);
    RELEASE_SAFELY(_coupon_id);
    RELEASE_SAFELY(_coupon_name);
    RELEASE_SAFELY(_min_amount);
    RELEASE_SAFELY(_end_time);
    RELEASE_SAFELY(_coupon_value);
    RELEASE_SAFELY(_coupon_sn);
    RELEASE_SAFELY(_arrstoreid);
    RELEASE_SAFELY(_storenames);
    RELEASE_SAFELY(_level);
    RELEASE_SAFELY(_ID);
    RELEASE_SAFELY(_count);
}

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.ID = [dict stringForKey:@"id"];
        self.brand_id = [dict stringForKey:@"brand_id"];
        self.brand_name = [dict stringForKey:@"brand_name"];
        self.mc_id = [dict stringForKey:@"c_id"];
        self.coupon_desc = [dict stringForKey:@"coupon_desc"];
        self.coupon_id = [dict stringForKey:@"coupon_id"];
        self.coupon_name = [dict stringForKey:@"coupon_name"];
        self.coupon_sn = [dict stringForKey:@"coupon_sn"];
        self.coupon_type = [dict stringForKey:@"coupon_type"];
        self.coupon_value = [dict stringForKey:@"coupon_value"];
        self.end_time = [dict stringForKey:@"end_time"];
        self.is_new = [dict stringForKey:@"is_new"];
        self.min_amount = [dict stringForKey:@"min_amount"];
        self.scope = [dict stringForKey:@"scope"];
        self.store_id = [dict stringForKey:@"store_id"];
        self.store_name = [dict stringForKey:@"store_name"];
        self.activity_title = [dict stringForKey:@"activity_title"];
        self.use_type = [dict stringForKey:@"use_type"];
        self.arrstoreid = [dict stringForKey:@"arrstoreid"];
        self.storenames = [dict stringForKey:@"storenames"];
        self.store_count = [dict stringForKey:@"store_count"];
        self.status = [dict stringForKey:@"status"];
        self.image_big = [dict stringForKey:@"image_big"];
        self.image_small = [dict stringForKey:@"image_small"];
        self.level = [dict stringForKey:@"level"];
        self.count = [dict stringForKey:@"count"];
        self.coexist = [dict stringForKey:@"coexist"];
        self.order_by = [dict stringForKey:@"order_by"];

    }
    return self;
}

-(NSString *)endTimeOfForamt
{
    return [NSDate stringOfDefaultFormatWithInterval:[_end_time doubleValue]];
}


-(NSString *)title
{
    return [_coupon_name copy];
}

-(NSInteger)actionTag
{

    if (_coupon_id)
    {
        return _coupon_id.intValue;
    }
    
    return KNoUseVoucherActionTag;
}

@end
