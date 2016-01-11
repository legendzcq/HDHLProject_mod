//
//  SearchStoreRequest.m
//  HDHLProject
//
//  Created by liu on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SearchStoreRequest.h"
#import "BrandModel.h"

@implementation SearchStoreRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=storeSearch&"];
}

- (void)processResult
{
    [super processResult];
    if (self.isSuccess)
    {
        //解析出订座订单列表
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *seatOrderJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *seatOrderArray = [NSMutableArray arrayWithCapacity:0];
        for (id dic in seatOrderJSONArray)
        {
            BrandModel *brandModel = [[BrandModel alloc] initWithDictionary:dic];
            [seatOrderArray addObject:brandModel];
        }
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end
