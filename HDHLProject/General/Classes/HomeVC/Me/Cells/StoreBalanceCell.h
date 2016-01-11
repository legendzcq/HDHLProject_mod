//
//  StoreBalanceCell.h
//  Carte
//
//  Created by liu on 15-4-14.
//
//

#import "BetterTableCell.h"
#import "MyStoreBalanceModel.h"
#import "BrandModel.h"
//充值代理
@protocol  RechargeDelegate <NSObject>

- (void)startToRechargeWithModel:(id)model;

@end

@interface StoreBalanceCell : BetterTableCell

@property (nonatomic,retain) BrandModel * model ;
@property(nonatomic,assign)id<RechargeDelegate>delegate;//将事件反传给Controller

@property (weak, nonatomic) IBOutlet UILabel *blanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet WebImageView *storePhotoView;


- (IBAction)RechargeBtnClick:(UIButton *)sender;

@end
