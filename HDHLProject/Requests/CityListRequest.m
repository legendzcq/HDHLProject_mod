//
//  CityListRequest.m
//  Carte
//
//  Created by ligh on 15-1-8.
//
//

#import "CityListRequest.h"

@implementation CityListRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=cityList&"];
    
}


- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
    
    if (self.isSuccess) {
        
        NSArray *cityJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *cityArray = [NSMutableArray array];
        for (id dic in cityJSONArray)
        {
            CityModel *cityModel = (CityModel*)[CityModel  reflectObjectsWithJsonObject:dic];
            [cityArray addObject:cityModel];
        }
        
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:cityArray forKey:KRequestResultDataKey];
    }
}

@end
