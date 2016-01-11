//
//  OrderMenuCell.h
//  Carte
//
//  Created by ligh on 14-7-23.
//
//

#import "BetterTableCell.h"
#import "GoodsModel.h"
#import "FrameLineView.h"

@protocol OrderMenuCellDelegate;


@interface OrderMenuCell : BetterTableCell

@property (retain, nonatomic) IBOutlet FrameLineView *seperateLineView;
@property (assign,nonatomic) id<OrderMenuCellDelegate> actionDelegate;

- (void)setCellData:(id)cellData;
- (void)setEditing:(BOOL)editing;

@end



@protocol OrderMenuCellDelegate <NSObject>

@optional

- (void)orderNumberChanged:(OrderMenuCell *)cell; //add_del
- (void)delAction:(OrderMenuCell *)cell; //add_del

@end