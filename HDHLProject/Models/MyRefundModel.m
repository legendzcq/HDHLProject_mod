//
//  MyRefundModel.m
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyRefundModel.h"

@implementation MyRefundModel


-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.amount = [dict stringForKey:@"amount"];
        self.order_sn = [dict stringForKey:@"order_sn"];
        self.amount_status_msg = [dict stringForKey:@"amount_status_msg"];
        self.amount_status_id = [dict stringForKey:@"amount_status_id"];
        self.amount_status_text = [dict stringForKey:@"amount_status_text"];
        self.store_name = [dict stringForKey:@"store_name"];
    }
    return self;
}


@end
