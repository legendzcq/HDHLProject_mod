//
//  PayResultModel.m
//  Carte
//
//  Created by ligh on 15-5-7.
//
//

#import "PayResultModel.h"

@implementation PayResultModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.add_result = [dict stringForKey:@"add_result"];
        self.order_amount = [dict stringForKey:@"order_amount"];
        self.order_sn = [dict stringForKey:@"order_sn"];
        self.order_id = [dict stringForKey:@"order_id"];
        self.wxpay_result = [dict dictionaryForKey:@"wxpay_result"];
    }
    return self;
}

@end

