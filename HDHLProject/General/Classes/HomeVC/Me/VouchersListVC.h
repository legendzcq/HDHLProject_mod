//
//  VouchersListVC.h
//  Carte
//
//  Created by ligh on 14-12-24.
//
//

#import "BetterTableViewVC.h"
#import "VoucherModel.h"

/**
 *  优惠券列表
 */
@protocol VouchersListVCDelegate <NSObject>

-(void)VouchersListDidSelectedVoucherWithVoucherModel:(VoucherModel*)voucherModel withUseVoucherBool:(BOOL)useVoucherBool;

@end


@interface VouchersListVC : BetterTableViewVC

@property(nonatomic, assign) id<VouchersListVCDelegate>delegate;

-(id)initWithOrderID:(NSString *)orderId;

@end
