//
//  AccountHelper.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "AccountHelper.h"

@implementation AccountHelper

+ (BOOL)isLogin {
    return [self userInfo] != nil && ![NSString isBlankString:[self uid]];
}

+ (UserModel *)userInfo {
    return (UserModel *)[[DataCacheManager sharedManager] getCachedObjectByKey:Store_UserInfoKey];
}

+ (NSString *)uid {
    NSString *uid = [[self userInfo] user_id];
    if ([NSString isBlankString:uid]) {
        return @"";
    }
    return uid;
}

+ (void)saveUserInfo:(UserModel *)userInfoModel {
    [[DataCacheManager sharedManager] addObject:userInfoModel forKey:Store_UserInfoKey];
}

+ (void)logout {
    [[DataCacheManager sharedManager] removeObjectInCacheByKey:Store_UserInfoKey];
}

//DeviceToken
+ (void)saveDeviceToken:(NSString *)token {
    [[DataCacheManager sharedManager] addObject:token forKey:KDeviceTokenKey];
}

+ (NSString *)getDeviceToken {
    NSString *deviceToken;
    NSObject *deviceToken_Object = [[DataCacheManager sharedManager] getCachedObjectByKey:KDeviceTokenKey];
    if ([deviceToken_Object isKindOfClass:[NSString class]]) {
        deviceToken = [NSString stringWithFormat:@"%@",deviceToken_Object];
    }
    if ([NSString isBlankString:deviceToken]) {
        deviceToken = @"";
    }
    return deviceToken;
}

//单点登录唯一识别字段
+ (void)saveLoginTypeCode {
    NSTimeInterval timeDate=[[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeDate];
    [[DataCacheManager sharedManager] addObject:timeString forKey:kLoginTypeCodeKey];
}

+ (NSString *)getLoginTypeCode {
    NSString *loginTime;
    NSObject *loginTimeObject = [[DataCacheManager sharedManager] getCachedObjectByKey:kLoginTypeCodeKey];
    if ([loginTimeObject isKindOfClass:[NSString class]]) {
        loginTime = [NSString stringWithFormat:@"%@",loginTimeObject];
    }
    if ([NSString isBlankString:loginTime]) {
        loginTime = @"";
    }
    return loginTime;
}

@end
