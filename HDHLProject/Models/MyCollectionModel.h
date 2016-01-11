//
//  MyCollectionModel.h
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseModelObject.h"

@interface MyCollectionModel : BaseModelObject

@property(retain, nonatomic) NSString *brand_name;//品牌名
@property(retain, nonatomic) NSString *frozen_money;//
@property(retain, nonatomic) NSString *give_money;//
@property(retain, nonatomic) NSString *level_id;//
@property(retain, nonatomic) NSString *recharge_money;//
@property(retain, nonatomic) NSString *store_id;//店铺id
@property(retain, nonatomic) NSString *store_name;//店铺名
@property(retain, nonatomic) NSString *user_money;//用户余额
@property(retain, nonatomic) NSString *brand_id;//品牌id
@property(retain, nonatomic) NSString *image_url;//图片
@end
