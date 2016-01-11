//
//  MyDishCardCell.h
//  Carte
//
//  Created by liu on 15-4-14.
//
//

#import "BetterTableCell.h"
#import "BrandModel.h"

@protocol ChooseStoreDelegate <NSObject>

- (void)startToChooseStoreWithModel:(id)model;

@end
@interface MyDishCardCell : BetterTableCell


@property (weak, nonatomic) IBOutlet UIImageView *backGroudView;
@property (weak, nonatomic) IBOutlet UIButton *storeNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet WebImageView *storePhotoView;
@property (nonatomic,assign) id<ChooseStoreDelegate>delegate;
@property (nonatomic,strong) BrandModel *brandModel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;

- (IBAction)ChooseStoreBtnClick:(UIButton *)sender;
- (void)showDistanceOrNotWithBool:(BOOL)locationSucess;
@end
