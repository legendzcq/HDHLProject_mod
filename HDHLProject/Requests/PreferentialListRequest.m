//
//  PreferentialListRequest.m
//  HDHLProject
//
//  Created by Mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PreferentialListRequest.h"

@implementation PreferentialListRequest

- (NSString *)getRequestUrl {
    return [NSString stringWithFormat:@"api.php?apiUrl=activityList&"];
}

- (void)processResult {
    [super processResult];
    if (self.isSuccess) {
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *grouponJSONArray = self.resultDic[@"data"][@"list"];
        pageModel.listArray = [GrouponModel reflectObjectsWithArrayOfDictionaries:grouponJSONArray];
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end
