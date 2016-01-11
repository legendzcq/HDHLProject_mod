//
//  FoodListItemView.m
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "OrderListItemView.h"

@interface OrderListItemView()
{

}
@end

@implementation OrderListItemView

- (void)dealloc
{
    RELEASE_SAFELY(_productNameLabel);
    RELEASE_SAFELY(_countLabel);
    RELEASE_SAFELY(_amountLabel);
    RELEASE_SAFELY(_iconButton);
    RELEASE_SAFELY(_lineView);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.width =SCREEN_WIDTH;
    _productNameLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _countLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _amountLabel.textColor =  ColorForHexKey(AppColor_Amount1);
}

- (void)setProductModel:(GoodsModel *)product
{
    _productNameLabel.text =  product.goods_name;
    
    
    _productNameLabel.width = [_productNameLabel sizeThatFits:CGSizeMake(self.width / 3, _productNameLabel.height)].width;
    if (_productNameLabel.right > _countLabel.left) {
        _productNameLabel.width = _countLabel.left - _productNameLabel.left;
    }
    _iconButton.hidden = !product.is_gift.intValue; //是否为赠
    _iconButton.left = _productNameLabel.right + 2;
    
    //如果是菜 则显示份
    if ( product.productType == GoodsProductType && ![NSString isBlankString:product.goods_units])
    {
        
          _countLabel.text = [NSString stringWithFormat:@"* %d %@",[product.goods_number intValue],product.goods_units];
    }else
    {
         _countLabel.text = [NSString stringWithFormat:@"* %d",[product.goods_number intValue]];
    }

    _amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.goods_price floatValue] * [product.goods_number intValue]];
}

//选中item
- (IBAction)selectedItemAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedListItemView:)])
    {
        [_delegate didSelectedListItemView:self];
    }
}

@end
