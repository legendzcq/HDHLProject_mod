//
//  GroupBuyOrderDetailsVC.m
//  Carte
//
//  Created by zln on 14/12/25.
//
//

#import "GroupBuyOrderDetailsVC.h"
#import "StrikethroughLabel.h"
#import "PayModeView.h"
#import "GrouponOrderModel.h"
#import "GrouponOrderDetailsRequest.h"
#import "CouponCodeView.h"
#import "CancelOrderRequest.h"
#import "OtherStoreInfoVC.h"
#import "GrouponPayRequest.h"
#import "GroupBuyDetailsVC.h"
#import "CommonHelper.h"
#import "FrameViewWB.h"
#import "FrameLineView.h"
#import "PayMannerView.h"
#import "UPPayPluginManager.h"
#import "PayResultModel.h"

@interface GroupBuyOrderDetailsVC ()<ExpandFrameViewDeleagte,UIScrollViewDelegate,UIActionSheetDelegate,UIWebViewDelegate,PayModeViewDelegate>
{
    //滑动试图
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet ExpandFrameView *_layOutFrameView;
    
    //图片展示
    IBOutlet ExpandFrameView *_imageFrameView;
    //图片展示
    
    IBOutlet WebImageView *_grouponImageView;
    
    //团购码显示
    IBOutlet ExpandFrameView *_expenseFrameView;
    
    //团购码标题
    IBOutlet UIView *_expenseTitleView;
    //团购码内容显示
    IBOutlet UIView *_expenseContentView;
    
    //订单状态显示
    IBOutlet ExpandFrameView *_orderStatusShowView;
   
    //订单状态
    IBOutlet UILabel *_orderStatusTitleLabel;
    
  //价钱显示
    
    IBOutlet ExpandFrameView *_priceShowFrameView;
    //现价显示
    IBOutlet UILabel *_nowPriceLabel;
    
    IBOutlet UILabel *_nowPriceLabel2;
    
    //市场价显示
    IBOutlet StrikethroughLabel *_agoPriceLabel;
    
    IBOutlet StrikethroughLabel *_agoPriceLabel2;
    //再次抢购
    IBOutlet UIButton *_againBuyButton;
    
    
    //店铺信息显示
    IBOutlet FrameView *_storeInfoShowFrameView;
    //商家名称
    IBOutlet UILabel *_storeNameLabel;
    
    //已经销售的团购
    IBOutlet UILabel *_yiShouLabel;
    
   //剩余时间
    IBOutlet UILabel *_shengYuTimeLabel;
    
    //显示更多商家信息
    IBOutlet ExpandFrameView *_moreStoreFrameView;
    //更多商家表头信息
    IBOutlet UIView *_moreStoreTitleView;
    
    //商家信息
    IBOutlet UIView *_storeInfoView;
    
    //更多分点里面的商家详情
    
    IBOutlet UILabel *_shiYongFanWeiLabel;
    
    IBOutlet UILabel *_moreStoreNameLabel;
    
    
    IBOutlet UILabel *_moreStoreAddressLabel;
    
    
    IBOutlet UIView *_moreStoreListView;
    
    
    IBOutlet ExpandFrameView *_grouponDetailFrameView;
    //团购详情
    
    IBOutlet FrameViewWB *_groupFrameView;
    IBOutlet UIWebView *_grouponDetailsWebView;
    
 
    IBOutlet FrameViewWB *_howFrameView;
    
    IBOutlet ExpandFrameView *_howBuyFrameView;
    //购买须知
    IBOutlet UIWebView *_howBuyWebView;
    
    

    
    //支付方式的选择
    IBOutlet FrameViewWB *_payModelBGView;
    
    //支付方式的model
    PayModeModel *_payModel;
    
    IBOutlet PayMannerView *_payModelView;
    //下面的支付显示
    IBOutlet UIView *_continuePayView;
//总共的团购价钱显示
    IBOutlet UILabel *_totalPriceLabel;

//继续支付按钮
    
    IBOutlet UIButton *_continuePayButton;
    
    IBOutlet FrameView *_askTuiKuanFrameView;
    

    IBOutlet UIButton *_askTuiButton;
    //团购订单详情
    GrouponOrderModel       *_grouponOrderModel;
    NSString                *_orderID;
    
