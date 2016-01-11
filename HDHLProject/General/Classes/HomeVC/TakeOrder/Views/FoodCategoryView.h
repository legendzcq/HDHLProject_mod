//
//  FoodCategoryView.h
//  Carte
//
//  Created by ligh on 14-3-27.
//
//

#import "XibView.h"
#import "GoodsCategoryModel.h"


/**
 *  菜系分类view
 */
@interface FoodCategoryView : XibView

@property (retain, nonatomic) IBOutlet UIButton *categoryNameButton;
@property (retain, nonatomic) GoodsCategoryModel *goodsCategoryModel;

- (void)refreshUI;

@end
