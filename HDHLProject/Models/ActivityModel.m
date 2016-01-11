//
//  ActivityModel.m
//  Carte
//
//  Created by ligh on 14-9-17.
//
//

#import "ActivityModel.h"

@implementation ActivityModel


-(void)dealloc
{
    RELEASE_SAFELY(_activity_id);
    RELEASE_SAFELY(_activity_title);
    RELEASE_SAFELY(_activity_desc);
    RELEASE_SAFELY(_activity_endtime);
    RELEASE_SAFELY(_activity_starttime);
    RELEASE_SAFELY(_activity_rel);
    RELEASE_SAFELY(_activity_type);
    RELEASE_SAFELY(_addtime);
    RELEASE_SAFELY(_brand_id);
    RELEASE_SAFELY(_module);
    RELEASE_SAFELY(_nodate);
    RELEASE_SAFELY(_coupon_sn);
    RELEASE_SAFELY(_nodate);
    RELEASE_SAFELY(_orders);
    RELEASE_SAFELY(_rel_id);
    RELEASE_SAFELY(_status)
    RELEASE_SAFELY(_store_ids);
    RELEASE_SAFELY(_amount_dec);
//    RELEASE_SAFELY(_activity_mutex);
}

/*
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.coexist            = [dict boolForKey:@"coexist"];
        self.activity_title     = [dict stringForKey:@"activity_title"];
        self.activity_id        = [dict stringForKey:@"activity_id"];
        self.activity_desc      = [dict stringForKey:@"activity_desc"];
        self.activity_endtime   = [dict stringForKey:@"activity_endtime"];
        self.activity_starttime = [dict stringForKey:@"activity_starttime"];
        self.activity_rel       = [dict stringForKey:@"activity_rel"];
        self.activity_type      = [dict stringForKey:@"activity_type"];
        self.addtime            = [dict stringForKey:@"addtime"];
        self.brand_id           = [dict stringForKey:@"brand_id"];
        self.module             = [dict stringForKey:@"module"];
        self.coupon_sn          = [dict stringForKey:@"coupon_sn"];
        self.nodate             = [dict stringForKey:@"nodate"];
        self.orders             = [dict stringForKey:@"orders"];
        self.rel_id             = [dict stringForKey:@"rel_id"];
        self.status             = [dict stringForKey:@"status"];
        self.store_ids          = [dict stringForKey:@"store_ids"];
        self.order_by           = [dict stringForKey:@"order_by"];
        self.gifts              = [dict stringForKey:@"gifts"];
        self.amount_dec         = [dict stringForKey:@"amount_dec"];

        //活动详情页面用到
        self.content       = [dict stringForKey:@"content"];
        self.share_content = [dict stringForKey:@"share_content"];
        self.share_link    = [dict stringForKey:@"share_link"];
        self.share_param   = [dict stringForKey:@"share_param"];

    }
    return self;
}
*/

//-(void)setAttributes:(NSDictionary *)dataDic
//{
//    [super setAttributes:dataDic];
//
//    self.coexist = [dataDic[@"coexist"] intValue];
//    
//}


@end