    CLLocation              *_userLocation;//定位到的用户位置

    //矩形图片

    IBOutlet UIImageView *_secondImageView;
    
}

@end

@implementation GroupBuyOrderDetailsVC

- (void)dealloc {
    
    RELEASE_SAFELY(_grouponOrderModel);
    RELEASE_SAFELY(_orderID);
    RELEASE_SAFELY(_userLocation);

    RELEASE_SAFELY(_payModelView);
    RELEASE_SAFELY(_continuePayButton);
    RELEASE_SAFELY(_totalPriceLabel);
    RELEASE_SAFELY(_continuePayView);
    RELEASE_SAFELY(_grouponImageView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_grouponDetailsWebView);
    RELEASE_SAFELY(_moreStoreListView);
    RELEASE_SAFELY(_moreStoreAddressLabel);
    RELEASE_SAFELY(_moreStoreNameLabel);
    RELEASE_SAFELY(_storeInfoView);
    RELEASE_SAFELY(_moreStoreTitleView);
    RELEASE_SAFELY(_moreStoreFrameView);
    RELEASE_SAFELY(_shengYuTimeLabel);
    RELEASE_SAFELY(_yiShouLabel);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_storeInfoShowFrameView);
    RELEASE_SAFELY(_againBuyButton);
    RELEASE_SAFELY(_agoPriceLabel);
    RELEASE_SAFELY(_nowPriceLabel);
    RELEASE_SAFELY(_priceShowFrameView);
    RELEASE_SAFELY(_orderStatusTitleLabel);
    RELEASE_SAFELY(_orderStatusShowView);
    RELEASE_SAFELY(_expenseContentView);
    RELEASE_SAFELY(_expenseTitleView);
    RELEASE_SAFELY(_expenseFrameView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_imageFrameView);
    RELEASE_SAFELY(_scrollView);
}


- (void)viewDidUnload {
    
    RELEASE_SAFELY(_payModelView);
    RELEASE_SAFELY(_continuePayButton);
    RELEASE_SAFELY(_totalPriceLabel);
    RELEASE_SAFELY(_continuePayView);
    RELEASE_SAFELY(_grouponImageView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_grouponDetailsWebView);
    RELEASE_SAFELY(_moreStoreListView);
    RELEASE_SAFELY(_moreStoreAddressLabel);
    RELEASE_SAFELY(_moreStoreNameLabel);
    RELEASE_SAFELY(_storeInfoView);
    RELEASE_SAFELY(_moreStoreTitleView);
    RELEASE_SAFELY(_moreStoreFrameView);
    RELEASE_SAFELY(_shengYuTimeLabel);
    RELEASE_SAFELY(_yiShouLabel);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_storeInfoShowFrameView);
    RELEASE_SAFELY(_againBuyButton);
    RELEASE_SAFELY(_agoPriceLabel);
    RELEASE_SAFELY(_nowPriceLabel);
    RELEASE_SAFELY(_priceShowFrameView);
    RELEASE_SAFELY(_orderStatusTitleLabel);
    RELEASE_SAFELY(_orderStatusShowView);
    RELEASE_SAFELY(_expenseContentView);
    RELEASE_SAFELY(_expenseTitleView);
    RELEASE_SAFELY(_expenseFrameView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_imageFrameView);
    RELEASE_SAFELY(_scrollView);

    _askTuiKuanFrameView = nil;
    _grouponDetailFrameView = nil;
    _howBuyFrameView = nil;
    _shiYongFanWeiLabel = nil;
    _orderStatusShowView = nil;
    _nowPriceLabel2 = nil;
    _agoPriceLabel2 = nil;
    _groupFrameView = nil;
   
    _howBuyFrameView = nil;
    _howBuyFrameView = nil;
    _howFrameView = nil;
    _secondImageView = nil;
    _priceShowFrameView = nil;
    _layOutFrameView = nil;
    _payModelBGView = nil;
    _askTuiButton = nil;
    [super viewDidUnload];
}

