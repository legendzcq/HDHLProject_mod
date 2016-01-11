//
//  TakeOrderPayVC.m
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "TakeOrderPayVC.h"
#import "PickerRowView.h"
#import "OrderListItemView.h"
#import "ActivityModel.h"
#import "TakeOrderPayInfoInitRequest.h"
#import "TakeOrderPayRequest.h"
#import "ActivitySingleView.h"
#import "StoreModel.h"
#import "PayMannerView.h"
#import "PayResultModel.h"
#import "OrderSelectedListView.h"
#import "VouchersListVC.h"

@interface TakeOrderPayVC () <ExpandFrameViewDeleagte, UIScrollViewDelegate, VouchersListVCDelegate>
{
    IBOutlet ExpandFrameView *_layoutView;
    IBOutlet UIScrollView    *_scrollView;
    
    //订单信息
    IBOutlet UIButton    *_submitOrderButton;
    IBOutlet FrameViewWB *_orderInfoView;

    //店铺信息
    IBOutlet UILabel *_storeNameLabel;
    IBOutlet UILabel *_orderNumLabel;
    StoreModel       *_storeModel;
    //菜单列表
    IBOutlet UIView *_orderListView;
    NSArray         *_productArray;
    //服务费
    IBOutlet UIView  *_serviceView;
    IBOutlet UILabel *_serviceExpensesTitleLabel;  //服务费标题
    IBOutlet UILabel *_serviceExpensesAmountLabel; //服务费金额
    //活动
    IBOutlet UIView *_activityListView;
    NSArray         *_activityArray; //可以参加的活动
    //备注
    IBOutlet FrameViewWB *_remarkView;
    IBOutlet UILabel     *_remarkLabel;
    //支付方式
    IBOutlet FrameViewWB *_payManagerBGView;
    IBOutlet RTLabel     *_countLabel; //支付数量
    IBOutlet UILabel   *_priceLabel;   //支付金额
    PayModeModel         *_selPayModel;
    NSArray              *_payModeArray;
    //优惠券
    IBOutlet FrameViewWB *_vouchersView;
    IBOutlet UILabel     *_vouchersLabel;
    IBOutlet UILabel     *_vouchersPriceLabel;
    IBOutlet UIButton    *_vouchersButton;
    CouponsTotalModel    *_couponsTotalModel;

    //支付信息 包含有支付的金额 和购买的商品
    OrderModel      *_orderModel;
    NSString        *_orderNumber;
    IBOutlet UIView *_bottomView;
}
@end

@implementation TakeOrderPayVC


- (void)dealloc
{
    RELEASE_SAFELY(_storeModel);
    RELEASE_SAFELY(_productArray);
    RELEASE_SAFELY(_orderModel);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_submitOrderButton);
    RELEASE_SAFELY(_layoutView);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_orderInfoView);
    RELEASE_SAFELY(_serviceExpensesTitleLabel);
    RELEASE_SAFELY(_serviceExpensesAmountLabel);
    RELEASE_SAFELY(_activityArray);
    RELEASE_SAFELY(_activityListView);
    RELEASE_SAFELY(_payManagerBGView);
    RELEASE_SAFELY(_selPayModel);
    RELEASE_SAFELY(_payModeArray);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_storeModel);
    RELEASE_SAFELY(_productArray);
    RELEASE_SAFELY(_orderModel);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_submitOrderButton);
    RELEASE_SAFELY(_layoutView);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_orderInfoView);
    RELEASE_SAFELY(_serviceExpensesTitleLabel);
    RELEASE_SAFELY(_serviceExpensesAmountLabel);
    RELEASE_SAFELY(_activityArray);
    RELEASE_SAFELY(_activityListView);
    RELEASE_SAFELY(_payManagerBGView);
    RELEASE_SAFELY(_selPayModel);
    RELEASE_SAFELY(_payModeArray);
    [super viewDidUnload];
}

