//
//  HistoryOrderRequest.m
//  Carte
//
//  Created by liu on 15-4-17.
//
//

#import "HistoryOrderRequest.h"
#import "DishOrderModel.h"
#import "TakeOutOrderModel.h"
#import "GrouponOrderModel.h"
#import "SeatOrderModel.h"

@implementation HistoryOrderRequest
- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=historyOrder&"];
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
            OrderModel  *dishOrderModel = nil;
            switch ([self.parameters[@"order_type"] intValue]) {
                case DishOrderType:
                      dishOrderModel = [[DishOrderModel alloc] initWithDictionary:dic];
                    break;
                case TakeOutOrderType:
                    dishOrderModel = [[TakeOutOrderModel alloc]initWithDictionary:dic];
                    break ;
                case SeatOrderType:
                     dishOrderModel = [[SeatOrderModel alloc]initWithDictionary:dic];
                    break;
                case GrouponOrderType:
                    dishOrderModel = [[GrouponOrderModel alloc]initWithDictionary:dic];
                    break ;
                default:
                    break;
            }
          
             dishOrderModel.orderType  = [self.parameters[@"order_type"]  intValue];
             dishOrderModel.isHistoryOrder = YES ;
             [seatOrderArray addObject:dishOrderModel];
        }
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end
