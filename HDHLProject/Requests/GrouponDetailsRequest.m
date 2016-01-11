//
//  GrouponDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-5-10.
//
//

#import "GrouponDetailsRequest.h"

@implementation GrouponDetailsRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=grouponDetail&"];
    
}


-(void)processResult
{
    
    [super processResult];
    
    if (self.isSuccess)
    {
        //解析出订座订单列表
        GrouponModel *groupModel = [[GrouponModel alloc] initWithDictionary:self.resultDic[@"data"]];
        [self.resultDic setObject:groupModel forKey:KRequestResultDataKey];
        [self.resultDic removeObjectForKey:@"data"];
    }
}

@end