- (id)initWithOrderNumber:(NSString *)orderNumber;
{
    if (self =  [super init]) {
        _orderNumber = orderNumber;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _layoutView.layoutDelegate = self;
    _scrollView.delegate = self;
}

- (void)configViewController
{
    [super configViewController];
    [self setNavigationBarTitle:@"订单支付"];
    [self loadColorConfig];
    [self sendRequestOfInitPayInfo];
}

- (void)loadColorConfig
{
    _storeNameLabel.font = FONT_STORE_NAME;
    _serviceExpensesTitleLabel.font = FONT_LIST_TITLE;
    _remarkLabel.font = FONT_LIST_TITLE;
    _vouchersLabel.font = FONT_LIST_TITLE;
    _serviceExpensesAmountLabel.font = FONT_DISH_PRICE;
    _vouchersPriceLabel.font = FONT_DISH_PRICE;
    _priceLabel.font = FONT_BOTTOM_PRICE;

    _vouchersPriceLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _storeNameLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _orderNumLabel.textColor = ColorForHexKey(AppColor_Order_NumberText);
    _remarkLabel.textColor = ColorForHexKey(AppColor_Order_NumberText);
    [_submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitOrderButton setBackgroundColor:ColorForHexKey(AppColor_OrderBottom_Selected)];
    _countLabel.textColor = [UIColor whiteColor];
    _priceLabel.textColor = [UIColor whiteColor];
    _bottomView.backgroundColor = ColorForHexKey(AppColor_OrderBottom_BgColor);
}

/**
 *  根据支付信息刷新UI信息
 */
- (void)refreshUI
{
    //商家信息
    [self setStoreInfo];
    //菜单列表
    [self setOrderListViewInfo];
    //其他费用
    [self setServiceExpensesView];
    //活动
    [self loadActivities:_activityArray];
    //备注
    [self setRemarkView];
    //优惠券
    [self loadVoucherView];
    //支付金额信息
    [self setOrderPayInfo];
    
    [_layoutView layoutSuperView];
}

//支付金额信息
- (void)setOrderPayInfo
{
    [_countLabel setTextAlignment:RTTextAlignmentLeft];
    _orderModel.payPriceString = [NSString stringWithFormat:@"%.2f",_orderModel.order_amount.floatValue + _orderModel.service_money.floatValue];
    _countLabel.text =  [NSString stringWithFormat:@"<font size=16>共%d个菜</font>", _orderModel.goods_count.intValue];
    _priceLabel.text =  [NSString stringWithFormat:@"合计:￥%@", _orderModel.payPriceString];
    if (_orderModel.goods_count.intValue > 99 && _orderModel.payPriceString.floatValue > 9999.99) {
        _countLabel.left = 5;
        _priceLabel.right = _submitOrderButton.left;
    }
}

//商家信息
- (void)setStoreInfo
{
    _storeNameLabel.text    = _storeModel.store_name;
    if (![NSString isBlankString:_orderModel.order_sn]) {
        _orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",_orderModel.order_sn];
    }
}

//菜单列表
- (void)setOrderListViewInfo
{
    //点菜清单
    OrderSelectedListView *orderView = [[OrderSelectedListView alloc] initWithFrame:CGRectMake(0, 0, _orderInfoView.width, 0)];
    [orderView showOrderSelectedListInView:_orderListView withArray:_productArray showMarketPrice:YES];
    [_orderListView addSubview:orderView];
    _orderListView.height = orderView.height;
    _orderListView.top = 75;
    _orderInfoView.height = _orderListView.bottom;
}

//其他费用
- (void)setServiceExpensesView
{
    //服务费
    _serviceView.top = _orderListView.bottom;
    if (_orderModel.service_money.floatValue) {
        _serviceView.hidden = NO;
        _serviceExpensesAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderModel.service_money.floatValue];
    } else {
        _serviceView.hidden = YES;
        _serviceView.height = 0;
    }
    _orderInfoView.height = _serviceView.bottom;
}

