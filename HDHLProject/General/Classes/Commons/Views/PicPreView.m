//
//  PicPreView.m
//  Carte
//
//  Created by user on 14-4-24.
//
//

#import "PicPreView.h"

@interface PicPreView()
{
    IBOutlet WebImageView   *_webImageView; //图片预览view
    
    IBOutlet UILabel        *_desLabel;
    IBOutlet UILabel        *_priceLabel;
    
    GoodsModel              *_goodsMdoel;
    ImageModel              *_imageModel;
    
    IBOutlet UILabel  *_numLabel;
    IBOutlet UIButton *_delButton;
    IBOutlet UIButton *_addButton;
    IBOutlet UIButton *_orderButton;
    int _numCount;
}
@end

@implementation PicPreView

- (void)dealloc
{
    RELEASE_SAFELY(_webImageView);
    RELEASE_SAFELY(_desLabel);
    RELEASE_SAFELY(_priceLabel);
    RELEASE_SAFELY(_orderButton);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColor];
    _delButton.enabled = NO;
    _numCount = 0;
}

- (void)loadColor
{
    _priceLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _desLabel.textColor   = ColorForHexKey(AppColor_Popup_Box_Text1);
}

- (void)showWithImagesModel:(ImageModel *)imageModel showPrice:(BOOL)showPrice
{
    _imageModel = imageModel;
    [self showWithImageUrl:imageModel.image_big];
    if (showPrice) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",imageModel.market_price.floatValue];
    } else {
        _priceLabel.hidden = YES;
    }
    
    _desLabel.text = imageModel.image_desc;
    
    if ([NSString isBlankString:imageModel.image_desc]) {
        _desLabel.text = @"暂无描述信息";
    }
}

- (void)showWithGoodsModel:(GoodsModel *)goodsModel
{
    _goodsMdoel = goodsModel;
    [self showWithImageUrl:goodsModel.image_big];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goods_price.floatValue];
    _desLabel.text = goodsModel.goods_desc;
    _numCount = (int)goodsModel.selectedNumber;
    [self refreshView];
    if ([NSString isBlankString:goodsModel.goods_desc]) {
        _desLabel.text = @"暂无描述信息";
    }
}

#pragma mark ViewActions
- (IBAction)cancelSelecteOrders:(id)sender
{
    if (_delegate) {
        [_delegate didCancelSelectOrders];
    }
    [self dismiss];
}

- (IBAction)addCartViewAction:(id)sender
{
    [self dismiss];
}

//加菜
- (IBAction)addOrderAction:(id)sender
{
    //促销菜数量限定
    if (_goodsMdoel.max_num.intValue && (_goodsMdoel.selectedNumber+1 > _goodsMdoel.max_num.intValue)) {
        [BDKNotifyHUD showCryingHUDWithText:@"已达到最大选择数量"];
        return;
    }
    if (_delegate) {
        [_delegate didSelectedGoodsModels:_goodsMdoel];
    }
    _numCount ++;
    [self refreshView];
}

//减菜
- (IBAction)delOrderAction:(id)sender {
    if (_delegate) {
        [_delegate didDeleteGoodsModels:_goodsMdoel];
    }
    _numCount --;
    [self refreshView];
}

- (void)refreshView {
    _numLabel.text = [NSString stringWithFormat:@"%d",_numCount];
    if (_numCount <= 0) {
        _delButton.enabled = NO;
    } else {
        _delButton.enabled = YES;
    }
}

- (void)showWithImageUrl:(NSString *)url
{
    self.frame = CGRectMake(0, 0, [KAPP_WINDOW width], [KAPP_WINDOW height]);
    [_webImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:KBigPlaceHodlerImage];
    self.top = self.height;
    [KAPP_WINDOW addSubview:self];
    
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    self.top = 0;
    [UIView commitAnimations];
    
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.2;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [self.layer addAnimation:animation forKey:nil];
//    [UIView beginAnimations:@"ShowAnimation" context:nil];
//    [UIView commitAnimations];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = self.height;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

//图片保存到本地
- (IBAction)savePhotoImageAction:(id)sender
{
    UIImage *aImage = _webImageView.image;
    UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        
        [BDKNotifyHUD showCryingHUDWithText:@"图片保存失败"];
        
    }else {
        
        [BDKNotifyHUD showSmileyHUDWithText:@"图片已保存到本地相册"];
        
    }
}

@end
