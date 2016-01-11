//
//  TakeoutAddressModel.h
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "BaseModelObject.h"

/**
 *  外卖地址model
 */
@interface TakeoutAddressModel : BaseModelObject

@property (retain,nonatomic) NSString *a_id;
@property (retain,nonatomic) NSString *username;//用户名
@property (retain,nonatomic) NSString *mobile;//手机号
@property (retain,nonatomic) NSString *city;//所在城市
@property (retain,nonatomic) NSString *address;//地址
@property (retain,nonatomic) NSString *default_address;//是否为默认地址 1是 0不是


@end
