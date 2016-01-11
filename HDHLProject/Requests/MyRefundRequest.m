//
//  MyRefundRequest.m
//  HDHLProject
//
//  Created by hdcai on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyRefundRequest.h"
#import "MyRefundModel.h"

@implementation MyRefundRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberRefundList&"];
}


-(void)processResult
{
    
    [super processResult];
    
    //    LOG(@"=================\n%@%@\n",self.resultDic[@"msg"],self.resultDic);order_sn,amount_status_msg,amount_status_text
    
    if (self.isSuccess)
    {
        
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *storeJSONArray = self.resultDic[@"data"][@"list"];
        pageModel.listArray = [MyRefundModel reflectObjectsWithArrayOfDictionaries:storeJSONArray];
        
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}


@end
