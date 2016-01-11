//
//  TencentWeiboApiManager.h
//  Carte
//
//  Created by ligh on 14-4-21.
//
//

#import <Foundation/Foundation.h>

/**
 *  腾讯微博API调用管理者
 */

//处理结果
typedef void(^TencentWbSuccessBlock)(BOOL);
typedef void(^TencentWbFailureBlock)(BOOL);

@interface TencentWeiboApiManager : WeiboApi

@property (copy, nonatomic) TencentWbSuccessBlock successBlock;
@property (copy, nonatomic) TencentWbFailureBlock failureBlock;

+ (id)shareManager;

//腾讯微博分享
- (void)tencentWbShareWithContent:(NSString *)content successCompletion:(TencentWbSuccessBlock) sucBlock failureCompletion:(TencentWbFailureBlock)faiBlock;

//处理腾讯微博回调
- (BOOL)handleOpenURL:(NSURL *)url;

@end
