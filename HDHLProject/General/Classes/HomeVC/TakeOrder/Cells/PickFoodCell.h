//
//  PickFoodCell.h
//  Carte
//
//  Created by ligh on 14-3-27.
//
//

#import "BetterTableCell.h"

@protocol PickFoodCellDelegate;

@interface PickFoodCell : BetterTableCell

@property (assign,nonatomic) id <PickFoodCellDelegate> delegate;

- (void)setCellData:(id)cellData withShow:(BOOL)show; //是否显示图片
- (void)hiddenSeparatorLine:(BOOL)hidden;
- (void)showSeparatorLineLeftZero:(BOOL)show;

@end

@protocol PickFoodCellDelegate <NSObject>

@optional
- (void)pickFoodCellAscending:(PickFoodCell *)cell; //添加一项
- (void)pickFoodCellDecreasing:(PickFoodCell *)cell;//减少一项
- (void)pickFoodCellOrigin:(PickFoodCell *)cell;//不变

- (void)pickFoodCellBuyCarWithView:(UIView *)btnView;

@end