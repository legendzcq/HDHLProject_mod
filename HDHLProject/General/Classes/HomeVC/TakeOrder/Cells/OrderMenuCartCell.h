//
//  OrderMenuCartCell.h
//  HDHLProject
//
//  Created by Mac on 15/7/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BetterTableCell.h"
#import "GoodsModel.h"
#import "FrameLineView.h"

@protocol OrderMenuCartCellDelegate;

@interface OrderMenuCartCell : BetterTableCell

@property (retain, nonatomic) IBOutlet FrameLineView *seperateLineView;
@property (assign,nonatomic) id <OrderMenuCartCellDelegate> actionDelegate;

- (void)setCellData:(id)cellData;

@end


@protocol OrderMenuCartCellDelegate <NSObject>

@optional

- (void)cartOrderNumberChanged:(OrderMenuCartCell *)cell; //add_del
- (void)cartDelAction:(OrderMenuCartCell *)cell; //清除一种菜品

@end