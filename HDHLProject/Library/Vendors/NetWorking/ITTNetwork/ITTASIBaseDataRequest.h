//
//  ASIBaseDataRequest.h
//  hupan
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTRequestResult.h"
#import "ASIFormDataRequest.h"
#import "ITTBaseDataRequest.h"

#define KRequestResultDataKey @"KRequestResultDataKey"


/**
 * NOTE:BaseDataRequest will handle it`s own retain/release lifecycle management, no need to release it manually
 */
@interface ITTASIBaseDataRequest : ITTBaseDataRequest
{
    ASIFormDataRequest* _request;
}

- (void)requestDidReceiveReponseHeaders:(ASIFormDataRequest*)request;

//取消请求使用默认的 主题
+(void) cancelUseDefaultSubjectRequest;
//使用默认的subject 发生请求
+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
              onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
               onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;


@end
