//  SeatOrderModel.h
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "OrderModel.h"



/**
 *  座位订单详情
 */
@interface SeatOrderModel : OrderModel

@property (retain,nonatomic) NSString *is_overtime;//是否已过期
@property (retain,nonatomic) NSString *share_content;

-(BOOL)isCancelOrder;//是否可以取消

@end
