//
//  StoreModel.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "StoreModel.h"

@implementation StoreModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.activitys = [dict arrayForKey:@"activitys"];
        
    }
    return self;
}

@end
