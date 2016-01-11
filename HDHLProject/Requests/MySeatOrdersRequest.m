//
//  MySeatOrdersRequest.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "MySeatOrdersRequest.h"


@implementation MySeatOrdersRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=listOrder&"];
}

-(void)processResult
{
    
    [super processResult];
    
    
    if (self.isSuccess)
    {
        //解析出订座订单列表
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *seatOrderJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *seatOrderArray = [NSMutableArray array];
        for (id dic in seatOrderJSONArray)
        {
            SeatOrderModel *seatOrderModel = [[SeatOrderModel alloc] initWithDictionary:dic];
            seatOrderModel.orderType = SeatOrderType;
            [seatOrderArray addObject:seatOrderModel];
        }
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
