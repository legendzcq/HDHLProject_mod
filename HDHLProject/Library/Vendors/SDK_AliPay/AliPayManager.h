//
//  AliPayManager.h
//  Carte
//
//  Created by ligh on 14-4-17.
//
//

#import <Foundation/Foundation.h>

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

//支付结果
typedef void(^AliPayManagerPayStatusBlock)(BOOL);


@interface Product : NSObject {
@private
    float _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *orderId;

@end

@interface AliPayManager : NSObject {
    
}

@property (copy,nonatomic) AliPayManagerPayStatusBlock statusBlock;

+ (id)shareManager;

- (void)handleHomeBack;

//支付
- (void)payForProduct:(Product *)product completion:(AliPayManagerPayStatusBlock)completionBlock;
//处理支付宝
- (BOOL)handleOpenURL:(NSURL *)url;

@end
