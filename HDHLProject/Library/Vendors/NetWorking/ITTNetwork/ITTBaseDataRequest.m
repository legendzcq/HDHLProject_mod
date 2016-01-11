//
//  ITTBaseDataRequest.m
//  
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTBaseDataRequest.h"
#import "CJSONDeserializer.h"
#import "DataCacheManager.h"
#import "ITTDataRequestManager.h"
#import "ITTMaskActivityView.h"

@implementation ITTBaseDataRequest

#pragma mark - init methods using delegate

+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:cacheType
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:indiView 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject{
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cacheKey
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath{
    
	return [self initWithDelegate:delegate 
                   withRequestUrl:nil
                   withParameters:params 
                withIndicatorView:indiView 
                withCancelSubject:cancelSubject 
                  withSilentAlert:silent 
                     withCacheKey:cacheKey 
                    withCacheType:cacheType
                     withFilePath:localFilePath];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath{
    
    self = [super init];
	if(self) {
        _requestUrl = [url retain];
        if (!_requestUrl) {
            _requestUrl = [[self getRequestUrl] retain];
        }
		_indicatorView = [indiView retain];
		_isLoading = NO;
		_delegate = [delegate retain];
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = [cache retain];
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = [cancelSubject retain];
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        
        _totalData = NSIntegerMax;
        _downloadedData = 0;
        _currentProgress = 0;
        
        _requestStartTime = [[NSDate date] retain];
        _parameters = [params retain];
        BOOL useCurrentCache = NO;
        if (localFilePath) {
            _filePath = [localFilePath retain];
        }
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            ITTDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
        
	}
	return self;
}

#pragma mark - init methods using delegate



+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}

- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
       withIndicatorView:(UIView*)indiView
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
       onProgressChanged:(void(^)(ITTBaseDataRequest *request,float progress))onProgressChangedBlock{
    
    self = [super init];
	if(self) {
        _requestUrl = [url retain];
        if (!_requestUrl) {
            _requestUrl =  [[NSString stringWithFormat:@"%@/%@",[self getRequestHost],[self getRequestUrl]] retain];
        }
		_indicatorView = [indiView retain];
		_isLoading = NO;
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = [cache retain];
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = [cancelSubject retain];
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (localFilePath) {
            _filePath = [localFilePath retain];
        }
        
        _requestStartTime = [[NSDate date] retain];
        _parameters = [params retain];
        BOOL useCurrentCache = NO;
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            
            
            ITTDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
	}
	return self;
}

#pragma mark - file download related init methods 
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:localFilePath];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
                 withFilePath:(NSString*)localFilePath
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock{
    
	ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:localFilePath
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:onProgressChangedBlock];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    [request release];
}
#pragma mark - life cycle methods 

- (void)doRelease{
    //remove self from Request Manager to release self;
    [[ITTDataRequestManager sharedManager] removeRequest:self];
}
- (void)dealloc {	
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
    [_maskActivityView release];
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
    
    ITTDINFO(@"request %@ is released,time spend on this request:%f seconds", [self class],[[NSDate date] timeIntervalSinceDate:_requestStartTime]);
    [_requestStartTime release];
    [_filePath release];
    [_delegate release];
    [_requestUrl release];
    [_cacheKey release];
    [_result release];
    [_cancelSubject release];
    [_resultDic release];
    [_resultString release];
    [_indicatorView release];
    [_parameters release];
    [_onRequestStartBlock release];
    [_onRequestFinishBlock release];
    [_onRequestCanceled release];
    [_onRequestFailedBlock release];
    [_onRequestProgressChangedBlock release];
	[super dealloc];
}

