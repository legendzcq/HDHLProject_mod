//
//  RechargeVC.m
//  Carte
//
//  Created by zln on 14/12/29.
//
//

#import "RechargeVC.h"
#import "RechargeRecoderVC.h"
#import "RechargeRequest.h"
#import "RechargeAddRequest.h"
#import "FrameViewWB.h"
#import "RoundImageView.h"
#import "ActivityTipView.h"
#import "PayMannerView.h"
#import "WebVC.h"
#import "ActivityModel.h"
#import "RechargeConfirmVC.h"
#import "PayResultModel.h"
#import "UIColor-Expanded.h"

@interface RechargeVC () <ExpandFrameViewDeleagte, UIScrollViewDelegate,ActivityTipViewDelegate>
{
    IBOutlet ExpandFrameView *_layoutView;
    //品牌ID
    NSString *_brandID;
    //店铺ID收藏用
    NSString *_storeID;
    //用户信息
    IBOutlet FrameViewWB *_personInfoView;
    IBOutlet UILabel *_moneyLabel;
    IBOutlet UILabel *_personIphoneLabel;
    IBOutlet UILabel *_personNameLabel;
    IBOutlet RoundImageView *_personImageView;
    
    IBOutlet UITextField *_moneyTextField;
    
    IBOutlet RTLabel *_promptLabel;
    
    IBOutlet UIImageView *_moneyBgImageView;
    IBOutlet UIButton *_payButton;
    
    
    IBOutlet FrameView *_payBGView;
    UserModel *_userModel;
    
    BOOL _activityTipBOOL;
    BOOL _AbulkCancelBOOL;
    ActivityModel *_activityModel;
    ActivityTipView *_activityTipView; //活动视图
    //底部增大确认对底部的距离
    IBOutlet UIView *_bottonLineView;

    //
    IBOutlet UIScrollView *_backScrollView;
    IBOutlet UIView *_activityTipBGView;
    //支付背景图
    IBOutlet FrameViewWB *_payAwayBGView;
    //接受支付方式的model
    id rePaysModel;
}

@end

@implementation RechargeVC

- (void)dealloc
{
    
    RELEASE_SAFELY(_promptLabel);
    RELEASE_SAFELY(_payButton);
    RELEASE_SAFELY(_moneyLabel);
    RELEASE_SAFELY(_personIphoneLabel);
    RELEASE_SAFELY(_personNameLabel);
    RELEASE_SAFELY(_personImageView);
}

- (void)viewDidUnload {
    
    RELEASE_SAFELY(_promptLabel);
    RELEASE_SAFELY(_payButton);
    RELEASE_SAFELY(_moneyLabel);
    RELEASE_SAFELY(_personIphoneLabel);
    RELEASE_SAFELY(_personNameLabel);
    RELEASE_SAFELY(_personImageView);
    [super viewDidUnload];
}
-(id)initWithBrandID:(NSString *) brandID withStoreID:(NSString *)storeID;
{
    
    if (self = [super init])
    {
        _brandID = brandID;
        _storeID = storeID;
    }
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _layoutView.layoutDelegate = self;
    [_layoutView layoutSuperView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self enableKeyboardManger];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadColorConfig];
    _AbulkCancelBOOL = NO;
    [self.navigationBarView setNavigationBarTitle:@"会员充值"];
    self.navigationBarView.rightBarButton.hidden = NO;
    [self setUIButtonStyle:UIButtonStyleRechargeRecoder withUIButton:self.navigationBarView.rightBarButton];
    [_personImageView.layer setCornerRadius:_personImageView.width/2.0];
    //添加触摸方法 收起键盘
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HidenKeyBoardAnimated)];
    [self.contentView addGestureRecognizer:tapGestureR];
    //个人信息
    [self personalInformation];
    //充值初始化
    [self sendWithRechargeRequest];
    //初始化contentView相对位置数值
    _backScrollView.delegate = self;    
    //活动视图
    _activityTipView = [ActivityTipView viewFromXIB];
    _activityTipView.width = self.contentView.width;
    _activityTipView.delegate = self;
    [_activityTipBGView addSubview:_activityTipView];
    _activityTipBGView.hidden = YES;
    self.contentView.hidden = YES;
}


