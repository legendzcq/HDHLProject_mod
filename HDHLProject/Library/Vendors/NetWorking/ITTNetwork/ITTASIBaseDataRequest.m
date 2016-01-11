//
//  ASIBaseDataRequest.m
//  hupan
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTASIBaseDataRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "CommonUtils.h"
#import "ITTNetworkTrafficManager.h"

@class AllBrandDataRequest;

@interface ITTASIBaseDataRequest()
- (void)cancelRequest;
- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params;
@end

@implementation ITTASIBaseDataRequest
#pragma mark -
#pragma mark private method
- (void)cancelRequest{
    [_request cancel];
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidCancelLoad:)]){
            [self.delegate requestDidCancelLoad:self];
        }
    }else {
        if (_onRequestCanceled) {
            _onRequestCanceled(self);
        }
    }
    ITTDINFO(@"cancelling request");
}


//取消网络请求
+(void)cancelUseDefaultSubjectRequest
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass(self) object:nil];
}

+(void)requestWithParameters:(NSDictionary *)params withIndicatorView:(UIView *)indiView onRequestFinished:(void (^)(ITTBaseDataRequest *))onFinishedBlock onRequestFailed:(void (^)(ITTBaseDataRequest *))onFailedBlock
{
    [self requestWithParameters:params withIndicatorView:indiView onRequestStart:nil onRequestFinished:onFinishedBlock onRequestCanceled:nil onRequestFailed:onFailedBlock];
}

+(void)requestWithParameters:(NSDictionary *)params withIndicatorView:(UIView *)indiView onRequestStart:(void (^)(ITTBaseDataRequest *))onStartBlock onRequestFinished:(void (^)(ITTBaseDataRequest *))onFinishedBlock onRequestCanceled:(void (^)(ITTBaseDataRequest *))onCanceledBlock onRequestFailed:(void (^)(ITTBaseDataRequest *))onFailedBlock
{
    NSString *subject = NSStringFromClass([self class]);
    if(![subject isEqualToString:@"MyDishCardsRequest"]){
    [self cancelUseDefaultSubjectRequest];
    }
    [self requestWithParameters:params withIndicatorView:indiView withCancelSubject:subject onRequestStart:onStartBlock onRequestFinished:onFinishedBlock onRequestCanceled:onCanceledBlock onRequestFailed:onFinishedBlock];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params{
    url = [NSString stringWithFormat:@"%@e=ios&apiVersion=%@&login_time=%@&",url,ApiVersion,LoginType_Code];
	// process params
	NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
	[allParams addEntriesFromDictionary: params];
	NSDictionary *staticParams = [self getStaticParams];
	if (staticParams != nil) {
		[allParams addEntriesFromDictionary:staticParams];
	}
    
    // used to monitor network traffic , this is not accurate number.
    long long postBodySize = 0; 
    
	if ([self getRequestMethod] == ITTRequestMethodGet){
        NSString *paramString = @"";
		if (allParams) {
			NSArray *allKeys = [allParams allKeys];
			NSInteger count = [allKeys count];
			NSString *value = nil;
			for (NSUInteger i=0; i<count; i++) {
				id key = allKeys[i];
				value = (NSString *)allParams[key];
				value = [self encodeURL:value];
				paramString = [paramString stringByAppendingString:(i == 0)?@"":@"&"];
				paramString = [paramString stringByAppendingFormat:@"%@=%@",key,value];
			}
		}
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,paramString];
        NSURL *nsUrl = [[NSURL alloc] initWithString:urlStr];
        _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
        RELEASE_SAFELY(nsUrl);
        
        postBodySize += [urlStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [_request setRequestMethod:@"GET"];
    }else{
        postBodySize += [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *nsUrl = [[NSURL alloc] initWithString:url];
        _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
        RELEASE_SAFELY(nsUrl);
        [_request setRequestMethod:@"POST"];
        ASIPostFormat postFormat = ASIURLEncodedPostFormat;
        for (NSString *key in [allParams allKeys]) {
            if ([allParams[key] isKindOfClass:[NSData class]]) {
                postFormat = ASIMultipartFormDataPostFormat;
                NSData* data = (NSData*)allParams[key];
                [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:key];
                postBodySize += [data length];
            }else if ([allParams[key] isKindOfClass:[UIImage class]]) {
                postFormat = ASIMultipartFormDataPostFormat;
                UIImage* image = allParams[key];
                NSData* data = UIImageJPEGRepresentation(image, 0.8);
                [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:key];
                postBodySize += [data length];
            }else{
                [_request addPostValue:allParams[key] forKey:key];
                postBodySize += [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                postBodySize += [allParams[key] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            }
            
        }
        _request.postFormat = postFormat;
    }
    _request.delegate = self;
    _request.defaultResponseEncoding = [self getResponseEncoding];
    _request.timeOutSeconds = 120;
    _request.allowCompressedResponse = YES;
    _request.shouldCompressRequestBody = NO;
    
    if (_filePath && [_filePath length] > 0) {
        //create folder
        NSUInteger pathLength = [_filePath length];
        NSUInteger fileLength = [[_filePath lastPathComponent] length];
        NSString *directoryPath = [_filePath substringToIndex:(pathLength - fileLength - 1)];
        [CommonUtils createDirectorysAtPath:directoryPath];
        
        _request.downloadProgressDelegate = self;
        _request.downloadDestinationPath = _filePath;
        _request.didReceiveResponseHeadersSelector = @selector(requestDidReceiveReponseHeaders:);
        _request.showAccurateProgress = YES;
    }
    
    [[ITTNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
}

- (void)doRequestWithParams:(NSDictionary*)params{
  
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    
    [_request startAsynchronous];
    ITTDINFO(@"request %@ is created, URL is: %@", [self class], [_request url]);
}

- (void)dealloc {	
    RELEASE_SAFELY(_request);
    [super dealloc];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // return yes to finish this request, return no to continue request from server
    ITTDINFO(@"using cache data for request:%@", [self class]);
    if (!cacheData) {
        return NO;
    }
    if ([cacheData isKindOfClass:[NSDictionary class]]) {
        self.resultDic = (NSMutableDictionary *)cacheData;
        self.result = [[[ITTRequestResult alloc] initWithCode:(self.resultDic)[@"result"] 
                                             withMessage:@""] autorelease];
        
        if (self.delegate) {
            if([self.delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
                [self.delegate requestDidFinishLoad:self];
            }
        }else {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(self);
            }
        }
        return YES;
    }else{
        ITTDINFO(@"request:[%@],cache data should be handled by subclass", [self class]);
        return NO;
    }
}
#pragma mark - request delegate method

- (void)requestDidReceiveReponseHeaders:(ASIFormDataRequest*)request{
    //do something
    if ([request responseHeaders][@"Content-Length"]) {
        _totalData = [(NSString*)[request responseHeaders][@"Content-Length"] longLongValue];
        ITTDINFO(@"total size of zip file:%lld", _totalData);
    }
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)newLength{
    if (newLength < 0) {
        newLength = 0;
    }
    _downloadedData += newLength;
    float newProgress = 1.0*_downloadedData/_totalData;
    
    if (_currentProgress < newProgress) {
        _currentProgress = newProgress;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(request:progressChanged:)]) {
                [self.delegate request:self progressChanged:_currentProgress];
            }
        }else{
            //using block
            if (_onRequestProgressChangedBlock) {
                _onRequestProgressChangedBlock(self,_currentProgress);
            }
        }
    }
    
}

- (void)requestStarted:(ASIFormDataRequest*)request {
	[self showIndicator:YES];
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
            [self.delegate requestDidStartLoad:self];
        }
    }else{
        if (_onRequestStartBlock) {
            _onRequestStartBlock(self);
        }
    }
}

- (void)requestFinished:(ASIFormDataRequest*)request {
    [[ITTNetworkTrafficManager sharedManager] logTrafficIn:request.totalBytesRead];
    [self showIndicator:NO];
	NSString *responseString;
    if (request.allowCompressedResponse) {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:[self getResponseEncoding]];
    }else{
        responseString = [[NSString alloc] initWithData:[request rawResponseData] encoding:[self getResponseEncoding]];
    }
    
	[self handleResultString:responseString];
    RELEASE_SAFELY(responseString);
    [self doRelease];
}

