//
//  PayModeView.m
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "PayModeView.h"
#import "PayModeModel.h"

@interface PayModeView()
{

}
@end

@implementation PayModeView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.headerName = @"支付方式:";
    
    self.backgroundColor = [UIColor whiteColor];

}

- (void)setOptionsModelArray:(NSArray *)optionsModelArray
{
    //如果用户余额为0，默认支付宝支付
    for (PayModeModel *payModeModel in optionsModelArray) {
        
        if ((payModeModel.pay_id.intValue == PayModeUserAccount) && (payModeModel.user_money.floatValue > 0)) {
            
            payModeModel.checked = YES;
            self.selectedOptionsMoel = payModeModel;
            
        } else {
            
            if (!self.selectedOptionsMoel) {
//                if (payModeModel.pay_id.intValue == PayModeAlipay) {
                if (payModeModel.is_default.intValue) {
                    payModeModel.checked = YES;
                    self.selectedOptionsMoel = payModeModel;
                }
            }
        }
    }

    [super setOptionsModelArray:optionsModelArray];
}

- (void)switchShow
{
    [super switchShow];
    if ([_payModeDelegate respondsToSelector:@selector(payModeViewSwitchShow:)]) {
        [_payModeDelegate payModeViewSwitchShow:self.opened];
    }
}

-(void)setSelectedOptionsMoel:(OptionsModel *)selectedOptionsMoel
{
    [super setSelectedOptionsMoel:selectedOptionsMoel];
    if (self.opened) {
        [self close];
    }
    if ([_payModeDelegate respondsToSelector:@selector(payModeViewSwitchShow:)]) {
        [_payModeDelegate payModeViewSwitchShow:self.opened];
    }
}

@end