-(id)initWithGroupOrderModel:(GrouponOrderModel *)groupOrderModel
{
    if (self = [super init])
    {
        _grouponOrderModel = groupOrderModel ;
        _orderID = _grouponOrderModel.order_id ;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _layOutFrameView.layoutDelegate = self;
}

-(void)configViewController
{
    [super configViewController];
    [self loadColorConfig];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self setNavigationBarTitle:@"团购详情"];
    [_scrollView setContentSize:CGSizeMake(0, 500)];
    
    self.contentView.hidden = YES;
    [self sendRequestOfGrouponDetails];
    
}

- (void)loadColorConfig
{
    _nowPriceLabel.textColor = ColorForHexKey(AppColor_Amount1);
//    _nowPriceLabel2.textColor = ColorForHexKey(AppColor_Amount1);
    _agoPriceLabel.textColor = ColorForHexKey(AppColor_Original_Price1);
    _agoPriceLabel2.textColor = ColorForHexKey(AppColor_Original_Price1);
    _storeNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
    _moreStoreNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
    _moreStoreAddressLabel.textColor = ColorForHexKey(AppColor_Content_Text1);
    _yiShouLabel.textColor = ColorForHexKey(AppColor_Prompt_Text1);
    _shengYuTimeLabel.textColor = ColorForHexKey(AppColor_Prompt_Text1);
    [_askTuiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_askTuiButton setBackgroundImage:[UIImage imageNamed:@"order_button_pay.png"] forState:UIControlStateNormal];
    [_askTuiButton setBackgroundImage:[UIImage imageNamed:@"order_button_pay_click.png"] forState:UIControlStateHighlighted];
}
#pragma mark============更新数据========
- (void)refreshUI
{
    if (!_grouponOrderModel) {
        return;
    }
    //加载团购图片
    [_grouponImageView setImageWithUrlString:_grouponOrderModel.image_big placeholderImage:KBigPlaceHodlerImage];
    
    //价格显示 暂无数据 假数据显示
    if ((int)_grouponOrderModel.shop_price.floatValue == _grouponOrderModel.shop_price.floatValue)
    {
        
        _nowPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",_grouponOrderModel.shop_price.floatValue];
        _nowPriceLabel2.text = [NSString stringWithFormat:@"￥%.0f",_grouponOrderModel.shop_price.floatValue];

        
    }else
    {
        _nowPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponOrderModel.shop_price.floatValue];
        _nowPriceLabel2.text = [NSString stringWithFormat:@"￥%.2f",_grouponOrderModel.shop_price.floatValue];

    }
    
    if ((int)_grouponOrderModel.shop_price.floatValue == _grouponOrderModel.shop_price.floatValue)
    {
        _agoPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",_grouponOrderModel.market_price.floatValue];
        _agoPriceLabel2.text = [NSString stringWithFormat:@"￥%.0f",_grouponOrderModel.market_price.floatValue];

        
    }else
    {
        _agoPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponOrderModel.market_price.floatValue];
        _agoPriceLabel2.text = [NSString stringWithFormat:@"￥%.2f",_grouponOrderModel.market_price.floatValue];

    }
    
    float width = [_nowPriceLabel.text widthWithFont:_nowPriceLabel.font boundingRectWithSize:CGSizeMake(100, _nowPriceLabel.height)];
    _nowPriceLabel.width = width;
    _agoPriceLabel.left = _nowPriceLabel.right + MARGIN_S;
    
    float width2 = [_nowPriceLabel2.text widthWithFont:_nowPriceLabel2.font boundingRectWithSize:CGSizeMake(100, _nowPriceLabel2.height)];
    _nowPriceLabel2.width = width2;
    _agoPriceLabel2.left = _nowPriceLabel2.right + MARGIN_S;

  

    //加载团购码
    
    [self loadCouponCodeViews];

    //团购名称以及已售团购显示
    
