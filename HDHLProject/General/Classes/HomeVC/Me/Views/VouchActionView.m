//
//  VouchActionView.m
//  Carte
//
//  Created by zln on 14/12/23.
//
//

#import "VouchActionView.h"

@implementation VouchActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    
    RELEASE_SAFELY(_vouchBackImageView);
    RELEASE_SAFELY(_vouchTitleLabel);
    RELEASE_SAFELY(_vochShowLabel);
    RELEASE_SAFELY(_littleIconButton1);
    RELEASE_SAFELY(_littleIconButton2);
    RELEASE_SAFELY(_vouchNameLabel);
    RELEASE_SAFELY(_vouchEndDateLabel);
    RELEASE_SAFELY(_vochPriceLabel);
}

- (void)awakeFromNib
{
    _vochPriceLabel.textColor = ColorForHexKey(AppColor_Coupon_Amount);
    _vouchTitleLabel.textColor = ColorForHexKey(AppColor_Usable_Coupon_Left_Text);
    _vouchNameLabel.textColor = ColorForHexKey(AppColor_Usable_Coupon_Right_Text1);
    _vouchEndDateLabel.textColor = ColorForHexKey(AppColor_Usable_Coupon_Right_Text1);
    
}

- (void)setVocherModel:(VoucherModel *)vocher
{
    //代金券
    if ([vocher.coupon_type isEqual:@"1"])
    {
        [self setCellDataImageAndLabelShowWithType:VoucherTypeDaiJin voucherModel:vocher];
    }
    
    //折扣券
    else if ([vocher.coupon_type isEqual:@"2"])
    {
        
        [self setCellDataImageAndLabelShowWithType:VoucherTypeZheKou voucherModel:vocher];
     }
    
    //实物券
    else if ([vocher.coupon_type isEqual:@"3"])
    {
        [self setCellDataImageAndLabelShowWithType:VoucherTypeShiWu voucherModel:vocher];
    }

}

- (void)setCellDataImageAndLabelShowWithType:(VoucherTypeClass)voucherType  voucherModel:(VoucherModel *)voucherModel
{
    
    NSString *useTime = [NSString stringWithFormat:@"%@",voucherModel.end_time];
    
//    if (voucherModel.end_time.doubleValue >= 2000000000) {
//        useTime = @"长期有效";
//        
//    }else {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:voucherModel.end_time.floatValue];
//        useTime = [date stringWithFormat:@"yyyy-MM-dd"];
//    }

    switch (voucherType) {
            
        case VoucherTypeDaiJin:
            //代金券
            _vouchBackImageView.image = [UIImage imageNamed:@"public_discount_coupon_head4"];
            [_littleIconButton1 setBackgroundImage:[UIImage imageNamed:@"public_discount_coupon_star4"] forState:UIControlStateNormal];
            [_littleIconButton2 setBackgroundImage:[UIImage imageNamed:@"public_discount_coupon_star4"] forState:UIControlStateNormal];
            _vouchTitleLabel.text = [NSString stringWithFormat:@"%@元",voucherModel.coupon_value];
            _vouchNameLabel.text = voucherModel.coupon_name;
            _vouchEndDateLabel.text = useTime;
            _vochPriceLabel.text = [NSString stringWithFormat:@"-￥%@",voucherModel.coupon_value];
            

            break;
            
        case VoucherTypeZheKou:
            //折扣券
            _vouchBackImageView.image = [UIImage imageNamed:@"public_discount_coupon_head5"];
            [_littleIconButton1 setBackgroundImage:[UIImage imageNamed:@"public_discount_coupon_star5"] forState:UIControlStateNormal];
            [_littleIconButton2 setBackgroundImage:[UIImage imageNamed:@"public_discount_coupon_star5"] forState:UIControlStateNormal];
            
            float str = voucherModel.coupon_value.floatValue/10;
            NSInteger myText = (NSInteger)(str);
//            if (myText == str) {
                _vouchTitleLabel.text = [NSString stringWithFormat:@"%d折",(int)myText];
                _vouchNameLabel.text = voucherModel.coupon_name;
                _vouchEndDateLabel.text = useTime;
              _vochPriceLabel.text = [NSString stringWithFormat:@"%d折",(int)myText];

//            }else {
//                _vouchTitleLabel.text = [NSString stringWithFormat:@"%.1f折",str];
//                _vouchNameLabel.text = voucherModel.coupon_name;
//                _vouchEndDateLabel.text = [NSString stringWithFormat:@"%@前有效",useTime];
//            }
            
            break;
            
        case VoucherTypeShiWu:
            //实物券
            _vouchBackImageView.image = [UIImage imageNamed:@"public_discount_coupon_head6"];
            [_littleIconButton1 setBackgroundImage:[UIImage imageNamed:@"public_discount_coupon_star6"] forState:UIControlStateNormal];
            [_littleIconButton2 setBackgroundImage:[UIImage imageNamed:@"public_discount_coupon_star6"] forState:UIControlStateNormal];
            _vouchTitleLabel.text = [NSString stringWithFormat:@"%@",voucherModel.coupon_value];
            _vouchNameLabel.text = voucherModel.coupon_name;
            _vouchEndDateLabel.text = useTime;
//            _vochPriceLabel.text = [NSString stringWithFormat:@"-￥0"];
            break;
            
        default: break;
    }
    
}
@end
