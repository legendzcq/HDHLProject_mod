//
//  GrouponListRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "GrouponListRequest.h"
#import "GrouponModel.h"

@implementation GrouponListRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=activityList&"];
    
}


- (void)processResult
{

    [super processResult];
    
//    LOG(@"==============%@====%@",self.resultDic[@"msg"],self.resultDic);
    
    if (self.isSuccess) {
        
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *grouponJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *grouponArray = [NSMutableArray array];
        for (id dic in grouponJSONArray)
        {
            GrouponModel *grouponModel = [[GrouponModel alloc] initWithDictionary:dic];
            [grouponArray addObject:grouponModel];
        }
        pageModel.listArray = grouponArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