-(void) loadColorConfig
{
    _personIphoneLabel.textColor = ColorForHexKey(AppColor_Second_Level_Title1);
    _personNameLabel.textColor   = ColorForHexKey(AppColor_Prompt_Text2);
    _moneyTextField.textColor    = ColorForHexKey(AppColor_Input_Box_Prompt_Checked);
    [_moneyTextField setValue:ColorForHexKey(AppColor_Input_Box_Prompt_Default) forKeyPath:@"_placeholderLabel.textColor"];
    [_payButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
    _moneyLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);

    _moneyBgImageView.image = [_moneyBgImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
}

-(void) clickPromptViewAction
{
    [self personalInformation];
    [self sendWithRechargeRequest];
}


- (void)personalInformation
{
    UserModel *userInfoModel = [AccountHelper userInfo];
    if (!_userModel) {
        _userModel = userInfoModel;
    }
    [_personImageView setImageWithUrlString:_userModel.userSmallPic placeholderImage:KNotLoginUserIconImage];
    if (![NSString isBlankString:_userModel.username]) {
        _personNameLabel.text = _userModel.username;
    }else{
        _personNameLabel.text = @"未设置";
    }
    
    _personIphoneLabel.text = _userModel.mobile;
}

- (void)refreshUI
{
    [self personalInformation];
    //设置活动高度
    _activityTipBOOL = _activityModel.activity_id.intValue;
    if(_activityTipBOOL)
    {
        _activityTipBGView.hidden = NO;
        [_activityTipView setActivityTipViewHightWithString:_activityModel.activity_title];
        _activityTipBGView.height = _activityTipView.height;
    }else{
        _activityTipBGView.hidden = YES;
    }
    
    //余额
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:@"%.2f",[_userModel.user_money doubleValue]]];
    //上部显示标题
    [self showPromptText];
    //充值方式
    //充值送活动
    [PayMannerView showInView:_payAwayBGView WithModelArray:_userModel.paysArray WithSelectedBlock:^(id obj) {
        rePaysModel = obj;
        [self changeMoneyTextFieldPromptText];
        if (_activityTipBOOL) {
            [self changeActivityTipTitleLabelText];
        }else{
        if (([obj pay_id].intValue == 6 )|| ([obj pay_id].intValue == 7 ) || ([obj pay_id].intValue == 8 ))
        {
            if (!_AbulkCancelBOOL) {
                //活动视图
                _activityTipBGView.hidden = NO;
                _activityTipView.hidden = NO;
                [_activityTipView setActivityTipViewHightWithString:ActivityTipViewPromptText];
                _activityTipBGView.height = _activityTipView.height;
                [_layoutView layoutSuperView];
            }else{
                _activityTipBGView.hidden = YES;
                [_layoutView layoutSuperView];
            }
            
        }else{
                _activityTipBGView.hidden = YES;
                [_layoutView layoutSuperView];
        }
        }
    }];
    
    [_layoutView layoutSuperView];
}
//选择方式改变时 改变输入框提示文字
-(void)changeMoneyTextFieldPromptText
{
    if (([rePaysModel pay_id].intValue == 6 )|| ([rePaysModel pay_id].intValue == 7 ) || ([rePaysModel pay_id].intValue == 8 ))
    {
        _moneyTextField.placeholder = @"请输入团购码";
    }else{
        _moneyTextField.placeholder = @"请输入您需要支付的金额";
    }
}
//选择方式改变时 改变活动框提示文字
-(void)changeActivityTipTitleLabelText
{
    if (([rePaysModel pay_id].intValue == 6 )|| ([rePaysModel pay_id].intValue == 7 ) || ([rePaysModel pay_id].intValue == 8 ))
    {
        [_activityTipView setActivityTipViewHightWithString:ActivityTipViewPromptText];
        _activityTipBGView.height = _activityTipView.height;
        [_layoutView layoutSuperView];
    }else{
        [_activityTipView setActivityTipViewHightWithString:_activityModel.activity_title];
        _activityTipBGView.height = _activityTipView.height;
        [_layoutView layoutSuperView];
    }
}



#pragma mark -
#pragma mark - ActivityTipViewDelegate

- (void)cancenActivityTipView
{
    if (([rePaysModel pay_id].intValue == 6 )|| ([rePaysModel pay_id].intValue == 7 ) || ([rePaysModel pay_id].intValue == 8 )){
        _AbulkCancelBOOL = YES;
    }
    _activityTipBOOL = NO;
    _activityTipBGView.hidden = YES;
    [_layoutView layoutSuperView];
}

- (void)gotoActivityAction
{
    WebVC *webVC = [[WebVC alloc] initWithContentID:_activityModel.activity_id];
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing];
}

#pragma mark - NavigationBarActions

