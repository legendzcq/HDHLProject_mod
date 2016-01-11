//
//  AccountHelper.h
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "AccountStatusObserverManager.h"

/**
 *  账户信息助手类
 */
#define User_Id [AccountHelper uid]
#define LoginType_Code [AccountHelper getLoginTypeCode] //单点登录标识字段

@interface AccountHelper : NSObject

//是否登录
+ (BOOL)isLogin;
//保存登录用户信息
+ (void)saveUserInfo:(UserModel *)userInfoModel;

//登录的用户信息
+ (UserModel *)userInfo;
+ (NSString *)uid;

//注销
+ (void)logout;

//DeviceToken
+ (void)saveDeviceToken:(NSString *)token;
+ (NSString *)getDeviceToken;

//单点登录唯一识别字段
+ (void)saveLoginTypeCode;
+ (NSString *)getLoginTypeCode;

@end
