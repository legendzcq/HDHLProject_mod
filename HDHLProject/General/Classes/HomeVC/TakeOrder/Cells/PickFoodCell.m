//
//  PickFoodCell.m
//  Carte
//
//  Created by ligh on 14-3-27.
//
//

#import "PickFoodCell.h"
#import "PicPreView.h"
#import "RoundImageView.h"

#import "FrameLineView.h"
#import "StrikethroughLabel.h"

//Models
#import "GoodsModel.h"

@interface PickFoodCell () <PicPreViewDelegate>
{
    IBOutlet RoundImageView     *_goodsImageView;//菜品图片
    IBOutlet UILabel            *_goodsNameLabel;//菜品名称
    IBOutlet UILabel            *_goodsPriceLabel;  //菜品会员价
    IBOutlet StrikethroughLabel *_goodsMarketLabel; //菜品市场价
    IBOutlet UILabel            *_goodsCountLabel;//菜品数量
    IBOutlet UIButton           *_decreaseButton;    //减少button
    IBOutlet UIButton           *_increaseButton;    //增加button
    IBOutlet UILabel            *_unitLabel;//单位（份）
    
    IBOutlet UIView      *_goodsActivityView;
    IBOutlet UIImageView *_goodsActivityImageView;
    IBOutlet UILabel     *_goodsActivityLabel;
    
    IBOutlet FrameLineView *_sepLine;
    
    int _currentCount; //当前选择的数量
}
@end

@implementation PickFoodCell


- (void)dealloc
{
    
    RELEASE_SAFELY(_decreaseButton);
    RELEASE_SAFELY(_increaseButton);
    RELEASE_SAFELY(_goodsImageView);
    RELEASE_SAFELY(_goodsNameLabel);
    RELEASE_SAFELY(_goodsPriceLabel);
    RELEASE_SAFELY(_goodsCountLabel);
    RELEASE_SAFELY(_unitLabel);
    RELEASE_SAFELY(_goodsActivityView);
    RELEASE_SAFELY(_goodsActivityImageView);
    RELEASE_SAFELY(_goodsActivityLabel);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    //图片放大预览
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addEnlargedDrawingView:)];
    [_goodsImageView addGestureRecognizer:singleTap];
    [self disableSelectedBackgroundView];
    _sepLine.top = self.height-0.5;
}

- (void)hiddenSeparatorLine:(BOOL)hidden {
    if (hidden) {
        _sepLine.hidden = YES;
    } else {
        _sepLine.hidden = NO;
    }
}

- (void)showSeparatorLineLeftZero:(BOOL)show {
    if (show) {
        _sepLine.left = 0;
        _sepLine.width = self.width-_sepLine.left;
    } else {
        _sepLine.left = 10;
        _sepLine.width = self.width-_sepLine.left;
    }
}

- (void)loadColorConfig
{
    _goodsPriceLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _goodsNameLabel.textColor  = ColorForHexKey(AppColor_First_Level_Title1);
    _goodsCountLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _unitLabel.textColor = ColorForHexKey(AppColor_Amount1);
    _goodsMarketLabel.textColor = ColorForHexKey(AppColor_OrderCart_ClearText);
}

-(void)setCellData:(id)cellData withShow:(BOOL)show
{
    [super setCellData:cellData];
    
    GoodsModel *goodsModel = cellData;
    
    if (!show) { //菜品图不可点击
        _goodsImageView.userInteractionEnabled = NO;
    } else {
        _goodsImageView.userInteractionEnabled = YES;
    }
    
//    if (show) {
        _goodsImageView.hidden = NO;
        [_goodsImageView setImageWithUrlString:goodsModel.image_small placeholderImage:KSmallPlaceHolderImage];
        
        _goodsNameLabel.left = _goodsImageView.right + 6;
        _goodsPriceLabel.left = _goodsImageView.right + 6;
        //        _goodsActivityView.left = _goodsImageView.right + 6;
        
//    } else {
//        _goodsImageView.hidden = YES;
//        
//        _goodsNameLabel.left = _goodsImageView.left;
//        _goodsPriceLabel.left = _goodsImageView.left;
//        //        _goodsActivityView.left = _goodsImageView.left;
//        
//    }
    
    //促销
    if (goodsModel.is_sale.intValue == 0) {
        _goodsActivityView.hidden = YES;
        
    } else {
        _goodsActivityView.hidden = NO;
        
        //        CGFloat acWidth = [goodsModel.goods_activity sizeWithFont:_goodsActivityLabel.font constrainedToSize:CGSizeMake(_goodsNameLabel.width, _goodsActivityLabel.height)].width + 6;
        
        //        _goodsActivityView.width = acWidth;
        //        _goodsActivityLabel.width = _goodsActivityView.width;
        //        _goodsActivityImageView.width = _goodsActivityView.width;
        
        _goodsActivityImageView.image = [_goodsActivityImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(8.0, 10.0, 8.0, 10.0) resizingMode:UIImageResizingModeTile];
        
        //        _goodsActivityLabel.text = goodsModel.goods_activity;
    }
    
    //菜名
    _goodsNameLabel.text = goodsModel.goods_name;
    if (_goodsActivityView.hidden) {
        _goodsNameLabel.width = _goodsActivityView.right -_goodsNameLabel.left;
    }
    //    float height = [goodsModel.goods_name sizeWithFont:_goodsNameLabel.font constrainedToSize:CGSizeMake(_goodsNameLabel.width, _goodsNameLabel.font.lineHeight * 2)].height;
    //    _goodsNameLabel.height = height;
    
    //菜价
    if (goodsModel.market_price.floatValue && (goodsModel.goods_price.floatValue != goodsModel.market_price.floatValue)) {
        _goodsMarketLabel.hidden = NO;
        _goodsMarketLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.market_price.floatValue];
    } else {
        _goodsMarketLabel.hidden = YES;
    }
    _goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goods_price.floatValue];
    _goodsPriceLabel.width = [_goodsPriceLabel.text widthWithFont:_goodsPriceLabel.font boundingRectWithSize:CGSizeMake(100, _goodsPriceLabel.height)];
    
    //数量