- (void)actionClickNavigationBarLeftButton
{
    [RechargeRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

- (void)actionClickNavigationBarRightButton
{
    RechargeRecoderVC *rechargeVC = [[RechargeRecoderVC alloc] initWithBrandID:_brandID];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

-(void) showPromptText
{
    NSString *text =  [NSString stringWithFormat:@"<font size=14 color=%@>您正在对 <font color=%@>%@ </font>进行余额充值！</font>",[ColorForHexKey(AppColor_Prompt_Text2) hexStringFromColor],[ColorForHexKey(AppColor_Money_Color_Text1) hexStringFromColor],_userModel.brand_name];
    _promptLabel.text = text;
}

#pragma mark ExpandFrameViewDeleagte
-(float)expandFrameView:(ExpandFrameView *)expandFrameView topMarginOfView:(UIView *)view
{
    if (view == _personInfoView) {
        return 0;
    }
    if (view == _payBGView)
    {
        return 60;
    }
    if (view == _bottonLineView)
    {
        return 45;
    }
    return 10;
}

#pragma mark - RechargePayRequest

- (IBAction)payButtonAction:(UIButton *)sender
{
    if (![rePaysModel pay_id].intValue) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:kDefaultPayAlertContent];
        return;
    }
    if (!_moneyTextField.text.floatValue) {
        if (([rePaysModel pay_id].intValue == 6 )|| ([rePaysModel pay_id].intValue == 7 ) || ([rePaysModel pay_id].intValue == 8 )){
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"请输入正确的团购码"];
            return;
        }else{
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"充值金额输入有误"];
            return;
        }
    }
    

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:[rePaysModel pay_id] forKey:@"pay_id"];
    [params setObject:_moneyTextField.text forKey:@"order_amount"];
    [params setObject:_brandID forKey:@"s_id"];
    [params setObject:_storeID forKey:@"store_id"];
    [RechargeAddRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
            
            [self handlePayResult:request.resultDic];
        }else{
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

//处理支付结果
- (void)handlePayResult:(NSDictionary *) resultDic
{
    PayResultModel *resultModel = [[PayResultModel alloc]initWithDictionary:resultDic[@"data"]];
    //充值确认页
    RechargeConfirmVC *rechargeConfirmVC = [[RechargeConfirmVC alloc]initWithOrderID:resultModel.order_id withRechargeConfirmWithType:RechargeConfirmWithRechargeType];

    if (resultModel.add_result.intValue == WaitAlipayPaymentStatus) { //等待使用支付宝支付
        //跳转到支付宝支付页面
        Product *product = [[Product alloc] init];
        product.orderId = resultModel.order_sn;
        product.price = resultModel.order_amount.floatValue;
        product.subject = @"余额充值";
        product.body = [NSString stringWithFormat:@"正在为%@进行余额充值", _userModel.brand_name];
        [[AliPayManager shareManager] payForProduct:product completion:^(BOOL success) {
             if (success) {
                 [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
             } else {
                 [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
             }
         }];
        
    } else if (resultModel.add_result.intValue == WaitUPPayPaymentStatus) { //等待使用银联支付
        
        [[UPPayPluginManager shareManager] uPPayPluginStartViewController:self uPPayTN:resultModel.order_sn successBlock:^(NSString *success) {
            [BDKNotifyHUD showSmileyHUDWithText:success completion:^{
                [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
            }];
            
        } failBlock:^(NSString *error) {
            [BDKNotifyHUD showCryingHUDWithText:error completion:^{
                [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
            }];
            
            
        } cancelBlock:^(NSString *cancel) {
            [BDKNotifyHUD showCryingHUDWithText:cancel completion:^{
                [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
            }];
            
        }];
        
    } else if (resultModel.add_result.intValue == WaitWXPayPaymentStatus) { //等待使用微信支付
        [[WXApiManager shareManager] wxPayForProduct:resultModel.wxpay_result successCompletion:^(BOOL success) {
            if (success) {
                    [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
            }else{
                [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
            }
            
        } failureCompletion:^(BOOL failure) {
                [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
        }];
    } else if (resultModel.add_result.intValue == WaitDZPayPaymentStatus ) { //大众点评
        [self.navigationController pushViewController:rechargeConfirmVC animated:YES];

    } else if (resultModel.add_result.intValue == WaitMTPayPaymentStatus){//美团
        [self.navigationController pushViewController:rechargeConfirmVC animated:YES];

    }else if (resultModel.add_result.intValue == WaitNMPayPaymentStatus){//百度糯米
        [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
    }else {
        NSString *msg = resultDic[@"msg"];
        [BDKNotifyHUD showSmileyHUDWithText:msg completion:^{
            RechargeConfirmVC *rechargeConfirmVC = [[RechargeConfirmVC alloc]initWithOrderID:resultModel.order_id withRechargeConfirmWithType:RechargeConfirmWithRechargeType];
            [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
        }];
    }
}

//发送充值初始化请求
- (void)sendWithRechargeRequest
{
    [RechargeRequest requestWithParameters:@{@"user_id":User_Id,@"s_id":_brandID} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
            _userModel = [[UserModel alloc]initWithDictionary:request.resultDic[@"data"]];
            _userModel.paysArray = [PayModeModel reflectArrayWithInitWithDictionary:request.resultDic[@"data"][@"pays"]];
            //是否有活动
            _activityModel = (ActivityModel*)[ActivityModel reflectObjectsWithJsonObject:request.resultDic[@"data"]];
            if (_activityModel.activity_id.intValue && _activityTipView.hidden) {
                _activityTipView.hidden = NO;
                _activityTipView.activityTitleLabel.text = _activityModel.activity_title;
                _activityTipBOOL = YES;
            }
            [self refreshUI];
            self.contentView.hidden = NO;
            [self hidePromptView];
        }else{
            [self showNetErrorPromptView];
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self showNetErrorPromptView];
        
    }];
}



- (void)gotoRechargeRecoderDetails
{
    RechargeRecoderVC *rechargeVC = [[RechargeRecoderVC alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}
//收起键盘方法
-(void)HidenKeyBoardAnimated
{
    if ([_moneyTextField isFirstResponder]) {
        [_moneyTextField resignFirstResponder];
        if (_backScrollView.bottom >= self.contentView.height) {
            [_backScrollView setContentOffset:CGPointMake(0,_bottonLineView.bottom -  _backScrollView.bottom) animated:YES];
        }
    }else{
        return;
    }
}
@end