//    //商家信息
    _storeNameLabel.text = _grouponOrderModel.groupon_name;
    _shengYuTimeLabel.text = [NSString stringWithFormat:@"剩余%d天",_grouponOrderModel.surplus_day.intValue];
    _yiShouLabel.text = [NSString stringWithFormat:@"已售%d件",_grouponOrderModel.sales.intValue];
   _shiYongFanWeiLabel.text = [NSString stringWithFormat:@"使用范围（%d家）",_grouponOrderModel.store_number.intValue];

    //显示更多分点信息
    if (_grouponOrderModel.storeModel)
    {
        _moreStoreFrameView.hidden = NO;
        if (![NSString isBlankString:_grouponOrderModel.brand_name]) {
            _moreStoreNameLabel.text  = [NSString stringWithFormat:@"%@(%@)",_grouponOrderModel.brand_name,_grouponOrderModel.storeModel.store_name];
        }else{
            _moreStoreNameLabel.text = _grouponOrderModel.storeModel.store_name;
        }
        _moreStoreAddressLabel.text = _grouponOrderModel.storeModel.address;
        _moreStoreListView.hidden = YES;
        _moreStoreFrameView.height = 136;
        if (_grouponOrderModel.store_number.intValue > 1)//是否有更多分店
        {
//            _storeCountLabel.text = [NSString stringWithFormat:@"共%d店",_grouponOrderModel.store_number.intValue];
            _moreStoreFrameView.height = 136;
            _moreStoreListView.hidden = NO;
        }
    }else
    {
        _moreStoreFrameView.height = 96;
        _moreStoreFrameView.hidden = YES;
    }
    
    //功能判断
    _orderStatusTitleLabel.text = [_grouponOrderModel orderStatusString];
    
    _orderStatusShowView.hidden = NO;
    if (_grouponOrderModel.order_status.intValue == 0)
    {
        _storeInfoShowFrameView.top = _priceShowFrameView.top + MARGIN_S+2;
        
        _storeInfoShowFrameView.height = 96;
        _orderStatusShowView.hidden = NO;
        _askTuiKuanFrameView.hidden = YES;
        _priceShowFrameView.hidden = YES;
        _payModelBGView.hidden = NO;
        _payModelView.hidden = NO;
        _continuePayView.hidden = NO;
        _expenseFrameView.hidden = YES;
        
        _scrollView.height = self.contentView.height - _continuePayView.height+MARGIN_S;
        
        _imageFrameView.height = _orderStatusShowView.top+ _orderStatusShowView.height;
        
        [_scrollView setContentSize:CGSizeMake(0, _scrollView.height+MARGIN_L*3)];
        
    } else if (_grouponOrderModel.order_status.intValue == 1)
    {
        
        _priceShowFrameView.top = _imageFrameView.height + MARGIN_S+2;

        _storeInfoShowFrameView.height = 65;
        _orderStatusShowView.hidden = YES;
        _askTuiKuanFrameView.hidden = NO;
        _priceShowFrameView.hidden = NO;
        _payModelBGView.hidden = YES;
        _payModelView.hidden = YES;
        _continuePayView.hidden = YES;
        _expenseFrameView.hidden = NO;
        
        _imageFrameView.height = _expenseFrameView.top+_expenseFrameView.height+MARGIN_S;
        _scrollView.height = self.contentView.height;
        [_scrollView setContentSize:CGSizeMake(0, _scrollView.height+MARGIN_L*3)];

    } else
    {
        _priceShowFrameView.top = _imageFrameView.height + MARGIN_S+2;
        
        _storeInfoShowFrameView.height = 65;
        _orderStatusShowView.hidden = YES;
        _askTuiKuanFrameView.hidden = YES;
        _priceShowFrameView.hidden = NO;
        _payModelBGView.hidden = YES;
        _payModelView.hidden = YES;
        _continuePayView.hidden = YES;
        _expenseFrameView.hidden = NO;
        
        _imageFrameView.height = _expenseFrameView.top+_expenseFrameView.height+MARGIN_S;
        _scrollView.height = self.contentView.height;
        [_scrollView setContentSize:CGSizeMake(0, _scrollView.height+MARGIN_L*3)];
    }
    _secondImageView.top = _imageFrameView.height- MARGIN_S;
    [_imageFrameView bringSubviewToFront:_secondImageView];
    
    //团购详情
    _grouponDetailsWebView.delegate = self;
    [_grouponDetailsWebView loadHTMLString: [NSString isBlankString:_grouponOrderModel.content] ? @"暂无团购详情"  : _grouponOrderModel.content baseURL:nil];
    //团购须知
    _howBuyWebView.delegate = self;
    [_howBuyWebView loadHTMLString:[NSString isBlankString:_grouponOrderModel.notice] ? @"暂无购买须知"  : _grouponOrderModel.notice baseURL:nil];
    //团购价格和数量
    _totalPriceLabel.text = [NSString stringWithFormat:@"共%@张 ￥%.2f",_grouponOrderModel.order_num,[_grouponOrderModel.shop_price doubleValue]*[_grouponOrderModel.order_num intValue]];
    
    //加线
    FrameLineView *lineView = [[FrameLineView alloc]initWithFrame:CGRectMake(0, _moreStoreFrameView.height-0.5, SCREEN_WIDTH, 0.5)];
    [_moreStoreFrameView addSubview:lineView];
       FrameLineView *lineViewOne = [[FrameLineView alloc]initWithFrame:CGRectMake(0, 45.5, SCREEN_WIDTH, 0.5)];
    [_groupFrameView addSubview:lineViewOne];
    [_imageFrameView layoutSuperView];
}

