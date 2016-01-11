//
//  CouponsTotalModel.h
//  Carte
//
//  Created by ligh on 15-1-29.
//
//

#import "BaseModelObject.h"
#import "VoucherModel.h"

@interface CouponsTotalModel : BaseModelObject

PROPERTY_STRONG NSString *coupon; //是否有可用优惠券 0 无，1 有
PROPERTY_STRONG NSArray  *coupons;         //优惠券列表
PROPERTY_STRONG VoucherModel *curVouModel; //当前选中的优惠券

- (BOOL)haveCurrentVoucherModel; //选中了优惠券
- (BOOL)isCoexistOfCurrentVoucherModel; //互斥

@end
