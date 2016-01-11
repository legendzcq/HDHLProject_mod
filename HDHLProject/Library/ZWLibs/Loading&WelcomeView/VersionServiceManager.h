//
//  VersionServiceManager.h
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingViewController.h"
#import "WelcomeViewController.h"

@interface VersionServiceManager : NSObject

typedef void (^VersionCheckSuccessCallback)(BOOL ishasNew,NSDictionary *dict);
typedef void (^VersionCheckFaildCallback)(NSString *reason);

AS_SINGLETON (VersionServiceManager)

//是否是第一次运行
- (BOOL)isFirstRunning;
//检测是否有新版本
- (void)isHasNewVersion:(BOOL)showNoNewVersionsMessage;
- (void)isHasNewVersionForeUpate; //强制更新

@end
