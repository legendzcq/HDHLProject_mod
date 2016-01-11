//
//  StoreDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-5-6.
//
//

#import "StoreDetailsRequest.h"
#import "TakeoutAddressModel.h"

@implementation StoreDetailsRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=storeHome&"];
}


-(void)processResult
{
    [super processResult];

    
    if (self.isSuccess)
    {
    
        StoreModel *storeMdoel = [[StoreModel alloc]initWithDictionary:self.resultDic[@"data"]];
        [self.resultDic setObject:storeMdoel forKey:KRequestResultDataKey];
    }
    
}

@end
