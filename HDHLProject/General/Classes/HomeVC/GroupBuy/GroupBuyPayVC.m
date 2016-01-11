//
//  GroupBuyPayVC.m
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "GroupBuyPayVC.h"
#import "MeVC.h"
//#import "GroupByOrdersListVC.h"
#import "RoundImageView.h"
#import "StrikethroughLabel.h"
#import "PayModeView.h"
#import "GrouponOrderModel.h"

#import "GrouponPayRequest.h"

#import "RechargeVC.h"
#import "OverageOrRechargeView.h"
#import "FrameViewWB.h"
#import "InvoiceCheckView.h"
#import "PayMannerView.h"
#import "PayResultModel.h"
#import "GrouponPayInitRequest.h"
@interface GroupBuyPayVC () <ExpandFrameViewDeleagte, UIWebViewDelegate>
{

    IBOutlet ExpandFrameView *_layouFrameView;
    
    IBOutlet UIScrollView     *_scrollView;
    IBOutlet FrameViewWB      *_grouponInfoView;
    
    IBOutlet UILabel        *_grouponNameLabel;//团购名称
    IBOutlet UILabel        *_shopPriceLabel;//团购价
    
    //支付方式
    IBOutlet FrameViewWB    *_payManagerBGView;
    PayModeModel            *_selPayModel;
    NSMutableArray          *_payModelArray;
    
    IBOutlet UILabel        *_countTitleLabel;
    IBOutlet UILabel        *_countLabel;//团购数量
    IBOutlet UILabel        *_payPriceLabel;//支付金额
    IBOutlet FrameView      *_grouponInfoFrameView;
    
    //团购详情
    IBOutlet FrameViewWB *_grouponDetailsBGView;
    IBOutlet UILabel     *_grouponDetailTitleLabel;
    IBOutlet UIWebView   *_grouponDetailsWebView;
    IBOutlet UIButton    *_grouponNextButton;
    
    GrouponModel            *_grouponModel;

    //发票信息
    IBOutlet UIView   *_invoiceCheckBGView;
    IBOutlet UIButton *_invoiceNOBtn;
    IBOutlet UIButton *_invoiceYESBtn;
    IBOutlet FrameViewWB *_invoiceTitleView;
    IBOutlet UITextField *_invoiceTitleField;
    
    //账余额，充值
    OverageOrRechargeView *_overageOrRechargeView;
    IBOutlet FrameViewWB  *_oveOrRecBGView;
    
    //底部视图
    IBOutlet UIView         *_payInfoView;
    IBOutlet UIButton       *_confirmPayButton;
}
@end

@implementation GroupBuyPayVC


- (void)dealloc
{
    RELEASE_SAFELY(_payModelArray);
    
    RELEASE_SAFELY(_grouponNameLabel);
    RELEASE_SAFELY(_shopPriceLabel);
    RELEASE_SAFELY(_countLabel);
    RELEASE_SAFELY(_payPriceLabel);
    RELEASE_SAFELY(_payInfoView);
    RELEASE_SAFELY(_grouponInfoFrameView);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_countTitleLabel);
    RELEASE_SAFELY(_confirmPayButton);
    RELEASE_SAFELY(_grouponInfoFrameView);
    RELEASE_SAFELY(_oveOrRecBGView);
    RELEASE_SAFELY(_overageOrRechargeView);
    RELEASE_SAFELY(_invoiceCheckBGView);
    RELEASE_SAFELY(_layouFrameView);
    
    RELEASE_SAFELY(_payManagerBGView);
    RELEASE_SAFELY(_selPayModel);
    
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_grouponNameLabel);
    RELEASE_SAFELY(_shopPriceLabel);
    RELEASE_SAFELY(_countLabel);
    RELEASE_SAFELY(_payPriceLabel);
    RELEASE_SAFELY(_payInfoView);
    RELEASE_SAFELY(_grouponInfoFrameView);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_countTitleLabel);
    RELEASE_SAFELY(_confirmPayButton);
    RELEASE_SAFELY(_oveOrRecBGView);
    RELEASE_SAFELY(_overageOrRechargeView);
    RELEASE_SAFELY(_invoiceCheckBGView);
    RELEASE_SAFELY(_layouFrameView);

    _grouponInfoView = nil;
    _grouponDetailsWebView = nil;
    _grouponDetailsBGView = nil;
    _grouponNextButton = nil;
    _grouponDetailTitleLabel = nil;
    _invoiceNOBtn = nil;
    _invoiceYESBtn = nil;
    _invoiceTitleView = nil;
    _invoiceTitleField = nil;
    RELEASE_SAFELY(_payManagerBGView);
    RELEASE_SAFELY(_selPayModel);
    
    [super viewDidUnload];
}



