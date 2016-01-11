//
//  MyVoucherDetailRequest.m
//  Carte
//
//  Created by hdcai on 15/4/22.
//
//

#import "MyVoucherDetailRequest.h"
#import "VoucherModel.h"
#import "TakeoutAddressModel.h"

@implementation MyVoucherDetailRequest
- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=showCoupon&"];
}


-(void)processResult
{
    
    [super processResult];
    
    if (self.isSuccess)
    {
        VoucherModel *voucherMdoel = [[VoucherModel alloc] initWithDictionary:self.resultDic[@"data"]];
        [self.resultDic setObject:voucherMdoel forKey:KRequestResultDataKey];
        TakeoutAddressModel * takeoutAddressModel = [[TakeoutAddressModel alloc]initWithDictionary:self.resultDic[@"data"][@"default_address"]];
//        [self.resultDic setObject:takeoutAddressModel forKey:KTakeOrderOutResultRequest];
        [self.resultDic removeObjectForKey:@"data"];
                
    }
}

@end
