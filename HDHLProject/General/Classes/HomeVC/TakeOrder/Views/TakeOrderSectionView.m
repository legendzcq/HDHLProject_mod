//
//  TakeOrderSectionView.m
//  Carte
//
//  Created by ligh on 14-12-22.
//
//

#import "TakeOrderSectionView.h"

@interface TakeOrderSectionView ()
{
    IBOutlet UILabel *_goodsCategroyLabel;
    IBOutlet UIImageView *_bgImageView;
}
@end

@implementation TakeOrderSectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
}

- (void) loadColorConfig
{
    _bgImageView.image = [UIImage resizableWithImage:_bgImageView.image];
    _goodsCategroyLabel.textColor = ColorForHexKey(AppColor_Second_Level_Title1);
}

- (void)setGoodsCategroyTitle:(NSString *)title
{
    _goodsCategroyLabel.text = title;
}

- (void)dealloc
{
    RELEASE_SAFELY(_goodsCategroyLabel);
}

@end
