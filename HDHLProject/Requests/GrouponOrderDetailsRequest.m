//
//  GrouponOrderDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "GrouponOrderDetailsRequest.h"
#import "GrouponOrderModel.h"
#import "PayModeModel.h"

@implementation GrouponOrderDetailsRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=showOrder&"];

}


-(void)processResult
{
    [super processResult];
    
    if (self.isSuccess)
    {
        GrouponOrderModel *grouponOrderModel = [[GrouponOrderModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSMutableArray * payModelArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *payDic in self.resultDic[@"data"][@"pays"]) {
            PayModeModel *payModel=[[PayModeModel alloc]initWithDictionary:payDic];
            [payModelArray addObject:payModel];
        }
        grouponOrderModel.pays = payModelArray;
        grouponOrderModel.orderType = GrouponOrderType;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:grouponOrderModel forKey:KRequestResultDataKey];
    }
}

@end
