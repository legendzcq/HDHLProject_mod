//
//  MyOrdersView.m
//  Carte
//
//  Created by liu on 15-4-10.
//
//

#import "MyOrdersView.h"
#import "FrameLineView.h"

#define MYORDERSVIEWLINE_FRAME CGRectMake(0,39.5, SCREEN_WIDTH, 0.5)
@implementation MyOrdersView{
    UIButton * _lastBtn;
   IBOutlet  UIImageView *imageViewOne;
   IBOutlet  UIImageView *imageViewTwo;
   IBOutlet  UIImageView *imageViewThree;
}
- (void)awakeFromNib
{
    [_orderSeatBtn setTitleColor:ColorForHexKey(AppColor_About_Share_Text) forState:UIControlStateNormal];
    [_orderSeatBtn setTitleColor:ColorForHexKey(AppColor_Btn_TitleSelected) forState:UIControlStateSelected];
    [_orderCarteBtn setTitleColor:ColorForHexKey(AppColor_About_Share_Text) forState:UIControlStateNormal];
    [_orderCarteBtn setTitleColor:ColorForHexKey(AppColor_Btn_TitleSelected) forState:UIControlStateSelected];
    [_takeOutBtn setTitleColor:ColorForHexKey(AppColor_About_Share_Text) forState:UIControlStateNormal];
    [_takeOutBtn setTitleColor:ColorForHexKey(AppColor_Btn_TitleSelected) forState:UIControlStateSelected];
    [_groupBuyBtn setTitleColor:ColorForHexKey(AppColor_About_Share_Text) forState:UIControlStateNormal];
    [_groupBuyBtn setTitleColor:ColorForHexKey(AppColor_Btn_TitleSelected) forState:UIControlStateSelected];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    imageViewOne.left = SCREEN_WIDTH/4;
    imageViewTwo.left = SCREEN_WIDTH/4*2;
    imageViewThree.left = SCREEN_WIDTH/4*3;
    
    _orderCarteBtn.left = 0 ;
    _takeOutBtn.left = SCREEN_WIDTH/4;
    _orderSeatBtn.left = SCREEN_WIDTH/4*2;
    _groupBuyBtn.left = SCREEN_WIDTH/4*3;
    
    _orderCarteBtn.width = SCREEN_WIDTH/4 ;
    _orderSeatBtn.width = SCREEN_WIDTH/4;
    _takeOutBtn.width = SCREEN_WIDTH/4;
    _groupBuyBtn.width = SCREEN_WIDTH/4;
}


+(void)showInView:(UIView *)view Delegate:(id)delegate WithType:(OrderType)orderType;
{
    MyOrdersView *ordersView=[MyOrdersView  viewFromXIB];
    ordersView.width = SCREEN_WIDTH ;
    ordersView.ordersDeleagate = delegate;
    FrameLineView *lineView = [[FrameLineView alloc]initWithFrame:MYORDERSVIEWLINE_FRAME];
    [ordersView setButtonSelectedWithType:orderType];
    [ordersView addSubview:lineView];
    [view addSubview:ordersView];
}
// 将视图置前
+(void)bringViewToFroneSuperiew:(UIView *)superView
{
    for (UIView *view in  superView.subviews)
    {
        if([view isKindOfClass:[MyOrdersView class]])
        {
            [superView bringSubviewToFront:view];
        }
    }
}
//SeatOrderType = 1,//订座订单
//DishOrderType = 2,//点菜订单
//GrouponOrderType = 3,//团购订单
//TakeOutOrderType = 4,//外卖订单
- (void)dealloc
{
    [self removeAllSubviews];
    RELEASE_SAFELY(_orderCarteBtn);
    RELEASE_SAFELY(_orderSeatBtn);
    RELEASE_SAFELY(_takeOutBtn);
    RELEASE_SAFELY(_groupBuyBtn);
}
- (IBAction)OrderSeatBtnClick:(UIButton *)sender
{
    [self setTintColorWithButton:sender];
    if(self.ordersDeleagate){
        [self.ordersDeleagate startToRefreshSuperViewWithType:SeatOrderType];
    }
}

- (IBAction)OrderCarteBtnClick:(UIButton *)sender{
    [self setTintColorWithButton:sender];
    if(self.ordersDeleagate){
        [self.ordersDeleagate startToRefreshSuperViewWithType:DishOrderType];
    }
}

- (IBAction)takeOutBtnClick:(UIButton *)sender{
    [self setTintColorWithButton:sender];
    if(self.ordersDeleagate){
       [self.ordersDeleagate startToRefreshSuperViewWithType:TakeOutOrderType];
    }
}

- (IBAction)groupBuyBtnClick:(UIButton *)sender{
    [self setTintColorWithButton:sender];
    if(self.ordersDeleagate){
         [self.ordersDeleagate startToRefreshSuperViewWithType:GrouponOrderType];
    }
}
//SeatOrderType = 1,//订座订单
//DishOrderType = 2,//点菜订单
//GrouponOrderType = 3,//团购订单
//TakeOutOrderType = 4,/
- (void)setButtonSelectedWithType:(OrderType)orderType
{
    UIButton *selectedBtn;
    switch (orderType) {
        case SeatOrderType:
            selectedBtn = self.orderSeatBtn;
            break;
        case DishOrderType:
            selectedBtn = self.orderCarteBtn;
            break;
        case GrouponOrderType:
            selectedBtn = self.groupBuyBtn;
            break;
        case TakeOutOrderType:
            selectedBtn = self.takeOutBtn;
            break;
        case SeatHistoryType:
            selectedBtn = self.orderSeatBtn;
            break;
        case OrderHistoryType:
            selectedBtn = self.orderCarteBtn;
            break;
        case GrouponHistoryType:
             selectedBtn = self.groupBuyBtn;
            break;
        case TakeOutHistoryType:
            selectedBtn = self.takeOutBtn;
            break;
        default:
            selectedBtn = nil ;
            break;
    }
    if(!selectedBtn){
        return ;
    }
    _lastBtn = selectedBtn;
    [selectedBtn setSelected:YES];
}
//按钮颜色设置
- (void)setTintColorWithButton:(UIButton*)button
{
    [_lastBtn setSelected:NO];
    [button setSelected:YES];
    _lastBtn = button ;
}

@end
