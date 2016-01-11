//
//  ShareViewManager.m
//  HDHLProject
//
//  Created by Mac on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ShareViewManager.h"
#import "ShareView.h"
@interface ShareViewManager () <WeiboSDKDelegate, TencentApiInterfaceDelegate> {
    
}
@end

@implementation ShareViewManager

DEF_SINGLETON (ShareViewManager)

- (void)dealloc {
    
}

#pragma mark -
#pragma mark - RegisterSinaApp

//注册新浪微博
+ (BOOL)registerSinaApp {
    //    [WeiboSDK enableDebugMode:YES];
    return [WeiboSDK registerApp:SinaAppKey];
}

//注册QQ
+ (id)registerQQApp {
    return  [TencentOpenApiManager registerApp:QQAppKey];
}

//注册微信
+ (BOOL)registerWeChatApp {
    return [WXApi registerApp:WXAppId];
}


#pragma mark -
#pragma mark - HandleOpenURL

//新浪微博
- (BOOL)handleOpenURLSina:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

//QQ
- (BOOL)handleOpenURLTencentQQ:(NSURL *)url {
    return [[TencentOpenApiManager shareManager] handleOpenURL:url];
}

//微信
- (BOOL)handleOpenURLWeChat:(NSURL *)url {
    return [[WXApiManager shareManager] handleOpenURL:url];
}

//腾讯微博
- (BOOL)handleOpenURLTencentWb:(NSURL *)url {
    return [[TencentWeiboApiManager shareManager] handleOpenURL:url];
}

#pragma mark -
#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (response.statusCode == 0) {
            [BDKNotifyHUD showSmileyHUDWithText:@"已分享到新浪微博"];
             ShareView *shareView=[[ShareView alloc]init] ;
            [shareView sendActivityShareWithShareType:ShareChannelTypeSinaWB];
        } else {
            [BDKNotifyHUD showCryingHUDWithText:@"分享失败"];
        }
    }
}

@end












