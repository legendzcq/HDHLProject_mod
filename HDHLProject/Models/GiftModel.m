//
//  GiftModel.m
//  Carte
//
//  Created by ligh on 14-9-27.     
//
//

#import "GiftModel.h"

@implementation GiftModel


-(NSDictionary *)attributeMapDictionary
{
    return @{
             @"gid": @"id",
             @"gift": @"gift",
             @"count": @"count",
             @"units" : @"units"
            };
}


@end
