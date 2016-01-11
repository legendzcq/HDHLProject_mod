//
//  OptionalBrandRequest.m
//  Carte
//
//  Created by liu on 15-4-21.
//
//

#import "OptionalBrandRequest.h"
#import "BrandModel.h"

@implementation OptionalBrandRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=listBrand&"];
}
-(void)processResult
{
    
    [super processResult];
    
    //    LOG(@"=================%@",self.resultDic);
    
    if (self.isSuccess)
    {
        //解析出订座订单列表
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *seatOrderJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *seatOrderArray = [NSMutableArray array];
        for (id dic in seatOrderJSONArray)
        {
            BrandModel *brandModel = [[BrandModel alloc] initWithDictionary:dic];
            [seatOrderArray addObject:brandModel];
        }
        pageModel.listArray = seatOrderArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end
