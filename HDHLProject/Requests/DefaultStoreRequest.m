//
//  DefaultStoreRequest.m
//  Carte
//
//  Created by ligh on 15-1-15.
//
//

#import "DefaultStoreRequest.h"

@implementation DefaultStoreRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=storeDefault&"];
    
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}


- (void)processResult
{
    [super processResult];
    
//    LOG(@"======%@======DefaultStoreRequest\n%@",self.resultDic[@"msg"],self.resultDic);
    
}

@end