//加载消费码
-(void) loadCouponCodeViews
{
    [_expenseContentView removeAllSubviews];
    
    float y = MARGIN_S;
    for (int i = 0; i< _grouponOrderModel.expenseArray.count ; i++)
    {
        ExpenseCodeModel *expensCodeModel =  _grouponOrderModel.expenseArray[i];
        CouponCodeView *couponCodeView = [CouponCodeView viewFromXIB];
        couponCodeView.top = y + MARGIN_S;
        [_expenseContentView addSubview:couponCodeView];
        [couponCodeView setExpenseCodeModel:expensCodeModel];
        
        int status = [expensCodeModel.expense_sn_status intValue];
        if (status == ExpenseUnUseStatus)//根据消费码状态加载颜色信息
        {
            couponCodeView.couponCodeLabel.textColor =  ColorForHexKey(AppColor_Default_Promotion_Code);
            couponCodeView.statusLabel.textColor =  ColorForHexKey(AppColor_Default_Promotion_Code);
        }else
        {
            couponCodeView.couponCodeLabel.textColor =  ColorForHexKey(AppColor_Gray_Promotion_Code);
            couponCodeView.statusLabel.textColor =  ColorForHexKey(AppColor_Gray_Promotion_Code);
        }
        
        y += couponCodeView.height;
        
    }
    
    _expenseContentView.height = y + MARGIN_M;
    _expenseFrameView.height = _expenseContentView.top + _expenseContentView.height;
    
 }

#pragma mark PayModeViewDelegate

- (void)payModeViewSwitchShow:(BOOL)switchShow
{
    _payModelView.superview.height = _payModelView.height;
    [_layOutFrameView layoutSuperView];
    [_scrollView setContentSize:CGSizeMake(self.view.width, _scrollView.contentSize.height+MARGIN_L)];
}

#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.height = webView.scrollView.contentSize.height;

    if (webView == _grouponDetailsWebView)
    {
        
        _grouponDetailsWebView.height = webView.height;
        _groupFrameView.height = _grouponDetailsWebView.height;
        
//        _grouponDetailFrameView.top = _moreStoreFrameView.bottom - MARGIN_M*2;
        _grouponDetailFrameView.height = _grouponDetailsWebView.height+25;
//        _howBuyFrameView.top = _grouponDetailFrameView.bottom;
        
    } else if (webView == _howBuyWebView)
    {
        _howBuyWebView.height = webView.height;
        _howFrameView.height = _howBuyWebView.height;

//        _howBuyFrameView.top = _grouponDetailFrameView.bottom + MARGIN_M;
        _howBuyFrameView.height = _howBuyWebView.height+25;
    }
    
//    _imageFrameView.top = 0;
//    _payModelBGView.top = _howBuyFrameView.bottom+MARGIN_L;
    _askTuiKuanFrameView.top = _howBuyFrameView.bottom;
    

    [_layOutFrameView layoutSuperView];
    [_scrollView setContentSize:CGSizeMake(self.view.width, _scrollView.contentSize.height+MARGIN_L*3)];

}

#pragma mark==================数据处理==============

/**
 *  团购订单详情
 */
