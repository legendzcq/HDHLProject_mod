//
//  BookSeatDateModel.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "PayInfoDateModel.h"

@implementation PayInfoDateModel


- (void)dealloc
{
    RELEASE_SAFELY(_md);
    RELEASE_SAFELY(_week);
    RELEASE_SAFELY(_order_time);
    RELEASE_SAFELY(_mdtime);
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.md         = [dict stringForKey:@"md"];
        self.week       = [dict stringForKey:@"week"];
        self.order_time = [dict stringForKey:@"order_time"];
        self.mdtime     = [dict stringForKey:@"mdtime"];
        NSArray *hoursArray = [dict arrayForKey:@"hours"];
        self.hours = [HoursModel reflectObjectsWithArrayOfDictionaries:hoursArray];
    }
    return self;
}


-(NSString *)orderTimeOfForamt
{
   NSDate *date = [NSDate dateWithTimeIntervalSince1970:_order_time.doubleValue];
    NSString *dateString = [date stringWithFormat:@"HH:mm"];

    return dateString;
}

@end
