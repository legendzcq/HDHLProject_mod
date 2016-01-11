//
//  WXApiManager.m
//  Carte
//
//  Created by ligh on 15-4-27.
//
//

#import "WXApiManager.h"

#define WXRelease(X) if (X != nil) {X = nil;}

@interface WXApiManager () <WXApiDelegate>
{

}
@end

@implementation WXApiManager

static id instance;
+ (id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

//微信支付
- (void)wxPayForProduct:(NSDictionary *)product successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock
{
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    
    PayReq *request = [[PayReq alloc] init];
    request.openID    = WXAppId;
    request.partnerId = WXPartnerID;
    request.package   = WXPackage;
    request.prepayId  = [self stringForValue:[product objectForKey:@"prepay_id"]];
    request.sign      = [self stringForValue:[product objectForKey:@"sign"]];
    request.timeStamp = [[self stringForValue:[product objectForKey:@"timeStamp"]] intValue];
    request.nonceStr  = [self stringForValue:[product objectForKey:@"nonceStr"]];

    NSString *timeStp = [NSString stringWithFormat:@"%d",request.timeStamp];
    if ([NSString isBlankString:request.prepayId] || [NSString isBlankString:request.sign] || [NSString isBlankString:timeStp] || [NSString isBlankString:request.nonceStr] ) {
        [BDKNotifyHUD showCryingHUDWithText:@"签名认证数据为空，支付失败！"];
        return;
    }
    [WXApi sendReq:request];
}

- (NSString *)stringForValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return ((NSString *)value).nonemptyString;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue].nonemptyString;
    } else {
        return [value description].nonemptyString;
    }
}

//微信分享
- (void)wxShareForMessage:(WXApiType)wxApiType content:(NSString *)content successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock {
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = content;
    if (wxApiType == WXApiTypeSceneTimeline) {
        req.scene = WXSceneTimeline;
    } else if (wxApiType == WXApiTypeWXSceneSession) {
        req.scene = WXSceneSession;
    }
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate

- (void)onResp:(id)resp
{
    NSLog(@"--------WXApiDelegate--------: %d",[(BaseResp *)resp errCode]);

    //微信支付（0成功 -1失败 -2用户取消）
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                _successBlock(YES);
                [BDKNotifyHUD showSmileyHUDWithText:@"支付成功"];
                WXRelease(_successBlock);
                break;
            default:
                _failureBlock(YES);
                if (response.errCode == -2) {
                    [BDKNotifyHUD showCryingHUDWithText:@"用户取消支付"];
                } else {
                    [BDKNotifyHUD showCryingHUDWithText:@"支付失败"];
                }
                WXRelease(_failureBlock);
                break;
        }
    }
    
    //微信分享
    else if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //BaseResp
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                _successBlock(YES);
                [BDKNotifyHUD showSmileyHUDWithText:@"分享成功"];
                WXRelease(_successBlock);
                break;
            case WXErrCodeUserCancel:
                _failureBlock(YES);
                [BDKNotifyHUD showSmileyHUDWithText:@"用户取消分享"];
                WXRelease(_failureBlock);
                break;
            default:
                _failureBlock(YES);
                [BDKNotifyHUD showCryingHUDWithText:@"分享失败"];
                WXRelease(_failureBlock);
                break;
        }
    }
    
    else if ([resp isKindOfClass:[QQBaseResp class]]){
        QQBaseResp *qqResp = resp;
        if (qqResp.result.intValue == 0) {
            [BDKNotifyHUD showSmileyHUDWithText:@"分享成功"];
        }else if (qqResp.result.intValue == -4){
            [BDKNotifyHUD showCryingHUDWithText:@"用户取消分享"];
        }else{
            [BDKNotifyHUD showCryingHUDWithText:@"分享失败"];
        }
    }
}

- (void)onReq:(BaseReq *)req
{
    
}

#pragma mark - 微信回调

//处理微信回调
- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

@end
