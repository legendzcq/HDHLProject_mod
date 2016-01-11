//
//  TencentOpenApiManager.m
//  HDHLProject
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TencentOpenApiManager.h"

#define QQRelease(X) if (X != nil) {X = nil;}

@interface TencentOpenApiManager () <TencentApiInterfaceDelegate, TencentSessionDelegate, QQApiInterfaceDelegate> {

}
@end

@implementation TencentOpenApiManager

static id instance;
+ (id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([TencentOAuth HandleOpenURL:url]) {
        return YES;
    } else if ([TencentApiInterface canOpenURL:url delegate:self]) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

+ (id)registerApp:(NSString *)appId {
    return [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
}

//腾讯QQ分享
- (void)tencentQQShareWithContent:(NSString *)content successCompletion:(TencentQQSuccessBlock) sucBlock failureCompletion:(TencentQQFailureBlock)faiBlock {
    QQRelease(_successBlock);
    QQRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:content];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode code = [QQApiInterface sendReq:req];
    [self handleQQSendResult:code];
}

- (void)handleQQSendResult:(QQApiSendResultCode)sendResult {
    switch (sendResult) {
        case EQQAPIQQNOTINSTALLED: {
            [BDKNotifyHUD showCryingHUDWithText:@"尚未安装手机QQ客户端"];
            break;
        } default: {
            [BDKNotifyHUD showCryingHUDWithText:@"发送失败"];
            break;
        }
    }
}

#pragma mark -
#pragma mark - TencentApiInterfaceDelegate

- (BOOL)onTencentReq:(TencentApiReq *)req {
    return YES;
}

- (BOOL)onTencentResp:(TencentApiResp *)resp {
    return YES;
}

#pragma mark -
#pragma mark - QQApiInterfaceDelegate

- (void)onResp:(QQBaseResp *)resp {
    QQBaseResp *qqResp = resp;
    if (qqResp.result.intValue == 0) {
        _successBlock(YES);
        [BDKNotifyHUD showSmileyHUDWithText:@"已经分享到QQ"];
    } else if (qqResp.result.intValue == -4){
        _failureBlock(YES);
        [BDKNotifyHUD showCryingHUDWithText:@"分享取消"];
    } else {
        _failureBlock(YES);
        [BDKNotifyHUD showSmileyHUDWithText:@"分享失败"];
    }
}

- (void)onReq:(QQBaseReq *)req {

}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)tencentDidLogin {
    
}

#pragma mark -
#pragma mark - TencentSessionDelegate

- (void)tencentDidLogout {
    
}

#pragma mark -
#pragma mark - TencentLoginDelegate

/**
 * 登录失败后的回调
 * param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

@end
