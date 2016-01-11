//
//  FoodListItemView.h
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "XibView.h"
#import "GoodsModel.h"
#import "FrameLineView.h"

@protocol OrderListItemViewDelegate;

/**
 *  
 *  订单列表项view
 */
@interface OrderListItemView : XibView

@property (retain, nonatomic) IBOutlet UILabel *productNameLabel;//商品名称
@property (retain, nonatomic) IBOutlet UILabel *countLabel;////数量
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;////金额
@property (retain, nonatomic) IBOutlet UIButton *iconButton;
@property (retain, nonatomic) IBOutlet FrameLineView *lineView;

@property (assign,nonatomic) id<OrderListItemViewDelegate> delegate;


-(void) setProductModel:(GoodsModel *) product;


@end

@protocol OrderListItemViewDelegate <NSObject>

-(void) didSelectedListItemView:(OrderListItemView *) orderListItemView;

@end