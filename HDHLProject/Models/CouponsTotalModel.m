//
//  CouponsTotalModel.m
//  Carte
//
//  Created by ligh on 15-1-29.
//
//

#import "CouponsTotalModel.h"

@implementation CouponsTotalModel

- (void)dealloc
{
    RELEASE_SAFELY(_coupons);
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.coupon = [dict stringForKey:@"coupon"];
        NSArray *couponsArray = [dict arrayForKey:@"coupons"];
        self.coupons = [VoucherModel reflectObjectsWithArrayOfDictionaries:couponsArray];
    }
    return self;
}

- (Class)elementClassForArrayKey:(NSString *)key {
    if ([key isEqualToString:@"coupons"]) {
        return [VoucherModel class];
    }
    return [super elementClassForArrayKey:key];
}

- (BOOL)haveCurrentVoucherModel {
    if (self.curVouModel != nil && ![NSString isBlankString:self.curVouModel.coupon_id]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCoexistOfCurrentVoucherModel {
    if (self.curVouModel != nil && ![NSString isBlankString:self.curVouModel.coupon_id] && self.curVouModel.coexist.intValue) {
        return YES;
    }
    return NO;
}

@end
