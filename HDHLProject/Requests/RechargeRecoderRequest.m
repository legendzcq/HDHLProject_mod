//
//  RechargeRecoderRequest.m
//  Carte
//
//  Created by ligh on 15-1-7.
//
//

#import "RechargeRecoderRequest.h"

@implementation RechargeRecoderRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"/api.php?apiUrl=transferLog&"];
}


- (void)processResult
{
    [super processResult];
    PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
    NSArray *recoderJSONArray = self.resultDic[@"data"][@"list"];
    pageModel.listArray = [RechargeRecoderModel reflectObjectsWithArrayOfDictionaries:recoderJSONArray];
    [self.resultDic removeObjectForKey:@"data"];
    [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
}

@end