- (id)initWithGrouponModel:(GrouponModel *)grouponModel
{
    if (self = [self init])
    {
        _grouponModel = grouponModel ;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _layouFrameView.layoutDelegate = self;
}

- (void)configViewController
{
    [super configViewController];
    [self setNavigationBarTitle:@"支付订单"];
    [self loadColorConfig];
    
    [_scrollView setContentSize:CGSizeMake(0, 550)];
    
    [self refreshUI];
    
    self.contentView.hidden = YES;
    [self sendRequestOfInit];
}

//加载颜色配置
-(void) loadColorConfig
{
    _grouponInfoFrameView.layer.borderWidth = 0;
    
    _countTitleLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _shopPriceLabel.textColor = ColorForHexKey(AppColor_Amount1);
    _payPriceLabel.textColor = ColorForHexKey(AppColor_Amount1);
   _grouponDetailTitleLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _countLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _grouponNameLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
   
    [_confirmPayButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
}


-(void) refreshUI
{
    _grouponNameLabel.text = _grouponModel.groupon_name;

    _shopPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.shop_price.floatValue];

    [self updatePayPriceLabelText];

    //团购详情
    [self grouponDetailsShow];
    
    //发票信息
    _invoiceTitleView.hidden = YES;
    _invoiceNOBtn.selected = YES;
    _invoiceCheckBGView.height = 40;
    
    //账户余额、充值
    [self setOverageValue];
    
    [_layouFrameView layoutSuperView];
}

- (void)grouponDetailsShow
{
    _grouponDetailsWebView.delegate = self;
    [_grouponDetailsWebView loadHTMLString:_grouponModel.content baseURL:nil];
}

- (IBAction)grouponDetailsShowAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //更改图片
        [_grouponNextButton setImage:[UIImage imageNamed:@"public_arrow_down"] forState:UIControlStateNormal];
        //更改高度
        _grouponDetailsBGView.height = _grouponDetailsWebView.height+48;
        
    } else {
        [_grouponNextButton setImage:[UIImage imageNamed:@"public_arrow_up"] forState:UIControlStateNormal];
        _grouponDetailsBGView.height = 48;
    }
    [_layouFrameView layoutSuperView];
}