-(void) sendRequestOfGrouponDetails
{
    /**
     *   "expense_sn" = 418945897450;
     "groupon_id" = "";
     "order_id" = 176;
     "s_id" = 13;
     "user_id" = 1;
     */
    NSMutableDictionary *dictionaryParams = [NSMutableDictionary dictionary];
    [dictionaryParams setObject:[AccountHelper uid] forKey:@"user_id"];
    [dictionaryParams setObject:_grouponOrderModel.order_id forKey:@"order_id"];
    [dictionaryParams setObject:GrouponOrderListOrderType forKey:@"order_type"];
//    if (![NSString isBlankString:_grouponOrderModel.expense_sn])
//    {
//        [dictionaryParams setObject:_grouponOrderModel.expense_sn forKey:@"expense_sn"];
//    }
//    
//    
    if (_userLocation)
    {
        [dictionaryParams setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.latitude] forKey:@"lat"];
        [dictionaryParams setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.longitude] forKey:@"lng"];
    }
    

    [GrouponOrderDetailsRequest requestWithParameters:dictionaryParams withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {

         if (request.isSuccess)
         {
             GrouponOrderModel *grouponOrderModel = request.resultDic[KRequestResultDataKey];
             RELEASE_SAFELY(_grouponOrderModel);
             _grouponOrderModel = grouponOrderModel ;
             
             if (_grouponOrderModel.pays)
             {
                 //支付方式
                 [PayMannerView showInView:_payModelBGView WithModelArray:_grouponOrderModel.pays WithSelectedBlock:^(id obj) {
                     _payModel = (PayModeModel *)obj;
                 }];
             }
             
             [self refreshUI];
             self.contentView.hidden = NO;
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
#pragma mark Requests


//处理支付结果
-(void) handlePayResult:(NSDictionary *) resultDic
{
     [self postNotificaitonName:KOrderListRefreshNotification];
     int result = [resultDic[@"data"][@"add_result"] intValue];
     NSString *orderID = [NSString stringWithFormat:@"%@",resultDic[@"data"][@"order_id"]];
     PayResultModel *resultModel = [[PayResultModel alloc] initWithDictionary:resultDic[@"data"]] ;
    if (result == WaitAlipayPaymentStatus)//等待使用支付宝支付
    {
        //挑战到支付宝支付页面
        Product *product = [_grouponOrderModel convert2ProductInfo];
        
        [[AliPayManager shareManager] payForProduct:product completion:^(BOOL success)
         {
             if(success){
             [self sendRequestOfGrouponDetails];
             }
         }];
    } else if(result == WaitUPPayPaymentStatus){ //银联
        [[UPPayPluginManager shareManager] uPPayPluginStartViewController:self uPPayTN:orderID successBlock:^(NSString *success){
            [BDKNotifyHUD showSmileyHUDWithText:success completion:^{
              [self sendRequestOfGrouponDetails];
            }];
        } failBlock:^(NSString *error) {
            [BDKNotifyHUD showCryingHUDWithText:error completion:^{
              
            }];
        } cancelBlock:^(NSString *cancel) {
            [BDKNotifyHUD showCryingHUDWithText:cancel completion:^{
            }];
        }];
    }else if(result == WaitWXPayPaymentStatus){//微信
            [[WXApiManager shareManager] wxPayForProduct:resultModel.wxpay_result successCompletion:^(BOOL success) {
                  [self sendRequestOfGrouponDetails];
            } failureCompletion:^(BOOL failure) {
            }];
    }else
    {
        NSString *mesString = resultDic[@"msg"];
        [BDKNotifyHUD showCryingHUDWithText:mesString];
    }
}

/**
 *  继续支付接口
 */
-(void) sendRequestOfPay
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:_orderID forKey:@"order_id"];
    //支付方式id
//    PayModeModel *payModeModel = (PayModeModel *)_payModelView.selectedOptionsMoel;
    [params setObject:[NSString stringWithFormat:@"%d",_payModel.pay_id.intValue] forKey:@"pay_id"];
    
    [GrouponPayRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             [self handlePayResult:request.resultDic];
         }else
         {
             NSString *msg = request.resultDic[@"msg"];
             [BDKNotifyHUD showCryingHUDWithText:[NSString isBlankString:msg] ? @"支付失败" : msg];
         }
     }onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDWithText:@"支付失败"];
     }];
}


