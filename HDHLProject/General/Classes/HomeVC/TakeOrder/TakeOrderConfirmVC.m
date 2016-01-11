//
//  TakeOrderConfirmVC.m
//  Carte
//
//  Created by ligh on 14-9-24.
//
//

#import "TakeOrderConfirmVC.h"
#import "OrderListItemView.h"
#import "FrameLineView.h"
#import "OrderTakeInitRequest.h"
#import "OrderTakeSureRequest.h"
#import "OrderSelectedListView.h"

#define kOrderConfirmViewSpace 10

@interface TakeOrderConfirmVC () <UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *_contentScrollView;
    IBOutlet FrameViewWB *_orderListView; //菜单
    IBOutlet UILabel     *_nameLabel;
    IBOutlet FrameViewWB *_remarkView;    //备注
    IBOutlet UILabel     *_remarkLabel;
    IBOutlet UITextField *_remarkTextField;
    IBOutlet FrameViewWB *_invoiceView;   //发票
    IBOutlet UILabel     *_invoiceLabel;
    IBOutlet UITextField *_invoiceTextField;
    
    IBOutlet UIView    *_bottomView;
    IBOutlet RTLabel   *_countLabel; //支付数量
    IBOutlet UILabel   *_priceLabel; //支付金额
    
    IBOutlet UIButton  *_orderSureButton;
    ShoopCartPayInfo   *_payInfo; //支付信息
    BOOL _showNOPreView;
}
@end

@implementation TakeOrderConfirmVC


- (void)dealloc
{
    RELEASE_SAFELY(_orderListView);
    RELEASE_SAFELY(_orderSureButton);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_orderListView);
    RELEASE_SAFELY(_orderSureButton);
    [super viewDidUnload];
}

//根据支付信息
- (id)initWithShoopCartPayInfo:(ShoopCartPayInfo *) payInfo
{
    if (self = [super init]) {
        if (!_payInfo) {
            _payInfo = [[ShoopCartPayInfo alloc] init];
        }
        _payInfo = payInfo;
        _showNOPreView = NO;
    }
    return self;
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if (_showNOPreView) {
//        return ;
//    }
//    
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [OrderTakeInitRequest cancelUseDefaultSubjectRequest];
    [OrderTakeSureRequest cancelUseDefaultSubjectRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarTitle:@"订单确认"];
    [self loadColorView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    _contentScrollView.delegate = self;
    _remarkTextField.delegate = self;
    _remarkTextField.tag = 1;
    _invoiceTextField.delegate = self;
    _invoiceTextField.tag = 2;

    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTapClick:)];
    [_contentScrollView addGestureRecognizer:tapGestureR];
    
    //订单初始化
    self.contentView.hidden = YES;
    [self sendRequestOfOrderTakeInitRequest];
}

- (void)loadColorView
{
    _orderSureButton.titleLabel.font = FONT_BOTTOM_RIGHT_BUTTON;
    _nameLabel.font = FONT_STORE_NAME;
    _remarkLabel.font = FONT_LIST_TITLE;
    _invoiceLabel.font = FONT_LIST_TITLE;
    _remarkTextField.font = FONT_LIST_CONTENT;
    _invoiceTextField.font = FONT_LIST_CONTENT;
    _priceLabel.font = FONT_BOTTOM_PRICE;
    
    _nameLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _remarkLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _invoiceLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _countLabel.textColor = [UIColor whiteColor];
    _priceLabel.textColor = [UIColor whiteColor];
    [_orderSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderSureButton setTitleColor:ColorForHexKey(AppColor_OrderBottom_Disabled_Title) forState:UIControlStateDisabled];
    [_orderSureButton setBackgroundColor:ColorForHexKey(AppColor_OrderBottom_Selected)];
    _bottomView.backgroundColor = ColorForHexKey(AppColor_OrderBottom_BgColor);
}

