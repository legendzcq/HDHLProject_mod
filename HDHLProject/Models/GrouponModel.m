//
//  GrouponModel.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "GrouponModel.h"

@implementation GrouponModel



- (void)dealloc
{
    RELEASE_SAFELY(_brand_name);
    RELEASE_SAFELY(_activity_title);
    RELEASE_SAFELY(_activity_id);
    RELEASE_SAFELY(_groupon_id);
    RELEASE_SAFELY(_sale_type);
    RELEASE_SAFELY(_image_big);
    RELEASE_SAFELY(_image_small);
    RELEASE_SAFELY(_market_price);
    RELEASE_SAFELY(_shop_price);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_endtime);
    RELEASE_SAFELY(_distance);
    
    RELEASE_SAFELY(_use_scope);
    RELEASE_SAFELY(_is_suppor);
    RELEASE_SAFELY(_notice);
    RELEASE_SAFELY(_sales);
    RELEASE_SAFELY(_surplus_day);
    RELEASE_SAFELY(_share_content);
    RELEASE_SAFELY(_store);
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.brand_name     = [dict stringForKey:@"brand_name"];
        self.activity_title = [dict stringForKey:@"activity_title"];
        self.activity_id    = [dict stringForKey:@"activity_id"];
        self.groupon_id     = [dict stringForKey:@"groupon_id"];
        self.sale_type      = [dict stringForKey:@"sale_type"];
        self.market_price   = [dict stringForKey:@"market_price"];
        self.shop_price     = [dict stringForKey:@"shop_price"];
        self.image_big      = [dict stringForKey:@"image_big"];
        self.image_small    = [dict stringForKey:@"image_small"];
        self.content        = [dict stringForKey:@"content"];
        self.distance       = [dict stringForKey:@"distance"];
        self.endtime        = [dict stringForKey:@"endtime"];

        self.groupon_name   = [dict stringForKey:@"groupon_name"];
        
        self.use_scope      = [dict stringForKey:@"use_scope"];
        self.is_suppor      = [dict stringForKey:@"is_suppor"];
        self.notice         = [dict stringForKey:@"notice"];
        self.sales          = [dict stringForKey:@"sales"];
        self.surplus_day    = [dict stringForKey:@"surplus_day"];
        self.share_content  = [dict stringForKey:@"share_content"];

    }
    return self;
}

//- (Class)elementClassForArrayKey:(NSString *)key {
//    if ([key isEqualToString:@"store"]) {
//        return [StoreModel class];
//    }
//    return [super elementClassForArrayKey:key];
//}

- (NSString *)endTimeOfForamt
{
    return [[NSDate dateWithTimeIntervalSince1970:[self.endtime doubleValue]] stringWithFormat:@"yyyy-MM-dd"];
}


@end
