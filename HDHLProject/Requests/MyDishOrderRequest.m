//
//  MyDishOrderRequest.m
//  Carte
//
//  Created by ligh on 14-4-30.
//
//

#import "MyDishOrderRequest.h"

@implementation MyDishOrderRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=listOrder&"];
}

-(void)processResult
{
    
    [super processResult];
    
//    LOG(@"=================%@",self.resultDic);
    
    if (self.isSuccess)
    {
        //解析出订座订单列表
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *seatOrderJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *seatOrderArray = [NSMutableArray array];
        for (id dic in seatOrderJSONArray)
        {
            OrderModel *dishOrderModel = [[OrderModel  alloc] initWithDictionary:dic];
            [seatOrderArray addObject:dishOrderModel];
        }
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
