//
//  UserModel.m
//  PMS
//
//  Created by ligh on 14/10/22.
//
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.user_id = [dict stringForKey:@"user_id"];
        self.username = [dict stringForKey:@"user_name"];
        self.mobile = [dict stringForKey:@"user_mobile"];
        self.gender = [dict stringForKey:@"gender"];
        self.phone = [dict stringForKey:@"phone"];
        self.paysArray = [dict arrayForKey:@"pays"];
        self.userSmallPic = [dict stringForKey:@"image_small"];
        self.userBigPic = [dict stringForKey:@"image_big"];
        self.user_money = [dict stringForKey:@"user_money"];
        self.brand_name = [dict stringForKey:@"brand_name"];
        self.message_number = [dict stringForKey:@"message_number"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.username = [aDecoder decodeObjectForKey:@"user_name"];
        self.mobile = [aDecoder decodeObjectForKey:@"user_mobile"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.username forKey:@"user_name"];
    [aCoder encodeObject:self.mobile forKey:@"user_mobile"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

@end
