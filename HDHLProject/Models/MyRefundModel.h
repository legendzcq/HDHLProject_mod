//
//  MyRefundModel.h
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseModelObject.h"

@interface MyRefundModel : BaseModelObject

@property(retain, nonatomic)NSString *amount;//退款金额
@property(retain, nonatomic)NSString *order_sn;//订单号
@property(retain, nonatomic)NSString *amount_status_msg;//状态文字
@property(retain, nonatomic)NSString *amount_status_id;//状态id
@property(retain, nonatomic)NSString *amount_status_text;//详情面描述
@property(retain, nonatomic)NSString *store_name;//店铺名字


@end
