//
//  GrouponStoreModel.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "GrouponStoreModel.h"

@implementation GrouponStoreModel

- (void)dealloc
{
    RELEASE_SAFELY(_address);
    RELEASE_SAFELY(_groupon_phone);
    RELEASE_SAFELY(_phone);
    RELEASE_SAFELY(_position);
    RELEASE_SAFELY(_store_id);
    RELEASE_SAFELY(_store_name);
}

-(NSDictionary *)attributeMapDictionary
{
    return @{
             @"address": @"address",
             @"groupon_phone": @"groupon_phone",
             @"phone": @"phone",
             @"position" : @"position",
             @"store_id": @"store_id",
             @"store_name": @"store_name"
             };
}

@end
