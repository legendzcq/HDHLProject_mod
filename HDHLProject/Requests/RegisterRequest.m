//
//  RegisterRequest.m
//  Carte
//
//  Created by user on 14-4-29.
//
//

#import "RegisterRequest.h"
#import "UserModel.h"

@implementation RegisterRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=register&"];
    
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
 
    if ([self isSuccess]) {
        UserModel *userModel = (UserModel*)[UserModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
        [self.resultDic setObject:userModel forKey:KRequestResultDataKey];
        [self.resultDic removeObjectForKey:@"data"];
    }
}


@end
