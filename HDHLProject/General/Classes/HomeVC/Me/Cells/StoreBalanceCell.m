//
//  StoreBalanceCell.m
//  Carte
//
//  Created by liu on 15-4-14.
//
//

#import "StoreBalanceCell.h"
#import "BrandModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation StoreBalanceCell

- (void)awakeFromNib
{
    self.priceLabel.textColor = ColorForHexKey(AppColor_Amount1);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setCellData:(id)cellData
{
    if(![cellData isKindOfClass:[BrandModel class]]){
        return ;
    }
    BrandModel *brandModel = (BrandModel *)cellData;
    self.model = brandModel ;
    self.storeNameLabel.text = brandModel.brand_name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",brandModel.user_money];
    [self.storePhotoView setImageWithUrlString:brandModel.brand_icons placeholderImage:KSmallPlaceHolderImage];
    [self roundViewWithView:self.storePhotoView];
}

- (void)roundViewWithView:(UIView *)view
{
    view.layer.masksToBounds = YES ;
    view.layer.cornerRadius  = 2 ;
}


- (IBAction)RechargeBtnClick:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(startToRechargeWithModel:)])
    {
        [self.delegate startToRechargeWithModel:self.model];
    }
}
@end
