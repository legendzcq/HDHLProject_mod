//
//  GroupBuyOrderCell.h
//  Carte
//
//  Created by ligh on 14-4-10.
//
//

#import "BetterTableCell.h"
#import "GrouponOrderModel.h"

/**
 *  团购订单cell
 */
@protocol GroupBuyOpertionDelegate <NSObject>

- (void)operationWithModel:(id)model
                 WithIndex:(int)index
        WithOperationState:(OperationState)state;
@end

@interface GroupBuyOrderCell : BetterTableCell

@property (nonatomic,assign)id<GroupBuyOpertionDelegate>delegate;
@property (nonatomic,retain)GrouponOrderModel *model;

@property (retain, nonatomic) IBOutlet UIButton *ShowGroupCodeButton;
@property (nonatomic,assign) int index;
@property (retain, nonatomic) IBOutlet UIButton *TellFriendButton;

@end
