//
//  ShareViewManager.h
//  HDHLProject
//
//  Created by Mac on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareViewManager : NSObject

+ (ShareViewManager *)sharedInstance;

//新浪微博
+ (BOOL)registerSinaApp;                //注册sinaweibo
- (BOOL)handleOpenURLSina:(NSURL *)url; //处理新浪微博回调

//QQ
+ (id)registerQQApp;                         //注册QQ
- (BOOL)handleOpenURLTencentQQ:(NSURL *)url; //处理QQ回调

//微信
+ (BOOL)registerWeChatApp;                //注册SinaWeibo
- (BOOL)handleOpenURLWeChat:(NSURL *)url; //处理微信回调

//腾讯微博
- (BOOL)handleOpenURLTencentWb:(NSURL *)url; //处理新浪微博回调

@end
