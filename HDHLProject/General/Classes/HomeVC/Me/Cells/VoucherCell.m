//
//  VoucherCell.m
//  Carte
//
//  Created by ligh on 14-4-9.
//
//

#import "VoucherCell.h"

@interface VoucherCell()
{
    IBOutlet RTLabel        *_voucherInfoTextView;//textview
    
    IBOutlet UIImageView *_couponHeadImage;
    IBOutlet UILabel *_couponLabel1;//使用码
    IBOutlet UILabel *_couponLabel2;//品牌名
    IBOutlet UILabel *_couponLabel3;//有效时间

    IBOutlet UILabel *_couponTitleLbl;
    VoucherModel *_voucherModel;
}
@end

@implementation VoucherCell

- (void)dealloc {
    RELEASE_SAFELY(_voucherInfoTextView);
    RELEASE_SAFELY(_couponHeadImage);

    RELEASE_SAFELY(_couponLabel1);
    RELEASE_SAFELY(_couponLabel2);
    RELEASE_SAFELY(_couponLabel3);

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self disableSelectedBackgroundView];
    
    //优惠券面值显示
    _voucherInfoTextView.textAlignment = kCTTextAlignmentCenter;
}


//加载颜色配置文件
-(void) loadColorConfig
{
    if (_voucherModel.status.intValue == 2) {
        _couponTitleLbl.textColor = ColorForHexKey(AppColor_Share_Button_Text);
        _couponLabel3.textColor = ColorForHexKey(AppColor_Share_Button_Text);
        _couponLabel2.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    }else{
        _couponTitleLbl.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
        _couponLabel3.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
        _couponLabel2.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    }
}

-(void)setCellData:(id)cellData
{

    _voucherModel = (VoucherModel*)cellData;
    
    if (_voucherModel.status.intValue == 2) {
        //可用
        _couponHeadImage.image = [UIImage imageNamed:@"my_vuchers_yellow"];
    }else if( _voucherModel.status.intValue == 1){
        //不可用
        _couponHeadImage.image = [UIImage imageNamed:@"my_vuchers_gray"];
    }
    //左边
    NSString *infoText  = [NSString stringWithFormat:@"￥<font size=24>%@</font><font size=18></font>",_voucherModel.coupon_value];
    _voucherInfoTextView.text = infoText;
    _voucherInfoTextView.textColor = [UIColor whiteColor];
    _voucherInfoTextView.top = 28;
    //右边
    _couponLabel1.text = _voucherModel.coupon_name;
    _couponLabel1.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _couponTitleLbl.text = [NSString stringWithFormat:@"使用码：%@",_voucherModel.coupon_sn];
    _couponLabel3.text = _voucherModel.end_time;
    _couponLabel2.text = [NSString stringWithFormat:@"%@（%@）",_voucherModel.brand_name,_voucherModel.scope];
    [self loadColorConfig];
}

@end