//    _unitLabel.text = @"";
//    if (![NSString isBlankString:goodsModel.goods_units])
//    {
//        _unitLabel.text = [NSString stringWithFormat:@"/%@",goodsModel.goods_units];
//        _unitLabel.left = _goodsPriceLabel.right;
//    }
//    _unitLabel.width = _increaseButton.left - _unitLabel.left;
//    _unitLabel.top = _goodsPriceLabel.top;
    
    [self refreshGoodsNumberUI];
    
}

//刷新菜品数量
-(void) refreshGoodsNumberUI
{
    GoodsModel *goodsModel = self.cellData;
    _goodsCountLabel.hidden = goodsModel.selectedNumber <= 0;
    _goodsCountLabel.text = [NSString stringWithFormat:@"%d",(int)goodsModel.selectedNumber];
    _decreaseButton.selected = goodsModel.selectedNumber > 0;
    _increaseButton.selected = goodsModel.selectedNumber > 0;
    _decreaseButton.hidden = _goodsCountLabel.hidden;
}

///////////////////////////////////////////////////////////////////////////////////////
#pragma Actions
//////////////////////////////////////////////////////////////////////////////////////////////////

///减少
- (IBAction)decreaseAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;
    if (goodsModel.selectedNumber == 1 ) {
        _unitLabel.width = _increaseButton.left - _unitLabel.left;
    }
    
    if (goodsModel.selectedNumber > 0)
        goodsModel.selectedNumber -= 1;
    
    
    [self refreshGoodsNumberUI];
    
    if (_delegate)
    {
        [_delegate pickFoodCellDecreasing:self];
    }
}

//递增
- (IBAction)increaseAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;
    _unitLabel.width = _decreaseButton.left - _unitLabel.left;
    
    //促销菜数量限定
    if (goodsModel.max_num.intValue && (goodsModel.selectedNumber+1 > goodsModel.max_num.intValue)) {
        [BDKNotifyHUD showCryingHUDWithText:@"已达到最大选择数量"];
        return;
    }
    
    goodsModel.selectedNumber += 1;
    [self refreshGoodsNumberUI];
    
    if (_delegate) {
        [_delegate pickFoodCellAscending:self];
    }
    
    if (_delegate) {
        UIView *btnView = [[UIView alloc] initWithFrame:_increaseButton.frame];
        btnView.top = self.cellRow * self.height + _increaseButton.top + (self.cellSection + 1) * 25;
        btnView.backgroundColor = [UIColor clearColor];
        [_delegate pickFoodCellBuyCarWithView:btnView];
    }
}

- (void)addEnlargedDrawingView:(UITapGestureRecognizer* )singleTap
{
    GoodsModel *goodsModel = self.cellData;
    _currentCount = (int)goodsModel.selectedNumber;
    PicPreView *picPreView = [PicPreView viewFromXIB];
    picPreView.delegate = self;
    [picPreView showWithGoodsModel:goodsModel];
}

- (void) didSelectedGoodsModels:(GoodsModel *) goodsModel
{
    [self increaseAction:nil];
}

- (void)didDeleteGoodsModels:(GoodsModel *) goodsModel {
    [self decreaseAction:nil];
}

- (void)didCancelSelectOrders {
    GoodsModel *goodsModel = self.cellData;
    goodsModel.selectedNumber = _currentCount;
    [self refreshGoodsNumberUI];
    if (_delegate) {
        [_delegate pickFoodCellOrigin:self];
    }
}

@end
