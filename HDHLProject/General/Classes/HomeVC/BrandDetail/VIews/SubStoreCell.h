//
//  SubStoreCell.h
//  Carte
//
//  Created by ligh on 14-4-11.
//
//

#import "BetterTableCell.h"

#import "StoreModel.h"

/**
 *  分店cell 带有选定按钮
 */
@interface SubStoreCell : BetterTableCell


//动态调整cellRow高度
+ (float)setRowHeightWithCellModel:(StoreModel *)model;

@end