//加载活动
- (void)loadActivities:(NSArray *)activityAry
{
    _activityListView.top = _serviceView.bottom;
    _activityListView.hidden = activityAry.count == 0;
    if (activityAry.count) {
        [_activityListView removeAllSubviews];
        //上面的横线
        FrameLineView *topLine = [[FrameLineView alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, _activityListView.width-LEFT_SPACE, 0.5)];
        [_activityListView addSubview:topLine];
        float y = topLine.bottom;
        float activityViewHeight = 45;    //活动cell高度
        for (int i = 0; i < activityAry.count ; i ++) {
            ActivityModel *activityModel = activityAry[i];
            ActivitySingleView *activityItemView = [ActivitySingleView viewFromXIB];
            activityItemView.width = _activityListView.width;
            [activityItemView setDataWithModel:activityModel];
            activityItemView.top = y + i * activityViewHeight;
            if (_orderModel.bind_pay.intValue == 1) {
                [activityItemView hiddenSelImageView];
            } else {
                activityItemView.selButton.tag = i;
                if ([activityItemView.selButton allTargets].count == 0) {
                    [activityItemView.selButton addTarget:self action:@selector(activityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            [_activityListView addSubview:activityItemView];
        }
        _activityListView.height  =  y + activityAry.count * activityViewHeight;
    } else {
        _activityListView.height = 0 ;
    }
    _orderInfoView.height = _activityListView.bottom;
}

//备注
- (void)setRemarkView {
    if ([NSString isBlankString:_orderModel.content]) {
        _remarkView.hidden = YES;
    } else {
        _remarkView.hidden = NO;
        _remarkLabel.text = _orderModel.content;
        CGFloat oneLineHeight = 17;
        NSInteger lineNum = [_remarkLabel.text numberOfLinesWithFont:_remarkLabel.font boundingRectWithWidth:_remarkLabel.width];
        if (lineNum > 1) {
            _remarkView.height += oneLineHeight * lineNum;
        }
    }
}

//加载优惠劵
- (void)loadVoucherView
{
    if (_orderModel.bind_pay.intValue == 1) {
        if (_couponsTotalModel.coupons.count) {
            _vouchersView.hidden = NO;
            _vouchersButton.hidden = YES;
            VoucherModel *model = [[VoucherModel alloc] init];
            model = (VoucherModel *)_couponsTotalModel.coupons.firstObject;
            _vouchersPriceLabel.left = _vouchersView.width - _vouchersPriceLabel.width - LEFT_SPACE;
            _vouchersPriceLabel.text = [NSString stringWithFormat:@"-￥%@", model.coupon_value];
        } else {
            _vouchersView.hidden = YES;
        }
    } else {
        if (_couponsTotalModel.coupon.intValue) {
            _vouchersView.hidden = NO;
        } else {
            _vouchersView.hidden = YES;
        }
    }
}

#pragma mark -
#pragma mark - 活动优惠券 规则

//选了活动后，根据规则刷新优惠券
- (void)activityButtonAction:(UIButton *)button
{
    ActivityModel *actModel = (ActivityModel *)_activityArray[button.tag];
     //规则
    if ([_couponsTotalModel isCoexistOfCurrentVoucherModel]) {
        //反选事件
        _couponsTotalModel.curVouModel = nil;
        _vouchersPriceLabel.text = nil;
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"已使用优惠券不能与此活动同享"];
    }
    actModel.selected = !actModel.selected;
    for (int k = 0; k < _activityArray.count; k ++) {
        ActivityModel *model = (ActivityModel *)_activityArray[k];
        if (k != button.tag) {
            model.selected = NO;
        }
    }
    //刷新活动列表显示
    [self loadActivities:_activityArray];
    [self refreshBottomView];
}

//选了优惠券后，根据规则刷新活动列表
- (void)voucherButtonAction
{
    //规则
    if ([_couponsTotalModel isCoexistOfCurrentVoucherModel]) {
        //反选事件
        if ([self haveActivity]) {
            for (int k = 0; k < _activityArray.count; k ++) {
                ActivityModel *model = (ActivityModel *)_activityArray[k];
                model.selected = NO;
            }
            [self loadActivities:_activityArray];
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"已参与活动不能与此优惠券同享"];
        }
    }
    
    [self refreshBottomView];
}

//是否参与了活动
- (BOOL)haveActivity
{
    for (int k = 0; k < _activityArray.count; k ++) {
        ActivityModel *model = (ActivityModel *)_activityArray[k];
        if (model.selected) {
            return YES;
        }
    }
    return NO;
}

//拿到当前选中的活动
- (ActivityModel *)haveActivityModel
{
    for (int k = 0; k < _activityArray.count; k ++) {
        ActivityModel *model = (ActivityModel *)_activityArray[k];
        if (model.selected) {
            return model;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark - VouchersListVC

- (IBAction)getVouchersList:(id)sender {
    VouchersListVC *voucherListView = [[VouchersListVC alloc] initWithOrderID:_orderModel.order_id];
    voucherListView.delegate = self;
    [self.navigationController pushViewController:voucherListView animated:YES];
}

#pragma mark -
#pragma mark - VouchersListVCDelegate

- (void)VouchersListDidSelectedVoucherWithVoucherModel:(VoucherModel*)voucherModel withUseVoucherBool:(BOOL)useVoucherBool {
    if (useVoucherBool) {
        if (!_couponsTotalModel.curVouModel) {
            _couponsTotalModel.curVouModel = [[VoucherModel alloc] init];
        }
        _vouchersPriceLabel.text = [NSString stringWithFormat:@"-￥%@",voucherModel.coupon_value];
    } else {
        _vouchersPriceLabel.text = nil;
    }
    _couponsTotalModel.curVouModel = voucherModel;
    
    //刷新活动列表
    [self voucherButtonAction];
}

#pragma mark -
#pragma mark - 底部视图（刷新金额）

- (void)refreshBottomView
{
    NSString *total = [NSString stringWithFormat:@"%.2f",_orderModel.order_amount.floatValue];
    
    if ([self haveActivity]) {
        _orderModel.payPriceString = [NSString stringWithFormat:@"%.2f",total.floatValue - [self haveActivityModel].amount_dec.floatValue];
        if (_orderModel.payPriceString.floatValue < 0) {
            _orderModel.payPriceString = @"0.00";
        }
    } else {
        _orderModel.payPriceString = total;
    }
    total = _orderModel.payPriceString;
    
    if ([_couponsTotalModel haveCurrentVoucherModel]) {
        _orderModel.couponsTotalPay = _couponsTotalModel.curVouModel.coupon_value.floatValue;
        _orderModel.payPriceString = [NSString stringWithFormat:@"%.2f",total.floatValue - _orderModel.couponsTotalPay];
        if (_orderModel.payPriceString.floatValue < 0) {
            _orderModel.payPriceString = @"0.00";
        }
    }else{
        _orderModel.couponsTotalPay = 0;
        _orderModel.payPriceString = total;
    }
    
    CGFloat totalMoney0 = _orderModel.payPriceString.floatValue;
    _orderModel.payPriceString = [NSString stringWithFormat:@"%.2f",totalMoney0+_orderModel.service_money.floatValue];
    _countLabel.text =  [NSString stringWithFormat:@"<font size=16>共%d个菜</font>", _orderModel.goods_count.intValue];
    _priceLabel.text =  [NSString stringWithFormat:@"合计:￥%@", _orderModel.payPriceString];
    if (_orderModel.goods_count.intValue > 99 && _orderModel.payPriceString.floatValue > 9999.99) {
        _countLabel.left = 5;
        _priceLabel.right = _submitOrderButton.left;
    } else {
        _priceLabel.right = _submitOrderButton.left-15;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing];
}

#pragma mark -
#pragma mark - ExpandFrameViewDeleagte

- (float)expandFrameView:(ExpandFrameView *)expandFrameView topMarginOfView:(UIView *)view
{
    return 10;
}

#pragma mark -
#pragma mark viewActions

-(void)clickPromptViewAction
{
    [self sendRequestOfInitPayInfo];
}

-(void)actionClickNavigationBarLeftButton
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [TakeOrderPayInfoInitRequest cancelUseDefaultSubjectRequest];
    [TakeOrderPayRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

//提交订单
- (IBAction)submitOrderAction:(id)sender
{
    if (!_selPayModel.pay_id.intValue) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:kDefaultPayAlertContent];
        return;
    }
    [self sendRequestOfNewOrderOrPay];
}

/**
 *  构建支付所需要的参数信息
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) getPayInfoParams
{
    /**
//     order_id 订单id
//     user_id 用户id
//     activity_id 活动id
//     coupon_id 代金券id字符串
//     order_amount 支付金额
//     pay_id 付款方式id
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:_orderModel.order_id forKey:@"order_id"];
    [params setObject:[NSString stringWithFormat:@"%.2f",_orderModel.payPriceString.floatValue] forKey:@"order_amount"];
    //支付方式id
    [params setObject:[NSString stringWithFormat:@"%d",_selPayModel.pay_id.intValue] forKey:@"pay_id"];
    //选中的活动
    if ([self haveActivity]) {
        [params setObject:[self haveActivityModel].activity_id forKey:@"activity_id"];
    }
    //用户选中优惠券
    if ([_couponsTotalModel haveCurrentVoucherModel]) {
        [params setObject:_couponsTotalModel.curVouModel.coupon_id forKey:@"coupon_id"];
    }
    
    return params;
}

//下单支付 如果是选用支付宝支付 则下单成功后自动调用支付宝支付 如果用用户余额支付则下单后支付成功
- (void)sendRequestOfNewOrderOrPay
{
    [TakeOrderPayRequest requestWithParameters:[self getPayInfoParams] withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
    {
        if (request.isSuccess) {
            NSString *overTime = [[(NSDictionary *)request.resultDic dictionaryForKey:@"data"] stringForKey:@"overtime"];
            if (overTime.intValue == 1) {
                _scrollView.hidden = YES;
                _bottomView.hidden = YES;
                [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
                [self showNoDataPromptView];
                return ;
            }
            [self handlePayResult:request.resultDic];
        } else {
            if (request.isNoLogin) {
                return ;
            }
            NSString *msg = request.resultDic[@"msg"];
            [BDKNotifyHUD showCryingHUDInView:self.view text:[NSString isBlankString:msg] ? @"下单失败，请重试" : msg];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"下单失败，请重试"];
    }];
}


/**
 *  处理支付成功的结果
 *
 *  @param orderID <#orderID description#>
 */
- (void)gotoOrderListVC:(BOOL)success
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //点菜支付 跳 OrderVC 列表页面
    [self popFromViewControllerToRootViewControllerWithTabBarIndex:kTabbarIndex1 animation:YES];
    if (success) {
        [self postNotificaitonName:kRefreshOrdersListNotification];
    }
}


//处理支付结果
- (void)handlePayResult:(NSDictionary *)resultDic
{
    PayResultModel *resultModel = [[PayResultModel alloc] initWithDictionary:resultDic[@"data"]];
    if ([NSString isBlankString:resultModel.order_sn]) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"订单号为空"];
        return;
    }
    
    if (resultModel.add_result.intValue == WaitAlipayPaymentStatus) { //等待使用支付宝支付
    
        Product *product = [_orderModel generateProductInfo:_productArray];
        product.orderId = resultModel.order_sn;
        product.price = resultModel.order_amount.floatValue;
        [[AliPayManager shareManager] payForProduct:product completion:^(BOOL success) {
            [self gotoOrderListVC:success];
        }];
        
    } else if (resultModel.add_result.intValue == WaitUPPayPaymentStatus) { //等待使用银联支付
        
        [[UPPayPluginManager shareManager] uPPayPluginStartViewController:self uPPayTN:resultModel.order_sn successBlock:^(NSString *success) {
            [BDKNotifyHUD showSmileyHUDInView:self.view text:success completion:^{
                [self gotoOrderListVC:YES];
            }];
        } failBlock:^(NSString *error) {
            [BDKNotifyHUD showCryingHUDInView:self.view text:error completion:^{
                [self gotoOrderListVC:NO];
            }];
        } cancelBlock:^(NSString *cancel) {
            [BDKNotifyHUD showCryingHUDInView:self.view text:cancel completion:^{
                [self gotoOrderListVC:NO];
            }];
        }];
    } else if (resultModel.add_result.intValue == WaitWXPayPaymentStatus) { //等待使用微信支付
        
        [[WXApiManager shareManager] wxPayForProduct:resultModel.wxpay_result successCompletion:^(BOOL success) {
            [self gotoOrderListVC:success];
        } failureCompletion:^(BOOL failure) {
            [self gotoOrderListVC:failure];
        }];
    } else {
        
        NSString *msg = resultDic[@"msg"];
        [BDKNotifyHUD showSmileyHUDInView:self.view text:msg completion:^{
            [self gotoOrderListVC:YES];
        }];
    }
}

/**
 *  初始化支付信息请求
 */
-(void)sendRequestOfInitPayInfo
{
    _scrollView.hidden = YES;
    _bottomView.hidden = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_orderNumber forKey:@"order_id"];

    [TakeOrderPayInfoInitRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             //支付信息
             RELEASE_SAFELY(_orderModel);
             _orderModel = [[OrderModel alloc] init];
             _orderModel = request.resultDic[KTakeOrderInfoResultRequest];
             if (_orderModel.overtime.intValue == 1) {
                 [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
                 [self showNoDataPromptView];
                 return ;
             }
             //商家信息
             _storeModel = (StoreModel *)[StoreModel reflectObjectsWithJsonObject:request.resultDic[@"data"]];

             //菜品
             _productArray = [NSArray arrayWithArray:request.resultDic[KTakeOrderGoodsResultRequest]];

             //活动
             _activityArray = [NSArray arrayWithArray:request.resultDic[KTakeOrderActivitiesResultRequest]];

             //优惠券
             RELEASE_SAFELY(_couponsTotalModel);
             _couponsTotalModel = [[CouponsTotalModel alloc] init];
             _couponsTotalModel = request.resultDic[KTakeOrderVoucherModelResultRequest];
             
             //支付方式
             _payModeArray = [NSArray arrayWithArray:request.resultDic[KTakeOrderPayModeResultRequest]];
             [PayMannerView showInView:_payManagerBGView WithModelArray:_payModeArray WithSelectedBlock:^(id obj) {
                 RELEASE_SAFELY(_selPayModel);
                 _selPayModel = [[PayModeModel alloc] init];
                 _selPayModel = (PayModeModel *)obj;
             }];
             
             _scrollView.hidden = NO;
             _bottomView.hidden = NO;
             [self refreshUI];
             [self hidePromptView];
             
         } else {
             if (request.isNoLogin) {
                 return ;
             }
             if (request.resultDic) {
                 [self showServerErrorPromptView];
             } else {
                 [self showNetErrorPromptView];
             }
         }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self showNetErrorPromptView];
    }];
}

- (NSString *)defaultNoDataPromptText
{
    return [NSString stringWithFormat:@"订单：%@\n支付超时",_orderModel.order_sn];
}

@end
