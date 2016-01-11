//
//  BookSeatInitRequest.m
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import "BookSeatInitRequest.h"

@implementation BookSeatInitRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=initOrder&"];
}


-(void)processResult
{
    [super processResult];
    
//    NSLog(@"====================BookSeatInitRequest\n%@",self.resultDic);
    
    if (self.isSuccess)
    {
        
        NSArray *dateJSONArray = self.resultDic[@"data"][@"date"];
        NSMutableArray *dateArray = [NSMutableArray array];
        for (id dateJSONDic in dateJSONArray)
        {
            PayInfoDateModel *dateModel = [[PayInfoDateModel alloc] initWithDictionary:dateJSONDic];
            [dateArray addObject:dateModel];
        }
        
        [self.resultDic setObject:dateArray forKey:KTakeOrderDateResultRequest];
        
        //就餐人数
        NSArray *perArray = self.resultDic[@"data"][@"max_per"];
        [self.resultDic setObject:perArray forKey:KTakeOrderMaxPerResultRequest];
        //座位类型
        NSArray *seatJSONArray = self.resultDic[@"data"][@"seats"];
        NSArray *seatArray = [NSArray array];
        seatArray = [SeatModel reflectObjectsWithArrayOfDictionaries:seatJSONArray];
        [self.resultDic setObject:seatArray forKey:KTakeOrderSeatsModelResultRequest];
        //        [self.resultDic removeObjectForKey:@"data"];
        
    }
}

@end
