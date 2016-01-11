//
//  OrderDishesVC.h
//  Carte
//
//  Created by ligh on 14-3-27.
//
//

#import "BetterTableViewVC.h"
#import "StoreModel.h"

/**
 *  点菜页面
 */

@interface TakeOrderVC : BetterTableViewVC

@property (retain, nonatomic) NSString *share_user_id;
- (id)initWithTakeOrderType:(TakeOrderType) type storeModel:(StoreModel *) storeModel;
- (id)initWithStoreID:(NSString *)orderID;

@end
