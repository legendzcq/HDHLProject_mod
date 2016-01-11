//
//  TakeOrderInitRequest.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "TakeOrderInitRequest.h"

@implementation TakeOrderInitRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=getMenus&"];
}

-(void)processResult
{
    [super processResult];
    
    if (self.isSuccess) {
        NSArray *goodsCategoryJSONArray = self.resultDic[@"data"][@"menu"];
        NSArray *goodsCategoryArray = [NSArray array];
        goodsCategoryArray = [GoodsCategoryModel reflectObjectsWithArrayOfDictionaries:goodsCategoryJSONArray];
        [self.resultDic setObject:goodsCategoryArray forKey:KRequestResultDataKey];
        
//        if (self.resultDic[@"data"][@"send_rules"]) {
//            SendRulesModel *sendRulesModel = (SendRulesModel *)[SendRulesModel reflectObjectsWithJsonObject:self.resultDic[@"data"][@"send_rules"]];
//            [self.resultDic setObject:sendRulesModel forKey:KSendRulesKey];
//        }
    }
}

@end
