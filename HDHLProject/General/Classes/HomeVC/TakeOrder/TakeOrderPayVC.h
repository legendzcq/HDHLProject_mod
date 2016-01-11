//
//  TakeOrderPayVC.h
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "BetterVC.h"
#import "ShoopCartPayInfo.h"

/**
 *  点菜支付页面
 */
@interface TakeOrderPayVC : BetterVC

//根据订单号
- (id)initWithOrderNumber:(NSString *)orderNumber;

@end
