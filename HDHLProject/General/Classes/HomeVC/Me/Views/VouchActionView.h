//
//  VouchActionView.h
//  Carte
//
//  Created by zln on 14/12/23.
//
//

#import "XibView.h"
#import "VoucherModel.h"


typedef enum
{
    VoucherTypeDaiJin = 1,//代金券
    VoucherTypeZheKou,    //折扣券
    VoucherTypeShiWu,     //实物券
    //    VoucherTypeUsed,      //已过期
    
}VoucherTypeClass; //优惠券类型

@interface VouchActionView : XibView

//根据不同的代金券显示不同的背景图片
@property (retain, nonatomic) IBOutlet UIImageView *vouchBackImageView;

//折扣金额以及折扣信息
@property (retain, nonatomic) IBOutlet UILabel *vouchTitleLabel;

//代金券的单位
@property (retain, nonatomic) IBOutlet UILabel *vochShowLabel;

//根据不同的折扣卷显示不同的星星icon
@property (retain, nonatomic) IBOutlet UIButton *littleIconButton1;

@property (retain, nonatomic) IBOutlet UIButton *littleIconButton2;

//代金卷名称
@property (retain, nonatomic) IBOutlet UILabel *vouchNameLabel;

//代金券有效日期
@property (retain, nonatomic) IBOutlet UILabel *vouchEndDateLabel;

@property (retain, nonatomic) IBOutlet UILabel *vochPriceLabel;


- (void)setVocherModel:(VoucherModel *)vocher;
@end
