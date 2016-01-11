//
//  RechargeConfirmVC.m
//  Carte
//
//  Created by hdcai on 15/4/27.
//
//

#import "RechargeConfirmVC.h"
#import "RechargeConfirmRequest.h"
#import "RechargeConfirmModel.h"

@interface RechargeConfirmVC ()
{
    //充值方式title
    IBOutlet UILabel *_payModeTitleLbl;
    //充值方式
    IBOutlet UILabel *_payModeLbl;
    //团购详细信息
    IBOutlet UILabel *_groupDetailLbl;
    //充值title
    IBOutlet UILabel *_rechargeTitleLbl;
    //充值金额
    IBOutlet UILabel *_rechargeMoneyLbl;
    //账户余额title
    IBOutlet UILabel *_accountBalanceTtileLbl;
    //账户余额
    IBOutlet UILabel *_accountBalanceLbl;
    //充值成功
    IBOutlet UILabel *_rechargeSuccessLbl;
    NSString *_order_id;
    NSInteger _rechargeConfirmType;
    RechargeConfirmModel *_rechargeConfirmModel;
    IBOutlet FrameViewWB *_backView;
    IBOutlet UIImageView *_lineImageV1;
    IBOutlet UIImageView *_lineImageV2;
    IBOutlet UILabel *_brandNameLabel;
    IBOutlet UILabel *_rechargeTimeTitleLabel;
    IBOutlet UILabel *_rechargeTimeLabel;
}
@end

@implementation RechargeConfirmVC