- (void)requestFailed:(ASIFormDataRequest*)request {
	[self showIndicator:NO];
	ITTDERROR(@"http request error:\n request:%@\n error:%@",[request.url absoluteString],request.error);
	if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
		[self.delegate request:self didFailLoadWithError:request.error];
	}
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
            [self.delegate request:self didFailLoadWithError:request.error];
        }
    }else{
        if (_onRequestFailedBlock) {
            _onRequestFailedBlock(self,request.error);
        }
    }
	
	if (request.error.domain == NetworkRequestErrorDomain) {
		NSString *errorMsg = nil;
		switch ([request.error code]) {
			case ASIConnectionFailureErrorType:
				errorMsg = @"无法连接到网络";
				break;
			case ASIRequestTimedOutErrorType:
				errorMsg = @"访问超时";
				break;
			case ASIAuthenticationErrorType:
				errorMsg = @"服务器身份验证失败";
				break;
			case ASIRequestCancelledErrorType:
				//errorMsg = @"request is cancelled";
				errorMsg = @"服务器请求已取消";
				break;
			case ASIUnableToCreateRequestErrorType:
				//errorMsg = @"ASIUnableToCreateRequestErrorType";
				errorMsg = @"无法创建服务器请求";
				break;
			case ASIInternalErrorWhileBuildingRequestType:
				//errorMsg = @"ASIInternalErrorWhileBuildingRequestType";
				errorMsg = @"服务器请求创建异常";
				break;
			case ASIInternalErrorWhileApplyingCredentialsType:
				//errorMsg = @"ASIInternalErrorWhileApplyingCredentialsType";
				errorMsg = @"服务器请求异常";
				break;
			case ASIFileManagementError:
				//errorMsg = @"ASIFileManagementError";
				errorMsg = @"服务器请求异常";
				break;
			case ASIUnhandledExceptionError:
				//errorMsg = @"ASIUnhandledExceptionError";
				errorMsg = @"未知请求异常异常";
				break;
			default:
				errorMsg = @"服务器故障或网络链接失败！";
				break;
		}
        if ([request.error code] != ASIRequestCancelledErrorType) {
            ITTDERROR(@"error detail:%@\n",request.error.userInfo);
            ITTDERROR(@"error code:%ld",[request.error code]);
            if (!_useSilentAlert) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errorMsg 
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
	}
    [self doRelease];
}



@end
