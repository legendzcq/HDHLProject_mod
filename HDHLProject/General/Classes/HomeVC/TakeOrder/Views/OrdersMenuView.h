//
//  OrdersMenuView.h
//  Carte
//
//  Created by ligh on 14-7-23.
//
//

#import "XibView.h"
#import "OrderMenuCartCell.h"

#define kOrdersMenuCellHeight 50
#define kOrdersMenuTopHeight 36
#define kOrdersMenuHeight (self.height-SCREEN_HEIGHT/4) //视图距离顶部距离

@protocol OrdersMenuViewDelegate;

@interface OrdersMenuView : XibView

@property (assign,nonatomic) id<OrdersMenuViewDelegate> actionDelegate;


- (void)showWithHeight:(float)height goodsArray:(NSMutableArray *)goodsArray;
- (void)hidden;
- (void)hiddenSomeQuestion; //某些原因引起的该视图在点菜页无故显示
- (CGFloat)ordersMenuViewHeight;
- (CGFloat)contentHeight;
- (void)refreshOrderMenuDishes:(NSArray *)array; //刷新当前选中菜品（主要是价格）

@end


@protocol OrdersMenuViewDelegate <NSObject>

-(void) orderNumberChanged:(GoodsModel *) goodsModel;
-(void) orderNumberChangedZero;
-(void) orderNumberChangedOne;
-(void) ordersMenuViewDidDismiss;
-(void) ordersMenuViewHiddenFinish;

@end