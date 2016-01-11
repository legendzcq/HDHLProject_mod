//
//  MeHOmeInfoRequest.m
//  Carte
//
//  Created by zln on 15/1/12.
//
//

#import "MeHOmeInfoRequest.h"

@implementation MeHOmeInfoRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberHome&"];
    
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}


- (void)processResult
{
    [super processResult];
    
    if ([self isSuccess])
    {
        UserModel *userModel = (UserModel*)[UserModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
        [self.resultDic setObject:userModel forKey:KRequestResultDataKey];
    }
}

@end
