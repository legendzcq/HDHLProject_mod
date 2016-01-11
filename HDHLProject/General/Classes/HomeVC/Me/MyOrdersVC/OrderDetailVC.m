//
//  OrderDetailVC.m
//  HDHLProject
//
//  Created by liu on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OrderDetailVC.h"
#import "TakeOrderPayVC.h"
//请求类
#import "DishOrderDetailsRequest.h"
#import "CancelOrderRequest.h"
//View类
#import "MyOrdersActivityView.h"
#import "OrderSelectedListView.h"
#import "FrameLineView.h"
#import <QuartzCore/QuartzCore.h>

#define OrderDetail_BottomEdage 10.0f
#define OrderDetail_OptionBtn_Height 45.0f
#define OrderDetail_CarteView_Top  self.codeView.hidden?0:15
@interface OrderDetailVC ()
// 店铺名订单状态
@property (weak, nonatomic) IBOutlet ExpandFrameView *storeDeatilView;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;//店铺名
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//状态
// 验证码视图
@property (weak, nonatomic) IBOutlet ExpandFrameView *codeView;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;//验证码
// 菜品视图
@property (weak, nonatomic) IBOutlet ExpandFrameView *carteView;
// 服务视图
@property (weak, nonatomic) IBOutlet ExpandFrameView *serviceView;

@property (weak, nonatomic) IBOutlet UILabel *sericePriceLabel;//服务费
// 数量，价格视图
@property (weak, nonatomic) IBOutlet ExpandFrameView *countPriceView;
@property (weak, nonatomic) IBOutlet UILabel *carteCountLabel;//数量
@property (weak, nonatomic) IBOutlet UILabel *cartePriceLabel;//价格
// 活动视图
@property (weak, nonatomic) IBOutlet ExpandFrameView *activityView;
// 代金卷视图
@property (weak, nonatomic) IBOutlet ExpandFrameView *couponView;

@property (weak, nonatomic) IBOutlet UILabel *couponPrice;//代金卷
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;//操作按钮
@property (weak, nonatomic) IBOutlet FrameViewWB *optionBtnView;//操作按钮
@property (nonatomic,strong) OrderModel *orderModel;//传过来滴model
@property (nonatomic,strong) DishOrderModel *dishOrderModel;//请求过来滴model
@property (weak, nonatomic) IBOutlet FrameViewWB *topContentView;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet FrameLineView *carteLineView;

@end

@implementation OrderDetailVC

- (id)initWithOrderModel:(OrderModel *)orderModel
{
    if(self = [super init]){
        self.orderModel = orderModel;
    }
    return self ;
}


- (void)configViewController
{
    [super configViewController];
    [self setColors];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderDetail) name:KOrderListRefreshNotification object:nil];//订单状态改变时用此操作
    self.navigationBarView.navigationBarTitleLabel.text = @"订单详情";
    self.navigationBarView.leftBarButton.hidden = NO ;
    self.contentView.hidden =YES ;
    self.optionBtnView.hidden = YES ;
    self.contentView.frame = CGRectMake(0, self.navigationBarView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT -self.navigationBarView.height);
    [self startRequestDishOrderDetail];
}
- (void)setColors
{
    self.codeLabel.backgroundColor = ColorForHexKey(AppColor_Code_Label);
    [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"list_button.png"] forState:UIControlStateNormal];
    [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"list_button_click"] forState:UIControlStateHighlighted];
    self.payWayLabel.backgroundColor = HomeColorForHexKey(AppColor_Home_NavBg1);
    self.cartePriceLabel.textColor = ColorForHexKey(AppColor_OrderBottom_Selected);
    self.stateLabel.textColor =ColorForHexKey(AppColor_OrderBottom_Selected);
    self.codeLabel.layer.masksToBounds = YES ;
    self.codeLabel.layer.cornerRadius  = 2;
    self.storeNameLabel.font =FONT_STORE_NAME;
    self.payWayLabel.hidden = YES ;
    self.orderSnLabel.font =FONT_DISH_NAME;
    self.orderSnLabel.textColor = ColorForHexKey(AppColor_Second_Level_Title3);
}