//账户余额、充值
- (void)setOverageValue
{
    NSString *overage = @"￥0.00";
    for (PayModeModel *payModeModel in _payModelArray) {
        if (payModeModel.pay_id.intValue == PayModeUserAccount) {
            overage = [NSString stringWithFormat:@"￥%@",payModeModel.user_money];
        }
    }
    _overageOrRechargeView = [OverageOrRechargeView viewFromXIB];
    [_oveOrRecBGView addSubview:_overageOrRechargeView];
    [_overageOrRechargeView setOverageValue:overage];
    [_overageOrRechargeView.rechargeButton addTarget:self action:@selector(rechargeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rechargeButtonAction:(UIButton *)button
{
    RechargeVC *rechVC = [[RechargeVC alloc] init];
    [self.navigationController pushViewController:rechVC animated:YES];
}

#pragma mark - InvoiceCheckView

- (IBAction)checkNOButtonAction:(id)sender
{
    if (_invoiceYESBtn.selected) {
        _invoiceYESBtn.selected = NO;
        _invoiceNOBtn.selected = YES;
        _invoiceTitleView.hidden = YES;
    }
    
    [UIView beginAnimations:@"CloseAnimation" context:nil];
     _invoiceCheckBGView.height = 40;
    [UIView commitAnimations];
    
    [_layouFrameView layoutSuperView];
}

- (IBAction)checkYESButtonAction:(id)sender
{
    if (_invoiceNOBtn.selected) {
        _invoiceYESBtn.selected = YES;
        _invoiceNOBtn.selected = NO;
        _invoiceTitleView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
    _invoiceCheckBGView.height = 85;
    } completion:^(BOOL finished) {
    }];
    
    [_layouFrameView layoutSuperView];
}

#pragma mark - ExpandFrameViewDeleagte

- (float)expandFrameView:(ExpandFrameView *)expandFrameView topMarginOfView:(UIView *)view
{
    if (view == _grouponInfoView) {
        return 0;
    }
    if (view == _invoiceCheckBGView) {
        return 0;
    }
    if (view == _payManagerBGView) {
        if (_invoiceYESBtn.selected) {
            return 10;
        }
        return 0;
    }
    return 10;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _grouponDetailsWebView.height = webView.scrollView.contentSize.height;
}

#pragma - mark ViewActions

-(void)clickPromptViewAction
{
    [self sendRequestOfInit];
}

//支付完成
- (IBAction)confirmPayAction:(id)sender
{
    /**
    order_id(可选)
    user_id
    groupon_id
    order_num
    invoice0/1
    invoice_title
    payment_id
    order_amount
    order_type:3
    */
    
    if (_invoiceYESBtn.selected) {
        if ([NSString isBlankString:_invoiceTitleField.text]) {
            [BDKNotifyHUD showCryingHUDWithText:@"请输入发票抬头"];
            return;
        }
    }
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@",_grouponModel.groupon_id] forKey:@"groupon_id"];
    [params setObject:_countLabel.text forKey:@"order_num"];
    [params setObject:[NSString stringWithFormat:@"%d",_invoiceYESBtn.selected] forKey:@"invoice"];
    if (_invoiceYESBtn.selected) {
        [params setObject:_invoiceTitleField.text forKey:@"invoice_title"];
    }
    
    //支付方式id
    [params setObject:[NSString stringWithFormat:@"%d",_selPayModel.pay_id.intValue] forKey:@"pay_id"];
  
    [params setObject:[NSString stringWithFormat:@"%.2f",_grouponModel.shop_price.floatValue * _countLabel.tag] forKey:@"order_amount"];
    [params setObject:[NSString stringWithFormat:@"%d", GrouponOrderType] forKey:@"order_type"];
    
    [GrouponPayRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
    {
        
        if (request.isSuccess)
        {
            [self handleServerPayResult:request.resultDic];
        }else
        {
            NSString *msg = [NSString isBlankString:request.resultDic[@"msg"]] ? @"下单失败 请重试" : request.resultDic[@"msg"];
            [BDKNotifyHUD showCryingHUDWithText:msg];
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
        [BDKNotifyHUD showCryingHUDWithText:@"下单失败 请重试"];
        
    }];

}


/**
 *  去团购订单详情页面
 *
 *  @param orderID    团购订单id
 *  @param expense_sn 团购消费码
 */
-(void) gotoOrderDetailsWithOrderID:(NSString *) orderID
{

//    GrouponOrderModel *orderModel = [[GrouponOrderModel alloc] init] ;
//    orderModel.groupon_id = _grouponModel.groupon_id;
//    orderModel.order_id = orderID;
//        
//    MeVC *meVC = [[MeVC alloc] init] ;
//    GroupByOrdersListVC *takeOrderListVC = [[GroupByOrdersListVC alloc] init];
//    GroupBuyOrderDetailsVC *takeOrderDetailsVC = [[GroupBuyOrderDetailsVC alloc] initWithGroupOrderModel:orderModel] ;
//        
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:[KAPP_DELEGATE viewController],meVC,takeOrderListVC,takeOrderDetailsVC, nil];
//    [self.navigationController setViewControllers:viewControllers animated:YES];
}

/**
 *  去团购订单列表页面
 */
-(void) gotoOrderList
{

}

//处理服务器支付结果
-(void) handleServerPayResult:(NSDictionary *) resultDic
{
    PayResultModel *resultModel = [[PayResultModel alloc] initWithDictionary:resultDic[@"data"]];
    if ([NSString isBlankString:resultModel.order_sn]) {
        [BDKNotifyHUD showCryingHUDWithText:@"订单号为空"];
        return;
    }
    
    if (resultModel.add_result.intValue == WaitAlipayPaymentStatus) { //等待使用支付宝支付
    
        Product *product = [[Product alloc] init] ;
        product.price = _grouponModel.shop_price.floatValue * _countLabel.tag;
        product.orderId = resultModel.order_sn;
        product.subject = [NSString stringWithFormat:@"团购订单:%@",_grouponModel.groupon_name];
        product.body = [NSString stringWithFormat:@"团购内容:%@",_grouponModel.content];

        [[AliPayManager shareManager] payForProduct:product completion:^(BOOL success) {
            [self gotoOrderList];
        }];
    } else if (resultModel.add_result.intValue == WaitUPPayPaymentStatus) { //等待使用银联支付
    
        [[UPPayPluginManager shareManager] uPPayPluginStartViewController:self uPPayTN:resultModel.order_sn successBlock:^(NSString *success) {
            [BDKNotifyHUD showSmileyHUDWithText:success completion:^{
                [self gotoOrderList];
            }];
        } failBlock:^(NSString *error) {
            [BDKNotifyHUD showCryingHUDWithText:error completion:^{
                [self gotoOrderList];
            }];
        } cancelBlock:^(NSString *cancel) {
            [BDKNotifyHUD showCryingHUDWithText:cancel completion:^{
                [self gotoOrderList];
            }];
        }];
    } else if (resultModel.add_result.intValue == WaitWXPayPaymentStatus) { //等待使用微信支付
        
        [[WXApiManager shareManager] wxPayForProduct:resultModel.wxpay_result successCompletion:^(BOOL success) {
            [self gotoOrderList];
        } failureCompletion:^(BOOL failure) {
            [self gotoOrderList];
        }];
    } else {
        
        NSString *msg = resultDic[@"msg"];
        [BDKNotifyHUD showSmileyHUDWithText:msg completion:^{
            [self gotoOrderList];
        }];
    }
}
#pragma mark Actions
-(void) updatePayPriceLabelText
{
    
    if ((int)_grouponModel.shop_price.floatValue == _grouponModel.shop_price.floatValue )
    {
        _payPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",_grouponModel.shop_price.floatValue * _countLabel.tag];
        
    }else
    {
        _payPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.shop_price.floatValue * _countLabel.tag];
    }
}

- (IBAction)reduceBuyCountAction:(id)sender
{
    if ((_countLabel.tag -1) < 1)
    {
        return;
    }
    
    _countLabel.tag -=1;
    _countLabel.text = [NSString stringWithFormat:@"%d", (int)_countLabel.tag];
    [self updatePayPriceLabelText];
   
}

- (IBAction)addBugyCountAction:(id)sender
{
    _countLabel.tag +=1;
    _countLabel.text = [NSString stringWithFormat:@"%d", (int)_countLabel.tag];
    _payPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.shop_price.floatValue * _countLabel.tag];
    
    [self updatePayPriceLabelText];
}


#pragma mark Request
-(void) sendRequestOfInit
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:_grouponModel.groupon_id forKey:@"groupon_id"];
    [params setObject:[NSString stringWithFormat:@"%d", GrouponOrderType] forKey:@"order_type"];
    
    [GrouponPayInitRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             StoreModel *storeModel = [_grouponModel store] ;
             RELEASE_SAFELY(_grouponModel);
           
             _grouponModel.store = storeModel;
             _grouponModel = [request.resultDic objectForKey: KRequestResultDataKey];
             
             _payModelArray  = [request.resultDic objectForKey: KTakeOrderPayModeResultRequest];
             [PayMannerView showInView:_payManagerBGView WithModelArray:_payModelArray WithSelectedBlock:^(id obj) {
                 _selPayModel = (PayModeModel *)obj ;
             }];
             
             self.contentView.hidden = NO;
             [self refreshUI];
             [self hidePromptView];
             
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
@end
