//
//  AliPayManager.m
//  Carte
//
//  Created by ligh on 14-4-17.
//
//

#import "AliPayManager.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;
@end

@implementation AliPayManager

@synthesize statusBlock = _statusBlock;

static id instance;
+ (id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)payForProduct:(Product *)product completion:(AliPayManagerPayStatusBlock)completionBlock {
    /*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */

    _statusBlock = nil;
    
    if (completionBlock) {
        _statusBlock  = [completionBlock copy];
    }
    NSString *appScheme = [ConfigHelper appScheme];
    NSString* orderSpec = [self getOrderInfo:product];

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [self handePayResult:resultDic];
        }];
    }
}

- (NSString*)getOrderInfo:(Product *)product {
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    order.tradeNO = product.orderId; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    
    //TODO:价格
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@/api.php/payment/alipay/notifyurl", Host_Url]; //回调URL
    
    return [order description];
}

- (void)handleHomeBack {
    if (!_statusBlock) {
        return;
    }
    [self handePayResult:nil];
}

- (void)handePayResult:(NSDictionary *)payResult {
    NSInteger statusCode = [payResult[@"resultStatus"] integerValue];
    if (statusCode == 9000) {
        if(_statusBlock)
        _statusBlock(YES);
        [BDKNotifyHUD showSmileyHUDWithText:@"支付成功"];
        _statusBlock = nil;
    } else {
        //交易失败
        if(_statusBlock)
        _statusBlock(YES);
        [BDKNotifyHUD showCryingHUDWithText:@"支付失败"];
        _statusBlock = nil;
    }
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handePayResult:resultDic];
        }];
        return YES;
    }
    return YES;
}

@end
