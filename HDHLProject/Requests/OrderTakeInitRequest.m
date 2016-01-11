//
//  OrderTakeInitRequest.m
//  HDHLProject
//
//  Created by Mac on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OrderTakeInitRequest.h"
#import "GoodsModel.h"

@implementation OrderTakeInitRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=preAddOrder&"];
}

- (void)processResult {
    [super processResult];

    if (self.isSuccess) {
        
        //菜品 goods
        NSArray *goodsJSONModeArray = [(NSDictionary *)self.resultDic[@"data"] arrayForKey:@"list"];
        NSArray *goodsModeArray = [NSArray array];
        goodsModeArray = [GoodsModel reflectArrayWithInitWithDictionary:goodsJSONModeArray];
        [self.resultDic setObject:goodsModeArray forKey:KTakeOrderGoodsResultRequest];

    }
}

@end
