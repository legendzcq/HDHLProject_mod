//
//  ITTBaseDataRequest.h
//  
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ITTRequestResult.h"
#import "DataCacheManager.h"
#import "ITTMaskActivityView.h"

typedef enum{
	ITTRequestMethodGet = 0,
	ITTRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
	ITTRequestMethodMultipartPost = 2  // content type = @"multipart/form-data"
} ITTRequestMethod;

@class ITTBaseDataRequest;

@protocol DataRequestDelegate <NSObject>
@optional
- (void)requestDidStartLoad:(ITTBaseDataRequest*)request;
- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request;
- (void)requestDidCancelLoad:(ITTBaseDataRequest*)request;
- (void)request:(ITTBaseDataRequest*)request progressChanged:(float)progress;
- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error;
@end

@interface ITTBaseDataRequest : NSObject {      
    NSString *_cancelSubject;           
    BOOL _useSilentAlert;       
    
    NSDate *_requestStartTime;
    BOOL _usingCacheData;
    NSString *_cacheKey;
    DataCacheManagerCacheType _cacheType;
    ITTMaskActivityView *_maskActivityView;
    NSString *_filePath;
    
    void (^_onRequestStartBlock)(ITTBaseDataRequest *);
    void (^_onRequestFinishBlock)(ITTBaseDataRequest *);
    void (^_onRequestCanceled)(ITTBaseDataRequest *);
    void (^_onRequestFailedBlock)(ITTBaseDataRequest *,NSError *);
    void (^_onRequestProgressChangedBlock)(ITTBaseDataRequest *,float);
    
    //progress related
    
    long long _totalData;
    long long _downloadedData;
    float _currentProgress;
}

@property (nonatomic, retain) id<DataRequestDelegate> delegate;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *requestUrl;
@property (nonatomic, retain) UIView *indicatorView;
@property (nonatomic, retain) NSMutableDictionary *resultDic;
@property (nonatomic, retain) NSString *resultString;
@property (nonatomic, retain) ITTRequestResult *result;
@property (nonatomic, retain,readonly) NSDictionary *parameters;

#pragma mark - init methods using delegate
+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject;

+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

#pragma mark - init methods using blocks

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

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
       onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock;


#pragma mark - file download related init methods 
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
                 withFilePath:(NSString*)localFilePath
            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onProgressChanged:(void(^)(ITTBaseDataRequest *request,float progress))onProgressChangedBlock;

#pragma mark - public methods
+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;
- (void)doRequestWithParams:(NSDictionary*)params;
- (NSStringEncoding)getResponseEncoding;
- (NSDictionary*)getStaticParams;
- (ITTRequestMethod)getRequestMethod;
- (NSString*)getRequestUrl;
- (NSString*)getRequestHost;
- (void)processResult;
- (BOOL)isSuccess;
- (BOOL)isNoLogin;
- (NSString*)encodeURL:(NSString *)string;
- (void)showIndicator:(BOOL)bshow;
- (BOOL)handleResultString:(NSString*)resultString;
- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (void)doRelease;
@end
