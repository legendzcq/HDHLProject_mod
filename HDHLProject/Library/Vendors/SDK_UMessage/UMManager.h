//
//  UMManager.h
//  HDHLProject
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMManager : NSObject

+ (id)shareManager;

/*
 *友盟初始化
 *在方法里实现：application:didFinishLaunchingWithOptions:
 */
+ (void)setUMessageLaunchingWithOptions:(NSDictionary *)launchOptions;

/*
 *获取token值
 *在方法里实现：application:didRegisterForRemoteNotificationsWithDeviceToken:
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (NSString *)retureDeviceToken:(NSData *)deviceToken;

/*
 *推送内容
 *在方法里实现：application:didReceiveRemoteNotification:
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/*
 *处理推送消息
 *在方法里实现：application:didFinishLaunchingWithOptions:
 */
- (void)handleRemoteNotificaiton:(NSDictionary *)launchOptions;
- (void)isWakeValue:(BOOL)value;

//推送功能未开启
+ (void)didFailToRegisterForRemoteNotifications;

/**
 *  处理从短信或者浏览器打开应用
 *  @param url 地址
 */
+ (void)handleRemoteOpenURL:(NSURL *)url;

@end
