//
//  MyOrdersView.h
//  Carte
//
//  Created by liu on 15-4-10.
//
//

#import "XibView.h"

@protocol MyOrdersViewDelelgate <NSObject>

- (void)startToRefreshSuperViewWithType:(OrderType)orderType;

@end

@interface MyOrdersView : XibView

@property (nonatomic,assign)id<MyOrdersViewDelelgate>ordersDeleagate;
@property (retain, nonatomic) IBOutlet UIButton *orderSeatBtn;
@property (retain, nonatomic) IBOutlet UIButton *orderCarteBtn;
@property (retain, nonatomic) IBOutlet UIButton *takeOutBtn;
@property (retain, nonatomic) IBOutlet UIButton *groupBuyBtn;

- (IBAction)OrderSeatBtnClick:(UIButton *)sender;
- (IBAction)OrderCarteBtnClick:(UIButton *)sender;
- (IBAction)takeOutBtnClick:(UIButton *)sender;
- (IBAction)groupBuyBtnClick:(UIButton *)sender;

+(void)showInView:(UIView *)view Delegate:(id)delegate WithType:(OrderType)orderType ;
+(void)bringViewToFroneSuperiew:(UIView *)superView ;

@end
