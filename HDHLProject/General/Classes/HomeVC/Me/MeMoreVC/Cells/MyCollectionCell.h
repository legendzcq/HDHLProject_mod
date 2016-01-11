//
//  MyCollectionCell.h
//  HDHLProject
//
//  Created by hdcai on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BetterTableCell.h"
#import "MyCollectionModel.h"

@protocol MyCollectionCellCheckDelegate <NSObject>

- (void)checkMyCollectionCellWithModel:(MyCollectionModel *)myCollectionModel WithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyCollectionCell : BetterTableCell

@property (nonatomic ,assign) id<MyCollectionCellCheckDelegate>delegate;
@property (nonatomic,retain)NSIndexPath *indexPath;

@end
