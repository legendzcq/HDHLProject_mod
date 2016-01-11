//
//  TencentOpenApiManager.h
//  HDHLProject
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//处理结果
typedef void(^TencentQQSuccessBlock)(BOOL);
typedef void(^TencentQQFailureBlock)(BOOL);

@interface TencentOpenApiManager : NSObject

@property (copy, nonatomic) TencentQQSuccessBlock successBlock;
@property (copy, nonatomic) TencentQQFailureBlock failureBlock;

+ (id)shareManager;

//注册QQ
+ (id)registerApp:(NSString *)appId;

//腾讯QQ分享
- (void)tencentQQShareWithContent:(NSString *)content successCompletion:(TencentQQSuccessBlock) sucBlock failureCompletion:(TencentQQFailureBlock)faiBlock;

//处理腾讯QQ回调
- (BOOL)handleOpenURL:(NSURL *)url;

@end
