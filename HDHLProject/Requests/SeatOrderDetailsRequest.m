   //
//  SeatOrderDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "SeatOrderDetailsRequest.h"
#import "SeatOrderModel.h"

@implementation SeatOrderDetailsRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=showOrder&"];
    
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
 
    if (self.isSuccess)
    {
        SeatOrderModel *seatOrderModel = [[SeatOrderModel alloc] initWithDictionary:self.resultDic[@"data"]];
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:seatOrderModel forKey:KRequestResultDataKey];
    }
}

@end
