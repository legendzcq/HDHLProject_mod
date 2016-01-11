//
//  OrderMenuCell.m
//  Carte
//
//  Created by ligh on 14-7-23.
//
//

#import "OrderMenuCell.h"


@interface OrderMenuCell()
{
    
    IBOutlet UILabel    *_orderNameLabel;//名称
    IBOutlet UILabel    *_numberLabel;//数量
    IBOutlet UILabel    *_priceLabel;//价格
    IBOutlet UIButton   *_decreasingButton;//减少数量按钮
    IBOutlet UIButton   *_delButton;
    IBOutlet UIButton   *_addButton;
}
@end

@implementation OrderMenuCell


- (void)dealloc
{
    RELEASE_SAFELY(_decreasingButton);
    RELEASE_SAFELY(_orderNameLabel);
    RELEASE_SAFELY(_numberLabel);
    RELEASE_SAFELY(_priceLabel);
    RELEASE_SAFELY(_delButton);
    RELEASE_SAFELY(_addButton);
    RELEASE_SAFELY(_seperateLineView);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    [self setEditing:NO];
}

-(void) loadColorConfig
{
    _orderNameLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _numberLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _priceLabel.textColor = ColorForHexKey(AppColor_Amount1);
}

-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    [self refreshUI];
}


-(void)setEditing:(BOOL)editing
{
    if (editing)
    {
        _numberLabel.textColor = ColorForHexKey(AppColor_Amount1);
        _delButton.userInteractionEnabled = YES;
        _decreasingButton.userInteractionEnabled = YES;
        _addButton.userInteractionEnabled = YES;

    }else
    {
        [self loadColorConfig];
        _delButton.userInteractionEnabled = NO;
        _decreasingButton.userInteractionEnabled = NO;
        _addButton.userInteractionEnabled = NO;
    }
}

-(void) refreshUI
{
    GoodsModel *goodsModel = self.cellData;
    _orderNameLabel.text = goodsModel.goods_name;
    _numberLabel.text = [NSString stringWithFormat:@"%d%@",(int)goodsModel.selectedNumber, goodsModel.goods_units];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goods_price.floatValue * goodsModel.selectedNumber];
}

//删除这份菜
- (IBAction)delAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;
    goodsModel.selectedNumber = 0;
    
    if (_actionDelegate)
    {
        [_actionDelegate delAction:self];
    }
}


//减少一份
- (IBAction)decreasingAction:(id)sender
{
    GoodsModel *goodsModel = self.cellData;

    if (goodsModel.selectedNumber > 0)
        goodsModel.selectedNumber -=1;
    else
        return;

    if (_actionDelegate)
    {
        [_actionDelegate orderNumberChanged:self];
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
            [_actionDelegate orderNumberChanged:self];
        }
}



@end
