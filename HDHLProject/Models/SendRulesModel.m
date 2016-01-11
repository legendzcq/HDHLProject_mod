//
//  SendRulesModel.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "SendRulesModel.h"

@implementation SendRulesModel


- (void)dealloc
{
    
    RELEASE_SAFELY(_send_intro);
    RELEASE_SAFELY(_stime);
    RELEASE_SAFELY(_etime);
    RELEASE_SAFELY(_box_price);
    RELEASE_SAFELY(_send_price);
    RELEASE_SAFELY(_min_price);
    RELEASE_SAFELY(_is_discount);
    RELEASE_SAFELY(_discount_rules);
    RELEASE_SAFELY(_time_overplus);
}

//-(NSDictionary *)attributeMapDictionary
//{   
//    return @{
//             @"box_price": @"box_price",
//             @"discount_rules": @"discount_rules",
//             @"etime": @"etime",
//             @"is_discount" : @"is_discount",
//             @"min_price" : @"min_price",
//             @"send_intro" : @"send_intro",
//             @"send_price" : @"send_price",
//             @"stime" : @"stime",
//             @"time_overplus" : @"time_overplus"
//             };
//}
@end
