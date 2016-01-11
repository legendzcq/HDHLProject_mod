//
//  GrouponStoreModel.h
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "BaseModelObject.h"

/**
 *  团购支持的商家model
 */
@interface GrouponStoreModel : BaseModelObject

@property (retain,nonatomic) NSString *address;//商家地址
@property (retain,nonatomic) NSString *groupon_phone;//团购手机号
@property (retain,nonatomic) NSString *phone;//团购手机号
@property (retain,nonatomic) NSString *position;//位置
@property (retain,nonatomic) NSString *store_id;//商家id
@property (retain,nonatomic) NSString *store_name;//商家名称

@end
