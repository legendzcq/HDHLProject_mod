//
//  VoucherCell.h
//  Carte
//
//  Created by ligh on 14-4-9.
//
//

#import "BetterTableCell.h"
#import "VoucherModel.h"

/**
 *  代金卷cell
 */


@interface VoucherCell : BetterTableCell

@property (nonatomic, assign) BOOL VouchersUsed; //必须填充的字段

- (void)setCellData:(id)cellData;

@end