#pragma mark - util methods

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse{
	NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
	return [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    return NO;
}

- (void)processResult{

    NSDictionary *resultDic = self.resultDic;
    _result = [[ITTRequestResult alloc] initWithCode:[NSString stringWithFormat:@"%@",resultDic[@"result"]]
                                         withMessage:resultDic[@"msg"]];
    if ([_result isSuccess]) {
        ITTDINFO(@"request[%@] :%@" ,self ,@"success");
    } else {
        ITTDERROR(@"request[%@] failed with message %@",self,_result.code);
        //处理单点登录的逻辑
        if ([_result isNoLogin]) {
            NSArray *subViewAry = [NSArray arrayWithArray:[KAPP_WINDOW subviews]];
            for (UIView *subView in subViewAry) {
                if ([subView isKindOfClass:[BDKNotifyHUDBGView class]]) {
                    return ;
                }
                if ([subView isKindOfClass:[MessageAlertView class]]) {
                    return ;
                }
            }
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"msg"]];
            [BDKNotifyHUD showCryingHUDWithText:msg duration:3.0f completion:^{
                [AccountHelper logout];
                LoginVC *loginVC = [[LoginVC alloc] init];
                loginVC.boolSingleSignOn = YES;
                [[KAPP_DELEGATE navigationController] pushViewController:loginVC animated:YES];
            }];
        }
    }
}

- (BOOL)isSuccess{
    if (_result && [_result isSuccess]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNoLogin {
    if (_result && [_result isNoLogin]) {
        return YES;
    }
    return NO;
}

- (NSString*)encodeURL:(NSString *)string{
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	if (newString) {
		return newString;
	}
	return @"";
}

- (void)showIndicator:(BOOL)bshow{
	_isLoading = bshow;
    if (bshow) {
        if (!_maskActivityView) {
            _maskActivityView = [[ITTMaskActivityView viewFromXIB] retain];
            [_maskActivityView showInView:_indicatorView];
        }
    }else {
        if (_maskActivityView) {
            [_maskActivityView hide];
            RELEASE_SAFELY(_maskActivityView);
        }
    }
}

- (BOOL)handleResultString:(NSString*)resultString{
    NSString *trimmedString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RELEASE_SAFELY(_resultString);
	_resultString = [trimmedString retain];
	if (!_resultString || [_resultString length] == 0) {
		ITTDERROR(@"!empty response error with Request:%@",[self class]);
		return NO;
	}
	//ITTDINFO(@"raw response:%@",_resultString);
    
	NSData *jsonData;
	if ([[_resultString  substringWithRange:NSMakeRange(0,1)] isEqualToString: @"["] ) {
		jsonData = [[[@"{\"data\":" stringByAppendingString:self.resultString ] stringByAppendingString:@"}"] dataUsingEncoding:NSUTF8StringEncoding];
	}else {
		jsonData = [self.resultString  dataUsingEncoding:NSUTF8StringEncoding];
	}
    NSError *error;
    NSDictionary *resultDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    
	if(!resultDic) { 
        if (_delegate) {
            //using delegate
            if([_delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
                [_delegate request:self 
              didFailLoadWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                       code:0
                                                   userInfo:nil]];
            }
        }else {
            //using block callback
            if (_onRequestFailedBlock) {
                _onRequestFailedBlock(self,[NSError errorWithDomain:NSURLErrorDomain
                                                               code:0
                                                           userInfo:nil]);
            }
        }
        ITTDERROR(@"http request:%@\n with error:%@\n raw result:%@",[self class],error,_resultString);
        return NO;
	}else{
        RELEASE_SAFELY(_resultDic);
        _resultDic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
        [self processResult];
        if ([self.result isSuccess] && _cacheKey) {
            if (_cacheType == DataCacheManagerCacheTypeMemory) {
                [[DataCacheManager sharedManager] addObjectToMemory:self.resultDic forKey:_cacheKey];
            }else{
                [[DataCacheManager sharedManager] addObject:self.resultDic forKey:_cacheKey];
            }
        }
        
        
        if (_delegate) {
            if([_delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
                [_delegate requestDidFinishLoad:self];
            }
        }else {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(self);
            }
        }
        return YES;
    }
}
#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params{
    ITTDERROR(@"should implement request logic here!");
}
- (NSStringEncoding)getResponseEncoding{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams{
	return @{};
}

- (ITTRequestMethod)getRequestMethod{
	return ITTRequestMethodGet;
}

- (NSString*)getRequestUrl{
	return @"";
}

- (NSString*)getRequestHost{
	return Host_Url;
}

@end
