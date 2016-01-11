//
//  BetterTableCell.h
//  KunshanTalent
//
//  Created by ligh on 13-9-23.
//
//

#import <UIKit/UIKit.h>

@interface BetterTableCell : UITableViewCell

///////////////////////////////////////////////////////////////////////////////
#pragma mark  data
///////////////////////////////////////////////////////////////////////////////
@property (strong, nonatomic) id cellData;
@property (weak, nonatomic) UIViewController *viewController;


@property (assign, nonatomic) NSInteger cellIndex;
@property (assign, nonatomic) NSInteger cellSection;
@property (assign, nonatomic) NSInteger cellRow;

///////////////////////////////////////////////////////////////////////////////
#pragma mark  view
///////////////////////////////////////////////////////////////////////////////
//设置数据源用
- (void)configerWithDataSource:(id)objectData;

- (void)disableSelectedBackgroundView;

+ (id)cellFromXIB;

+ (NSString *)cellIdentifier;

@end
