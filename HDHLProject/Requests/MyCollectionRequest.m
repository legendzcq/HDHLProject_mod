//
//  MyCollectionRequest.m
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCollectionRequest.h"
#import "MyCollectionModel.h"

@implementation MyCollectionRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=favourtList&"];
}


-(void)processResult
{
    
    [super processResult];
    
    //    LOG(@"=================\n%@%@\n",self.resultDic[@"msg"],self.resultDic);
    
    if (self.isSuccess)
    {
        
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *storeJSONArray = self.resultDic[@"data"][@"list"];
        pageModel.listArray = [MyCollectionModel reflectObjectsWithArrayOfDictionaries:storeJSONArray];
        
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
