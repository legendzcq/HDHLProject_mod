//
//  RechargeConfirmRequest.m
//  Carte
//
//  Created by hdcai on 15/4/29.
//
//

#import "RechargeConfirmRequest.h"
#import "RechargeConfirmModel.h"

@implementation RechargeConfirmRequest
- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"/api.php?apiUrl=transferResult&"];
}


- (void)processResult
{
    [super processResult];
    
    RechargeConfirmModel *rechargeConfirmModel = (RechargeConfirmModel*)[RechargeConfirmModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
    [self.resultDic setObject:rechargeConfirmModel forKey:KRequestResultDataKey];
}

@end