-(id) initWithOrderID:(NSString *) order_id withRechargeConfirmWithType:(RechargeConfirmWithType)rechargeConfirmType
{
    
    if (self = [super init])
    {
        _order_id = order_id;
        _rechargeConfirmType = rechargeConfirmType;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.hidden = YES;
    [self loadColorConfig];
    [self.navigationBarView setNavigationBarTitle:@"充值确认"];
    self.navigationBarView.rightBarButton.hidden = YES;
    
    self.contentView.hidden = YES;
    
    //充值初始化
    [self sendWithRechargeConfirmRequest];

}
-(void) loadColorConfig
{
    _brandNameLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _rechargeTitleLbl.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _rechargeMoneyLbl.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _payModeTitleLbl.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _payModeLbl.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _groupDetailLbl.textColor = ColorForHexKey(AppColor_Second_Level_Title3);
    _rechargeTimeTitleLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _rechargeTimeLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _accountBalanceTtileLbl.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _accountBalanceLbl.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _rechargeSuccessLbl.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
//    //充值方式title
//    _payModeTitleLbl.textColor = ColorForHexKey(AppColor_Amount2);
//    //充值方式
//    _payModeLbl.textColor = ColorForHexKey(AppColor_Amount2);
//    //团购详细信息
//    _groupDetailLbl.textColor = ColorForHexKey(AppColor_Amount4);
//    //充值title
//    _rechargeTitleLbl.textColor = ColorForHexKey(AppColor_Amount4);
//    //充值金额
//    _rechargeMoneyLbl.textColor = ColorForHexKey(AppColor_Amount1);
//    //账户余额title
//    _accountBalanceTtileLbl.textColor =ColorForHexKey(AppColor_Amount4);
//    //账户余额
//    _accountBalanceLbl.textColor = ColorForHexKey(AppColor_Amount1);
//    //充值成功
//    _rechargeSuccessLbl.textColor = ColorForHexKey(AppColor_Amount5);
}

-(void)refreshUI
{
    self.contentView.hidden = NO;
    _payModeLbl.text = _rechargeConfirmModel.pay_name;
    _rechargeMoneyLbl.text = _rechargeConfirmModel.order_amount;
    _accountBalanceLbl.text = _rechargeConfirmModel.user_money;
    ///////////////////////////
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_rechargeConfirmModel.pay_time.floatValue];
    _rechargeTimeLabel.text = [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
    _brandNameLabel.text = _rechargeConfirmModel.brand_name;
    
    if ([NSString isBlankString:_rechargeConfirmModel.pay_desc] && [NSString isBlankString:_rechargeConfirmModel.groupon_name]) {
        _groupDetailLbl.hidden = YES;
        _rechargeTitleLbl.top = _lineImageV1.bottom;
        _rechargeMoneyLbl.top = _lineImageV1.bottom;
        _payModeTitleLbl.top = _rechargeTitleLbl.bottom;
        _payModeLbl.top = _rechargeTitleLbl.bottom;
        _rechargeTimeTitleLabel.top = _payModeTitleLbl.bottom;
        _rechargeTimeLabel.top = _payModeTitleLbl.bottom;
        _accountBalanceTtileLbl.top = _rechargeTimeTitleLabel.bottom;
        _accountBalanceLbl.top = _rechargeTimeTitleLabel.bottom;
        _lineImageV2.top = _accountBalanceLbl.bottom;
        _rechargeSuccessLbl.top = _lineImageV2.bottom;
        _backView.height = _rechargeSuccessLbl.bottom;
    }else{
        if ((![NSString isBlankString:_rechargeConfirmModel.groupon_name]) && _rechargeConfirmModel.is_success.intValue) {
            //团购券充值成功
            _groupDetailLbl.hidden = NO;
            _groupDetailLbl.text = _rechargeConfirmModel.groupon_name;
        }else if ([NSString isBlankString:_rechargeConfirmModel.groupon_name] && _rechargeConfirmModel.is_success.intValue){
            //现金充值成功
            _groupDetailLbl.hidden = YES;
            _rechargeTitleLbl.top = _lineImageV1.bottom;
            _rechargeMoneyLbl.top = _lineImageV1.bottom;
            _payModeTitleLbl.top = _rechargeTitleLbl.bottom;
            _payModeLbl.top = _rechargeTitleLbl.bottom;
            _rechargeTimeTitleLabel.top = _payModeTitleLbl.bottom;
            _rechargeTimeLabel.top = _payModeTitleLbl.bottom;
            _accountBalanceTtileLbl.top = _rechargeTimeTitleLabel.bottom;
            _accountBalanceLbl.top = _rechargeTimeTitleLabel.bottom;
            _lineImageV2.top = _accountBalanceLbl.bottom;
            _rechargeSuccessLbl.top = _lineImageV2.bottom;
            _backView.height = _rechargeSuccessLbl.bottom;
        }else{
            //失败情况
            _groupDetailLbl.hidden = NO;
            _groupDetailLbl.text = _rechargeConfirmModel.pay_desc;
        }
    }
    if (_rechargeConfirmModel.is_success.intValue) {
        _rechargeSuccessLbl.text = @"充值成功";
    }else{
        _rechargeSuccessLbl.text = @"充值失败";
    }
}

-(void)sendWithRechargeConfirmRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    if (![NSString isBlankString:_order_id]) {
        [params setObject:_order_id forKey:@"order_id"];
    }
    [RechargeConfirmRequest requestWithParameters:@{@"user_id":User_Id,@"order_id":_order_id} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
            _rechargeConfirmModel = (RechargeConfirmModel *)request.resultDic[KRequestResultDataKey];
            [self refreshUI];
            self.contentView.hidden = NO;
        }else{
            if (request.isNoLogin) {
                return ;
            }
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"获取充值详情失败"];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"获取充值详情失败"];
        
    }];
}

#pragma mark - NavigationBarActions

- (void)actionClickNavigationBarLeftButton
{
    if (_rechargeConfirmModel.is_success.intValue) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kRechargeConfirmNotification object:self];
    }
    if (_rechargeConfirmType == RechargeConfirmWithRechargeType) {
        NSInteger count = self.navigationController.viewControllers.count;
        UIViewController *vc = (UIViewController*)[self.navigationController.viewControllers objectAtIndex:(count-3)];
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
