//
//  GrouponMoreStoreRequest.m
//  Carte
//
//  Created by ligh on 14-5-12.
//
//

#import "GrouponMoreStoreRequest.h"

@implementation GrouponMoreStoreRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=branchStore&"];
    
}

-(void)processResult
{
    
    [super processResult];
    
    
    if (self.isSuccess)
    {
    
        NSArray *storeJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *storeArray = [NSMutableArray array];
        for (id dic in storeJSONArray)
        {
            StoreModel *storeModel = [[StoreModel alloc] initWithDictionary:dic];
            [storeArray addObject:storeModel];
        }

        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:storeArray forKey:KRequestResultDataKey];
    }
}

@end
