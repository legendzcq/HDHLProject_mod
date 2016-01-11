//
//  UPPayPluginManager.h
//  Carte
//
//  Created by ligh on 15-1-19.
//
//

#import <Foundation/Foundation.h>
#import "UPPayPlugin.h"


#define kResultSuccess @"支付成功"
#define kResultError   @"支付失败"
#define kResultCancel  @"用户取消支付"

typedef void(^UPPaySuccessBlock) (NSString *success);
typedef void(^UPPayFailBlock)    (NSString *error);
typedef void(^UPPayCancelBlock)  (NSString *cancel);


@interface UPPayPluginManager : NSObject

+ (id)shareManager;

- (void)uPPayPluginStartViewController:(UIViewController *)view;
- (void)uPPayPluginStartViewController:(UIViewController *)view uPPayTN:(NSString *)tn successBlock:(UPPaySuccessBlock)success failBlock:(UPPayFailBlock)fail cancelBlock:(UPPayCancelBlock)cancel;

@end