/**
 *  取消订单
 */
-(void) sendRequestOfCanceOrder
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_orderID forKey:@"order_id"];
    [params setObject:[NSString stringWithFormat:@"%d",GrouponOrderType] forKey:@"order_type"];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:@"user" forKey:@"who"];
    
    [CancelOrderRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             [self postNotificaitonName:KOrderListRefreshNotification];
             
             [BDKNotifyHUD showSmileyHUDWithText:@"已撤销" completion:^{
                 
                 //    _grouponOrderModel.order_status = [NSNumber numberWithInt:GrouponOrderRefundStatus];
                 //  [self refreshUI];
                 
                 [self sendRequestOfGrouponDetails];
                 
             }];
         }else
         {
             NSString *msg = request.resultDic[@"msg"];
             [BDKNotifyHUD showCryingHUDWithText:[NSString isBlankString:msg] ? @"撤单失败" : msg];
         }
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDWithText:@"撤单失败"];
     }];
}


#pragma mark viewActions

//其他分店信息
- (IBAction)moreStroeAction:(id)sender
{
    OtherStoreInfoVC *otherStoreInfoVC = [[OtherStoreInfoVC alloc] initWithGrouponID:_grouponOrderModel.groupon_id withBrandName: _grouponOrderModel.brand_name];
    [self.navigationController pushViewController:otherStoreInfoVC animated:YES];
}



//取消或者继续支付
- (IBAction)cancelOrderOrPay:(id)sender
{
    if ([_grouponOrderModel isAgainPay])//继续支付
    {
        
        [self sendRequestOfPay];
        
    }else if([_grouponOrderModel isCancelOrder])//退款
    {
        [[MessageAlertView viewFromXIB] showAlertViewInView:self.view msg:@"您确定要撤销此订单吗？" onCanleBlock:nil onConfirmBlock:^{
            
            [self sendRequestOfCanceOrder];
            
        }];
    }else{
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"亲，已无法撤单"];
    }
}
-(void)actionClickNavigationBarLeftButton
{
    [GrouponOrderDetailsRequest cancelUseDefaultSubjectRequest];
    [CancelOrderRequest cancelUseDefaultSubjectRequest];
    
    [super actionClickNavigationBarLeftButton];
}

//呼叫商家
//呼叫分店
- (IBAction)callStore:(id)sender
{
    if (!_grouponOrderModel.storeModel)
    {
        return;
    }
    NSArray *mobileArray = [PhoneNumberHelper parseText:_grouponOrderModel.storeModel.phone];
    
    if (mobileArray && mobileArray.count>1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *mobile in mobileArray)
        {
            [actionSheet addButtonWithTitle:mobile];
        }
        
        [actionSheet addButtonWithTitle:@"取消"];
        
        [actionSheet showInView:self.view];
        
    }else
    {
        [PhoneNumberHelper callPhoneWithText:mobileArray[0]];
    }
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *mobile = [actionSheet buttonTitleAtIndex:buttonIndex];
    [PhoneNumberHelper callPhoneWithText:mobile];
}

//再次购买
- (IBAction)rushBuyAction:(id)sender
{
    GroupBuyDetailsVC *groupBuyDetailsVC  = [[GroupBuyDetailsVC alloc] initWithGrouponID:_grouponOrderModel.groupon_id];
    [self.navigationController pushViewController:groupBuyDetailsVC animated:YES];
}


#pragma mark ExpandFrameViewDeleagte
-(float)expandFrameView:(ExpandFrameView *)expandFrameView topMarginOfView:(UIView *)view
{
    if (view == _continuePayView)//取消订单按钮 距之上view之间的距离为30
    {
        return 30.0f;
        
    }
    else if (view == _imageFrameView)
    {
        return 0;
    }else if ( view == _grouponDetailFrameView)
    {
        return -MARGIN_S;
    } else if (view == _askTuiKuanFrameView)
    {
        return 0;
    }
    
    //默认为10 也可以重写此方法来返回想要的距离
    return MARGIN_M;
}


@end