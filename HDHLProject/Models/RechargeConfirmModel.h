//
//  RechargeConfirmModel.h
//  Carte
//
//  Created by hdcai on 15/4/29.
//
//

#import "BaseModelObject.h"

@interface RechargeConfirmModel : BaseModelObject

@property (nonatomic, retain)NSString *pay_time;
@property (nonatomic, retain)NSString *pay_name;
@property (nonatomic, retain)NSString *order_amount;
@property (nonatomic, retain)NSString *user_money;
@property (nonatomic, retain)NSString *pay_desc;
@property (nonatomic, retain)NSString *is_success;
@property (nonatomic, retain)NSString *groupon_name;
//////////
@property (nonatomic, retain)NSString *brand_name;

@end
