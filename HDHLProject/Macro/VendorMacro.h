//
//  VendorMacro.h
//  MinFramework
//  第三方常量
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_VendorMacro_h
#define MinFramework_VendorMacro_h

//友盟信息
#define UMENG_APPKEY     @"5590a7f867e58ea3b000239a"
#define UMENG_CHANNEL_ID @"App Store" //默认渠道
//#import "MobClick.h" //友盟统计
#import "UMessage.h" //友盟推送
#import "UMManager.h"

//微信
#define WXAppId         @"wx1bda22ad6a430a90"
#define WXPartnerID     @"1240542002" /** 商家向财付通申请的商家id */
#define WXPackage       @"Sign=WXPay"   /** 商家根据财付通文档填写的数据和签名 */
#define WXPartnerSecret @"af9d8e495ab6af2b25244bb7f50b274a" //商户API密钥
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"

//新浪微博相关
#define SinaAppKey        @"3188751613"
#define SinaRedirectURI   @"http://www.hdcai.com"
#import "WeiboSDK.h"

//TencentQQ
#define QQAppKey      @"801498891"
#define QQAppSecret   @"43bd43dcbdc7836fafea93b9081d5aa4"
#define QQRedirectURI @"http://www.hdcai.com"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "TencentOpenApiManager.h"

//TencentWB
#import "WeiboApi.h"
#import "WeiboApiObject.h"
#import "TencentWeiboApiManager.h"

//百度地图
#define BMKAppAK @"W8t2s5b3cbSB3kzBlDNxovPE"
#import <BaiduMapAPI/BMapKit.h>
#import "BMKLocationManager.h"

//支付宝
#import "AliPayManager.h"

//银联支付
#import "UPPayPluginManager.h"

#endif
