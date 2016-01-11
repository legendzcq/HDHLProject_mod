//
//  GroupBuyCell.m
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "GroupBuyCell.h"
#import "StrikethroughLabel.h"

@interface GroupBuyCell()
{
    //团购图片
    IBOutlet WebImageView       *_groupImageView;
    //团购图片名称
    IBOutlet UILabel                *_grouponNameLabel;
    //品牌名
    IBOutlet UILabel                *_brandLabel;
    //团购价格
    IBOutlet UILabel                *_shopPriceLabel;
    //市场价格
    IBOutlet StrikethroughLabel     *_marketPriceLabel;
    //截止日期
    IBOutlet UILabel                *_deadlineLabel;
    
    //距离
    IBOutlet UILabel                *_distanceLabel;
    IBOutlet UIImageView            *_distanceImageView;
    
    IBOutlet UIView                 *_frameView;
    
    //右边类型小图标显示
    IBOutlet UIView      *_grouponImeBGView;
    IBOutlet UIImageView *_grouponTypeImageView;
    IBOutlet UILabel     *_grouponTypeLabel;
 //团购显示支持哪些分店
    IBOutlet UILabel *_zhiChiUseLabel;
    
}
@end

@implementation GroupBuyCell

- (void)dealloc
{
    RELEASE_SAFELY(_groupImageView);
    RELEASE_SAFELY(_shopPriceLabel);
    RELEASE_SAFELY(_marketPriceLabel);
    RELEASE_SAFELY(_distanceLabel);
    RELEASE_SAFELY(_frameView);
    RELEASE_SAFELY(_deadlineLabel);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    
    [_frameView.layer setCornerRadius:3];
    
//    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    
//    _groupInstructionLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
}

-(void) loadColorConfig
{
    _marketPriceLabel.textColor = ColorForHexKey(AppColor_Original_Price1);
    _grouponNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
    
    _shopPriceLabel.textColor = ColorForHexKey(AppColor_Amount1);
    _grouponTypeLabel.textColor = ColorForHexKey(AppColor_Label_Text);
    _zhiChiUseLabel.textColor = ColorForHexKey(AppColor_Prompt_Text2);
    _deadlineLabel.textColor  =ColorForHexKey(AppColor_Content_Text1);
    _distanceLabel.textColor = ColorForHexKey(AppColor_Content_Text1);
}

-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    
    GrouponModel *grouponModel = cellData;
    
    //图片
    [_groupImageView setImageWithUrlString:grouponModel.image_small placeholderImage:KSmallPlaceHolderImage];
    //品牌名
    _brandLabel.text = grouponModel.brand_name;
    //标题
    _grouponNameLabel.text = grouponModel.activity_title;
    float nameWidth = [_grouponNameLabel.text widthWithFont:_grouponNameLabel.font boundingRectWithSize:CGSizeMake(_frameView.width-_grouponTypeImageView.width, _grouponNameLabel.height)];
    _grouponNameLabel.width = nameWidth;
    _grouponImeBGView.right = self.contentView.right - 10;
    if (_grouponNameLabel.right >= _grouponImeBGView.left) {
        _grouponNameLabel.width = _grouponImeBGView.left - _grouponNameLabel.left;
    }
    //支持的店
    _zhiChiUseLabel.text= grouponModel.use_scope;
    _zhiChiUseLabel.left = _grouponNameLabel.right+MARGIN_S;
    
    float userWidth = [_zhiChiUseLabel.text widthWithFont:_zhiChiUseLabel.font boundingRectWithSize:CGSizeMake(MAXFLOAT, _zhiChiUseLabel.height)];
    _zhiChiUseLabel.width = userWidth;
    if (_zhiChiUseLabel.left >= _grouponImeBGView.left) {
        _zhiChiUseLabel.width = 0;
    } else {
        if (_zhiChiUseLabel.right >= _grouponImeBGView.left) {
            _zhiChiUseLabel.width = _grouponImeBGView.left - _zhiChiUseLabel.left - 2*MARGIN_S;
        }
    }
    
//    if (grouponModel.is_suppor.intValue == 1) {
//        _zhiChiUseLabel.textColor = ColorForHexKey(AppColor_Order_Status_Text);
//    } else {
//        _zhiChiUseLabel.textColor = ColorForHexKey(AppColor_Prompt_Text2);
//    }
    
    if (grouponModel.sale_type.intValue == GroupISShow) { //团购
        _grouponTypeImageView.image = [UIImage imageNamed:@"promotion_groupon"];
        _grouponTypeLabel.text = @"团购";
        _shopPriceLabel.hidden = NO;
        _marketPriceLabel.hidden = NO;
    } else { //活动
        _grouponTypeImageView.image = [UIImage imageNamed:@"promotion_activity"];
        _grouponTypeLabel.text = @"活动";
        _shopPriceLabel.hidden = YES;
        _marketPriceLabel.hidden = YES;
    }

    //团购价格
    if (grouponModel.sale_type.intValue == GroupISShow) {
        _shopPriceLabel.text = [NSString stringWithFormat:@"￥%@",grouponModel.shop_price];
        _marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",grouponModel.market_price];
        
        if ((int)grouponModel.shop_price.floatValue == grouponModel.shop_price.floatValue)
        {
            _shopPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",grouponModel.shop_price.floatValue];
        } else {
            _shopPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",grouponModel.shop_price.floatValue];
        }
        
        if ((int)grouponModel.market_price.floatValue == grouponModel.market_price.floatValue)
        {
            _marketPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",grouponModel.market_price.floatValue];
        } else {
            _marketPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",grouponModel.market_price.floatValue];
        }
        
        float width = [_shopPriceLabel.text widthWithFont:_shopPriceLabel.font boundingRectWithSize:CGSizeMake(100, _shopPriceLabel.font.lineHeight)];
        _shopPriceLabel.width = width;
        _marketPriceLabel.left = _shopPriceLabel.right + MARGIN_S;
        
        //如果市场价格等于0则不显示
        _marketPriceLabel.hidden = grouponModel.market_price.floatValue ==0 || grouponModel.market_price.floatValue == grouponModel.shop_price.floatValue;
    }
   
    //截止日期
    _deadlineLabel.text = [NSString stringWithFormat:@"截止日期：%@",[grouponModel endTimeOfForamt]];
    
    //距离
    _distanceLabel.text = grouponModel.distance;
    _distanceLabel.hidden = [grouponModel.distance isEqualToString:@"-1"];
    _distanceImageView.hidden = _distanceLabel.hidden;
    
    if (_distanceLabel.hidden) {
        return ;
    }
    float distaneLabelWidth = [_distanceLabel.text widthWithFont:_distanceLabel.font boundingRectWithSize:CGSizeMake(120, _distanceLabel.height)];
    _distanceLabel.width = distaneLabelWidth;
    _distanceLabel.left = _frameView.width - distaneLabelWidth;
    _distanceImageView.right = _distanceLabel.left - MARGIN_S;
    
}

@end
