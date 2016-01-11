//
//  OrderSelectedListView.m
//  HDHLProject
//
//  Created by Mac on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OrderSelectedListView.h"
#import "GoodsModel.h"
#import "StrikethroughLabel.h"

#define kOrderSelListCellHeight 40
#define kOrderSelGoodCountWidth 40 //数量
#define kOrderSelGoodPriceWidth 70 //价格

@implementation OrderSelectedListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)showOrderSelectedListInView:(UIView *)inView withArray:(NSArray *)array showMarketPrice:(BOOL)show {
    CGFloat width = inView.width;
    CGFloat topSpace = 0;
    for (GoodsModel *good in array) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, topSpace, width, kOrderSelListCellHeight)];
        [self addSubview:bgView];
        [self setOrderListCell:bgView withData:good showMarketPrice:show];
        topSpace += kOrderSelListCellHeight;
    }
    self.height = topSpace;
}

- (void)setOrderListCell:(UIView *)cellView withData:(GoodsModel *) goodsModel showMarketPrice:(BOOL)show {
    CGFloat cellWidth  = cellView.width;
    CGFloat cellHeight = cellView.height;
    //标题
    UILabel *goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, cellWidth/2-kOrderSelGoodCountWidth/2-LEFT_SPACE, cellHeight)];
    goodNameLabel.textAlignment = NSTextAlignmentLeft;
    goodNameLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    goodNameLabel.font = FONT_DISH_NAME;
    [cellView addSubview:goodNameLabel];
    goodNameLabel.text = goodsModel.goods_name;

    //数量
    UILabel *goodCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth/2-kOrderSelGoodCountWidth/2, 0, kOrderSelGoodCountWidth, cellHeight)];
    goodCountLabel.textAlignment = NSTextAlignmentCenter;
    goodCountLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    goodCountLabel.font = FONT_DISH_COUNT;
    [cellView addSubview:goodCountLabel];
    goodCountLabel.text = [NSString stringWithFormat:@"x%d",(int)goodsModel.selectedNumber];

    //促销菜
    if (goodsModel.is_sale.intValue) {
        CGFloat nameWidth = [goodNameLabel.text widthWithFont:goodNameLabel.font boundingRectWithSize:CGSizeMake(goodNameLabel.width, goodNameLabel.height)];
        if (nameWidth > goodNameLabel.width-30-10) {
            goodNameLabel.width = goodNameLabel.width-30-10;
        } else {
            goodNameLabel.width = nameWidth;
        }
        
        UILabel *saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodNameLabel.right+8, (cellView.height-15)/2, 30, 15)];
        saleLabel.backgroundColor = [UIColor redColor];
        saleLabel.text = @"促销";
        saleLabel.textColor = [UIColor whiteColor];
        saleLabel.textAlignment = NSTextAlignmentCenter;
        saleLabel.font = [UIFont systemFontOfSize:12];
        [cellView addSubview:saleLabel];
    }
    
    //价格
    //会员价
    UILabel *goodPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth-LEFT_SPACE-kOrderSelGoodPriceWidth, 0, kOrderSelGoodPriceWidth, cellHeight)];
    goodPriceLabel.textAlignment = NSTextAlignmentRight;
    goodPriceLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    goodPriceLabel.font = FONT_DISH_PRICE;
    [cellView addSubview:goodPriceLabel];
    goodPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.goods_price.floatValue * goodsModel.selectedNumber];
    //原价
    if (show) {
        if (goodsModel.market_price.floatValue && (goodsModel.goods_price.floatValue != goodsModel.market_price.floatValue)) {
            StrikethroughLabel *goodMarketLabel = [[StrikethroughLabel alloc]  initWithFrame:CGRectMake(cellWidth-LEFT_SPACE-kOrderSelGoodPriceWidth*2, 0, kOrderSelGoodPriceWidth, cellHeight)];
            goodMarketLabel.textAlignment = NSTextAlignmentRight;
            goodMarketLabel.textColor = ColorForHexKey(AppColor_OrderCart_ClearText);
            goodMarketLabel.font = FONT_DISH_MARKET;
            [cellView addSubview:goodMarketLabel];
            goodMarketLabel.text = [NSString stringWithFormat:@"￥%.2f",goodsModel.market_price.floatValue * goodsModel.selectedNumber];
        }
    }
}

@end













