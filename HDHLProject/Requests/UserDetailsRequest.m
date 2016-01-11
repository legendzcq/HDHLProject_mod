//
//  UserDetailsRequest.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "UserDetailsRequest.h"

@implementation UserDetailsRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=memberInfo&"];
    
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
