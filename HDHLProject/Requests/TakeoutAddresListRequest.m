//
//  TakeoutAddresListRequest.m
//  Carte
//
//  Created by ligh on 14-5-4.
//
//

#import "TakeoutAddresListRequest.h"


@implementation TakeoutAddresListRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberInfo&"];
}


- (void)processResult {
    [super processResult];
    
    if (self.isSuccess) {
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *addressJSONArray = self.resultDic[@"data"][@"user_address"];
        pageModel.listArray = [TakeoutAddressModel reflectObjectsWithArrayOfDictionaries:addressJSONArray];;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end
