//
//  RechargeRequest.m
//  Carte
//
//  Created by ligh on 15-1-7.
//
//

#import "RechargeRequest.h"

@implementation RechargeRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"/api.php?apiUrl=memberTransfer&"];
}


- (void)processResult
{
    [super processResult];
    
    UserModel *userModel = [[UserModel alloc]initWithDictionary:self.resultDic[@"data"]];
    NSArray *paysJSONArray = self.resultDic[@"data"][@"pays"];
    NSMutableArray *paysArray = [NSMutableArray array];
    for ( id dic  in paysJSONArray) {
        PayModeModel *payModel = (PayModeModel*)[PayModeModel reflectObjectsWithJsonObject:dic];
        if (payModel.pay_id.intValue == PayModeUserAccount) {
            payModel.user_money = self.resultDic[@"data"][@"user_money"];
        }
        [paysArray addObject:payModel];
    }
    userModel.paysArray = paysArray;
    
    [self.resultDic setObject:userModel forKey:KRequestResultDataKey];
}

@end
