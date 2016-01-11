//
//  WXApiManager.h
//  Carte
//
//  Created by ligh on 15-4-27.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

typedef NS_ENUM(NSInteger, WXApiType)
{
    WXApiTypeSceneTimeline  = 1,//微信朋友圈
    WXApiTypeWXSceneSession = 2,//微信好友
};

//处理结果
typedef void(^WXApiManagerSuccessBlock)(BOOL);
typedef void(^WXApiManagerFailureBlock)(BOOL);

@interface WXApiManager : NSObject

@property (copy,nonatomic) WXApiManagerSuccessBlock successBlock;
@property (copy,nonatomic) WXApiManagerFailureBlock failureBlock;

+ (id)shareManager;

//微信支付
- (void)wxPayForProduct:(NSDictionary *)product successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock;

//微信分享
- (void)wxShareForMessage:(WXApiType)wxApiType content:(NSString *)content successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock;

//处理微信回调
- (BOOL)handleOpenURL:(NSURL *)url;

@end
