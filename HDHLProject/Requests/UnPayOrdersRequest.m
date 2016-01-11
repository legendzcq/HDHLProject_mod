//
//  UnPayOrdersRequest.m
//  Carte
//
//  Created by liu on 15-4-22.
//
//

#import "UnPayOrdersRequest.h"
#import "BrandModel.h"
#import "OrderModel.h"

@implementation UnPayOrdersRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=oneOrder&"];
}

-(void)processResult
{
    
    [super processResult];
    
    //    LOG(@"=================%@",self.resultDic);
    
    if (self.isSuccess)
    {
        //解析出订座订单列表
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSDictionary  *dic = self.resultDic[@"data"];
        NSMutableArray *seatOrderArray = [NSMutableArray array];
        
        OrderModel *brandModel = [[OrderModel alloc] initWithDictionary:dic];
        [seatOrderArray addObject:brandModel];
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
