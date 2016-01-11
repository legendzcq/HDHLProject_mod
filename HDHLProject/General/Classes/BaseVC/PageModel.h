//
//  PageModel.h
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "BaseModelObject.h"

/**
 *  分页model
 */
@interface PageModel : BaseModelObject

@property (strong,nonatomic) NSString  *pagenow;//当前页
@property (strong,nonatomic) NSString  *totalpage;//总页数

@property (strong,nonatomic) NSArray   *listArray; //列表数据

//是否有更多数据
- (BOOL)isMoreData;

@end
