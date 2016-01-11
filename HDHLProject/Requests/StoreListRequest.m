//
//  StoreListRequest.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "StoreListRequest.h"

#import "StoreModel.h"

@implementation StoreListRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=storeSearch&"];
}


-(void)processResult
{
    
    [super processResult];
   
//    LOG(@"=================\n%@%@\n",self.resultDic[@"msg"],self.resultDic);
    
    if (self.isSuccess)
    {
        
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *storeJSONArray = self.resultDic[@"data"][@"list"];
        pageModel.listArray = [StoreModel reflectObjectsWithArrayOfDictionaries:storeJSONArray];
        
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
