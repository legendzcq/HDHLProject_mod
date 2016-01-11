//
//  TakeOrderConfirmVC.h
//  Carte
//
//  Created by ligh on 14-9-24.
//
//

#import "BetterVC.h"
#import "ShoopCartPayInfo.h"

@protocol TakeOrderConfirmDelegate <NSObject>
- (void)refreshTakeOrderGoodsWithPayInfo:(ShoopCartPayInfo *)payInfo;
- (void)showTakeOrderSelectedListWithPayInfo:(ShoopCartPayInfo *)payInfo;
@end

//点菜和外卖确认页面
@interface TakeOrderConfirmVC : BetterVC

@property (nonatomic, assign) id <TakeOrderConfirmDelegate> delegate;
//根据支付信息
- (id)initWithShoopCartPayInfo:(ShoopCartPayInfo *)payInfo;

@end
