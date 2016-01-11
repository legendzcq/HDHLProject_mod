//
//  LoginRequest.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "LoginRequest.h"
#import "UserModel.h"

@implementation LoginRequest

- (NSString *)getRequestUrl {
    return [NSString stringWithFormat:@"api.php?apiUrl=login&"];
}

- (void)processResult {
    [super processResult];
    if ([self isSuccess]) {
        UserModel *userModel = (UserModel*)[UserModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
        [self.resultDic setObject:userModel forKey:KRequestResultDataKey];
        [self.resultDic removeObjectForKey:@"data"];
    }
}

@end
