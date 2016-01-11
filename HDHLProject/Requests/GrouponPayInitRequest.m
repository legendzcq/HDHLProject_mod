//
//  GrouponPayInitRequest.m
//  Carte
//
//  Created by ligh on 14-5-12.
//
//

#import "GrouponPayInitRequest.h"
#import "GrouponModel.h"
#import "PayModeModel.h"

@implementation GrouponPayInitRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=preAddOrder&"];
}

-(void)processResult
{
    [super processResult];
    
//    LOG(@"==================%@%@\n",self.resultDic[@"msg"],self.resultDic);
    
    if (self.isSuccess)
    {
        GrouponModel *groupModel = [[GrouponModel alloc] initWithDictionary:self.resultDic[@"data"]];
        [self.resultDic setObject:groupModel forKey:KRequestResultDataKey];
        NSArray *payJSONArray = self.resultDic[@"data"][@"pays"];
        NSMutableArray *payModelArray = [NSMutableArray array];
        for (id payDic in payJSONArray)
        {
            PayModeModel *payModel = [[PayModeModel alloc] initWithDictionary:payDic];
            if (payModel.pay_id.intValue == PayModeUserAccount) {
                payModel.user_money = self.resultDic[@"data"][@"user_money"];
            }
            [payModelArray addObject:payModel];
        }
        
        [self.resultDic setObject:payModelArray forKey:KTakeOrderPayModeResultRequest];
        
        [self.resultDic removeObjectForKey:@"data"];
    }
}

@end
