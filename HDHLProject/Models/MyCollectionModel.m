//
//  MyCollectionModel.m
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCollectionModel.h"

@implementation MyCollectionModel
-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        self.brand_name = [dict stringForKey:@"brand_name"];
        self.frozen_money = [dict stringForKey:@"frozen_money"];
        self.give_money = [dict stringForKey:@"give_money"];
        self.level_id = [dict stringForKey:@"level_id"];
        self.recharge_money = [dict stringForKey:@"recharge_money"];
        self.store_id = [dict stringForKey:@"store_id"];
        self.store_name = [dict stringForKey:@"store_name"];
        self.user_money = [dict stringForKey:@"user_money"];
        self.brand_id = [dict stringForKey:@"brand_id"];
        self.image_url = [dict stringForKey:@"image_url"];
    }
    return self;
}

@end
