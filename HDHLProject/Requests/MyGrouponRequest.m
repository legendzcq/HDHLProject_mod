//
//  MyGrouponRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "MyGrouponRequest.h"
#import "GrouponOrderModel.h"

@implementation MyGrouponRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=listOrder&"];
}

-(void)processResult
{
    
    [super processResult];
    
    
    if (self.isSuccess)
    {
        //解析出团购订单列表
        
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *seatOrderJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *seatOrderArray = [NSMutableArray array];
        for (id dic in seatOrderJSONArray)
        {
           GrouponOrderModel *grouponOrderModel = [[GrouponOrderModel alloc] initWithDictionary:dic];
         
           grouponOrderModel.orderType = GrouponOrderType;
           [seatOrderArray addObject:grouponOrderModel];
        }
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];

    }
}


@end
