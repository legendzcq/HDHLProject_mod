//
//  OrderMenuCartCell.m
//  HDHLProject
//
//  Created by Mac on 15/7/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OrderMenuCartCell.h"

@interface OrderMenuCartCell()
{
    IBOutlet UIView *_bgView;
    IBOutlet UIImageView *_iconImageView;
    IBOutlet FrameLineView *_lineView;
    
    IBOutlet UILabel    *_goodsNameLabel;//名称
    IBOutlet UILabel    *_numberLabel;//数量
    IBOutlet UILabel    *_priceLabel;//价格
    IBOutlet UIButton   *_decreasingButton;//减少数量按钮
    IBOutlet UIButton   *_addButton;
    
    IBOutlet UIView      *_goodsActivityView;
}
@end

@implementation OrderMenuCartCell


- (void)dealloc
{
    RELEASE_SAFELY(_decreasingButton);
    RELEASE_SAFELY(_goodsNameLabel);
    RELEASE_SAFELY(_numberLabel);
    RELEASE_SAFELY(_priceLabel);
    RELEASE_SAFELY(_addButton);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    if (IOS_VERSION_CODE <= 7) {
        [self.contentView addSubview:_bgView];
    }
}

-(void) loadColorConfig
{
    _priceLabel.font = FONT_DISH_PRICE;
    
    _goodsNameLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _numberLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _priceLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
}

- (void)setCellData:(id)cellData
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [super setCellData:cellData];
    [self refreshUI];
}

- (void)refreshUI
{
    GoodsModel *goodsModel = self.cellData;
    _goodsNameLabel.text = goodsModel.goods_name;
    _numberLabel.text = [NSString stringWithFormat:@"%d",(int)goodsModel.selectedNumber];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goods_price.floatValue * goodsModel.selectedNumber];
    //促销
    if (goodsModel.is_sale.intValue == 0) {
        _goodsActivityView.hidden = YES;
    } else {
        _goodsActivityView.hidden = NO;
    }
    float width_max = SCREEN_WIDTH-(225*SCREEN_WIDTH)/320;
    float _width = [_goodsNameLabel.text widthWithFont:_goodsNameLabel.font boundingRectWithSize:CGSizeMake(width_max, _goodsNameLabel.height)];
    if (_width > width_max) {
        _goodsNameLabel.width = width_max;
    } else {
        _goodsNameLabel.width = _width;
    }
    if (_goodsActivityView.hidden) {
        _goodsNameLabel.width = _width + 35;
    } else {
        _goodsActivityView.left = _goodsNameLabel.right + 8;
    }
}

//删除这份菜
- (IBAction)delAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;
    goodsModel.selectedNumber = 0;
    
    if (_actionDelegate)
    {
        [_actionDelegate cartDelAction:self];
    }
}


//减少一份
- (IBAction)decreasingAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;

    if (goodsModel.selectedNumber > 1) {
        goodsModel.selectedNumber -= 1;
    } else {
        goodsModel.selectedNumber = 0;
        if (_actionDelegate) {
            [_actionDelegate cartDelAction:self];
        }
        return;
    }

    if (_actionDelegate)
    {
        [_actionDelegate cartOrderNumberChanged:self];
    }
    
    [self refreshUI];
}

//加一份
- (IBAction)ascendingAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;
    goodsModel.selectedNumber += 1;
    
    [self refreshUI];
    
    if (_actionDelegate)
    {
        [_actionDelegate cartOrderNumberChanged:self];
    }
}

@end
