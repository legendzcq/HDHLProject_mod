//
//  RechargeRecoderCell.m
//  Carte
//
//  Created by zln on 14/12/30.
//
//


#import "RechargeRecoderCell.h"

@interface RechargeRecoderCell ()
{
    IBOutlet UILabel *_rechargeMoneyPriceTitleLabel;
    
    IBOutlet UILabel *_rechargeMoneyPriceLabel;
    
    
    IBOutlet UILabel *_rechargeTimeTitleLabel;
    
    IBOutlet UILabel *_rechargeWhetherSuccessLbl;
    IBOutlet UILabel *_rechargeTimeLabel;
    
    IBOutlet UILabel *_rechargePaymentLabel; //支付方式
    //品牌
    IBOutlet UILabel *_brandLabel;
}

@end

@implementation RechargeRecoderCell

- (void)dealloc {
    
    RELEASE_SAFELY(_rechargeMoneyPriceTitleLabel);
    RELEASE_SAFELY(_rechargeMoneyPriceLabel);
    RELEASE_SAFELY(_rechargeTimeTitleLabel);
    RELEASE_SAFELY(_rechargeTimeLabel);
    RELEASE_SAFELY(_rechargePaymentLabel);
    RELEASE_SAFELY(_rechargeWhetherSuccessLbl);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColor];
//    [self loadColorConfig];
    
    [self disableSelectedBackgroundView];
}

- (void)loadColor
{
    _brandLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _rechargeMoneyPriceLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _rechargeTimeTitleLabel.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    _rechargeMoneyPriceTitleLabel.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    _rechargeTimeLabel.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    _rechargePaymentLabel.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    _rechargeWhetherSuccessLbl.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
}

-(void)setCellData:(id)cellData
{
    if (![cellData isKindOfClass:[RechargeRecoderModel class]]) {
        return;
    }
    [super setCellData:cellData];
    
    RechargeRecoderModel *recoderModel = (RechargeRecoderModel *)cellData;
    _brandLabel.text = recoderModel.brand_name;
    _rechargeMoneyPriceLabel.text = [NSString stringWithFormat:@"￥%@",recoderModel.order_amount];
    _rechargePaymentLabel.text = [NSString stringWithFormat:@"(%@)",recoderModel.pay_name];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:recoderModel.pay_time.floatValue];
    _rechargeTimeLabel.text = [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
    if (recoderModel.is_success.intValue) {
        _rechargeWhetherSuccessLbl.text = @"充值成功";
    }else{
        _rechargeWhetherSuccessLbl.text = @"充值失败";
    }
    //计算位置布局
    CGFloat priceWidth = [_rechargeMoneyPriceLabel.text widthWithFont:_rechargeMoneyPriceLabel.font boundingRectWithSize:CGSizeMake(self.width - MARGIN_L * 2, _rechargeMoneyPriceLabel.height)];
    _rechargeMoneyPriceLabel.width = priceWidth;
    _rechargePaymentLabel.left = _rechargeMoneyPriceLabel.right +5;
}



@end
