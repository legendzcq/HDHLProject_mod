//
//  TakeoutAddressModel.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "TakeoutAddressModel.h"

@implementation TakeoutAddressModel

- (void)dealloc
{
    RELEASE_SAFELY(_a_id);
    RELEASE_SAFELY(_username);
    RELEASE_SAFELY(_mobile);
    RELEASE_SAFELY(_city);
    RELEASE_SAFELY(_address);
    RELEASE_SAFELY(_default_address);
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.a_id = [dict stringForKey:@"a_id"];
        self.username = [dict stringForKey:@"username"];
        self.mobile = [dict stringForKey:@"mobile"];
        self.city = [dict stringForKey:@"city"];
        self.address = [dict stringForKey:@"address"];
        self.default_address = [dict stringForKey:@"default_address"];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.a_id = [aDecoder decodeObjectForKey:@"a_id"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.default_address = [aDecoder decodeObjectForKey:@"default_address"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.a_id forKey:@"a_id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.default_address forKey:@"default_address"];

}

@end
