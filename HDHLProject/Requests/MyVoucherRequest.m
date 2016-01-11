//
//  MyVoucherRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "MyVoucherRequest.h"


@implementation MyVoucherRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberCoupons&"];
}


-(void)processResult
{
    
    [super processResult];

    if (self.isSuccess)
    {
        //解析优惠券列表
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *storeJSONArray = self.resultDic[@"data"][@"list"];
        pageModel.listArray = [VoucherModel reflectObjectsWithArrayOfDictionaries:storeJSONArray];
        
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end







