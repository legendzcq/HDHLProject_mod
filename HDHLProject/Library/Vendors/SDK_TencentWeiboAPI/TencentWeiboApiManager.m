//
//  TencentWeiboApiManager.m
//  Carte
//
//  Created by ligh on 14-4-21.
//
//

#import "TencentWeiboApiManager.h"
#import "WeiboApi.h"
#import "WeiboApiObject.h"

#define WBRelease(X) if (X != nil) {X = nil;}

@interface TencentWeiboApiManager () <WeiboRequestDelegate,WeiboAuthDelegate,TencentSessionDelegate> {
    NSString *_shareContent;
}
@end

@implementation TencentWeiboApiManager

static id instance;
+ (id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithAppKey:QQAppKey andSecret:QQAppSecret andRedirectUri:QQRedirectURI andAuthModeFlag:0 andCachePolicy:0] ;
    });
    return instance;
}

//腾讯微博分享
- (void)tencentWbShareWithContent:(NSString *)content successCompletion:(TencentWbSuccessBlock) sucBlock failureCompletion:(TencentWbFailureBlock)faiBlock {
    WBRelease(_successBlock);
    WBRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    _shareContent = content;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self loginWithDelegate:self andRootController:window.rootViewController];
    [self checkAuthValid:TCWBAuthCheckServer andDelegete:self];
}

- (void)shareContentWithTencentClient {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json", @"format", _shareContent, @"content", nil];
    [self requestWithParams:params apiName:@"t/add" httpMethod:@"POST" delegate:self];
}

//处理腾讯微博回调
- (BOOL)handleOpenURL:(NSURL *)url {
    return [[[WeiboApi alloc] init] handleOpenURL:url];
}

#pragma mark -
#pragma mark - delegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _successBlock(YES);
        [BDKNotifyHUD showSmileyHUDWithText:@"分享成功"];
    });
}

/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _failureBlock(YES);
        [BDKNotifyHUD showCryingHUDWithText:@"分享失败"];
        
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self shareContentWithTencentClient];
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi
{
    _failureBlock(YES);
    [BDKNotifyHUD showCryingHUDWithText:@"用户取消"];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _failureBlock(YES);
        if (error.code == 101) { //用户取消
            [BDKNotifyHUD showCryingHUDWithText:@"用户取消"];
        } else {
            [BDKNotifyHUD showCryingHUDWithText:@"授权失败,请稍后重试"];
        }
    });
}

- (void)didNeedRelogin:(NSError *)error reqNo:(int)reqno
{
    _failureBlock(YES);
    [BDKNotifyHUD showCryingHUDWithText:@"授权失败,请稍后重试"];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!bResult) {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [self loginWithDelegate:self andRootController:window.rootViewController];
        } else {
            [self shareContentWithTencentClient];
        }
    });
}

@end
