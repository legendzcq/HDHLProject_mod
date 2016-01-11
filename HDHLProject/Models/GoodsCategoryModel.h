//
//  GoodsCategoryModel.h
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

/**
 *  菜品分类model
 */
@interface GoodsCategoryModel : BaseModelObject

@property (retain,nonatomic) NSString *cate_name;//分类名称
@property (retain,nonatomic) NSString *cate_id;//分类id
@property (retain,nonatomic) NSArray  *goods;//分类下的菜品列表

@property (assign,nonatomic) NSInteger selectedNumber;//菜品选中的数量

@end