//刷新UI
- (void)refreshUI
{
    //底部支付信息
    [_countLabel setTextAlignment:RTTextAlignmentLeft];
    _countLabel.text = [NSString stringWithFormat:@"<font size=16>共%d个菜</font>", _payInfo.product_count];
    _priceLabel.text = [NSString stringWithFormat:@"合计:￥%@", _payInfo.payInfoString];
    if (_payInfo.product_count > 99 && _payInfo.payInfoString.floatValue > 9999.99) {
        _countLabel.left = 5;
        _priceLabel.right = _orderSureButton.left;
    }
    
    //店铺名
    _nameLabel.text = _payInfo.storeModel.store_name;
    
    //点菜清单
    OrderSelectedListView *orderView = [[OrderSelectedListView alloc] initWithFrame:CGRectMake(0, 45, _orderListView.width, 0)];
    [orderView showOrderSelectedListInView:_orderListView withArray:_payInfo.productArray showMarketPrice:YES];
    [_orderListView addSubview:orderView];
    _orderListView.height = orderView.bottom + 2;
    
    _remarkView.top = _orderListView.bottom + kOrderConfirmViewSpace;
    _invoiceView.top = _remarkView.bottom + kOrderConfirmViewSpace;
    [_contentScrollView setContentSize:CGSizeMake(0, _invoiceView.bottom + 20)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing];
}

//点击事件
-(void)bgViewTapClick:(UITapGestureRecognizer*)tap {
    [self endEditing];
}

#pragma -
#pragma - Requests

- (void)sendRequestOfOrderTakeInitRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *selectType = [NSString stringWithFormat:@"%d",DishOrderType];
    [params setObject:selectType forKey:@"order_type"];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_payInfo.storeModel.store_id forKey:@"store_id"];
    [params setObject:_payInfo.goodsJSONString forKey:@"goods"];
    
    [OrderTakeInitRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
            //支付金额
            _payInfo.payInfoString = [(NSDictionary *)request.resultDic[@"data"] stringForKey:@"goodsAmount"];
            //菜品数量
            _payInfo.totalcount = [(NSDictionary *)request.resultDic[@"data"] stringForKey:@"totalcount"];
            //菜品
            if (_payInfo.productArray.count) {
                [_payInfo.productArray removeAllObjects];
            }
            _payInfo.productArray = (NSMutableArray *)[NSArray arrayWithArray:request.resultDic[KTakeOrderGoodsResultRequest]];
            //店铺
            _payInfo.storeModel.store_name = [(NSDictionary *)request.resultDic[@"data"] stringForKey:@"store_name"];
            _payInfo.storeModel.brand_id = [(NSDictionary *)request.resultDic[@"data"] stringForKey:@"brand_id"];

            self.contentView.hidden = NO;
            [self refreshUI];

        } else {
            if (request.isNoLogin) {
                return ;
            }
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"服务器加载失败"];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络加载失败"];
    }];
}

- (IBAction)submitOrderAction:(id)sender
{
    _showNOPreView = YES;
    _orderSureButton.enabled = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *selectType = [NSString stringWithFormat:@"%d",DishOrderType];
    [params setObject:selectType forKey:@"order_type"];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_payInfo.storeModel.store_id forKey:@"store_id"];
    [params setObject:_payInfo.storeModel.brand_id forKey:@"s_id"];
    [params setObject:_payInfo.goodsJSONString forKey:@"goods"];
    if (![NSString isBlankString:_remarkTextField.text]) {
        [params setObject:_remarkTextField.text forKey:@"content"];
    }
    if (![NSString isBlankString:_invoiceTextField.text]) {
        [params setObject:_invoiceTextField.text forKey:@"invoice_title"];
    }

    [OrderTakeSureRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
    
        if (request.isSuccess) {
            
            [BDKNotifyHUD showSmileyHUDInView:self.view text:request.resultDic[@"msg"] completion:^{
                if (_payInfo.takeOrderType == TakeOrderDefaultType) { //点菜支付 跳 OrderVC 列表页面
                    [self popFromViewControllerToRootViewControllerWithTabBarIndex:kTabbarIndex1 animation:YES];
                    //刷新订单列表
                    [self postNotificaitonName:kRefreshOrdersListNotification];

                }
            }];
        } else {
            if (request.isNoLogin) {
                return ;
            }
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"订单生成失败"];
            _orderSureButton.enabled = YES;
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络加载失败"];
        _orderSureButton.enabled = YES;
    }];
}

#pragma mark - ClickNavigationBarButton

- (void)actionClickNavigationBarLeftButton
{
    [super actionClickNavigationBarLeftButton];
    if ([_delegate respondsToSelector:@selector(showTakeOrderSelectedListWithPayInfo:)]) {
        [_delegate showTakeOrderSelectedListWithPayInfo:_payInfo];
    }
}

#pragma mark - 限制备注入输入长度

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _remarkTextField) {
        if (textField.text.length > 30) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)fieldTextChanged:(NSNotification *)notification
{
    if (_remarkTextField.text.length > 30) {
        _remarkTextField.text = [_remarkTextField.text substringToIndex:30];
    }
}

@end