- (void)refreshOrderDetail
{
    [self startRequestDishOrderDetail];
}
- (void)actionClickNavigationBarLeftButton
{
    [self popFromViewControllerToRootViewControllerWithTabBarIndex:1 animation:YES];
}
- (void)refreshUI
{
    UIScrollView *fatherView = (UIScrollView *)self.contentView;
    //订单号
    self.orderSnLabel.text =[NSString stringWithFormat:@"订单号:%@",  [self.dishOrderModel.order_sn length]?self.dishOrderModel.order_sn:@"空"];
    // 验证码是否显示
    self.codeView.hidden = [self.dishOrderModel.order_status intValue]==WaitPayUnValidationStatus?NO:YES;
    // 菜品列表
    OrderSelectedListView *orderView = [[OrderSelectedListView alloc] initWithFrame:CGRectMake(0,OrderDetail_CarteView_Top, SCREEN_WIDTH, 0)];
    [orderView showOrderSelectedListInView:self.carteView withArray:self.dishOrderModel.goods showMarketPrice:NO];
    [self.carteView insertSubview:orderView atIndex:0];
    self.carteView.height = orderView.bottom;
    self.carteLineView.top = OrderDetail_CarteView_Top;
    // 服务费
    self.serviceView.hidden = [self.dishOrderModel.service_money intValue]==0?YES:NO;
    self.storeNameLabel.text = self.dishOrderModel.store_name;
    self.stateLabel.text = [self.dishOrderModel orderStatusString];
    self.sericePriceLabel.text =[NSString stringWithFormat:@"￥%@", self.dishOrderModel.service_money];
    self.carteCountLabel.text  =[NSString stringWithFormat:@"共%@份", self.dishOrderModel.goods_count];
    self.cartePriceLabel.text =[NSString stringWithFormat:@"合计:￥%@", self.dishOrderModel.order_amount];
    self.codeLabel.text = self.dishOrderModel.expense_sn;
 // 活动列表
    self.activityView.hidden = self.dishOrderModel.activitys.count?NO:YES ;
    if(self.dishOrderModel.activitys.count){
        [MyOrdersActivityView showInView:self.activityView WithActivityArray:self.dishOrderModel.activitys];
    }
    [self.storeDeatilView layoutSuperView];//重新布局
    
    // 从新设定高度
    UIView *lastView = self.activityView.hidden?self.countPriceView:self.activityView; // 
    self.topContentView.height = lastView.bottom;
    self.couponView.top = self.topContentView.bottom +OrderDetail_BottomEdage;
    //支付方式
    self.payWayLabel.text = self.dishOrderModel.payment_name;
    self.payWayLabel.hidden = [self.stateLabel.text isEqualToString:@"已结账"]?NO:YES ;
    //优惠活动 只存在一个
    self.couponView.hidden = [self.dishOrderModel.coupons count]==0?YES:NO;
    self.couponPrice.text = [NSString stringWithFormat:@"￥%@",[[self.dishOrderModel.coupons lastObject] coupon_value]];
    [self setOptionBtn];
    fatherView.scrollEnabled = YES ;
    
    float totaleHeight = self.couponView.hidden==YES?self.topContentView.bottom+2*OrderDetail_BottomEdage+OrderDetail_OptionBtn_Height:self.couponView.bottom+2*OrderDetail_BottomEdage+OrderDetail_OptionBtn_Height;
    fatherView.contentSize = CGSizeMake(SCREEN_WIDTH, totaleHeight);
}
- (void)setOptionBtn
{
    int codeValue = [self.dishOrderModel.order_status intValue];
    switch (codeValue)
    {
        case WaitPayUnValidationStatus://0
            self.optionBtnView.hidden =NO ;
            [self.optionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.optionBtn addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside];
            //  return @"未验证";
            break;
        case PayUnValidationStatus://1
            self.optionBtnView.hidden = YES ;
         //   return @"付款中";
            break;
        case OrderRefundFinshStatus://4
            self.optionBtnView.hidden = YES ;
         //   return @"已结账";
            break;
        case WaitPayValidationStatus://5
         //   return @"已验证"; // 可以点付款
            self.optionBtnView.hidden =NO ;
            [self.optionBtn setTitle:@"支付" forState:UIControlStateNormal];
             [self.optionBtn addTarget:self action:@selector(aginPay) forControlEvents:UIControlEventTouchUpInside];
            break;
        case PayValidationStatus://6
            self.optionBtnView.hidden = YES ;
         //   return @"已结账";  //已经付款
            break;
        case OrderOverdueStatus://99
            self.optionBtnView.hidden = YES ;
         //   return @"已过期";
            break;
        case OrderCancleStatus://-1
            self.optionBtnView.hidden = YES ;
         //   return @"已取消";
            break;
        default:
            break;
    }

}

- (void)startRequestDishOrderDetail
{
    [DishOrderDetailsRequest requestWithParameters:@{@"order_id":self.orderModel.order_id,@"user_id":[AccountHelper uid],@"order_type":self.orderModel.order_type} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             
             DishOrderModel *dishOrderModel = request.resultDic[KRequestResultDataKey];
             if (dishOrderModel)
             {
                 
              self.dishOrderModel = dishOrderModel ;
              self.dishOrderModel.order_type = self.orderModel.order_type;
              self.contentView.hidden = NO;
              self.optionBtn.hidden = NO ;
             [self refreshUI];
             }
         }else
         {
             if (request.resultDic)
             {
                 [self showServerErrorPromptView];
             }else
             {
                 [self showNetErrorPromptView];
             }
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [self showNetErrorPromptView];
     }];

}

#pragma mark - 支付取消操作 -
- (void)cancleOrder
{
    [[MessageAlertView viewFromXIB] showAlertViewInView:self.view msg:@"您确定要撤销此订单吗？" cancelTitle:@"取消" confirmTitle:@"确定" onCanleBlock:nil onConfirmBlock:^{
        [self sendRequestOfCanceOrder];
    }];
}

- (void)sendRequestOfCanceOrder
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.dishOrderModel.order_id forKey:@"order_id"];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    
    [CancelOrderRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             [self postNotificaitonName:KOrderListRefreshNotification];
             [BDKNotifyHUD showSmileyHUDInView:self.contentView text:@"已撤销" completion:^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshOrdersListNotification object:nil ];
                 [self  startRequestDishOrderDetail];
             }];
             
         }else
         {
             NSString *msg = request.resultDic[@"msg"];
             [BDKNotifyHUD showCryingHUDInView:self.contentView text:[NSString isBlankString:msg] ? @"撤单失败" : msg];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDInView:self.contentView text:@"撤单失败"];
     }];
}
- (void)aginPay
{
    TakeOrderPayVC *payVC = [[TakeOrderPayVC alloc]initWithOrderNumber:self.dishOrderModel.order_id];
    [self pushFromRootViewControllerToViewController:payVC animation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
